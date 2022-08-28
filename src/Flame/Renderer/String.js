let textNode = 1,
    elementNode = 2,
    svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5,
    managedNode = 6;
let reUnescapedHtml = /[&<>"']/g,
    reHasUnescapedHtml = RegExp(reUnescapedHtml.source),
    htmlEscapes = new Map([
        ['&', '&amp;'],
        ['<', '&lt;'],
        ['>', '&gt;'],
        ['"', '&quot;'],
        ["'", '&#39;']
    ]);
let containerElements = new Set([
    'a',
    'defs',
    'glyph',
    'g',
    'marker',
    'mask',
    'missing-glyph',
    'pattern',
    'svg',
    'switch',
    'symbol',
    'text',
    'desc',
    'metadata',
    'title'
]),
    voidElements = new Set([
        'area',
        'base',
        'br',
        'col',
        'embed',
        'hr',
        'img',
        'input',
        'keygen',
        'link',
        'meta',
        'param',
        'source',
        'track',
        'wbr'
    ]);
let omitProperties = new Set([
    'attributes',
    'childElementCount',
    'children',
    'classList',
    'clientHeight',
    'clientLeft',
    'clientTop',
    'clientWidth',
    'currentStyle',
    'firstElementChild',
    'innerHTML',
    'lastElementChild',
    'nextElementSibling',
    'ongotpointercapture',
    'onlostpointercapture',
    'onwheel',
    'outerHTML',
    'previousElementSibling',
    'runtimeStyle',
    'scrollHeight',
    'scrollLeft',
    'scrollLeftMax',
    'scrollTop',
    'scrollTopMax',
    'scrollWidth',
    'tabStop',
    'tag'
]);
let booleanAttributes = new Set([
    'disabled',
    'visible',
    'checked',
    'readonly',
    'required',
    'allowfullscreen',
    'autofocus',
    'autoplay',
    'compact',
    'controls',
    'default',
    'formnovalidate',
    'hidden',
    'ismap',
    'itemscope',
    'loop',
    'multiple',
    'muted',
    'noresize',
    'noshade',
    'novalidate',
    'nowrap',
    'open',
    'reversed',
    'seamless',
    'selected',
    'sortable',
    'truespeed',
    'typemustmatch'
]);

/** String rendering adapted from https://github.com/snabbdom/snabbdom-to-html */
export function render_(html) {
    let docType = '<!DOCTYPE html>',
        rendered = stringify(html);

    if (html.nodeType === elementNode && html.tag === 'html')
        rendered = docType + rendered;

    return rendered;
}

function stringify(html) {
    switch (html.nodeType) {
        case textNode:
            return escape(html.text);
        case lazyNode:
            return stringify(html.render(html.arg));
        case fragmentNode:
            let childrenTag = new Array(html.children.length);

            for (let i = 0; i < html.children.length; ++i)
                childrenTag.push(stringify(html.children[i]));

            return childrenTag.join('');
        //skip for now, as element creation needs polyfills on server-side
        case managedNode:
            return '';
        default:
            let isSvg = html.nodeType === svgNode,
                stringfiedNodeData = stringifyNodeData(html.nodeData),
                tag = html.tag,
                markup = ['<' + tag];

            if (stringfiedNodeData.length > 0)
                markup.push(' ' + stringfiedNodeData);

            if (isSvg && !containerElements.has(tag))
                markup.push(' /');

            markup.push('>');

            if (!voidElements.has(tag) && !isSvg || isSvg && containerElements.has(tag)) {
                if (html.nodeData.properties !== undefined && html.nodeData.properties.innerHTML !== undefined)
                    markup.push(html.nodeData.properties.innerHTML);
                else if (html.text !== undefined)
                    markup.push(escape(html.text));
                else if (html.children !== undefined && html.children.length > 0)
                    for (let i = 0; i < html.children.length; ++i)
                        markup.push(stringify(html.children[i]));

                markup.push('</' + tag + '>');
            }

            return markup.join('');
    }
}

function stringifyNodeData(nodeData) {
    let result = [],
        mapped = new Map();

    if (nodeData.styles !== undefined)
        setStyles(mapped, nodeData.styles);

    if (nodeData.classes !== undefined && nodeData.classes.length > 0)
        setClasses(mapped, nodeData.classes);

    if (nodeData.properties !== undefined)
        setProperties(mapped, nodeData.properties);

    if (nodeData.attributes !== undefined)
        setAttributes(mapped, nodeData.attributes);

    for (let keyValue of mapped)
        if (keyValue[1].length > 0)
            result.push(keyValue[0] + '="' + keyValue[1] + '"');

    return result.join(' ');
}

function setStyles(mapped, styles) {
    let values = [];

    for (let key in styles)
        values.push(key + ': ' + escape(styles[key]));

    if (values.length > 0)
        mapped.set('style', values.join('; '));
}

function setClasses(mapped, classes) {
    mapped.set('class', classes.join(' '));
}

function setProperties(mapped, properties) {
    for (let key in properties)
        if (!omitProperties.has(key)) {
            let value = properties[key];

            if (booleanAttributes.has(key)) {
                if (value)
                    mapped.set(key, key);
            }
            else
                mapped.set(key, escape(value));
        }
}

function setAttributes(mapped, attributes) {
    for (let key in attributes)
        mapped.set(key, escape(attributes[key]));
}

// from loadash https://github.com/lodash/lodash/blob/4.17.15/lodash.js#L14251
function escape(string) {
    return reHasUnescapedHtml.test(string) ? string.replace(reUnescapedHtml, escapeHtmlChar) : string;
}

function escapeHtmlChar(key) {
    return htmlEscapes.get(key);
}
