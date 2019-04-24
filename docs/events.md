---
layout: default
title: Handling events
permalink: /events
---

## Handling events

Perhaps the most important field in the application record
```haskell
{
        init :: model,
        view :: model -> Html message,
        update :: model -> message -> model,
        inputs :: Array Signal
}
```
is the `update` function. This is where we define our business logic by matching event messages and returning an updated model.

<a href="/views" class="direction previous">Previous: Defining views</a>
<a href="/rendering" class="direction">Next: Rendering the app</a>