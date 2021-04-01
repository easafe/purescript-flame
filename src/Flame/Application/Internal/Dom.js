
let querySelector = typeof document == 'undefined' ? null : document.querySelector.bind(document);

exports.querySelector_ = querySelector;

exports.textContent_ = function(element) {
        return element.textContent || '';
}

exports.removeElement_ = function(selector) {
        querySelector(selector).remove();
}