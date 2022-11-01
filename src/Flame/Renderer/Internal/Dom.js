let namespace = 'http://www.w3.org/2000/svg',
    eventPrefix = '__flame_',
    eventPostfix = 'updater';
let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5,
    managedNode = 6;
//these events cannot be synthetic
let nonBubblingEvents = ["focus", "blur", "scroll", "load", "unload"];

export function start_(eventWrapper, root, updater, html) {
    return new F(eventWrapper, root, updater, html, false);
}

export function startFrom_(eventWrapper, root, updater, html) {
    return new F(eventWrapper, root, updater, html, true);
}

export function resume_(f, html) {
    f.resume(html);
}

/** Class to scope application data since a document can have many mount points */
function F(eventWrapper, root, updater, html, isDry) {
    /** Hack so all kinds of events have the same result type */
    this.eventWrapper = eventWrapper;
    /** Keep track of synthetic events currently registered by saving the total number of events and the handler function */
    this.applicationEvents = new Map();
    /** Mounting point on DOM */
    this.root = root;
    /** User supplied function to process messages*/
    this.updater = updater;
    /** The current virtual nodes to be diff'd when the view updates */
    this.cachedHtml = html.node === undefined ? html : shallowCopy(html); //if node is already defined, then this object has been reused in views

    //"dry" application means that it was server side rendered
    if (isDry)
        this.hydrate(this.root, this.cachedHtml);
    else
        this.createAllNodes(this.root, this.cachedHtml);
}

/** Install events handlers and set nodes on the virtual nodes */
F.prototype.hydrate = function (parent, html, referenceNode) {
    //here we trust that the nodes on the parent match the virtual node structure
    switch (html.nodeType) {
        case lazyNode:
            html.node = parent;

            html.rendered = html.render(html.arg);
            html.render = undefined;

            this.hydrate(parent, html.rendered);
            break;
        case textNode:
            html.node = parent;
            break;
        case managedNode:
            this.createAllNodes(parent, html, referenceNode);
            break;
        default:
            if (html.nodeType === fragmentNode)
                html.node = document.createDocumentFragment();
            else {
                html.node = parent;

                if (html.nodeData.events !== undefined)
                    this.createAllEvents(parent, html);
            }
            let htmlChildrenLength;

            if (html.text === undefined && html.children !== undefined && (htmlChildrenLength = html.children.length) > 0) {
                let childNodes = parent.childNodes;

                for (let i = 0, cni = 0; i < htmlChildrenLength; ++i, ++cni) {
                    let c = html.children[i] = (html.children[i].node === undefined ? html.children[i] : shallowCopy(html.children[i]));
                    //will happen when:
                    // managed nodes
                    // client side view is different from server side view or actual dom
                    if (childNodes[cni] === undefined)
                        this.createAllNodes(parent, c);
                    else {
                        if (c.nodeType === fragmentNode) {
                            let fragmentChildrenLength = c.children.length;

                            c.node = document.createDocumentFragment();
                            for (let j = 0; j < fragmentChildrenLength; ++j) {
                                let cf = c.children[j] = (c.children[j].node === undefined ? c.children[j] : shallowCopy(c.children[j]));

                                this.hydrate(childNodes[cni++], cf);
                            }
                            cni--;
                        }
                        else if (c.nodeType === managedNode)
                            this.hydrate(parent, c, childNodes[cni]);
                        else
                            this.hydrate(childNodes[cni], c);
                    }
                }
            }
    }
};

