import jsdom from "jsdom";
const enviroment = (new jsdom.JSDOM('', { runScripts: "outside-only" }));

global.window = enviroment.window;
global.document = enviroment.window.document;
global.SVGElement = enviroment.window.SVGElement;
global.CustomEvent = enviroment.window.CustomEvent;

export function unsafeCreateEnviroment() {
    //removes event listeners and child nodes
    document.body = document.body.cloneNode(false);
    document.body.innerHTML = '<div id=mount-point></div>';
}

export function clickEvent() {
    return new window.Event('click', { bubbles: true });
}

export function inputEvent() {
    return new window.Event('input', { bubbles: true });
}

export function keydownEvent() {
    return new window.KeyboardEvent('keydown', { key: 'q', bubbles: true });
}

export function enterPressedEvent() {
    return new window.KeyboardEvent('keypress', { key: 'Enter', bubbles: true });
}

export function errorEvent() {
    return new window.Event('error', { bubbles: true });
}

export function offlineEvent() {
    return new window.Event('offline', { bubbles: true });
}

export function getCssText(node) {
    return node.style.cssText;
}

export function getAllAttributes(node) {
    let attributes = [];

    for (let i = 0; i < node.attributes.length; i++)
        attributes.push(node.attributes[i].name + ':' + node.attributes[i].value);

    return attributes.join(' ');
}

export function getAllProperties(node) {
    return function (list) {
        let properties = [];

        for (let p of list)
            if (node[p])
                properties.push(node[p] + '');

        return properties;
    };
}

export function innerHtml_(node, html) {
    node.innerHTML = html;
}

export function createSvg() {
    return document.createElementNS('http://www.w3.org/1999/xhtml', 'svg');
}

export function createDiv() {
    return document.createElement('div');
}