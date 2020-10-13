exports.key_ = function(event) {
    if (event.type === "keyup" || event.type === "keydown" || event.type === "keypress")
        return event.key;

    return "";
}
