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

The `mount` function we previously saw in [Handling events](events) sets up a Flame application in the client side
```haskell
mount :: forall model message. QuerySelector -> Application model message -> Effect (Channel (Array message))
```
The first parameter is a css selector used as mount point. Under the hood, Flame uses the [snabbdom](https://github.com/snabbdom/snabbdom) virtual DOM.

### Server side rendering

We can render a Flame application as a string markup on server side in two different ways:

#### Static markup

The module `Flame.Renderer.String` exports the function
```haskell
render :: forall a. Html a -> Effect String
```
which can be used to generate markup as a string, e.g., for a static page or website, or as a template. This way, we can render regular `view` functions using the full expressivity of PureScript server side, but no `message` events will be raised.

#### Pre rendered application

The module `Flame` provides
```haskell
preMount :: forall model m message. Generic model m => EncodeRep m => QuerySelector -> PreApplication model message -> Effect String
```
which can used to render on server side the initial state of an application. On client side, we can use
```haskell
resumeMount :: forall model m message. Generic model m => DecodeRep m => QuerySelector -> ResumedApplication model message -> Effect (Channel (Array message))
```
to install event handlers in the pre rendered markup. The `Generic` constraint is necessary since Flame will serialize the initial state of `PreApplication`
```haskell
type PreApplication model message = {
        init :: model,
        view :: model -> Html message
}
```
into the rendered markup. For this reason, the `QuerySelector` passed to `preMount` and `resumeMount` must match -- otherwise the application will crash with an exception. To avoid diffing issues, the same `view` function should be passed to both function records as well.

`ResumedApplication` is defined as
```haskell
type ResumedApplication model message = {
        init :: Array (Aff (Maybe message)),
        view :: model -> Html message,
        update :: model -> message -> Tuple model (Array (Aff (Maybe message)))
}
```
Notice how `init` only contains the initial messages to be raised. The `update` function responsible for handling events is added on client side as well.

See the [Dice application](https://github.com/easafe/purescript-flame/tree/master/examples/EffectList/ServerSideRendering) for an example of how to pre render an application on server side.

<a href="/events" class="direction previous">Previous: Handling events</a>
