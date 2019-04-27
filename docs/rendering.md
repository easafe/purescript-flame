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

### Server side rendering

<a href="/events" class="direction previous">Previous: Handling events</a>
