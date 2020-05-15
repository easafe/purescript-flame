exports.unsafeMergeFields = function (model) {
        return function (subset) {
                var copy = {};

                for (var key of Object.keys(model)) {
                        copy[key] = model[key];
                }

                for (var key of Object.keys(subset)) {
                        copy[key] = subset[key];
                }

                return copy;
        }
}