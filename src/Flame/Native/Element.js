import  {createElement } from 'react';
import { View, Text, TouchableOpacity, TextInput, StyleSheet, Image } from 'react-native';

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
        let props = toProps(nodeData)

        return createElement(View, props, ...children);
    };
}

let noop = () => {};

export function createButtonNode(nodeData) {
    return function(children) {
        let props = toProps(nodeData),
            title = children[0]
            onPress = noop,
            disabled = false;

        if (props.disabled) {
            disabled = true;
            delete props.disabled;
        }

        if (props.onPress) {
            onPress = props.onPress;
            delete props.onPress;
        }

        return createElement(TouchableOpacity, { onPress, disabled }, createElement(View, props, createElement(Text, props, title.toUpperCase())));
    }
}

export function createHrNode(nodeData) {
    let props = toProps(nodeData);

    if (props.style === undefined)
        props.style = [initialStyles.hr];
    else {
        props.style = [initialStyles.hr, props.style];
    }

    return createElement(View, props, undefined);
}

export function createTableNode(nodeData) {
    return function(children) {
        let props = toProps(nodeData);

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
        let props = toProps(nodeData);

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
        let props = toProps(nodeData),
            propedChildren = [];

        for (let c of children) {
            propedChildren.push(createElement(Text, props, c));
        }

        return createViewNode(undefined)(propedChildren);
    }
}

export function createBrNode(nodeData) {
    return createElement(Text, toProps(nodeData), '\n');
}

export function createInputNode(nodeData) {
    let props = toProps(nodeData);

    if (props.type === 'button' || props.type === 'submit') {
        return createButtonNode(nodeData)([props.value || ""]);
    }

    return createElement(TextInput, props);
}

export function createANode(nodeData) {
    return function(children) {
        let props = toProps(nodeData),
            propedChildren = [];

        for (let c of children) {
            propedChildren.push(createElement(Text, props, c));
        }

        return createElement(View, undefined, ...propedChildren);
    }
}

export function createBNode(nodeData) {
    return function(children) {
        let props = toProps(nodeData);

        if (props.style === undefined)
            props.style = [initialStyles.b];
        else {
            props.style = [initialStyles.b, props.style];
        }

        let propedChildren = [];

        for (let c of children) {
            propedChildren.push(createElement(Text, props, c));
        }

        return createElement(View, undefined, ...propedChildren);
    }
}

export function createImageNode(nodeData) {
    let props = toProps(nodeData);

    return createElement(Image, props);
}

export function text(value) {
    return createElement(Text, undefined, value);
}

function toProps(allData) {
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
