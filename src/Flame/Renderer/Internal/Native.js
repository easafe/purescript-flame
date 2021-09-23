'use strict';

let namespace = 'http://www.w3.org/2000/svg',
    eventPrefix = '__flame_',
    eventPostfix = 'updater';
let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5,
    managedNode = 6;

exports.start_ = function (eventWrapper, root, updater) {
    return new N(eventWrapper, root, updater, html);
};

function N(eventWrapper, updater, html) {
    this.eventWrapper = eventWrapper;
    this.updater = updater;
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
N.render = function (html) {

}
