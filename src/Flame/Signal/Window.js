//there is no purescript solution to reusing code in foreign files
function channelHandler(message, channel, eventName) {
        window.addEventListener(eventName, function(_) {
                //we are relying on a dependency implementation detail, which is not good for obvious reasons
                channel.set(message);
        });
}

function channelRawHandler(eventName) {
        return function(applyHandler, constructor, channel) {
                window.addEventListener(eventName, function(event) {
                        channel.set(applyHandler(event)(constructor));
                });
        }
}

exports.onError_ = function(message, channel) {
        channelHandler(message, channel, 'error');
}

exports.onError__ = function() {
        return channelRawHandler('error');
}

exports.onResize_ = function(message, channel) {
        channelHandler(message, channel, 'resize');
}

exports.onResize__ = function() {
        return channelRawHandler('resize');
}

exports.onOffline_ = function(message, channel) {
        channelHandler(message, channel, 'offline');
}

exports.onOffline__ = function() {
        return channelRawHandler('offline');
}

exports.onOnline_ = function(message, channel) {
        channelHandler(message, channel, 'online');
}

exports.onOnline__ = function() {
        return channelRawHandler('online');
}

exports.onLoad_ = function(message, channel) {
        channelHandler(message, channel, 'load');
}

exports.onLoad__ = function() {
        return channelRawHandler('load');
}

exports.onUnload_ = function(message, channel) {
        channelHandler(message, channel, 'unload');
}

exports.onUnload__ = function() {
        return channelRawHandler('unload');
}