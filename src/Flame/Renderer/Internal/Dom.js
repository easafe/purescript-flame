let svgNamespace = 'http://www.w3.org/2000/svg',
    eventPrefix = '__flame_',
    eventPostfix = 'updater';
let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5,
    managedNode = 6;
//these events do not bubble, so they cannot be delegated to the root
let nonBubblingEvents = new Set([
    'focus',
    'blur',
    'scroll',
    'scrollend',
    'load',
    'unload',
    'error',
    'abort',
    'mouseenter',
    'mouseleave',
    'pointerenter',
    'pointerleave',
    'toggle',
    'invalid',
    'cancel',
    'close',
    'play',
    'playing',
    'pause',
    'ended',
    'emptied',
    'stalled',
    'suspend',
    'waiting',
    'seeking',
    'seeked',
    'timeupdate',
    'durationchange',
    'ratechange',
    'volumechange',
    'progress',
    'loadstart',
    'loadeddata',
    'loadedmetadata',
    'canplay',
    'canplaythrough'
]);
/** Properties whose reflected attribute is not just the lower cased name */
let propertyAttributeNames = new Map([
    ['htmlFor', 'for'],
    ['className', 'class'],
    ['acceptCharset', 'accept-charset'],
    ['httpEquiv', 'http-equiv']
]);

export function start_(eventWrapper, root, updater, html) {
    return new Renderer(eventWrapper, root, updater, html, false);
}

export function startFrom_(eventWrapper, root, updater, html) {
    return new Renderer(eventWrapper, root, updater, html, true);
}

export function resume_(renderer, html) {
    renderer.resume(html);
}

/** Scopes application data since a document can have many mount points */
class Renderer {
    constructor(eventWrapper, root, updater, html, isDry) {
        /** Hack so all kinds of events have the same result type */
        this.eventWrapper = eventWrapper;
        /** Keep track of synthetic events currently registered by saving the total number of events and the handler function */
        this.applicationEvents = new Map();
        /** Mounting point on DOM */
        this.root = root;
        /** User supplied function to process messages */
        this.updater = updater;
        /** The current virtual nodes to be diff'd when the view updates */
        this.cachedHtml = checkCopy(html);

        //"dry" application means that it was server side rendered
        if (isDry)
            this.hydrate(this.root, this.cachedHtml);
        else
            this.createAllNodes(this.root, this.cachedHtml, null);
    }

    /** Patches the application with the updated view */
    resume(updatedHtml) {
        this.cachedHtml = this.updateAllNodes(this.root, this.cachedHtml, updatedHtml, null);
    }

    /** Installs event handlers and sets nodes on the virtual nodes from an existing DOM node */
    hydrate(node, html) {
        //here we trust that the nodes on the parent match the virtual node structure
        switch (html.nodeType) {
            case lazyNode:
                renderLazy(html);
                this.hydrate(node, html.rendered);
                html.node = html.rendered.node;
                break;
            case textNode:
                html.node = node;
                break;
            case fragmentNode:
                html.node = document.createDocumentFragment();
                this.hydrateChildren(node, html.children, { index: 0 });
                break;
            default:
                html.node = node;

                if (html.nodeData.events !== undefined)
                    this.createAllEvents(node, html);

                if (html.text === undefined && html.children !== undefined)
                    this.hydrateChildren(node, html.children, { index: 0 });
        }
    }

    /** Hydrates children against the child nodes of the parent; the cursor is shared with nested fragments as they have no node of their own */
    hydrateChildren(parent, children, cursor) {
        let childrenLength = children.length;

        for (let i = 0; i < childrenLength; ++i)
            this.hydrateChild(parent, children[i] = checkCopy(children[i]), cursor);
    }

    hydrateChild(parent, html, cursor) {
        let childNodes = parent.childNodes;

        switch (html.nodeType) {
            case fragmentNode:
                html.node = document.createDocumentFragment();
                this.hydrateChildren(parent, html.children, cursor);
                break;
            case lazyNode:
                renderLazy(html);
                this.hydrateChild(parent, html.rendered, cursor);
                html.node = html.rendered.node;
                break;
            //managed nodes are not rendered server side
            case managedNode:
                this.createAllNodes(parent, html, childNodes[cursor.index] ?? null);
                //child nodes is a live list, so the index must skip the node just inserted
                cursor.index++;
                break;
            default:
                let node = childNodes[cursor.index];

                //will happen when the client side view is different from the server side view or actual dom
                if (node === undefined)
                    this.createAllNodes(parent, html, null);
                else
                    this.hydrate(node, html);

                cursor.index++;
        }
    }

