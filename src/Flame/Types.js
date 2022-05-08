export function messageMapper(mapper) {
    return function (html) {
        return addMessageMapper(html, mapper);
    };
}

function addMessageMapper(html, mapper) {
    if (html.nodeType !== 1 && html.nodeType !== 4)
        mapHtml(html, mapper);

    if (html.children !== undefined && html.children.length > 0)
        for (let i = 0; i < html.children.length; ++i)
            addMessageMapper(html.children[i], mapper);

    return html;
}

function mapHtml(html, mapper) {
    if (html.messageMapper) {
        let previousMessageMapper = html.messageMapper;

        html.messageMapper = function (message) {
            return mapper(previousMessageMapper(message));
        };
    }
    else
        html.messageMapper = mapper;
}