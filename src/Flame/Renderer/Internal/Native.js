import React, { Component } from 'react';
import { AppRegistry } from 'react-native';

//as far as I can tell we need this because for class based components react expects a class type and not an instance
let reactWrapper = { app : undefined },
    initialMarkup,
    initialState;

//needed so we can run events as it is
global.globalFlameEventWrapper = undefined;
global.globalFlameUpdater = undefined;

export function start_(eventWrapper, updater, name, markup, state) {
    initialMarkup = markup;
    initialState = state;

    global.globalFlameEventWrapper = eventWrapper;
    global.globalFlameUpdater = updater;

    AppRegistry.registerComponent(name, function () {
        return N;
    });

    return reactWrapper;
};

export function resume_(wrapper, view, model) {
    wrapper.app.flameRender(view(model), model);
};

class N extends Component {
    flameMarkup;

    constructor() {
        super();

        this.flameMarkup = initialMarkup;
        this.state = initialState;

        reactWrapper.app = this;
    }

    flameRender(newMarkup, newState) {
        this.flameMarkup = newMarkup;
        this.setState(newState);
    }

    render() {
        return this.flameMarkup;
    }
}

// let textNode = 1,
//     elementNode = 2,
//     svgNode = 3,
//     fragmentNode = 4,
//     lazyNode = 5,
//     managedNode = 6;

// let boldStyle = { fontWeight: 'bold' },
//     italicStyle = { fontStyle: 'italic' },
//     underlineStyle = { textDecorationLine: 'underline' },
//     strikethroughStyle = { textDecorationLine: 'line-through' },
//     codeStyle = { fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace' };

// let defaultStyles = native.StyleSheet.create({
//     b: boldStyle,
//     strong: boldStyle,
//     i: italicStyle,
//     em: italicStyle,
//     u: underlineStyle,
//     s: strikethroughStyle,
//     strike: strikethroughStyle,
//     pre: codeStyle,
//     code: codeStyle,
//     a: {
//         fontWeight: 'bold',
//         color: '#007AFF',
//     },
//     h1: { fontWeight: 'bold', fontSize: 36 },
//     h2: { fontWeight: 'bold', fontSize: 30 },
//     h3: { fontWeight: 'bold', fontSize: 24 },
//     h4: { fontWeight: 'bold', fontSize: 18 },
//     h5: { fontWeight: 'bold', fontSize: 14 },
//     h6: { fontWeight: 'bold', fontSize: 12 },
// });

// function render(nodes, parentStyles) {
//     switch (nodes.nodeType) {
//         case textNode:
//             return createTextElement(nodes.text, parentStyles);
//         case elementNode:
//             let props = createProps(nodes, parentStyles);

//             if (nodes.children !== undefined && nodes.children.length > 0) {
//                 let children = [];

//                 for (let i = 0; i < nodes.children.length; i++)
//                     children.push(this.render(nodes.children[i], props.style));

//                 return react.createElement(native.View, props, children);
//             }
//             else if (nodes.text !== undefined)
//                 return react.createElement(native.View, props, createTextElement(nodes.text));
//             else if (nodes.tag === 'br')
//                 return react.createElement(native.Text); //creates an empty line
//             //img
//             //button or input type button or input type submit
//             //some attribute to specify a native tag

//             return react.createElement(native.View);
//         case svgNode:
//             //check https://github.com/react-native-svg/react-native-svg
//             throw 'SVG not implemented yet';
//         case fragmentNode:
//             let children = [];

//             for (let i = 0; i < nodes.children.length; i++)
//                 children.push(this.render(nodes.children[i], undefined));

//             return react.createElement(react.Fragment, undefined, children);
//         case lazyNode:
//             throw 'lazy node not implemented yet';
//         case managedNode:
//             throw 'managed node not implemented yet';
//     }
// }

// function createTextElement(text, parentStyles) {
//     return react.createElement(native.Text, createProps(nodes, parentStyles), text);
// }

// function createProps(nodes,parentStyles) {
//     let props = {
//         style: styles(nodes, parentStyles)
//     };

//     return props;
// }

// function styles(nodes, parentStyles) {
//     let defaultStyle = defaultStyles[nodes.tag];
//     let htmlStyle;

//     if (nodes.nodeData === undefined || nodes.nodeData.nativeStyles === undefined) {
//         if (parentStyles !== undefined)
//             htmlStyle = parentStyles;
//     }
//     else {
//         if (parentStyles === undefined)
//             htmlStyle = nodes.nodeData.nativeStyles;
//         else
//             htmlStyle = parentStyles.concat(nodes.nodeData.nativeStyles);
//     }

//     if (defaultStyle === undefined)
//         return htmlStyle;

//     if (htmlStyle === undefined)
//         return defaultStyle;

//     return defaultStyle.concat(htmlStyle);
// }