    /** Creates all nodes from a given html into a parent, before the reference node (or appended if null) */
    createAllNodes(parent, html, referenceNode) {
        if (html.nodeType === lazyNode) {
            renderLazy(html);
            this.createAllNodes(parent, html.rendered, referenceNode);
            html.node = html.rendered.node;

            return;
        }

        let node = this.createNode(html);

        if (html.text !== undefined)
            node.textContent = html.text;
        else if (html.children !== undefined)
            this.createChildrenNodes(node, html.children);

        parent.insertBefore(node, referenceNode);
    }

    /** Abstract over shallow copying a html object before creating its nodes */
    checkCreateAllNodes(parent, html, referenceNode) {
        html = checkCopy(html);
        this.createAllNodes(parent, html, referenceNode);

        return html;
    }

    /** Children nodes must be recursively created */
    createChildrenNodes(parent, children) {
        let childrenLength = children.length;

        for (let i = 0; i < childrenLength; ++i)
            this.createAllNodes(parent, children[i] = checkCopy(children[i]), null);
    }

    /** Creates a single node and sets its node data */
    createNode(html) {
        switch (html.nodeType) {
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
    }

    /** Creates a node of type element */
    createElement(html) {
        let element = document.createElement(html.tag);

        this.createNodeData(element, html, false);

        return element;
    }

    /** Creates a node of type svg */
    createSvg(html) {
        let svg = document.createElementNS(svgNamespace, html.tag);

        this.createNodeData(svg, html, true);

        return svg;
    }

    /** Creates a node from a user supplied function */
    createManagedNode(html) {
        let node = html.createNode(html.arg)();

        this.createNodeData(node, html, isSvgElement(node));

        return node;
    }

    /** Sets node data: attributes, properties, events, etc */
    createNodeData(node, html, isSvg) {
        let nodeData = html.nodeData;

        if (nodeData.styles !== undefined)
            for (let key in nodeData.styles)
                node.style.setProperty(key, nodeData.styles[key]);

        if (nodeData.classes !== undefined && nodeData.classes.length > 0)
            setClasses(node, nodeData.classes.join(' '), isSvg);

        if (nodeData.attributes !== undefined)
            for (let key in nodeData.attributes)
                node.setAttribute(key, nodeData.attributes[key]);

        if (nodeData.properties !== undefined)
            for (let key in nodeData.properties)
                node[key] = nodeData.properties[key];

        if (nodeData.events !== undefined)
            this.createAllEvents(node, html);
    }

    /** Creates synthetic events
     *
     *  If the event bubbles, a single listener for its type is added to the root, and fired at the nearest node from the target that contains a handler. Otherwise the event is added to the node */
    createAllEvents(node, html) {
        for (let key in html.nodeData.events)
            this.createEvent(node, key, html);
    }

    createEvent(node, name, html) {
        let handlers = html.nodeData.events[name],
            eventKey = eventPrefix + name;

        if (nonBubblingEvents.has(name)) {
            let runNonBubblingEvent = event => this.runHandlers(handlers, html.messageMapper, event);

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
                let runEvent = event => this.runEvent(event);

                this.root.addEventListener(name, runEvent, false);
                this.applicationEvents.set(name, {
                    count: 1,
                    handler: runEvent
                });
            }
            else
                synthetic.count++;
        }
    }

    /** Finds and runs the handler of a synthetic event */
    runEvent(event) {
        let node = event.target,
            eventKey = eventPrefix + event.type;

        while (node !== null && node !== this.root) {
            let handlers = node[eventKey];

            if (handlers !== undefined) {
                this.runHandlers(handlers, node[eventKey + eventPostfix], event);

                return;
            }
            node = node.parentNode;
        }
    }

