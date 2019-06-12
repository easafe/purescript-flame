function channelHandler(message, channel, eventName) {
        document.addEventListener(eventName, function(_) {
                //we are relying on a dependency implementation detail, which is not good for obvious reasons
                channel.set(message);
        });
}

//in channelRawHandler and channelSpecialHandler since applyHandler is an Applicative we have to first receive the type class dictionary (hence the inderection layer)
// and then later the other arguments
// applyHandler is also curried
function channelRawHandler(eventName) {
        return function(applyHandler, constructor, channel) {
                document.addEventListener(eventName, function(event) {
                        channel.set(applyHandler(event)(constructor));
                });
        }
}

function channelSpecialHandler(eventName, transformer) {
        return function(applyHandler, constructor, channel) {
                document.addEventListener(eventName, function(event) {
                        channel.set(applyHandler(transformer(event))(constructor));
                });
        }
}

exports.onClick_ = function(message, channel) {
        channelHandler(message, channel, 'click');
}

exports.onClick__ = function() {
        return channelRawHandler('click');
}

exports.onScroll_ = function(message, channel) {
        channelHandler(message, channel, 'scroll');
}

exports.onScroll__ = function() {
        return channelRawHandler('scroll');
}

exports.onFocus_ = function(message, channel) {
        channelHandler(message, channel, 'focus');
}

exports.onFocus__ = function() {
        return channelRawHandler('focus');
}

exports.onBlur_ = function(message, channel) {
        channelHandler(message, channel, 'blur');
}

exports.onBlur__ = function() {
        return channelRawHandler('blur');
}

exports.onKeydown_ = function() {
        return channelSpecialHandler('keydown', function(event) {
                return event.key;
        });
}

exports.onKeydown__ = function() {
        return channelRawHandler('keydown');
}

exports.onKeypress_ = function() {
        return channelSpecialHandler('keypress', function(event) {
                return event.key;
        });
}

exports.onKeypress__ = function() {
        return channelRawHandler('keypress');
}

exports.onKeyup_ = function() {
        return channelSpecialHandler('keyup', function(event) {
                return event.key;
        });
}

exports.onKeyup__ = function() {
        return channelRawHandler('keyup');
}

exports.onContextmenu_ = function(message, channel) {
        channelHandler(message, channel, 'contextmenu');
}

exports.onContextmenu__ = function() {
        return channelRawHandler('contextmenu');
}

exports.onDblclick_ = function(message, channel) {
        channelHandler(message, channel, 'dblclick');
}

exports.onDblclick__ = function() {
        return channelRawHandler('dblclick');
}

exports.onWheel_ = function(message, channel) {
        channelHandler(message, channel, 'wheel');
}

exports.onWheel__ = function() {
        return channelRawHandler('wheel');
}

exports.onDrag_ = function(message, channel) {
        channelHandler(message, channel, 'drag');
}

exports.onDrag__ = function() {
        return channelRawHandler('drag');
}

exports.onDragend_ = function(message, channel) {
        channelHandler(message, channel, 'dragend');
}

exports.onDragend__ = function() {
        return channelRawHandler('dragend');
}

exports.onDragenter_ = function(message, channel) {
        channelHandler(message, channel, 'dragenter');
}

exports.onDragenter__ = function() {
        return channelRawHandler('dragenter');
}

exports.onDragstart_ = function(message, channel) {
        channelHandler(message, channel, 'dragstart');
}

exports.onDragstart__ = function() {
        return channelRawHandler('dragstart');
}

exports.onDragleave_ = function(message, channel) {
        channelHandler(message, channel, 'dragleave');
}

exports.onDragleave__ = function() {
        return channelRawHandler('dragleave');
}

exports.onDragover_ = function(message, channel) {
        channelHandler(message, channel, 'dragover');
}

exports.onDragover__ = function() {
        return channelRawHandler('dragover');
}

exports.onDrop_ = function(message, channel) {
        channelHandler(message, channel, 'drop');
}

exports.onDrop__ = function() {
        return channelRawHandler('drop');
}
