//there is no purescript solution to reusing code in foreign files
function constantHandler(constantSignal, message, eventName) {
        var out = constantSignal(message);

        window.addEventListener(eventName, function (_) {
                out.set(message);
        });

        return out;
}

function constantRawHandler(constantSignal, constructor, eventName) {
        var out = constantSignal(constructor(undefined));

        window.addEventListener(eventName, function (event) {
                out.set(constructor(event));
        });

        return out;
}

exports.onError_ = function (constant, message) {
        return constantHandler(constant, message, 'error');
}

exports.onError__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'error');
}

exports.onResize_ = function (constant, message) {
        return constantHandler(constant, message, 'resize');
}

exports.onResize__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'resize');
}

exports.onOffline_ = function (constant, message) {
        return constantHandler(constant, message, 'offline');
}

exports.onOffline__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'offline');
}

exports.onOnline_ = function (constant, message) {
        return constantHandler(constant, message, 'online');
}

exports.onOnline__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'online');
}

exports.onLoad_ = function (constant, message) {
        return constantHandler(constant, message, 'load');
}

exports.onLoad__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'load');
}

exports.onUnload_ = function (constant, message) {
        return constantHandler(constant, message, 'unload');
}

exports.onUnload__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'unload');
}