/** Copy a given html so properties are not overwritten by reuse */
function shallowCopy(origin) {
    switch (origin.nodeType) {
        case textNode:
            return {
                nodeType: textNode,
                node: undefined,
                text: origin.text
            };
        case fragmentNode:
            return {
                nodeType: fragmentNode,
                node: undefined,
                children: origin.children
            };
        case lazyNode:
            return {
                nodeType: lazyNode,
                node: undefined,
                nodeData: origin.nodeData,
                render: origin.render,
                arg: origin.arg,
                rendered: undefined,
                messageMapper: origin.messageMapper
            };
        case managedNode:
            return {
                nodeType: managedNode,
                node: undefined,
                nodeData: origin.nodeData,
                createNode: origin.createNode,
                updateNode: origin.updateNode,
                arg: origin.arg,
                messageMapper: origin.messageMapper
            };
        default:
            return {
                nodeType: origin.nodeType,
                node: undefined,
                tag: origin.tag,
                nodeData: origin.nodeData,
                children: origin.children,
                text: origin.text,
                messageMapper: origin.messageMapper
            };
    }
}

/**Creates all nodes from a given html into a parent*/
F.prototype.createAllNodes = function (parent, html, referenceNode) {
    let node = this.createNode(html);

    if (html.text !== undefined)
        node.textContent = html.text;
    else {
        if (html.children !== undefined)
            this.createChildrenNodes(node, html.children);
        else if (html.rendered !== undefined) {
            if (html.messageMapper !== undefined)
                lazyMessageMap(html.messageMapper, html.rendered);

            if (html.rendered.text !== undefined) {
                node.textContent = html.rendered.text;
            }
            else if (html.rendered.children !== undefined)
                this.createChildrenNodes(node, html.rendered.children);
        }
    }

    //same as appendChild if referenceNode is null
    parent.insertBefore(node, referenceNode);
};

/** Abstract over shallow copying a html object before creating its nodes */
F.prototype.checkCreateAllNodes = function (parent, html, referenceNode) {
    if (html.node !== undefined)
        html = shallowCopy(html);
    this.createAllNodes(parent, html, referenceNode);

    return html;
};

/** Children nodes must be recursively created */
F.prototype.createChildrenNodes = function (parent, children) {
    let childrenLength = children.length;

    for (let i = 0; i < childrenLength; ++i) {
        let html = children[i] = (children[i].node === undefined ? children[i] : shallowCopy(children[i]));

        this.checkCreateAllNodes(parent, html, null);
    }
};

/** Creates a single node and sets its node data */
F.prototype.createNode = function (html) {
    switch (html.nodeType) {
        case lazyNode:
            html.rendered = html.render(html.arg);
            html.render = undefined;

            return html.node = this.createNode(html.rendered);
        case textNode:
            return html.node = document.createTextNode(html.text);
        case elementNode:
            return html.node = this.createElement(html);
        case svgNode:
            return html.node = this.createSvg(html);
        case fragmentNode:
            return html.node = document.createDocumentFragment();
        case managedNode:
            return html.node = this.createManagedNode(html);
    }
};

/** Creates a node of type element */
F.prototype.createElement = function (html) {
    let element = document.createElement(html.tag);

    this.createNodeData(element, html, false);

    return element;
};

/** Creates a node of type svg */
F.prototype.createSvg = function (html) {
    let svg = document.createElementNS(namespace, html.tag);

    this.createNodeData(svg, html, true);

    return svg;
};

/** Creates a node from a user supplied function */
F.prototype.createManagedNode = function (html) {
    let node = html.createNode(html.arg)();
    html.createNode = undefined;
    //the svg element is an instance of HTMLElement
    this.createNodeData(node, html, node instanceof SVGElement || node.nodeName.toLowerCase() === "svg");

    return node;
};

/** Sets node updatedChildren: attributes, properties, events, etc */
F.prototype.createNodeData = function (node, html, isSvg) {
    if (html.nodeData.styles !== undefined)
        createStyles(node, html.nodeData.styles);

    if (html.nodeData.classes !== undefined && html.nodeData.classes.length > 0)
        createClasses(node, html.nodeData.classes, isSvg);

    if (html.nodeData.attributes !== undefined)
        createAttributes(node, html.nodeData.attributes);

    if (html.nodeData.properties !== undefined)
        for (let key in html.nodeData.properties)
            node[key] = html.nodeData.properties[key];

    if (html.nodeData.events !== undefined)
        this.createAllEvents(node, html);
};

