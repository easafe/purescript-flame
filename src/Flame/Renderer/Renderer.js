// adapted from https://github.com/LukaJCB/purescript-snabbdom

var patch = require('snabbdom').init([
	require('snabbdom/modules/attributes').default,
	require('snabbdom/modules/eventlisteners').default,
]);

var h = require('snabbdom/h').default;

exports.emptyVNode = [];

exports.text_ = function (text) {
	return text;
}

exports.toVNodeEvents_ = function (obj) {
	for (var key in obj) {
		var fn = obj[key];
		obj[key] = function(a) {
			return fn(a)();
		};
	}

	return obj;
}

exports.h_ = h;

exports.patch_ = patch;

exports.patchInitial_ = patch;