    /** Runs all event handlers for a given event */
    runHandlers(handlers, messageMapper, event) {
        let handlersLength = handlers.length;

        for (let i = 0; i < handlersLength; ++i) {
            let h = handlers[i],
                //handler can be just a message or a function that takes an event
                maybeMessage = typeof h === 'function' ? h(event)() : this.eventWrapper(h);

            this.updater(messageMapper === undefined ? maybeMessage : messageMapper(maybeMessage))();
        }
        event.stopPropagation();
    }

    /** Patches a node; the reference node is where new nodes go if the html is a fragment (null to append) */
    updateAllNodes(parent, currentHtml, updatedHtml, referenceNode) {
        //if node is already defined, then this object has been reused in views
        updatedHtml = checkCopy(updatedHtml);

        //recreate node if it has changed tag or node type
        if (currentHtml.tag !== updatedHtml.tag || currentHtml.nodeType !== updatedHtml.nodeType) {
            this.createAllNodes(parent, updatedHtml, firstDomNode(currentHtml) ?? referenceNode);
            removeNode(parent, currentHtml);

            return updatedHtml;
        }

        switch (updatedHtml.nodeType) {
            case lazyNode:
                if (updatedHtml.arg !== currentHtml.arg) {
                    renderLazy(updatedHtml);
                    updatedHtml.rendered = this.updateAllNodes(parent, currentHtml.rendered, updatedHtml.rendered, referenceNode);
                }
                else
                    updatedHtml.rendered = currentHtml.rendered;

                updatedHtml.node = updatedHtml.rendered.node;
                break;
            case managedNode:
                let node = updatedHtml.updateNode(currentHtml.node)(currentHtml.arg)(updatedHtml.arg)(),
                    isSvg = isSvgElement(node);

                if (node !== currentHtml.node) {
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
                updatedHtml.node = currentHtml.node;

                if (updatedHtml.text !== currentHtml.text)
                    updatedHtml.node.textContent = updatedHtml.text;
                break;
            //fragments nodes only count for their children, which live on the parent
            case fragmentNode:
                updatedHtml.node = currentHtml.node;
                this.updateChildrenNodes(parent, currentHtml, updatedHtml, referenceNode);
                break;
            //the usual case, element/svg to be patched
            default:
                this.updateElement(currentHtml, updatedHtml);
        }

        return updatedHtml;
    }

    /** Patches node data and contents of an element */
    updateElement(currentHtml, updatedHtml) {
        let node = updatedHtml.node = currentHtml.node;

        this.updateNodeData(node, currentHtml.nodeData, updatedHtml, updatedHtml.nodeType === svgNode);

        //a single text child is stored as the text property instead
        if (updatedHtml.text !== undefined) {
            if (currentHtml.text !== updatedHtml.text)
                node.textContent = updatedHtml.text;
        }
        else if (currentHtml.text !== undefined) {
            //innerHTML was already set by updateNodeData
            if (!hasInnerHtml(updatedHtml.nodeData))
                clearNode(node);

            if (updatedHtml.children !== undefined)
                this.createChildrenNodes(node, updatedHtml.children);
        }
        else
            this.updateChildrenNodes(node, currentHtml, updatedHtml, null);
    }

    /** Patches children of a node */
    updateChildrenNodes(parent, currentHtml, updatedHtml, referenceNode) {
        let currentChildren = currentHtml.children,
            updatedChildren = updatedHtml.children,
            currentLength = currentChildren === undefined ? 0 : currentChildren.length,
            updatedLength = updatedChildren === undefined ? 0 : updatedChildren.length;

        //create all nodes regardless
        if (currentLength === 0) {
            for (let i = 0; i < updatedLength; ++i)
                updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i], referenceNode);
        }
        //remove all nodes regardless
        else if (updatedLength === 0) {
            if (currentHtml.nodeType === fragmentNode)
                removeChildren(parent, currentChildren);
            //innerHTML (which was already set by updateNodeData) replaces the children by itself
            else if (!hasInnerHtml(updatedHtml.nodeData))
                clearNode(parent);
        }
        //if both first nodes have keys, assume keyed
        else if (keyOf(currentChildren[0]) !== undefined && keyOf(updatedChildren[0]) !== undefined)
            this.updateKeyedChildrenNodes(parent, currentHtml, currentChildren, updatedChildren, referenceNode);
        //otherwise use the non keyed algorithm
        else
            this.updateNonKeyedChildrenNodes(parent, currentChildren, updatedChildren, referenceNode);
    }

    /** Non keyed children nodes are compared as it is */
    updateNonKeyedChildrenNodes(parent, currentChildren, updatedChildren, referenceNode) {
        let currentLength = currentChildren.length,
            updatedLength = updatedChildren.length,
            commonLength = Math.min(currentLength, updatedLength);

        //same nodes
        for (let i = 0; i < commonLength; ++i)
            updatedChildren[i] = this.updateAllNodes(parent, currentChildren[i], updatedChildren[i], nextReference(currentChildren, i, referenceNode));

        //new nodes
        for (let i = commonLength; i < updatedLength; ++i)
            updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i], referenceNode);

        //nodes to be removed
        for (let i = commonLength; i < currentLength; ++i)
            removeNode(parent, currentChildren[i]);
    }

    /** Keyed algorithm adapted from stage0
     *
     * https://github.com/Freak613/stage0/blob/21027de473bd6fc51e499fa8a505c4ea700bc8e9/keyed.js
     *
     * Keyed children are expected to be single nodes (elements, text or managed nodes); children without a key are recreated */
    updateKeyedChildrenNodes(parent, parentHtml, currentChildren, updatedChildren, referenceNode) {
        let currentStart = 0,
            updatedStart = 0,
            currentEnd = currentChildren.length - 1,
            updatedEnd = updatedChildren.length - 1;

        //these are used to keep track of moved nodes
        let afterNode = referenceNode,
            currentStartNode = currentChildren[currentStart].node,
            updatedStartNode = currentStartNode,
            currentEndNode = currentChildren[currentEnd].node;

        let currentHtml,
            updatedHtml,
            loop = true;

        fixes: while (loop) {
            loop = false;

            currentHtml = currentChildren[currentStart];
            updatedHtml = updatedChildren[updatedStart];

            //common prefix of current and updated children
            while (sameKey(currentHtml, updatedHtml)) {
                updatedChildren[updatedStart] = this.updateAllNodes(parent, currentHtml, updatedHtml, null);
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
            while (sameKey(currentHtml, updatedHtml)) {
                updatedChildren[updatedEnd] = this.updateAllNodes(parent, currentHtml, updatedHtml, null);
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
            while (sameKey(currentHtml, updatedHtml)) {
                loop = true;

                updatedChildren[updatedStart] = this.updateAllNodes(parent, currentHtml, updatedHtml, null);
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
            while (sameKey(currentHtml, updatedHtml)) {
                loop = true;

                updatedChildren[updatedEnd] = this.updateAllNodes(parent, currentHtml, updatedHtml, null);
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

        if (updatedEnd < updatedStart) {
            //remove nodes
            while (currentStart <= currentEnd) {
                removeNode(parent, currentChildren[currentEnd]);
                currentEnd--;
            }
        }
        else if (currentEnd < currentStart) {
            //add nodes
            while (updatedStart <= updatedEnd) {
                updatedChildren[updatedStart] = this.checkCreateAllNodes(parent, updatedChildren[updatedStart], afterNode);
                updatedStart++;
            }
        }
        else {
            //position on the current children of the node to be reused at position i, or -1 if it should be created
            let P = new Array(updatedEnd + 1).fill(-1);
            //maps keys to positions on the updated children
            let I = new Map();

            for (let i = updatedStart; i <= updatedEnd; i++) {
                let key = keyOf(updatedChildren[i]);

                if (key !== undefined)
                    I.set(key, i);
            }

            let reusingNodes = updatedStart + updatedChildren.length - 1 - updatedEnd,
                toRemove = [];

            for (let i = currentStart; i <= currentEnd; i++) {
                let key = keyOf(currentChildren[i]);

                if (key !== undefined && I.has(key)) {
                    P[I.get(key)] = i;
                    reusingNodes++;
                }
                else
                    toRemove.push(i);
            }

            if (reusingNodes === 0 && parentHtml.nodeType !== fragmentNode) {
                //replace all nodes
                clearNode(parent);

                for (let i = updatedStart; i <= updatedEnd; i++)
                    updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i], null);
            }
            else {
                //remove nodes
                let toRemoveLength = toRemove.length;

                for (let i = 0; i < toRemoveLength; i++)
                    removeNode(parent, currentChildren[toRemove[i]]);

                //move nodes
                let longestSeq = longestSubsequence(P, updatedStart),
                    seqIndex = longestSeq.length - 1;

                for (let i = updatedEnd; i >= updatedStart; i--) {
                    if (longestSeq[seqIndex] === i) {
                        currentHtml = currentChildren[P[i]];
                        updatedChildren[i] = this.updateAllNodes(parent, currentHtml, updatedChildren[i], null);
                        afterNode = currentHtml.node;
                        seqIndex--;
                    }
                    else if (P[i] === -1) {
                        updatedChildren[i] = this.checkCreateAllNodes(parent, updatedChildren[i], afterNode);
                        afterNode = updatedChildren[i].node;
                    }
                    else {
                        currentHtml = currentChildren[P[i]];
                        updatedChildren[i] = this.updateAllNodes(parent, currentHtml, updatedChildren[i], null);
                        parent.insertBefore(currentHtml.node, afterNode);
                        afterNode = currentHtml.node;
                    }
                }
            }
        }
    }

    /** Updates the node data of a node */
    updateNodeData(node, currentNodeData, updatedHtml, isSvg) {
        let updatedNodeData = updatedHtml.nodeData;

        updateObject(currentNodeData.styles, updatedNodeData.styles, (key, value) => node.style.setProperty(key, value), key => node.style.removeProperty(key));
        updateObject(currentNodeData.attributes, updatedNodeData.attributes, (key, value) => node.setAttribute(key, value), key => node.removeAttribute(key));
        updateClasses(node, currentNodeData.classes, updatedNodeData.classes, isSvg);
        updateObject(currentNodeData.properties, updatedNodeData.properties, (key, value) => node[key] = value, key => removeProperty(node, key));
        this.updateEvents(node, currentNodeData.events, updatedHtml);
    }

    /** Updates node events */
    updateEvents(node, currentEvents, updatedHtml) {
        let updatedEvents = updatedHtml.nodeData.events;

        if (currentEvents === undefined) {
            if (updatedEvents !== undefined)
                this.createAllEvents(node, updatedHtml);
        }
        else if (updatedEvents === undefined) {
            for (let key in currentEvents)
                this.removeEvent(node, key);
        }
        else {
            for (let key in currentEvents) {
                let updated = updatedEvents[key];

                if (updated === undefined)
                    this.removeEvent(node, key);
                //since handlers are compared by reference, more often than not we will unlisten and listen on an event again
                else if (!sameHandlers(currentEvents[key], updated)) {
                    this.removeEvent(node, key);
                    this.createEvent(node, key, updatedHtml);
                }
            }

            for (let key in updatedEvents)
                if (currentEvents[key] === undefined)
                    this.createEvent(node, key, updatedHtml);
        }
    }

    /** Removes a given event from a node */
    removeEvent(node, name) {
        let eventKey = eventPrefix + name;

        if (nonBubblingEvents.has(name))
            node.removeEventListener(name, node[eventKey], false);
        else {
            let synthetic = this.applicationEvents.get(name);

            if (--synthetic.count === 0) {
                this.root.removeEventListener(name, synthetic.handler, false);
                this.applicationEvents.delete(name);
            }
        }
        //functor mapping
        node[eventKey + eventPostfix] = undefined;
        node[eventKey] = undefined;
    }
}

/** Html objects can be reused in views, so they are copied if their node was already set */
function checkCopy(html) {
    return html.node === undefined ? html : shallowCopy(html);
}

/** Copies a given html so properties are not overwritten by reuse */
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
                children: origin.children.slice()
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
                children: origin.children === undefined ? undefined : origin.children.slice(),
                text: origin.text,
                messageMapper: origin.messageMapper
            };
    }
}

