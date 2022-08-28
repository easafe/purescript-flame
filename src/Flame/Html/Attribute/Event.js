let messageEventData = 5,
    rawEventData = 6;

export function createEvent_(name) {
    return function (message) {
        return [messageEventData, name, message];
    };
}

export function createRawEvent_(name) {
    return function (handler) {
        return [rawEventData, name, handler];
    };
}

export function nodeValue_(event) {
    if (event.target.contentEditable === true || event.target.contentEditable === "true" || event.target.contentEditable === "")
        return event.target.innerText;

    return event.target.value;
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