/** Sets the style attribute */
function createStyles(node, styles) {
    for (let key in styles)
        node.style.setProperty(key, styles[key]);
}

/** Sets className property for elements and class attribute for svg*/
function createClasses(node, classes, isSvg) {
    let joined = classes.join(' ');

    if (isSvg)
        node.setAttribute('class', joined);
    else
        node.className = joined;
}

//** Set node attributes */
function createAttributes(node, attributes) {
    for (let key in attributes)
        node.setAttribute(key, attributes[key]);
}

/** Creates synthetic events
 *
 *  If the event bubbles, a single listener for its type is added to the root, and fired at the nearest node from the target that contains a handler. Otherwise the event is added to the node */
F.prototype.createAllEvents = function (node, html) {
    for (let key in html.nodeData.events)
        this.createEvent(node, key, html);
};

F.prototype.createEvent = function (node, name, html) {
    let handlers = html.nodeData.events[name],
        eventKey = eventPrefix + name;

    if (nonBubblingEvents.includes(name)) {
        let runNonBubblingEvent = this.runNonBubblingEvent(handlers, html.messageMapper);

        //same as with applicationEvents, save the listener so we can unregister it later
        node[eventKey] = runNonBubblingEvent;
        node.addEventListener(name, runNonBubblingEvent, false);
    }
    else {
        node[eventKey] = handlers;
        //to support functors, the mapping function is saved on the node
        if (html.messageMapper !== undefined)
            node[eventKey + eventPostfix] = html.messageMapper;

        let synthetic = this.applicationEvents.get(name);

        if (synthetic === undefined) {
            let runEvent = this.runEvent.bind(this);

            this.root.addEventListener(name, runEvent, false);
            this.applicationEvents.set(name, {
                count: 1,
                handler: runEvent
            });
        }
        else
            synthetic.count++;
    }
};

/** Runs a non bubbling event */
F.prototype.runNonBubblingEvent = function (handlers, messageMapper) {
    return function (event) {
        this.runHandlers(handlers, messageMapper, event);
    }.bind(this);
};

/** Finds and run the handler of a synthetic event */
F.prototype.runEvent = function (event) {
    let node = event.target,
        eventKey = eventPrefix + event.type;

    while (node !== this.root) {
        let handlers = node[eventKey];

        if (handlers !== undefined) {
            this.runHandlers(handlers, node[eventKey + eventPostfix], event);
            return;
        }
        node = node.parentNode;
    }
};

/** Runs all event handlers for a given event */
F.prototype.runHandlers = function (handlers, messageMapper, event) {
    let handlersLength = handlers.length;

    for (let i = 0; i < handlersLength; ++i) {
        let h = handlers[i],
            maybeMessage = typeof h === "function" ? h(event)() : this.eventWrapper(h);

        //handler can be just a message or a function that takes an event
        this.updater(messageMapper === undefined ? maybeMessage : messageMapper(maybeMessage))();
    }
    event.stopPropagation();
};

F.prototype.resume = function (updatedHtml) {
    this.cachedHtml = this.updateAllNodes(this.root, this.cachedHtml, updatedHtml);
};