/** Renders a lazy node, applying the functor mapping (if any) to the whole rendered tree */
function renderLazy(html) {
    html.rendered = html.render(html.arg);

    if (html.messageMapper !== undefined)
        lazyMessageMap(html.messageMapper, html.rendered);
}

/** Composes the message mapper of a lazy node with the ones already present on its rendered tree */
function lazyMessageMap(mapper, html) {
    if (html.nodeType !== textNode && html.nodeType !== fragmentNode) {
        if (html.messageMapper === undefined)
            html.messageMapper = mapper;
        else {
            let previousMessageMapper = html.messageMapper;

            html.messageMapper = message => mapper(previousMessageMapper(message));
        }
    }

    if (html.children !== undefined)
        for (let i = 0; i < html.children.length; ++i)
            lazyMessageMap(mapper, html.children[i]);
}

/** First actual DOM node of a given html, or undefined for empty fragments */
function firstDomNode(html) {
    switch (html.nodeType) {
        case fragmentNode:
            for (let i = 0; i < html.children.length; ++i) {
                let node = firstDomNode(html.children[i]);

                if (node !== undefined)
                    return node;
            }

            return undefined;
        case lazyNode:
            return firstDomNode(html.rendered);
        default:
            return html.node;
    }
}

/** DOM node that follows the child at the given position, falling back to the reference node of the parent */
function nextReference(children, i, referenceNode) {
    let html = children[i];

    //only fragments (or lazy nodes that may render fragments) need to know where their contents end
    if (html.nodeType !== fragmentNode && html.nodeType !== lazyNode)
        return null;

    for (let j = i + 1; j < children.length; ++j) {
        let node = firstDomNode(children[j]);

        if (node !== undefined)
            return node;
    }

    return referenceNode;
}

