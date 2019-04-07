// adapted from https://github.com/LukaJCB/purescript-snabbdom

var patch = require('snabbdom').init([
	require('snabbdom/modules/class').default,
	require('snabbdom/modules/attributes').default,
	require('snabbdom/modules/style').default,
	require('snabbdom/modules/eventlisteners').default,
	require('snabbdom/modules/props').default
]);

var h = require('snabbdom/h').default;

function transformEff1(fn) {
	return function (a) {
		return fn(a)();
	}
}

function transformEff2(fn) {
	return function (a, b) {
		return fn(a)(b)();
	}
}
exports.getElementImpl_ = function (proxy, just, nothing) {
	if (proxy.elm) {
		return just(proxy.elm);
	} else {
		return nothing;
	}
}

exports.text_ = function (text) {
	return text;
}

exports.toVNodeHookObjectProxy_ = function (obj) {
	var proxy = {};
	for (var key in obj) {
		if (obj[key].value0) {
			if (key != "update") {
				proxy[key] = transformEff1(obj[key].value0);
			} else {
				proxy[key] = transformEff2(obj[key].value0);
			}
		}
	}
	return proxy;
}

exports.toVNodeEventObject_ = function (obj) {
	for (var key in obj) {
		var fn = obj[key];
		obj[key] = transformEff1(fn);
	}

	return obj;
}

exports.h_ = h;

exports.patch_ = patch;

exports.patchInitial_ = patch;

exports.updateValueHook_ = function (old, proxy) {
	return function () {
		if (proxy.elm) {
			if (proxy.elm.value != proxy.elm.getAttribute("value")) {
				proxy.elm.value = proxy.elm.getAttribute("value");
			}
		}
	}
}