/** Patches over the parent element*/
F.prototype.updateAllNodes = function (parent, currentHtml, updatedHtml) {
    //if node is already defined, then this object has been reused in views
    if (updatedHtml.node !== undefined)
        updatedHtml = shallowCopy(updatedHtml);
    //recreate node if it has changed tag or node type
    if (currentHtml.tag !== updatedHtml.tag || currentHtml.nodeType !== updatedHtml.nodeType) {
        if (currentHtml.nodeType === fragmentNode) {
            this.createAllNodes(parent, updatedHtml, firstFragmentChildNode(currentHtml.children));
            removeFragmentChildren(parent, currentHtml.children);
        } else {
            //moving the node instead of using clearNode allows us to reuse nodes
            this.createAllNodes(parent, updatedHtml, currentHtml.node);
            parent.removeChild(currentHtml.node);
        }
    }
    else {
        updatedHtml.node = currentHtml.node;

        switch (updatedHtml.nodeType) {
            case lazyNode:
                if (updatedHtml.arg !== currentHtml.arg) {
                    updatedHtml.rendered = updatedHtml.render(updatedHtml.arg);

                    if (updatedHtml.messageMapper !== undefined)
                        lazyMessageMap(updatedHtml.messageMapper, updatedHtml.rendered);

                    this.updateAllNodes(parent, currentHtml.rendered, updatedHtml.rendered);
                }
                else
                    updatedHtml.rendered = currentHtml.rendered;

                updatedHtml.render = undefined;
                break;
            case managedNode:
                let node = updatedHtml.updateNode(currentHtml.node)(currentHtml.arg)(updatedHtml.arg)(),
                    isSvg = node instanceof SVGElement || node.nodeName.toLowerCase() === "svg";

                if (node !== currentHtml.node || node.nodeType !== currentHtml.node.nodeType || node.nodeName !== currentHtml.node.nodeName) {
                    this.createNodeData(node, updatedHtml, isSvg);
                    parent.insertBefore(node, currentHtml.node);
                    parent.removeChild(currentHtml.node);
                }
                else
                    this.updateNodeData(node, currentHtml.nodeData, updatedHtml, isSvg);

                updatedHtml.node = node;
                break;
            //text nodes can have only their textContent changed
            case textNode:
                if (updatedHtml.text !== currentHtml.text)
                    updatedHtml.node.textContent = updatedHtml.text;
                break;
            //parent instead of currentHtml.node, as fragments nodes only count for their children
            case fragmentNode:
                this.updateChildrenNodes(parent, currentHtml, updatedHtml);
                break;
            //the usual case, element/svg to be patched
            default:
                this.updateNodeData(currentHtml.node, currentHtml.nodeData, updatedHtml, updatedHtml.nodeType == svgNode);
                //it is a pain but save us some work
                if ((updatedHtml.text !== undefined || updatedHtml.children === undefined && currentHtml.text != undefined) && !hasInnerHtml(updatedHtml.nodeData) && updatedHtml.text != currentHtml.node.textContent)
                    currentHtml.node.textContent = updatedHtml.text;
                else
                    this.updateChildrenNodes(currentHtml.node, currentHtml, updatedHtml);
        }
    }

    return updatedHtml;
};

/** Fragments are not child of any nodes, so we must find the first actual node */
function firstFragmentChildNode(children) {
    let childrenLength = children.length;

    for (let i = 0; i < childrenLength; ++i) {
        if (children[i].nodeType === fragmentNode)
            return firstFragmentChildNode(children[i].children);

        return children[i].node;
    }

    return undefined;
}

/** fragments are not child of any nodes, so we must recursively remove the actual child nodes  */
function removeFragmentChildren(parent, children) {
    let childrenLength = children.length;

    for (let i = 0; i < childrenLength; ++i)
        if (children[i].nodeType === fragmentNode)
            removeFragmentChildren(children[i].children)
        else
            parent.removeChild(children[i].node);
}

function clearNode(node) {
    node.textContent = '';
}

/** Patch children of a node */
F.prototype.updateChildrenNodes = function (parent, currentHtml, updatedHtml) {
    let currentChildren = currentHtml.children,
        updatedChildren = updatedHtml.children;
    //create all nodes regardless
    if (currentChildren === undefined || currentChildren.length === 0) {
        let updatedChildrenLength;

        if (updatedChildren !== undefined && (updatedChildrenLength = updatedChildren.length) > 0) {
            //nodes are appended to the parent, so we must clear it if innerHTML or textContent was set
            // there are a few situations in which this is unsafe, but innerHTML should be considered always dangerous anyway
            if (currentHtml.text !== undefined || hasInnerHtml(currentHtml.nodeData))
                clearNode(parent);

            for (let i = 0; i < updatedChildrenLength; ++i)
                updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i]);
        }
    }
    //remove all nodes regardless
    else if (updatedChildren === undefined || updatedChildren.length === 0) {
        //html that uses innerHTML usually has no child nodes
        if (currentChildren !== undefined && (currentChildren.length > 0 || currentHtml.text !== undefined) && !hasInnerHtml(updatedHtml.nodeData))
            clearNode(parent);
    }
    //if both first nodes have keys, assume keyed
    else if (currentChildren[0].nodeData !== undefined && currentChildren[0].nodeData.key !== undefined && updatedChildren[0].nodeData !== undefined && updatedChildren[0].nodeData.key !== undefined)
        this.updateKeyedChildrenNodes(parent, currentChildren, updatedChildren);
    //otherwise use the non keyed algorithm
    else
        this.updateNonKeyedChildrenNodes(parent, currentChildren, updatedChildren);
};

