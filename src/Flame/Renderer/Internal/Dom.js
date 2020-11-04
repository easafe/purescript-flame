'use strict';

let namespace = 'http://www.w3.org/2000/svg',
    eventPrefix = '__flame_',
    styleAttribute = 'style';
let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5,
    managedNode = 6;

exports.start_ = function (eventWrapper, root, updater, html) {
    return new F(eventWrapper, root, updater, html, false);
};

exports.startFrom_ = function (eventWrapper, root, updater, html) {
    return new F(eventWrapper, root, updater, html, true);
};

exports.resume_ = function (f, html) {
    f.resume(html);
};

/** Class to scope application data since a document can have many mount points*/
function F(eventWrapper, root, updater, html, isDry) {
    /** Hack so all kinds events have the same result type */
    this.eventWrapper = eventWrapper;
    /** Keep count of synthetic events currently registered */
    this.applicationEvents = {};
    /** Mounting point on DOM */
    this.root = root;
    /** User supplied function to process messages*/
    this.updater = updater;
    /** The current virtual nodes to be diff'd when the view updates */
    this.cachedHtml = html;

    //a "dry" application means that it was server side rendered
    if (isDry)
        this.hydrate(this.root, this.cachedHtml);
    else
        this.createAllNodes(this.root, this.cachedHtml);
}

/** Install events handlers and set nodes on the virtual nodes */
F.prototype.hydrate = function (parent, html) {
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
        case fragmentNode:
            html.node = document.createDocumentFragment();

            let childNodes = parent.childNodes;

            for (let i = 0; i < html.children.length; ++i)
                if (childNodes[i] === undefined)
                    this.createAllNodes(parent, html.children[i], html.children[i + 1]);
                else
                    this.hydrate(childNodes[i], html.children[i]);
            break;
        default:
            html.node = parent;

            if (html.nodeData.events !== undefined)
                this.createEvents(parent, html.nodeData.events);

            if (html.children !== undefined && html.children.length > 0) {
                let childNodes = parent.childNodes;

                for (let i = 0; i < html.children.length; ++i)
                    //will happen when:
                    // managed nodes
                    // client side view is different from server side view
                    // the parent node has an empty text node
                    if (childNodes[i] === undefined)
                        this.createAllNodes(parent, html.children[i], html.children[i + 1]);
                    else
                        this.hydrate(childNodes[i], html.children[i]);
            }
    }
};

/**Creates all nodes from a given html into a parent*/
F.prototype.createAllNodes = function (parent, html, referenceNode) {
    let nodeParent = this.createNode(html);

    if (html.children !== undefined)
        this.createChildrenNodes(nodeParent, html.children);
    if (html.rendered != undefined && html.rendered.children !== undefined)
        this.createChildrenNodes(nodeParent, html.rendered.children);

    //same as appendChild if referenceNode is null
    parent.insertBefore(nodeParent, referenceNode);
};

