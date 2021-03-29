---
layout: default
title: Rendering the app
permalink: /rendering
---

## Rendering the app

With all pieces in place
```haskell
type Application model message = {
        init :: model,
        view :: model -> Html message,
        update :: model -> message -> model
}
```
let's talk about actually rendering the application.

### DOM rendering

The `mount` function we previously saw in [Handling events](events) sets up a Flame application on the client side
```haskell
mount :: forall model message. QuerySelector -> Application model message -> Effect (Channel (Array message))
```
The first parameter is a CSS selector used as mount point. The application markup is added as children nodes to the mont point, otherwise it is left untouched. Several mount points can live in the same `document` provided they are mounted on different selectors.

### Server side rendering

We can render a Flame application as a markup string server-side in two different ways:

#### Static markup

The module `Flame.Renderer.String` exports the function
```haskell
render :: forall message. Html message -> Effect String
```
which can be used to generate markup as a string, e.g., for a static page or website or template. This way, we can render regular `view` functions using the full expressivity of PureScript server-side, but no `message` events will be raised.

#### Pre rendered application

The module `Flame` provides
```haskell
type PreApplication model message = {
        init :: model,
        view :: model -> Html message
}

preMount :: forall model message. SerializeState model => QuerySelector -> PreApplication model message -> Effect String
```
which can used to render server-side the initial state of an application. On client side, we can use
```haskell
type ResumedApplication model message = {
        init :: Array (Aff (Maybe message)), -- only the (optional) initial message to be raised
        view :: model -> Html message,
        update :: model -> message -> Tuple model (Array (Aff (Maybe message))) --update is only available client side
}

resumeMount :: forall model message. UnserializeState model => QuerySelector -> ResumedApplication model message -> Effect (Channel (Array message))
```
to install event handlers in the pre rendered markup. The `SerializeState`/`UnserializeState` type class automatically serializes the initial state as JSON in case of records or `Generic` instances. The `QuerySelector` passed to `preMount` and `resumeMount` must match -- otherwise the application will crash with an exception. To avoid diffing issues, the same `view` function should be used on the server and client side as well.

See the [Dice application](https://github.com/easafe/purescript-flame/tree/master/examples/ServerSideRendering) for an example of how to pre render an application on server-side.

<a href="/events" class="direction previous">Previous: Handling events</a>