//innerHTML property is a pain in the ass
function hasInnerHtml(parentNodeData) {
    return parentNodeData !== undefined && parentNodeData.properties !== undefined && parentNodeData.properties.innerHTML !== undefined;
}

/** Keyed algorithm adapted from stage0
 *
 * https://github.com/Freak613/stage0/blob/21027de473bd6fc51e499fa8a505c4ea700bc8e9/keyed.js
 */
F.prototype.updateKeyedChildrenNodes = function (parent, currentChildren, updatedChildren) {
    let currentStart = 0,
        updatedStart = 0,
        currentEnd = currentChildren.length - 1,
        updatedEnd = updatedChildren.length - 1;

    //these are used to keep track of moved nodes
    let afterNode,
        currentStartNode = currentChildren[currentStart].node,
        updatedStartNode = currentStartNode,
        currentEndNode = currentChildren[currentEnd].node;

    let loop = true;

    fixes: while (loop) {
        loop = false;

        let currentHtml = currentChildren[currentStart],
            updatedHtml = updatedChildren[updatedStart];

        //common prefix of current and updated children
        while (currentHtml.nodeData.key === updatedHtml.nodeData.key) {
            updatedHtml = this.updateAllNodes(parent, currentHtml, updatedHtml);
            updatedStartNode = currentStartNode = currentHtml.node.nextSibling;

            currentStart++;
            updatedStart++;
            if (currentEnd < currentStart || updatedEnd < updatedStart)
                break fixes;

            currentHtml = currentChildren[currentStart];
            updatedHtml = updatedChildren[updatedStart];
        }

        currentHtml = currentChildren[currentEnd];
        updatedHtml = updatedChildren[updatedEnd];

        //common suffix of current and updated children
        while (currentHtml.nodeData.key === updatedHtml.nodeData.key) {
            updatedHtml = this.updateAllNodes(parent, currentHtml, updatedHtml);
            afterNode = currentEndNode;
            currentEndNode = currentEndNode.previousSibling;

            currentEnd--;
            updatedEnd--;
            if (currentEnd < currentStart || updatedEnd < updatedStart)
                break fixes;

            currentHtml = currentChildren[currentEnd];
            updatedHtml = updatedChildren[updatedEnd];
        }

        currentHtml = currentChildren[currentEnd];
        updatedHtml = updatedChildren[updatedStart];

        //swap backwards
        while (currentHtml.nodeData.key === updatedHtml.nodeData.key) {
            loop = true;

            updatedHtml = this.updateAllNodes(parent, currentHtml, updatedHtml);
            currentEndNode = currentHtml.node.previousSibling;
            parent.insertBefore(currentHtml.node, updatedStartNode);

            updatedStart++;
            currentEnd--;
            if (currentEnd < currentStart || updatedEnd < updatedStart)
                break fixes;

            currentHtml = currentChildren[currentEnd];
            updatedHtml = updatedChildren[updatedStart];
        }

        currentHtml = currentChildren[currentStart];
        updatedHtml = updatedChildren[updatedEnd];

        //swap forward
        while (currentHtml.nodeData.key === updatedHtml.nodeData.key) {
            loop = true;

            updatedHtml = this.updateAllNodes(parent, currentHtml, updatedHtml);
            parent.insertBefore(currentHtml.node, afterNode);
            afterNode = currentHtml.node;

            currentStart++;
            updatedEnd--;
            if (currentEnd < currentStart || updatedEnd < updatedStart)
                break fixes;

            currentHtml = currentChildren[currentStart];
            updatedHtml = updatedChildren[updatedEnd];
        }
    }

    if (updatedEnd < updatedStart)
        //remove nodes
        while (currentStart <= currentEnd) {
            parent.removeChild(currentChildren[currentEnd].node);
            currentEnd--;
        }
    else if (currentEnd < currentStart)
        //add nodes
        while (updatedStart <= updatedEnd) {
            updatedChildren[updatedStart] = this.checkCreateAllNodes(parent, updatedChildren[updatedStart], afterNode);
            updatedStart++;
        }
    else {
        //whether the item at position i should be created or updated
        let P = new Int32Array(updatedEnd + 1 - updatedStart);
        //maps positions from current to updated
        let I = new Map();

        for (let i = updatedStart; i <= updatedEnd; i++) {
            P[i] = -1;
            I.set(updatedChildren[i].nodeData.key, i);
        }

        let reusingNodes = updatedStart + updatedChildren.length - 1 - updatedEnd,
            toRemove = [];

        for (let i = currentStart; i <= currentEnd; i++)
            if (I.has(currentChildren[i].nodeData.key)) {
                P[I.get(currentChildren[i].nodeData.key)] = i;
                reusingNodes++;
            }
            else
                toRemove.push(i);

        if (reusingNodes === 0) {
            //replace all nodes
            parent.textContent = "";

            for (let i = updatedStart; i <= updatedEnd; i++)
                updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i]);
        }
        else {
            //remove nodes
            let toRemoveLength = toRemove.length;

            for (let i = 0; i < toRemoveLength; i++)
                parent.removeChild(currentChildren[toRemove[i]].node);

            //move nodes
            let longestSeq = longestSubsequence(P, updatedStart),
                seqIndex = longestSeq.length - 1;

            for (let i = updatedEnd; i >= updatedStart; i--) {
                if (longestSeq[seqIndex] === i) {
                    currentHtml = currentChildren[P[longestSeq[seqIndex]]];
                    updatedChildren[i] = this.updateAllNodes(parent, currentHtml, updatedChildren[i]);
                    afterNode = currentHtml.node;
                    seqIndex--;
                }
                else {
                    if (P[i] === -1) {
                        updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i], afterNode);
                        afterNode = updatedChildren[i].node;
                    }
                    else {
                        currentHtml = currentChildren[P[i]];
                        updatedChildren[i] = this.updateAllNodes(parent, currentHtml, updatedChildren[i]);
                        parent.insertBefore(currentHtml.node, afterNode);
                        afterNode = currentHtml.node;
                    }
                }
            }
        }
    }
};

