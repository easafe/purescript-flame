//this is not ideal, e.g. if the library is loaded twice
let applicationIds = new Set();

exports.checkApplicationId_ = function (id) {
    if (applicationIds.has(id))
        throw `Error mounting application: id ${id} already registered!`;

    applicationIds.add(id);
}