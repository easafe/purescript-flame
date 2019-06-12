//there is no purescript solution to reusing code in foreign files
function channelHandler(message, channel, eventName) {
        document.addEventListener(eventName, function (_) {
                channel.set(message);
        });
}

function channelRawHandler(constructor, channel, eventName) {
        document.addEventListener(eventName, function (event) {
                channel.set(constructor(event));
        });
}

exports.onError_ = function (message, channel) {
        return channelHandler(message, channel, 'error');
}

exports.onError__ = function (constructor, channel) {
        return channelRawHandler(constructor, channel, 'error');
}

exports.onResize_ = function (message, channel) {
        return channelHandler(message, channel, 'resize');
}

exports.onResize__ = function (constructor, channel) {
        return channelRawHandler(constructor, channel, 'resize');
}

exports.onOffline_ = function (message, channel) {
        return channelHandler(message, channel, 'offline');
}

exports.onOffline__ = function (constructor, channel) {
        return channelRawHandler(constructor, channel, 'offline');
}

exports.onOnline_ = function (message, channel) {
        return channelHandler(message, channel, 'online');
}

exports.onOnline__ = function (constructor, channel) {
        return channelRawHandler(constructor, channel, 'online');
}

exports.onLoad_ = function (message, channel) {
        return channelHandler(message, channel, 'load');
}

exports.onLoad__ = function (constructor, channel) {
        return channelRawHandler(constructor, channel, 'load');
}

exports.onUnload_ = function (message, channel) {
        return channelHandler(message, channel, 'unload');
}

exports.onUnload__ = function (constructor, channel) {
        return channelRawHandler(constructor, channel, 'unload');
}