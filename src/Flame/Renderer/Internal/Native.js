'use strict';
let react = require('react');
let native = require('react-native');

let namespace = 'http://www.w3.org/2000/svg',
    eventPrefix = '__flame_',
    eventPostfix = 'updater';
let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5,
    managedNode = 6;

let boldStyle = { fontWeight: 'bold' },
    italicStyle = { fontStyle: 'italic' },
    underlineStyle = { textDecorationLine: 'underline' },
    strikethroughStyle = { textDecorationLine: 'line-through' },
    codeStyle = { fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace' };

let defaultStyles = native.StyleSheet.create({
    b: boldStyle,
    strong: boldStyle,
    i: italicStyle,
    em: italicStyle,
    u: underlineStyle,
    s: strikethroughStyle,
    strike: strikethroughStyle,
    pre: codeStyle,
    code: codeStyle,
    a: {
        fontWeight: 'bold',
        color: '#007AFF',
    },
    h1: { fontWeight: 'bold', fontSize: 36 },
    h2: { fontWeight: 'bold', fontSize: 30 },
    h3: { fontWeight: 'bold', fontSize: 24 },
    h4: { fontWeight: 'bold', fontSize: 18 },
    h5: { fontWeight: 'bold', fontSize: 14 },
    h6: { fontWeight: 'bold', fontSize: 12 },
});

exports.start_ = function (eventWrapper, updater, name, html) {
    return new N(eventWrapper, updater, name, html);
};

function N(eventWrapper, updater, name, html) {
    let n = this;

    n.eventWrapper = eventWrapper;
    n.updater = updater;

    native.AppRegistry.registerComponent(name, function () {
        return function () {
            return n.render(html, [])
        }
    });
}

/** Transforms html into react markup
 *
 *  This is a best effort attempt, with the following considerations
 *
 *  - Elements have a base style that matches their function (e.g. <b> is bold)
 *  - CSS styles are converted to React Native styles
 *  - Styles cascade
 * */
N.prototype.render = function (html, parentStyles) {
    switch (html.nodeType) {
        case textNode:
            return createTextElement(html.text);
        case elementNode:
            let props = createProps();

            if (html.children !== undefined && html.children.length > 0) {
                let children = [];

                for (let i = 0; i < html.children.length; i++)
                    children.push(this.render(html.children[i], props.style));

                return react.createElement(native.View, props, children);
            }
            else if (html.text !== undefined)
                return react.createElement(native.View, props, createTextElement(html.text));
            else if (html.tag === 'br')
                return react.createElement(native.Text); //creates an empty line

            return react.createElement(native.View);
        case svgNode:
            //check https://github.com/react-native-svg/react-native-svg
            throw 'SVG not implemented yet';
        case fragmentNode:
            let children = [];

            for (let i = 0; i < html.children.length; i++)
                children.push(this.render(html.children[i], undefined));

            return react.createElement(react.Fragment, undefined, children);
        case lazyNode:
            throw 'lazy node not implemented yet';
        case managedNode:
            throw 'managed node not implemented yet';
    }

    //spago bundle-app removes non exported functions......
    function createTextElement(text) {
        return react.createElement(native.Text, createProps(), text);
    }

    function createProps() {
        let props = {
            style: styles()
        };

        return props;
    }

    function styles() {
        let defaultStyle = defaultStyles[html.tag];
        let htmlStyle;

        if (html.nodeData === undefined || html.nodeData.nativeStyles === undefined) {
            if (parentStyles !== undefined)
                htmlStyle = parentStyles;
        }
        else {
            if (parentStyles === undefined)
                htmlStyle = html.nodeData.nativeStyles;

            else
                htmlStyle = parentStyles.concat(html.nodeData.nativeStyles);
        }

        if (defaultStyle === undefined)
            return htmlStyle;

        if (htmlStyle === undefined)
            return defaultStyle;

        return defaultStyle.concat(htmlStyle);
    }
}