//returns an array of the indices that comprise the longest increasing subsequence
function longestSubsequence(ns, updatedStart) {
    let seq = [],
        is = [],
        l = -1,
        i,
        len,
        pre = new Int32Array(ns.length);

    for (i = updatedStart, len = ns.length; i < len; i++) {
        let n = ns[i];

        if (n < 0)
            continue;

        let j = findGreatestIndex(seq, n);

        if (j !== -1)
            pre[i] = is[j];
        if (j === l) {
            l++;
            seq[l] = n;
            is[l] = i;
        }
        else if (n < seq[j + 1]) {
            seq[j + 1] = n;
            is[j + 1] = i;
        }
    }

    for (i = is[l]; l >= 0; i = pre[i], l--)
        seq[l] = i;

    return seq;
}

function findGreatestIndex(seq, n) {
    let lo = -1,
        hi = seq.length;

    if (hi > 0 && seq[hi - 1] <= n)
        return hi - 1;

    while (hi - lo > 1) {
        let mid = Math.floor((lo + hi) / 2);

        if (seq[mid] > n)
            hi = mid;
        else
            lo = mid;
    }

    return lo;
}

/** Non keyed children nodes are compared as it is */
F.prototype.updateNonKeyedChildrenNodes = function (parent, currentChildren, updatedChildren) {
    let currentChildrenLength = currentChildren.length,
        updatedChildrenLength = updatedChildren.length,
        commonLength = Math.min(currentChildrenLength, updatedChildrenLength);

    //same nodes
    for (let i = 0; i < commonLength; ++i)
        updatedChildren[i] = this.updateAllNodes(parent, currentChildren[i], updatedChildren[i]);

    //new nodes
    if (currentChildrenLength < updatedChildrenLength)
        for (let i = commonLength; i < updatedChildrenLength; ++i)
            updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i]);
    //nodes to be removed
    else if (currentChildrenLength > updatedChildrenLength)
        for (let i = commonLength; i < currentChildrenLength; ++i)
            parent.removeChild(currentChildren[i].node);

};

