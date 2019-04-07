var state = {
	model: {},
	vNode: [],
	view: undefined,
	update: undefined
};

exports.setState_ = function (newState) {
	state.model = newState.model;
	state.vNode = newState.vNode;

	if (state.view === undefined) {
		state.view = newState.view;
		state.update = newState.update;
	}
}

exports.getState = function () {
	return state;
}