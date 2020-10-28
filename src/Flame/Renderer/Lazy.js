let lazyNode = 5;

exports.createLazyNode = function (nodeData) {
    return function (render) {
        return function (arg) {
            let key = nodeData[0];

            return {
                nodeType: lazyNode,
                nodeData: key === undefined ? undefined : { key: key },
                render: render,
                arg: arg
            };
        };
    };
};