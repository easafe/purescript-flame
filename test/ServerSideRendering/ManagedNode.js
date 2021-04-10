exports.setInnerHTML = function(selector, html) {
    document.querySelector(selector).innerHTML = html;
}

exports.setElementInnerHTML = function(element, html) {
    element.innerHTML = html;
}