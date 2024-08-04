let messageEventData = 5,
    rawEventData = 6;

//the global functions will be set at the native renderer
function messageHandler(message) {
    return function() {
        return global.globalFlameUpdater(global.globalFlameEventWrapper(message))();
    }
}

function rawMessageHandler(handler) {
    return function(event) {
        return global.globalFlameUpdater(handler(event)())();
    }
}

export function createEvent_(name) {
    return function (message) {
        return [messageEventData, name, messageHandler(message)];
    };
}

export function createRawEvent_(name) {
    return function (handler) {
        return [rawEventData, name, rawMessageHandler(handler)];
    };
}

export function checkedValue_(event) {
    if (event.target.tagName === "INPUT" && (event.target.type === "checkbox" || event.target.type === "radio"))
        return event.target.checked;

    return false;
}

export function preventDefault_(event) {
    event.preventDefault();
}

export function key_(event) {
    if (event.type === "keyup" || event.type === "keydown" || event.type === "keypress")
        return event.key;

    return "";
}

export function selection_(event) {
    if (event.target.tagName === "INPUT" && event.target.type == "text" || event.target.tagName === "TEXTAREA")
        return event.target.value.substring(event.target.selectionStart, event.target.selectionEnd);

    return "";
}
