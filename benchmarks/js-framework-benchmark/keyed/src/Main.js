function _random(max) {
    return Math.round(Math.random() * 1000) % max;
}

var adjectives = [
    "pretty",
    "large",
    "big",
    "small",
    "tall",
    "short",
    "long",
    "handsome",
    "plain",
    "quaint",
    "clean",
    "elegant",
    "easy",
    "angry",
    "crazy",
    "helpful",
    "mushy",
    "odd",
    "unsightly",
    "adorable",
    "important",
    "inexpensive",
    "cheap",
    "expensive",
    "fancy"
],
    colours = [
        "red",
        "yellow",
        "blue",
        "green",
        "pink",
        "brown",
        "purple",
        "brown",
        "white",
        "black",
        "orange"
],
    nouns = [
        "table",
        "chair",
        "house",
        "bbq",
        "desk",
        "car",
        "pony",
        "cookie",
        "sandwich",
        "burger",
        "pizza",
        "mouse",
        "keyboard"
];

export function createRandomNRows_(count, lastId) {
    var data = [];

    for (var i = 0; i < count; i++)
        data.push({
            id: ++lastId,
            selected: false,
            label:
                adjectives[_random(adjectives.length)] +
                " " +
                colours[_random(colours.length)] +
                " " +
                nouns[_random(nouns.length)]
        });

    return data;
}
