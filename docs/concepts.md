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
      update :: model -> message -> model,
      subscribe :: Array (Subscription message)
}
```
The type variable `model` refers to the state of the application. `message`, on the other hand, describes the kinds of events the application can handle.

### Application state

In the counter example we set our model as a simple type alias

```haskell
type Model = Int
```

that is, the state of our application is a single integer. In a real world application, the model will probably be something more interesting -- Flame makes no assumption about how it is structured.

With our model type declared, we can define the initial state of the application

```haskell
init :: Model
init = 0
```

The first time the application is rendered, Flame calls the view function with `init`.

### Application markup

The `view` function maps the current state to markup. Whenever the model is updated, Flame patches the DOM by calling `view` with the new state.

In the counter example, the view is defined as

```haskell
view :: Model -> Html Message
view model = HE.main "main" [
      HE.button [HA.onClick Decrement] "-",
      HE.text $ show model,
      HE.button [HA.onClick Increment] "+"
]
```

The `message`s raised on events are used to signal how the application state should be updated.

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

### Subscriptions

Finally, we can specify events that come from outside of the `view` as an array to `subscribe`. Such events include `window`, `document` -- and even messages arbitrarily raised by user code. These messages will then be handled in the usual way by the `update` function.

In the counter example no external events are handled, so the subscription list is empty

```haskell
subscribe :: Array (Subscription Message)
subscribe = []
}
```

See [Handling external events](events#handling-external-events) for an in depth look at subscriptions.

### Rendering

Having all pieces put together, we can either render the application to the DOM, as in the case of the counter example

```haskell
main :: Effect Unit
main = FAN.mount_ (QuerySelector "body") {
      init,
      view,
      update,
      subscribe
}
```

or as a `String` with `Flame.Renderer.String.render`, which can be used server-side.

See [Rendering the app](rendering) for an in depth look at rendering.

<a href="/index" class="direction previous">Previous: Getting started</a>
<a href="/views" class="direction">Next: Defining views</a>
