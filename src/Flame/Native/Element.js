import  {createElement } from 'react';
import { View, Text, Button, TextInput, StyleSheet, Image } from 'react-native';

let styleData = 1,
    classData = 2,
    keyData = 7;

let initialStyles = StyleSheet.create({
    hr: {
        borderBottomColor: 'black',
        borderBottomWidth: StyleSheet.hairlineWidth,
    },
    table : {
        flexDirection: 'column'
    },
    tr : {
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    b: {
        fontWeight: 'bold'
   }
});

export function createViewNode(nodeData) {
    return function (children) {
        let props = fromNodeData(nodeData)

        return createElement(View, props, ...children);
    };
}

export function createButtonNode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData)
        props.title = children[0] ;

        return createElement(Button, props);
    }
}

export function createHrNode(nodeData) {
    let props = fromNodeData(nodeData);

    if (props.style === undefined)
        props.style = [initialStyles.hr];
    else {
        props.style = [initialStyles.hr, props.style];
    }

    return createViewNode(nodeData)(undefined);
}

export function createTableNode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData);

        if (props.style === undefined)
            props.style = [initialStyles.table];
        else {
            props.style = [initialStyles.table, props.style];
        }

        return createElement(View, props, ...children);
    }
}

export function createTrNode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData);

        if (props.style === undefined)
            props.style = [initialStyles.tr];
        else {
            props.style = [initialStyles.tr, props.style];
        }

        return createElement(View, props, ...children);
    }
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

export function createBNode(nodeData) {
    return function(children) {
        let props = fromNodeData(nodeData);

        if (props.style === undefined)
            props.style = [initialStyles.b];
        else {
            props.style = [initialStyles.b, props.style];
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
    let nodeData = {};

    if (allData !== undefined)
        for (let data of allData) {
            let dataOne = data[1];
            //[0] also always contain the data type
            switch (data[0]) {
                case styleData:
                    nodeData.style = dataOne;
                    break;
    //            case classData:
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

    return nodeData;
}
