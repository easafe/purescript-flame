export function unsafeMergeFields(model) {
      return function (subset) {
            let copy = {};

            for (let key of Object.keys(model)) {
                  copy[key] = model[key];
            }

            for (let key of Object.keys(subset)) {
                  copy[key] = subset[key];
            }

            return copy;
      }
}