exports.unwrapEff1 = function(fn) {
    return function(a) {
        return fn(a)()
    }
};

exports.unwrapEff2 = function(fn) {
    return function(a, b) {
        return fn(a)(b)()
    };
};
