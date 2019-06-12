//we are relying on a dependency implementation detail, which is not good for obvious reasons
function channelHandler(message, channel, eventName) {
        document.addEventListener(eventName, function (_) {
                channel.set(message);
        });
}

function channelRawHandler(constructor, channel, eventName) {
        document.addEventListener(eventName, function (event) {
                console.log(constructor)
                channel.set(constructor(event));
        });
}

function channelSpecialHandler(constructor, channel, eventName, transformer) {
        document.addEventListener(eventName, function (event) {
                channel.set(constructor(transformer(event)));
        });
}

exports.onClick_ = function(message, channel) {
        channelHandler(message, channel, 'click');
}

exports.onClick__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'click');
}

exports.onScroll_ = function(message, channel) {
        channelHandler(message, channel, 'scroll');
}

exports.onScroll__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'scroll');
}

exports.onFocus_ = function(message, channel) {
        channelHandler(message, channel, 'focus');
}

exports.onFocus__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'focus');
}

exports.onBlur_ = function(message, channel) {
        channelHandler(message, channel, 'blur');
}

exports.onBlur__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'blur');
}

exports.onKeydown_ = function(constructor, channel) {
        channelSpecialHandler(constructor, channel, 'keydown', function (event) {
                return event.key;
        });
}

exports.onKeydown__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'keydown');
}

exports.onKeypress_ = function(message, channel) {
        channelSpecialHandler(constructor, channel, 'keypress', function (event) {
                return event.key;
        });
}

exports.onKeypress__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'keypress');
}

exports.onKeyup_ = function(message, channel) {
        channelSpecialHandler(constructor, channel, 'keyup', function (event) {
                return event.key;
        });
}

exports.onKeyup__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'keyup');
}

exports.onContextmenu_ = function(message, channel) {
        channelHandler(message, channel, 'contextmenu');
}

exports.onContextmenu__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'contextmenu');
}

exports.onDblclick_ = function(message, channel) {
        channelHandler(message, channel, 'dblclick');
}

exports.onDblclick__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'dblclick');
}

exports.onWheel_ = function(message, channel) {
        channelHandler(message, channel, 'wheel');
}

exports.onWheel__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'wheel');
}

exports.onDrag_ = function(message, channel) {
        channelHandler(message, channel, 'drag');
}

exports.onDrag__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'drag');
}

exports.onDragend_ = function(message, channel) {
        channelHandler(message, channel, 'dragend');
}

exports.onDragend__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'dragend');
}

exports.onDragenter_ = function(message, channel) {
        channelHandler(message, channel, 'dragenter');
}

exports.onDragenter__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'dragenter');
}

exports.onDragstart_ = function(message, channel) {
        channelHandler(message, channel, 'dragstart');
}

exports.onDragstart__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'dragstart');
}

exports.onDragleave_ = function(message, channel) {
        channelHandler(message, channel, 'dragleave');
}

exports.onDragleave__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'dragleave');
}

exports.onDragover_ = function(message, channel) {
        channelHandler(message, channel, 'dragover');
}

exports.onDragover__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'dragover');
}

exports.onDrop_ = function(message, channel) {
        channelHandler(message, channel, 'drop');
}

exports.onDrop__ = function(constructor, channel) {
        channelRawHandler(constructor, channel, 'drop');
}