/** Removes the actual DOM nodes of a given html */
function removeNode(parent, html) {
    switch (html.nodeType) {
        case fragmentNode:
            removeChildren(parent, html.children);
            break;
        case lazyNode:
            removeNode(parent, html.rendered);
            break;
        default:
            parent.removeChild(html.node);
    }
}

function removeChildren(parent, children) {
    for (let i = 0; i < children.length; ++i)
        removeNode(parent, children[i]);
}

function clearNode(node) {
    node.textContent = '';
}

//innerHTML property is a pain in the ass
function hasInnerHtml(nodeData) {
    return nodeData !== undefined && nodeData.properties !== undefined && nodeData.properties.innerHTML !== undefined;
}

function isSvgElement(node) {
    return node.namespaceURI === svgNamespace;
}

function keyOf(html) {
    return html.nodeData === undefined ? undefined : html.nodeData.key;
}

/** Children without keys never match, so they are recreated by the keyed algorithm */
function sameKey(currentHtml, updatedHtml) {
    let key = keyOf(currentHtml);

    return key !== undefined && key === keyOf(updatedHtml);
}

function sameHandlers(currentHandlers, updatedHandlers) {
    if (currentHandlers.length !== updatedHandlers.length)
        return false;

    for (let i = 0; i < currentHandlers.length; ++i)
        if (currentHandlers[i] !== updatedHandlers[i])
            return false;

    return true;
}

