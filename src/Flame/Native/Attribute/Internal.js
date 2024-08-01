let styleData = 1,
    classData = 2,
    propertyData = 3,
    attributeData = 4,
    keyData = 7;

export function createProperty(name) {
    return function (value) {
        return [propertyData, name, value];
    };
}

export function createAttribute(name) {
    return function (value) {
        return [attributeData, name, value];
    };
}

export function createClass(array) {
    return [classData, array];
}

export function createStyle(object) {
    return [styleData, object];
}

export function createKey(value) {
    return [keyData, value];
}