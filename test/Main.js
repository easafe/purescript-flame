const jsdom = require("jsdom");
const enviroment = (new jsdom.JSDOM('', { runScripts: "outside-only" }));

global.window = enviroment.window;
global.document	= enviroment.window.document;

exports.unsafeCreateEnviroment = function () {
	document.body.innerHTML = '<div id=mount-point></div>';
}

exports.clickEvent = function () {
	return new window.Event('click');
}

exports.inputEvent = function () {
	return new window.Event('input');
}

exports.keydownEvent = function () {
	return new window.Event('keydown');
}