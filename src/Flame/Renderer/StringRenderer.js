const toHtml = require('snabbdom-to-html');

exports.render_ = function (vnode) {
        //console.log(vnode);
        return toHtml(vnode);
};