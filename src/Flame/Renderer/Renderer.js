// adapted from https://github.com/LukaJCB/purescript-snabbdom

var patch = require('snabbdom').init([
	require('snabbdom/modules/props').default,
	require('snabbdom/modules/attributes').default,
	require('snabbdom/modules/eventlisteners').default,
]),
	h = require('snabbdom/h').default,
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

function copyToThunk(vnode, thunk) {
    thunk.elm = vnode.elm;
    vnode.data.fn = thunk.data.fn;
    vnode.data.args = thunk.data.args;
    thunk.data = vnode.data;
    thunk.children = vnode.children;
    thunk.text = vnode.text;
    thunk.elm = vnode.elm;
}

function initThunkHook(thunk) {
    var cur = thunk.data;
    var vnode = cur.fn.apply(undefined, cur.args);
    copyToThunk(vnode, thunk);
}

function prepatchThunkHook(oldVnode, thunk) {
    var i, old = oldVnode.data, cur = thunk.data;
    var oldArgs = old.args, args = cur.args;
    if (oldArgs.length !== args.length) {
        copyToThunk(cur.fn.apply(undefined, args), thunk);
        return;
    }
    for (i = 0; i < args.length; ++i) {
        if (oldArgs[i] !== args[i]) {
            copyToThunk(cur.fn.apply(undefined, args), thunk);
            return;
        }
    }
    copyToThunk(oldVnode, thunk);
}

exports.thunk_ = function thunk(sel, key, fn, args) {
    if (args === undefined) {
        args = fn;
        fn = key;
        key = undefined;
    }
    return h(sel, {
        key: key,
        hook: { init: initThunkHook, prepatch: prepatchThunkHook },
        fn: fn,
        args: args
    });
};

exports.patch_ = patch;

exports.patchInitial_ = patch;

exports.patchInitialFrom_ = function (element, vNode) {
	patch(toVNode(element), vNode);
}