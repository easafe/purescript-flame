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
            return n.render(html)
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
N.prototype.render = function (html) {
    switch (html.nodeType) {
        case textNode:
            return react.createElement(native.Text, {}, html.text);
        case elementNode:
            break;
        case svgNode:
            break;
        case fragmentNode:
            break;
        case lazyNode:
            break;
        case managedNode:
            break;
    }
}



// if (node.type === 'tag') {
//     if (node.name === 'img') {
//         return <Img key={index} attribs={node.attribs} />;
//     }

//     let linkPressHandler = null;
//     let linkLongPressHandler = null;
//     if (node.name === 'a' && node.attribs && node.attribs.href) {
//         linkPressHandler = () =>
//             opts.linkHandler(entities.decodeHTML(node.attribs.href));
//         if (opts.linkLongPressHandler) {
//             linkLongPressHandler = () =>
//                 opts.linkLongPressHandler(entities.decodeHTML(node.attribs.href));
//         }
//     }

//     let linebreakBefore = null;
//     let linebreakAfter = null;
//     if (opts.addLineBreaks) {
//         switch (node.name) {
//             case 'pre':
//                 linebreakBefore = opts.lineBreak;
//                 break;
//             case 'p':
//                 if (index < list.length - 1) {
//                     linebreakAfter = opts.paragraphBreak;
//                 }
//                 break;
//             case 'br':
//             case 'h1':
//             case 'h2':
//             case 'h3':
//             case 'h4':
//             case 'h5':
//                 linebreakAfter = opts.lineBreak;
//                 break;
//         }
//     }

//     let listItemPrefix = null;
//     if (node.name === 'li') {
//         const defaultStyle = opts.textProps ? opts.textProps.style : null;
//         const customStyle = inheritedStyle(parent);

//         if (!parent) {
//             listItemPrefix = null;
//         } else if (parent.name === 'ol') {
//             listItemPrefix = (<Text style={[defaultStyle, customStyle]}>
//                 {`${orderedListCounter++}. `}
//             </Text>);
//         } else if (parent.name === 'ul') {
//             listItemPrefix = (<Text style={[defaultStyle, customStyle]}>
//                 {opts.bullet}
//             </Text>);
//         }
//         if (opts.addLineBreaks && index < list.length - 1) {
//             linebreakAfter = opts.lineBreak;
//         }
//     }

//     const { NodeComponent, styles } = opts;

//     return (
//         <NodeComponent
//             {...opts.nodeComponentProps}
//             key={index}
//             onPress={linkPressHandler}
//             style={!node.parent ? styles[node.name] : null}
//             onLongPress={linkLongPressHandler}
//         >
//             {linebreakBefore}
//             {listItemPrefix}
//             {domToElement(node.children, node)}
//             {linebreakAfter}
//         </NodeComponent>
//     );
// }

function inheritedStyle(parent) {
    // if (!parent) return null;
    // const style = StyleSheet.flatten(opts.styles[parent.name]) || {};
    // const parentStyle = inheritedStyle(parent.parent) || {};
    // return { ...parentStyle, ...style };
}
