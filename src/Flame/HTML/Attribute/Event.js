exports.nodeValue_ = function (event) {
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