/** Updates the node data of a node */
F.prototype.updateNodeData = function (node, currentNodeData, updatedHtml, isSvg) {
    updateStyles(node, currentNodeData.styles, updatedHtml.nodeData.styles);

    updateAttributes(node, currentNodeData.attributes, updatedHtml.nodeData.attributes);

    updateClasses(node, currentNodeData.classes, updatedHtml.nodeData.classes, isSvg);

    updateProperties(node, currentNodeData.properties, updatedHtml.nodeData.properties);

    this.updateEvents(node, currentNodeData.events, updatedHtml);
};

/** Updates the style attribute of a node */
function updateStyles(node, currentStyles, updatedStyles) {
    if (currentStyles === undefined) {
        if (updatedStyles !== undefined)
            createStyles(node, updatedStyles);
    }
    else if (updatedStyles === undefined) {
        if (currentStyles !== undefined)
            node.removeAttribute('style');
    }
    else {
        let matchCount = 0;
        //this takes advantage of the sort order of for in
        for (let key in currentStyles) {
            let current = currentStyles[key],
                updated = updatedStyles[key],
                hasUpdated = updatedStyles[key] !== undefined;

            if (hasUpdated)
                matchCount++;

            if (current !== updated)
                if (hasUpdated)
                    node.style.setProperty(key, updated);
                else
                    node.style.removeProperty(key);
        }

        let newKeys = Object.keys(updatedStyles),
            newKeysLength = newKeys.length;

        for (let i = 0; matchCount < newKeysLength && i < newKeysLength; ++i) {
            let key = newKeys[i];

            if (currentStyles[key] === undefined) {
                let updated = updatedStyles[key];
                ++matchCount;

                node.style.setProperty(key, updated);
            }
        }
    }
}

function updateClasses(node, currentClasses, updatedClasses, isSvg) {
    let classUpdated = updatedClasses !== undefined && updatedClasses.length > 0;

    if (currentClasses !== undefined && currentClasses.length > 0 && !classUpdated)
        createClasses(node, [], isSvg);
    else if (classUpdated)
        createClasses(node, updatedClasses, isSvg);
}

/** Updates the attributes of a node */
function updateAttributes(node, currentAttributes, updatedAttributes) {
    if (currentAttributes === undefined) {
        if (updatedAttributes !== undefined)
            createAttributes(node, updatedAttributes);
    }
    else if (updatedAttributes === undefined) {
        if (currentAttributes !== undefined)
            for (let key in currentAttributes)
                node.removeAttribute(key);
    }
    else {
        let matchCount = 0;
        //this takes advantage of the sort order of for in
        for (let key in currentAttributes) {
            let current = currentAttributes[key],
                updated = updatedAttributes[key],
                hasUpdated = updated !== undefined;

            if (hasUpdated)
                matchCount++;

            if (current !== updated)
                if (hasUpdated)
                    node.setAttribute(key, updated);
                else
                    node.removeAttribute(key);
        }

        let newKeys = Object.keys(updatedAttributes),
            newKeysLength = newKeys.length;

        for (let i = 0; matchCount < newKeysLength && i < newKeysLength; ++i) {
            let key = newKeys[i];

            if (currentAttributes[key] === undefined) {
                let updated = updatedAttributes[key];
                ++matchCount;

                node.setAttribute(key, updated);
            }
        }
    }
}