/** Sets className property for elements and class attribute for svg */
function setClasses(node, joined, isSvg) {
    if (isSvg)
        node.setAttribute('class', joined);
    else
        node.className = joined;
}

function updateClasses(node, currentClasses, updatedClasses, isSvg) {
    let current = currentClasses === undefined ? '' : currentClasses.join(' '),
        updated = updatedClasses === undefined ? '' : updatedClasses.join(' ');

    if (current !== updated)
        setClasses(node, updated, isSvg);
}

/** Diffs two objects of node data (styles, attributes or properties), calling set for new or changed keys and remove for missing ones */
function updateObject(current, updated, set, remove) {
    if (current === undefined) {
        if (updated !== undefined)
            for (let key in updated)
                set(key, updated[key]);
    }
    else if (updated === undefined) {
        for (let key in current)
            remove(key);
    }
    else {
        for (let key in current) {
            let value = updated[key];

            if (value === undefined)
                remove(key);
            else if (value !== current[key])
                set(key, value);
        }

        for (let key in updated)
            if (current[key] === undefined)
                set(key, updated[key]);
    }
}

/** Unsets a property set by a previous render
 *
 *  Reflected properties (id, tabIndex, colSpan, checked...) are backed by an attribute: removing it restores the default value. Content properties have no attribute so they are cleared instead */
function removeProperty(node, key) {
    if (key === 'innerHTML' || key === 'textContent' || key === 'value')
        node[key] = '';
    else if (typeof node[key] === 'boolean')
        node[key] = false;

    node.removeAttribute(propertyAttributeNames.get(key) || key.toLowerCase());
}

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
