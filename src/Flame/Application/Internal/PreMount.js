let textNode = 1,
    // elementNode = 2,
    // svgNode = 3,
    fragmentNode = 4,
    lazyNode = 5;

export function injectState(stateHtml) {
    return function (html) {
        return injectTo(stateHtml, html);
    };
}

function injectTo(stateHtml, html) {
    switch (html.nodeType) {
        case lazyNode:
            html.rendered = html.render(html.arg);
            html.render = undefined;

            return injectTo(stateHtml, html.rendered);
        case textNode:
            return {
                nodeType: fragmentNode,
                children: [stateHtml, html]
            };
        case fragmentNode:
            html.children.unshift(stateHtml);

            return html;
        default:
            if (html.children === undefined)
                html.children = [];
            //if the view is a complete page, the state has to be added to the body
            // otherwise it won't show up on the final markup
            if (html.tag === "html")
                for (let c of html.children) {
                    if (c.tag === "body") {
                        injectTo(stateHtml, c);
                        break;
                    }
                }
            else
                html.children.unshift(stateHtml);

            return html;
    }
}

