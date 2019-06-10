function constantHandler(constantSignal, message, eventName) {
        var out = constantSignal(message);

        document.addEventListener(eventName, function (_) {
                out.set(message);
        });

        return out;
}

function constantRawHandler(constantSignal, constructor, eventName) {
        var out = constantSignal(constructor(undefined));

        document.addEventListener(eventName, function (event) {
                out.set(constructor(event));
        });

        return out;
}

function constantSpecialHandler(constantSignal, constructor, eventName, transformer) {
        var out = constantSignal(constructor(undefined));

        document.addEventListener(eventName, function (event) {
                out.set(constructor(transformer(event)));
        });

        return out;
}

exports.onClick_ = function (constant, message) {
        return constantHandler(constant, message, 'click');
}

exports.onClick__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'click');
}

exports.onScroll_ = function (constant, message) {
        return constantHandler(constant, message, 'scroll');
}

exports.onScroll__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'scroll');
}

exports.onFocus_ = function (constant, message) {
        return constantHandler(constant, message, 'focus');
}

exports.onFocus__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'focus');
}

exports.onBlur_ = function (constant, message) {
        return constantHandler(constant, message, 'blur');
}

exports.onBlur__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'blur');
}

exports.onKeydown_ = function (constant, constructor) {
        return constantSpecialHandler(constant, constructor, 'keydown', function (event) {
                return event.key;
        });
}

exports.onKeydown__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'keydown');
}

exports.onKeypress_ = function (constant, message) {
        return constantSpecialHandler(constant, constructor, 'keypress', function (event) {
                return event.key;
        });
}

exports.onKeypress__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'keypress');
}

exports.onKeyup_ = function (constant, message) {
        return constantSpecialHandler(constant, constructor, 'keyup', function (event) {
                return event.key;
        });
}

exports.onKeyup__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'keyup');
}

exports.onContextmenu_ = function (constant, message) {
        return constantHandler(constant, message, 'contextmenu');
}

exports.onContextmenu__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'contextmenu');
}

exports.onDblclick_ = function (constant, message) {
        return constantHandler(constant, message, 'dblclick');
}

exports.onDblclick__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'dblclick');
}

exports.onWheel_ = function (constant, message) {
        return constantHandler(constant, message, 'wheel');
}

exports.onWheel__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'wheel');
}

exports.onDrag_ = function (constant, message) {
        return constantHandler(constant, message, 'drag');
}

exports.onDrag__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'drag');
}

exports.onDragend_ = function (constant, message) {
        return constantHandler(constant, message, 'dragend');
}

exports.onDragend__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'dragend');
}

exports.onDragenter_ = function (constant, message) {
        return constantHandler(constant, message, 'dragenter');
}

exports.onDragenter__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'dragenter');
}

exports.onDragstart_ = function (constant, message) {
        return constantHandler(constant, message, 'dragstart');
}

exports.onDragstart__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'dragstart');
}

exports.onDragleave_ = function (constant, message) {
        return constantHandler(constant, message, 'dragleave');
}

exports.onDragleave__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'dragleave');
}

exports.onDragover_ = function (constant, message) {
        return constantHandler(constant, message, 'dragover');
}

exports.onDragover__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'dragover');
}

exports.onDrop_ = function (constant, message) {
        return constantHandler(constant, message, 'drop');
}

exports.onDrop__ = function (constant, constructor) {
        return constantRawHandler(constant, constructor, 'drop');
}