//this is not ideal, e.g. if the library is loaded twice
let applications = new Map();

export function checkApplicationId_(id) {
    let application = applications.get(id);

    if (application !== undefined && application.registered)
        throw `Error mounting application: id ${id} already registered!`;

    applications.set(id, {
        registered: true,
        messages: application === undefined ? [] : application.messages
    });
}

/** Marks the application as able to receive messages, returning the ones queued so far */
export function registerApplicationId_(id) {
    let application = applications.get(id),
        messages = application.messages;

    application.messages = null;

    return messages;
}

export function isApplicationInitialized_(id) {
    let application = applications.get(id);

    return application !== undefined && application.messages === null;
}

/** Messages sent to an application before it is mounted wait until it is */
export function queueMessage_(id, message) {
    let application = applications.get(id);

    if (application === undefined) {
        application = {
            registered: false,
            messages: []
        };
        applications.set(id, application);
    }

    application.messages.push(message);
}