/** Updates the properties of a node */
function updateProperties(node, currentProperties, updatedProperties) {
    //since we might reuse nodes, we need to unset properties that also have an equivalent attribute
    let addAll = currentProperties === undefined,
        removeAll = updatedProperties === undefined;

    if (addAll) {
        if (!removeAll)
            for (let key in updatedProperties)
                node[key] = updatedProperties[key];
    }
    else if (removeAll) {
        if (!addAll)
            for (let key in currentProperties)
                node.removeAttribute(key);
    }
    else {
        let matchCount = 0;
        //this takes advantage of the sort order of for in
        for (let key in currentProperties) {
            let current = currentProperties[key],
                updated = updatedProperties[key],
                hasUpdated = updated !== undefined;

            if (hasUpdated)
                matchCount++;

            if (current !== updated)
                if (hasUpdated)
                    node[key] = updated;
                else
                    node.removeAttribute(key);
        }

        let newKeys = Object.keys(updatedProperties),
            newKeysLength = newKeys.length;

        for (let i = 0; matchCount < newKeysLength && i < newKeysLength; ++i) {
            let key = newKeys[i];

            if (currentProperties[key] === undefined) {
                let updated = updatedProperties[key];
                ++matchCount;

                node[key] = updated;
            }
        }
    }
}

/** Updates node events */
F.prototype.updateEvents = function (node, currentEvents, updatedHtml) {
    let updatedEvents = updatedHtml.nodeData.events;

    if (currentEvents === undefined) {
        if (updatedEvents !== undefined)
            this.createAllEvents(node, updatedHtml);
    }
    else if (updatedEvents === undefined) {
        if (currentEvents !== undefined)
            for (let key in currentEvents)
                this.removeEvent(node, key);
    }
    else {
        let matchCount = 0;

        for (let key in currentEvents) {
            let current = currentEvents[key],
                updated = updatedEvents[key],
                hasUpdated = false;

            //events handlers are arrays of messages/effect handlers
            if (updated === undefined)
                this.removeEvent(node, key);
            else {
                let currentLength = current.length,
                    updatedLength = updated.length;

                if (currentLength != updatedLength)
                    hasUpdated = true;
                else {
                    for (let i = 0; i < currentLength; ++i)
                        //since this is by reference, more often than not we will unlisten and listen on an event again
                        if (current[i] != updated[i]) {
                            hasUpdated = true;
                            break;
                        }
                }
            }

            if (hasUpdated) {
                matchCount++;

                this.removeEvent(node, key);
                this.createEvent(node, key, updatedHtml);
            }
        }

        let newKeys = Object.keys(updatedEvents),
            newKeysLength = newKeys.length;

        for (let i = 0; matchCount < newKeysLength && i < newKeysLength; ++i) {
            let key = newKeys[i];

            if (currentEvents[key] === undefined) {
                ++matchCount;

                this.createEvent(node, key, updatedHtml);
            }
        }
    }
};

/** Remove all given events from a node */
F.prototype.removeEvent = function (node, name) {
    let eventKey = eventPrefix + name;

    if (nonBubblingEvents.includes(name)) {
        let runNonBubblingEvent = node[eventKey];

        node.removeEventListener(name, runNonBubblingEvent, false);
    } else {
        let count = --this.applicationEvents.get(name).count;

        if (count === 0) {
            this.root.removeEventListener(name, this.applicationEvents.get(name).handler, false);
            this.applicationEvents.delete(name);
        }
    }
    //functor mapping
    node[eventKey + eventPostfix] = undefined;
    node[eventKey] = undefined;
};

function lazyMessageMap(mapper, html) {
    html.messageMapper = mapper;

    if (html.children !== undefined && html.children.length > 0)
        for (let i = 0; i < html.children.length; ++i)
            lazyMessageMap(mapper, html.children[i]);
}
