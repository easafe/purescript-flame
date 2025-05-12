
//to also convert if native expects numbers (like borderRadius)
//expand some short hand properties like border

let unitProperties = new Set();

let regex = /(\D)(cm|in|mm|pc|pt|px|Q)/;

for (let stl in obj) {
    for (let key in stl) {
        if (unitProperties.has(key)) {
            stl[key]
        }
    }
}