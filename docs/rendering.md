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
        update :: model -> message -> model,
        inputs :: Array (Signal message)
}
```
let's talk about actually rendering the application.

### DOM rendering

The `mount` function we previously saw in [Handling events](events) sets up a Flame application in the client side
```haskell
mount :: Selector -> Application model message -> Effect Unit
```
The first parameter is a css selector used as mount point. Under the hood, Flame uses the [snabbdom](https://github.com/snabbdom/snabbdom) virtual DOM.

### Server side rendering

<a href="/events" class="direction previous">Previous: Handling events</a>
