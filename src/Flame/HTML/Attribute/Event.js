exports.nodeValue_ = function (event) {
	if (event.target.contentEditable === true || event.target.contentEditable === "true" || event.target.contentEditable === "")
		return event.target.innerText;

	return event.target.value;
}

exports.checkedValue_ = function (event) {
	if (event.target.tagName === "INPUT" && (event.target.type === "checkbox" || event.target.type === "radio"))
		return event.target.checked;

	return false;
}

exports.preventDefault_ = function(event) {
	event.preventDefault();
}

exports.key_ = function(event) {
	if (event.type === "keyup" || event.type === "keydown" || event.type === "keypress")
		return event.key;

	return "";
}

exports.selection_ = function(event) {
	if (event.target.tagName === "INPUT" && event.target.type == "text" || event.target.tagName === "TEXTAREA")
		return event.target.value.substring(event.target.selectionStart, event.target.selectionEnd);

	return "";
}