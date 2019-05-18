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

exports.toVNodeEvents_ = function (events) {
	for (var key in events) {
		var handler = events[key];

		events[key] = runEvent(handler);
	}

	return events;
}

function runEvent(handler) {
	return function(event) {
		return handler(event)();
	}
}

exports.h_ = h;

exports.patch_ = patch;

exports.patchInitial_ = patch;
