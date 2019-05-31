exports.onClick_ = function (constant, message) {
        var out = constant(message);

        document.addEventListener('click', function (_) {
                out.set(message);
        });

        return out;
}
