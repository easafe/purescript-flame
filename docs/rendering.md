---
layout: default
title: Rendering the app
permalink: /rendering
---

## Rendering the app

With all pieces in place

```haskell
type Application model message = {
      model :: model
      view :: model -> Html message,
      update :: Update model message,
      subscribe :: Array (Subscription message)
}
```

let's talk about actually rendering the application.

### DOM rendering

The mount functions we saw previously in [Handling events](events) sets up a Flame application on the client side

```haskell
mount_ :: forall model message. QuerySelector -> Application model message -> Effect Unit

mount :: forall id model message. Show id => QuerySelector -> AppId id message -> Application model message -> Effect Unit
```

The first parameter is a CSS selector used as mount point. The application markup is added as children nodes to the mount point. Several applications can live in the same `document` provided they are mounted on different selectors.

### Server side rendering

We can render a Flame application as a markup string server-side in two different ways:

#### Static markup

The module `Flame.Renderer.String` exports the function

```haskell
render :: forall message. Html message -> Effect String
```

which can be used to generate markup as a string, e.g., for a static page or website or template. This way, we can render regular `view` functions using the full expressiveness of PureScript server-side, but no `message` events will be raised.

#### Pre rendered application

The module `Flame` provides

```haskell
type PreApplication model message = {
      model :: model
      view :: model -> Html message
}

preMount :: forall model message. SerializeState model => QuerySelector -> PreApplication model message -> Effect String
```

which can used to render server-side the initial state of an application. On client side, we can use

```haskell
type ResumedApplication model message = {
      view :: model -> Html message,
      update :: model -> message -> Tuple model (Array (Aff (Maybe message))), -- update is only available client side
      subscribe :: Array (Subscription message) -- subscriptions are only available client side
}

resumeMount_ :: forall model message. UnserializeState model => QuerySelector -> ResumedApplication model message -> Effect model
--or
resumeMount :: forall id model message. UnserializeState model => Show id => QuerySelector -> AppId id message -> ResumedApplication model message -> Effect model
```

to install event handlers in the pre rendered markup. The `SerializeState`/`UnserializeState` type class automatically parses the initial state as JSON in case of records or `Generic` instances. The `QuerySelector` passed to `preMount` and `resumeMount` must match -- otherwise the application will crash with an exception. To avoid diffing issues, the same `view` function should be used on the server and client side as well. To make initialization logic easier, `resumeMount` returns the initial parsed model.

See the [Dice application](https://github.com/easafe/purescript-flame/tree/master/examples/ServerSideRendering) for an example of how to pre render an application on server-side.

<a href="/events" class="direction previous">Previous: Handling events</a>
