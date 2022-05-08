
export function querySelector_(selector) {
    return document.querySelector(selector);
}

export function textContent_(element) {
    return element.textContent || '';
}

export function removeElement_(selector) {
    document.querySelector(selector).remove();
}

export function createWindowListener_(eventName, updater) {
    window.addEventListener(eventName, function(event) {
        updater(event)();
    });
}

export function createDocumentListener_(eventName, updater) {
    document.addEventListener(eventName, function(event) {
        updater(event)();
    });
}

export function createCustomListener_(eventName, updater) {
    document.addEventListener(eventName, function (event) {
        updater(event.detail)();
    });
}

export function dispatchCustomEvent_(eventName, payload) {
    document.dispatchEvent(new CustomEvent(eventName, { detail: payload } ));
}