const jsdom = require("jsdom");
const enviroment = (new jsdom.JSDOM('', { runScripts: "outside-only" }));

global.window = enviroment.window;
global.document = enviroment.window.document;
global.SVGElement = enviroment.window.SVGElement;

// a dirty hack to make snabbdom style module import properly
window.requestAnimationFrame = setTimeout;

exports.unsafeCreateEnviroment = function () {
    //removes event listeners and child nodes
    document.body = document.body.cloneNode(false);
    document.body.innerHTML = '<div id=mount-point></div>';
};

exports.clickEvent = function () {
    return new window.Event('click', { bubbles: true });
};

exports.inputEvent = function () {
    return new window.Event('input', { bubbles: true });
};

exports.keydownEvent = function () {
    return new window.KeyboardEvent('keydown', { key: 'q', bubbles: true });
};

exports.enterPressedEvent = function () {
    return new window.KeyboardEvent('keypress', { key: 'Enter', bubbles: true });
};

exports.errorEvent = function () {
    return new window.Event('error', { bubbles: true });
};

exports.offlineEvent = function () {
    return new window.Event('offline', { bubbles: true });
};

exports.getCssText = function (node) {
    return node.style.cssText;
};

exports.getAllAttributes = function (node) {
    let attributes = [];

    for (let i = 0; i < node.attributes.length; i++)
        attributes.push(node.attributes[i].name + ':' + node.attributes[i].value);

    return attributes.join(' ');
};

exports.getAllProperties = function (node) {
    return function (list) {
        let properties = [];

        for (let p of list)
            if (node[p])
                properties.push(node[p] + '');

        return properties;
    };
};

exports.innerHtml_ = function (node, html) {
    node.innerHTML = html;
};

exports.createSvg = function () {
    return document.createElementNS('http://www.w3.org/1999/xhtml', 'svg');
};

exports.createDiv = function () {
    return document.createElement('div');
};