exports.onClick_ = function (constant, message) {
        var out = constant(message);

        document.addEventListener('click', function (_) {
                out.set(message);
        });

        return out;
}

exports.onClick__ = function (constant, constructor) {
        var out = constant(constructor(undefined));

        document.addEventListener('click', function (event) {
                out.set(constructor(event));
        });

        return out;
}
