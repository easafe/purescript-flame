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
 *  - CSS styles cascade
 *  - React Native only styles are applied
*/
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
        let props = {},
            style = styles();

        if (style !== undefined)
            props.style = style;

        return props;
    }

    function styles() {
        if (html.nodeData === undefined || html.nodeData.nativeStyles === undefined) {
            if (parentStyles === undefined)
                return undefined;

            return parentStyles;
        }
        else {
            if (parentStyles === undefined)
                return html.nodeData.nativeStyles;

            return parentStyles.concat(html.nodeData.nativeStyles);
        }
    }
}