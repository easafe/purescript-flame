
exports.querySelector_ = function (selector) {
    return document.querySelector(selector);
};

exports.textContent_ = function (element) {
    return element.textContent || '';
};

exports.removeElement_ = function (selector) {
    document.querySelector(selector).remove();
};

exports.createWindowListener_ = function (eventName, updater) {
    window.addEventListener(eventName, function(event) {
        updater(event)();
    });
};

exports.createDocumentListener_ = function (eventName, updater) {
    document.addEventListener(eventName, function(event) {
        updater(event)();
    });
};

exports.createCustomListener_ = function (eventName, updater) {
    document.addEventListener(eventName, function (event) {
        updater(event.detail)();
    });
};

exports.dispatchCustomEvent_ = function(eventName, payload) {
    document.dispatchEvent(new CustomEvent(eventName, { detail: payload } ));
}