/** Children nodes must be recursively created */
F.prototype.createChildrenNodes = function (parent, children) {
    for (let c of children) {
        let node = this.createNode(c);

        if (c.children !== undefined)
            this.createChildrenNodes(node, c.children);
        if (c.rendered !== undefined && c.rendered.children !== undefined)
            this.createChildrenNodes(node, c.rendered.children);

        parent.appendChild(node);
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

    this.createNodeData(element, html.nodeData, false);

    return element;
};

/** Creates a node of type svg */
F.prototype.createSvg = function (html) {
    let svg = document.createElementNS(namespace, html.tag);

    this.createNodeData(svg, html.nodeData, true);

    return svg;
};

/** Creates a node from a user supplied function */
F.prototype.createManagedNode = function (html) {
    let node = html.createElement(html.arg)();
    html.createElement = undefined;
    //the svg element is an instance of HTMLElement
    this.createNodeData(node, html.nodeData, node instanceof SVGElement || node.nodeName.toLowerCase() === "svg");

    return node;
};

/** Sets node updatedChildren: attributes, properties, events, etc */
F.prototype.createNodeData = function (node, nodeData, isSvg) {
    if (nodeData.styles !== undefined)
        createStyles(node, nodeData.styles);

    if (nodeData.classes !== undefined && nodeData.classes.length > 0)
        createClasses(node, nodeData.classes, isSvg);

    if (nodeData.attributes !== undefined)
        createAttributes(node, nodeData.attributes);

    if (nodeData.properties !== undefined)
        for (let key in nodeData.properties)
            node[key] = nodeData.properties[key];

    if (nodeData.events !== undefined)
        this.createEvents(node, nodeData.events);
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

/** Creates synthethic events
 *
 * A single listener for each event type is added to the document, and fired at the nearest node from the target that contains a handler */
F.prototype.createEvents = function (node, events) {
    for (let key in events) {
        let eventKey = eventPrefix + key;

        node[eventKey] = events[key];

        if (this.applicationEvents[key] === undefined) {
            document.addEventListener(key, this.runEvent.bind(this), false);
            this.applicationEvents[key] = 1;
        }
        else
            this.applicationEvents[key] = this.applicationEvents[key] + 1;
    }

};

/** Finds and run the handler of a synthetic event */
F.prototype.runEvent = function (event) {
    let node = event.target,
        eventKey = eventPrefix + event.type;
    //don't handle events outside of the root
    if (this.root.contains(event.target))
        while (node !== this.root) {
            //handler can be just a message or a function that takes an event
            let handler = node[eventKey];

            if (handler !== undefined) {
                this.updater(typeof handler === "function" ? handler(event)() : this.eventWrapper(handler))();

                return;
            }
            node = node.parentNode;
        }
};

F.prototype.resume = function (updatedHtml) {
    this.updateAllNodes(this.root, this.cachedHtml, updatedHtml);
    this.cachedHtml = updatedHtml;
};

/**Patches over the parent element*/
F.prototype.updateAllNodes = function (parent, currentHtml, updatedHtml) {
    //clear out the node if the views have changed completely
    if (currentHtml.tag !== updatedHtml.tag || currentHtml.nodeType !== updatedHtml.nodeType) {
        //edge case, but this will clear out other elements inside of the root that don't come from the view
        clearNode(parent);
        this.createAllNodes(parent, updatedHtml);
    }
    else {
        updatedHtml.node = currentHtml.node;

        switch (updatedHtml.nodeType) {
            case lazyNode:
                if (updatedHtml.arg !== currentHtml.arg) {
                    updatedHtml.rendered = updatedHtml.render(updatedHtml.arg);

                    this.updateAllNodes(parent, currentHtml.rendered, updatedHtml.rendered);
                }
                else
                    updatedHtml.rendered = currentHtml.rendered;

                updatedHtml.render = undefined;
                break;
            case managedNode:
                let node = updatedHtml.updateElement(currentHtml.node)(currentHtml.arg)(updatedHtml.arg)();

                if (node !== currentHtml.node || node.nodeType !== currentHtml.node.nodeType || node.nodeName !== currentHtml.node.nodeName) {
                    this.createNodeData(node, updatedHtml.nodeData, node instanceof SVGElement || node.nodeName.toLowerCase() === "svg");
                    parent.insertBefore(node, currentHtml.node);
                    parent.removeChild(currentHtml.node);
                }
                else
                    this.updateNodeData(node, currentHtml.nodeData, updatedHtml.nodeData, node instanceof SVGElement || node.nodeName.toLowerCase() === "svg");

                updatedHtml.node = node;
                break;
            //text nodes can have only their textContent changed
            case textNode:
                updatedHtml.node.textContent = updatedHtml.text;
                break;
            //parent instead of currentHtml.node, as fragments nodes only count for their children
            case fragmentNode:
                this.updateChildrenNodes(parent, currentHtml.children, updatedHtml.children);
                break;
            //the usual case, element/svg to be patched
            default:
                this.updateNodeData(currentHtml.node, currentHtml.nodeData, updatedHtml.nodeData, updatedHtml.nodeType == svgNode);
                this.updateChildrenNodes(currentHtml.node, currentHtml.children, updatedHtml.children);
        }
    }
};

function clearNode(node) {
    node.textContent = '';
}

/** Patch children of a node */
F.prototype.updateChildrenNodes = function (parent, currentChildren, updatedChildren) {
    //create all nodes regardless
    if (currentChildren === undefined || currentChildren.length === 0) {
        if (updatedChildren !== undefined && updatedChildren.length > 0)
            for (let c of updatedChildren)
                this.createAllNodes(parent, c);
    }
    //remove all nodes regardless
    else if (updatedChildren === undefined || updatedChildren.length === 0) {
        if (currentChildren !== undefined && currentChildren.length > 0)
            clearNode(parent);
    }
    //if both first nodes have keys, assume keyed
    else if (currentChildren[0].nodeData !== undefined && currentChildren[0].nodeData.key !== undefined && updatedChildren[0].nodeData !== undefined && updatedChildren[0].nodeData.key !== undefined)
        this.updateKeyedChildrenNodes(parent, currentChildren, updatedChildren);
    //otherwise use the non keyed algorithm
    else
        this.updateNonKeyedChildrenNodes(parent, currentChildren, updatedChildren);
};

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
            this.updateAllNodes(parent, currentHtml, updatedHtml);
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
            this.updateAllNodes(parent, currentHtml, updatedHtml);
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

            this.updateAllNodes(parent, currentHtml, updatedHtml);
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

            this.updateAllNodes(parent, currentHtml, updatedHtml);
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
            this.createAllNodes(parent, updatedChildren[updatedStart], afterNode);
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
            toRemove = new Int32Array();

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
                this.createAllNodes(parent, updatedChildren[i]);
        }
        else {
            //remove nodes
            for (let i = 0; i < toRemove.length; i++)
                parent.removeChild(currentChildren[toRemove[i]].node);

            //move nodes
            let longestSeq = longestSubsequence(P, updatedStart),
                seqIndex = longestSeq.length - 1;

            for (let i = updatedEnd; i >= updatedStart; i--) {
                if (longestSeq[seqIndex] === i) {
                    currentHtml = currentChildren[P[longestSeq[seqIndex]]];
                    this.updateAllNodes(parent, currentHtml, updatedChildren[i]);
                    afterNode = currentHtml.node;
                    seqIndex--;
                }
                else {
                    if (P[i] === -1) {
                        this.createAllNodes(parent, updatedChildren[i], afterNode);
                        afterNode = updatedChildren[i].node;
                    }
                    else {
                        currentHtml = currentChildren[P[i]];
                        this.updateAllNodes(parent, currentHtml, updatedChildren[i]);
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
    let seq = new Int32Array(),
        is = new Int32Array(),
        l = -1,
        pre = new Int32Array(ns.length);

    for (let i = updatedStart, len = ns.length; i < len; i++) {
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
        this.updateAllNodes(parent, currentChildren[i], updatedChildren[i]);
    //new nodes
    if (currentChildrenLength < updatedChildrenLength)
        for (let i = commonLength; i < updatedChildrenLength; ++i) {
            this.createAllNodes(parent, updatedChildren[i]);
        }
    //nodes to be removed
    else if (currentChildrenLength > updatedChildrenLength)
        for (let i = commonLength; i < currentChildrenLength; ++i)
            parent.removeChild(currentChildren[i].node);
};

/** Updates the node data of a node */
F.prototype.updateNodeData = function (node, currentNodeData, updatedNodeData, isSvg) {
    updateStyles(node, currentNodeData.styles, updatedNodeData.styles);

    updateAttributes(node, currentNodeData.attributes, updatedNodeData.attributes);

    updateClasses(node, currentNodeData.classes, updatedNodeData.classes, isSvg);

    updateProperties(node, currentNodeData.properties, updatedNodeData.properties);

    this.updateEvents(node, currentNodeData.events, updatedNodeData.events);
};

/** Updates the style attribute of a node */
function updateStyles(node, currentStyles, updatedStyles) {
    if (currentStyles === undefined) {
        if (updatedStyles !== undefined)
            createStyles(node, updatedStyles);
    }
    else if (updatedStyles === undefined) {
        if (currentStyles !== undefined)
            node.removeAttribute(styleAttribute);
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

        let newKeys = Object.keys(updatedStyles);

        for (let i = 0; matchCount < newKeys.length && i < newKeys.length; ++i) {
            let key = newKeys[i];

            if (currentStyles[key] === undefined) {
                let updated = updatedStyles[key];
                ++matchCount;

                if (updated !== undefined)
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
            for (let key of currentAttributes)
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

        let newKeys = Object.keys(updatedAttributes);

        for (let i = 0; matchCount < newKeys.length && i < newKeys.length; ++i) {
            let key = newKeys[i];

            if (currentAttributes[key] === undefined) {
                let updated = updatedAttributes[key];
                ++matchCount;

                if (updated !== undefined)
                    node.setAttribute(key, updated);
            }
        }
    }
}

/** Updates the properties of a node */
function updateProperties(node, currentProperties, updatedProperties) {
    if (updatedProperties !== undefined)
        for (let key in updatedProperties) {
            let current = currentProperties === undefined ? undefined : currentProperties[key],
                updated = updatedProperties[key];

            if (current !== updated)
                node[key] = updated;
        }
}

/** Updates the synthetic events of a node */
F.prototype.updateEvents = function (node, currentEvents, updatedEvents) {
    if (currentEvents === undefined) {
        if (updatedEvents !== undefined)
            this.createEvents(node, updatedEvents);
    }
    else if (updatedEvents === undefined) {
        if (currentEvents !== undefined)
            this.removeEvents(Object.keys(currentEvents));
    }
    else {
        let matchCount = 0;
        //since we have gone over the pain of not wrapping events whenever possible,
        // some function references can be compared
        for (let key in currentEvents)
            if (updatedEvents[key] !== undefined && currentEvents[key] !== updatedEvents[key]) {
                node[eventPrefix + key] = updatedEvents[key];
                matchCount++;
            }

        let newKeys = Object.keys(updatedEvents);

        for (let i = 0; matchCount < newKeys.length && i < newKeys.length; ++i) {
            let key = newKeys[i];

            if (currentEvents[key] === undefined) {
                this.removeEvents(node, [key]);
                ++matchCount;
            }
        }
    }
};

/** Remove all given synthetic events from a node */
F.prototype.removeEvents = function (node, eventNames) {
    for (let name of eventNames) {
        node[eventPrefix + name] = undefined;

        this.applicationEvents[name] = this.applicationEvents[name] - 1;
        if (this.applicationEvents[name] === 0) {
            this.applicationEvents[name] = undefined;
            document.removeEventListener(name, this.runEvent.bind(this), false);
        }
    }
};