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
The first parameter is a css selector used as mount point. Under the hood, Flame uses the [snabbdom](https://github.com/snabbdom/snabbdom) virtual DOM.

#### Hooks

Snabbdom provides [hooks](https://github.com/snabbdom/snabbdom#hooks) to inject code into the DOM lifecycle. Since hooks directly manipulate virtual nodes, the functions exported by `Flame.Renderer.Hook` expect foreign interface callbacks, e.g.:
```haskell
-- | Foreign VNode hook function with two parameters
type HookFn2 = EffectFn2 VNode VNode Unit

-- | Attaches a hook for a vnode element been patched
atPostpatch :: forall message. HookFn2 -> NodeData message
```
These functions can be passed to elements in your views in the same way as attributes.

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
type PreApplication model message = {
        init :: model,
        view :: model -> Html message
}

preMount :: forall model message. SerializeModel model => QuerySelector -> PreApplication model message -> Effect String
```
which can used to render on server side the initial state of an application. On client side, we can use
```haskell
type ResumedApplication model message = {
        init :: Array (Aff (Maybe message)), -- only the (optional) initial message to be raised
        view :: model -> Html message,
        update :: model -> message -> Tuple model (Array (Aff (Maybe message))) --update is only available client side
}

resumeMount :: forall model message. UnserializeModel model => QuerySelector -> ResumedApplication model message -> Effect (Channel (Array message))
```
to install event handlers in the pre rendered markup. The `SerializeModel`/`UnserializeModel` type class automatically serialize the initial state as JSON, provided it is either a record or has a `Generic` instance. The `QuerySelector` passed to `preMount` and `resumeMount` must match -- otherwise the application will crash with an exception. To avoid diffing issues, the same `view` function should be used on the server and client side as well.

See the [Dice application](https://github.com/easafe/purescript-flame/tree/master/examples/EffectList/ServerSideRendering) for an example of how to pre render an application on server side.

<a href="/events" class="direction previous">Previous: Handling events</a>
