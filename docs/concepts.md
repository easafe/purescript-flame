---
layout: default
title: Main concepts
permalink: /concepts
---

## Main concepts

A Flame application consists of the following record
```haskell
type Application model message = {
        init :: model,
        view :: model -> Html message,
        update :: model -> message -> model
}
```
The type variable `model` refers to the state of the application. `message`, on the other hand, describe the kind of events the application handles.

### Application state

In the counter example we set our state as a simple type alias
```haskell
type Model = Int
```
that is, the state of our application is a single integer. In a real world application, the state will probably be something more interesting -- Flame makes no assumption about how it is structured.

With our model type declared, we can define the initial state of the application
```haskell
init :: Model
init = 0
```
The first time the application is rendered, Flame will call the view function with `init`.

### Application markup

The `view` function maps the current state to markup. Whenever the model is updated, flame will patch the DOM by calling `view` with the new state.

In the counter example, the model is defined as
```haskell
view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HA.onClick Decrement] "-",
        HE.text $ show model,
        HE.button [HA.onClick Increment] "+"
]
```
The `Message`s raised as events will be used to signal how the application state should be updated.

See [Defining views](views) for an in depth look at views.

### State updating

The `update` function handles events, returning an updated model. In a Flame application, we reify native events as a custom data type. In the counter example, we are interested in the following events:
```haskell
data Message = Increment | Decrement
```
and thus our update function looks like
```haskell
update :: Model -> Message -> Model
update model = case _ of
        Increment -> model + 1
        Decrement -> model - 1
```

See [Handling events](events) for an in depth look at update strategies.

### External event handling

Finally, mounting a Flame application record yields a [`Channel`](https://pursuit.purescript.org/packages/purescript-signal/10.1.0/docs/Signal.Channel), which can be fed messages from events outside of our view. This includes `window` or `document` events, such as resize or load, and custom events, all of which will then be handled as usual by the application `update` function.

In the counter example, no external events are handled, so we use the version of `mount` that discardsgit the channel
```haskell
main :: Effect Unit
main = FAN.mount_ "main" {
        ...
}
```

See [Handling external events](events#handling-external-events) for an in depth look at external events.

### Rendering

Having all pieces put together, we can either render the application to the DOM, as in the case of the counter example
```haskell
main :: Effect Unit
main = FAN.mount_ "main" {
        init,
        update,
        view
}
```
or as a `String` with `Flame.Renderer.StringRenderer.render`, which can be used server-side.

See [Rendering the app](rendering) for an in depth look at rendering.

<a href="/index" class="direction previous">Previous: Getting started</a>
<a href="/views" class="direction">Next: Defining views</a>
