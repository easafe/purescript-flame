import React, {createElement } from 'react';
import { View, Text, Button, TextInput, StyleSheet, Image } from 'react-native';

let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    lazyNode = 5,
    managedNode = 6;
let styleData = 1,
    classData = 2,
    propertyData = 3,
    attributeData = 4,
    keyData = 7;


export function createViewNode(nodeData) {
    return function (children) {
        let props = fromNodeData(nodeData)

        return createElement(View, props, ...children);
    };
}

export function createButtonNode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData)

        return createElement(Button, { title: children[0], ...props });
    }
}

let initialHrStyle = {
    borderBottomColor: 'black',
    borderBottomWidth: StyleSheet.hairlineWidth,
};

export function createHrNode(nodeData) {
    let props = fromNodeData(nodeData);

    if (props.style === undefined)
        props.style = { ...initialHrStyle};
    else {
        props.style = { ...initialHrStyle, ...props.style };
    }

    return createViewNode(nodeData)(undefined);
}

export function createLabelNode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData),
            propedChildren = [];

        for (let c of children) {
            let txt = text(c);
            txt.props = props;

            propedChildren.push(txt);
        }

        return createViewNode(undefined)(propedChildren);
    }
}

export function createBrNode(nodeData) {
    let txt = text('\n');
    txt.props = fromNodeData(nodeData);

    return txt;
}

export function createInputNode(nodeData) {
    let props = fromNodeData(nodeData);

    if (props.type === 'button' || props.type === 'submit') {
        return createElement(Button, { title: props.value || "", ...props })
    }

    return createElement(TextInput, props);
}

export function createANode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData),
            propedChildren = [];

        for (let c of children) {
            let txt = text(c);
            txt.props = props;

            propedChildren.push(txt);
        }

        return createViewNode(undefined)(propedChildren);
    }
}

let initialBStyle = {
     fontWeight: 'bold'
};

export function createBNode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData);

        if (props.style === undefined)
            props.style = { ...initialBStyle};
        else {
            props.style = { ...initialBStyle, ...props.style };
        }

        let propedChildren = [];

        for (let c of children) {
            let txt = text(c);
            txt.props = props;

            propedChildren.push(txt);
        }

        return createViewNode(undefined)(propedChildren);
    }
}

export function createImageNode(nodeData) {
    let props = fromNodeData(nodeData);

    return createElement(Image, props);
}

export function text(value) {
    return createElement(Text, undefined, value);
}

function fromNodeData(allData) {
    let nodeData;

    if (allData !== undefined) {
        nodeData = {};

        for (let data of allData) {
            let dataOne = data[1];
            //[0] also always contain the data type
            switch (data[0]) {
    //             case styleData:
    //                 if (nodeData.styles === undefined)
    //                     nodeData.styles = {};

    //                 for (let key in dataOne)
    //                     nodeData.styles[key] = dataOne[key];
    //                 break;
    //             case classData:
    //                 if (nodeData.classes === undefined)
    //                     nodeData.classes = [];

    //                 nodeData.classes = nodeData.classes.concat(dataOne);
    //                 break;
    //             case keyData:
    //                 nodeData.key = dataOne;
    //                 break;
                default:
                    nodeData[dataOne] = data[2];
            }
        }
    }

    return nodeData;
}
