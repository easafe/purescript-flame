// adapted from https://github.com/LukaJCB/purescript-snabbdom

var patch = require('snabbdom').init([
	require('snabbdom/modules/props').default,
	require('snabbdom/modules/attributes').default,
	require('snabbdom/modules/eventlisteners').default,
]),
	h = require('snabbdom/h').default,
	thunk = require('snabbdom/thunk').default,
	toVNode = require('snabbdom/tovnode').default;

exports.emptyVNode = [];

exports.text_ = function(text) {
	return text;
}

exports.toTextVNode_ = function(element, text) {
	var vNode = toVNode(element)
	vNode.text = text;
	vNode.children = undefined;

	return vNode;
}

exports.toVNodeEvents_ = function(events) {
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

exports.thunk_ = thunk;

exports.patch_ = patch;

exports.patchInitial_ = patch;

exports.patchInitialFrom_ = function (element, vNode) {
	patch(toVNode(element), vNode);
}