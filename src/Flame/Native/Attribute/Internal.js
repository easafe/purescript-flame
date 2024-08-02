let styleData = 1,
    classData = 2,
    propertyData = 3;

export function createProperty(name) {
    return function (value) {
        return [propertyData, name, value];
    };
}

export function createClass(array) {
    return [classData, array];
}

export function createStyle(object) {
    return [styleData, object];
}
