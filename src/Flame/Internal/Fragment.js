let fragmentNode = 4;

export function createFragmentNode(children) {
    return {
        nodeType: fragmentNode,
        node: undefined,
        children: children
    };
}