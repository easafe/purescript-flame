let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5,
    managedNode = 6;
let styleData = 1,
    classData = 2,
    propertyData = 3,
    attributeData = 4,
    keyData = 7;

exports.createElementNode = function (tag) {
    return function (nodeData) {
        return function (potentialChildren) {
            let children = potentialChildren,
                text = undefined;

            if (potentialChildren.length === 1 && potentialChildren[0].nodeType == textNode) {
                children = undefined;
                text = potentialChildren[0].text;
            }

            return {
                nodeType: elementNode,
                node: undefined,
                tag: tag,
                nodeData: fromNodeData(nodeData),
                children: children,
                text: text
            };
        };
    };
};

exports.createDatalessElementNode = function (tag) {
    return function (potentialChildren) {
        let children = potentialChildren,
            text = undefined;

        if (potentialChildren.length === 1 && potentialChildren[0].nodeType == textNode) {
            children = undefined;
            text = potentialChildren[0].text;
        }

        return {
            nodeType: elementNode,
            node: undefined,
            tag: tag,
            nodeData: {},
            children: children,
            text: text
        };
    };
};

exports.createSingleElementNode = function (tag) {
    return function (nodeData) {
        return {
            nodeType: elementNode,
            node: undefined,
            tag: tag,
            nodeData: fromNodeData(nodeData)
        };
    };
};

exports.createEmptyElement = function (tag) {
    return {
        nodeType: tag.trim().toLowerCase() === 'svg' ? svgNode : elementNode,
        node: undefined,
        tag: tag,
        nodeData: {}
    };
};

exports.createFragmentNode = function (children) {
    return {
        nodeType: fragmentNode,
        node: undefined,
        children: children
    };
};

exports.text = function (value) {
    return {
        nodeType: textNode,
        node: undefined,
        text: value
    };
};

exports.createLazyNode = function (nodeData) {
    return function (render) {
        return function (arg) {
            let key = nodeData[0];

            return {
                nodeType: lazyNode,
                node: undefined,
                nodeData: key === undefined ? undefined : { key: key },
                render: render,
                arg: arg,
                rendered: undefined
            };
        };
    };
};

exports.createManagedNode = function (render) {
    return function (nodeData) {
        return function (arg) {
            return {
                nodeType: managedNode,
                node: undefined,
                nodeData: fromNodeData(nodeData),
                createNode: render.createNode,
                updateNode: render.updateNode,
                arg: arg
            };
        };
    };
};

exports.createDatalessManagedNode = function (render) {
    return function (arg) {
        return {
            nodeType: managedNode,
            node: undefined,
            nodeData: {},
            createNode: render.createNode,
            updateNode: render.updateNode,
            arg: arg
        };
    };
};

exports.createSvgNode = function (nodeData) {
    return function (children) {
        return {
            nodeType: svgNode,
            node: undefined,
            tag: 'svg',
            nodeData: fromNodeData(nodeData),
            children: asSvg(children)
        };
    };
};

exports.createDatalessSvgNode = function (children) {
    return {
        nodeType: svgNode,
        node: undefined,
        tag: 'svg',
        nodeData: {},
        children: asSvg(children)
    };
};

exports.createSingleSvgNode = function (nodeData) {
    return {
        nodeType: svgNode,
        node: undefined,
        tag: 'svg',
        nodeData: fromNodeData(nodeData)
    };
};

function asSvg(elements) {
    for (let e of elements)
        if (e.nodeType === elementNode)
            e.nodeType = svgNode;

    return elements;
}

function fromNodeData(allData) {
    let nodeData = {};

    if (allData !== undefined)
        for (let data of allData) {
            let dataOne = data[1];
            //[0] also always contain the data type
            switch (data[0]) {
                case styleData:
                    if (nodeData.styles === undefined)
                        nodeData.styles = {};

                    for (let key in dataOne)
                        nodeData.styles[key] = dataOne[key];
                    break;
                case classData:
                    if (nodeData.classes === undefined)
                        nodeData.classes = [];

                    nodeData.classes = nodeData.classes.concat(dataOne);
                    break;
                case propertyData:
                    if (nodeData.properties === undefined)
                        nodeData.properties = {};

                    nodeData.properties[dataOne] = data[2];
                    break;
                case attributeData:
                    if (nodeData.attributes === undefined)
                        nodeData.attributes = {};

                    nodeData.attributes[dataOne] = data[2];
                    break;
                case keyData:
                    nodeData.key = dataOne;
                    break;
                default:
                    if (nodeData.events === undefined)
                        nodeData.events = {};

                    if (nodeData.events[dataOne] === undefined)
                        nodeData.events[dataOne] = [];

                    nodeData.events[dataOne].push(data[2]);
            }
        }

    return nodeData;
}