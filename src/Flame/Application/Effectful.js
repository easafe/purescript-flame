exports.unsafeMergeFields = function (model) {
        return function (subset) {
                for (var key of Object.keys(subset)) {
                        model[key] = subset[key];
                }

                return model;
        }
}