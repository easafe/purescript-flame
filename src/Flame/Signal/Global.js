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

exports.onKeydown_ = function (constant, constructor) {
        return constantSpecialHandler(constant, constructor, 'keydown', function (event) {
                return event.key;
        });
}
