'use strict';

let styleData = 1,
    classData = 2,
    propertyData = 3,
    attributeData = 4,
    keyData = 7;

exports.createProperty_ = function (name, value) {
    return [propertyData, name, value];
};

exports.createAttribute_ = function (name, value) {
    return [attributeData, name, value];
};

exports.createClass = function (array) {
    return [classData, array];
};

exports.createStyle = function (object) {
    return [styleData, object];
};

exports.createKey = function (value) {
    return [keyData, value];
};