export function compareReference(a) {
      return function (b) {
            return a === b;
      }
}