---
layout: default
title: Getting started
---

## Simple, fast & type safe web applications

Flame is a PureScript front-end framework inspired by the Elm architecture with focus on simplicity and performance. Featuring:

* Message based state updating -- see [Handling events](events)

* Subscriptions -- see [Handling external events](events#subscriptions)

* Server side rendering -- see [Rendering the app](rendering)

* Performance comparable to native JavaScript frameworks -- see [benchmarks](benchmarks)

* Parse HTML into Flame markup with [breeze](https://github.com/easafe/haskell-breeze)

## Quick start

Install:

```bash
spago install flame
```

Example counter app:

```haskell
module Counter.Main where

import Prelude

import Effect (Effect)
import Flame (Html, QuerySelector(..), Subscription)
-- Side effects free updating; see docs for other examples
import Flame.Application.NoEffects as FAN
import Flame.Html.Element as HE
import Flame.Html.Attribute as HA

-- | The model represents the state of the app
type Model = Int

-- | Data type used to represent events
data Message = Increment | Decrement

-- | Initial state of the app
init :: Model
init = 0

-- | `update` is called to handle events
update :: Model -> Message -> Model
update model = case _ of
      Increment -> model + 1
      Decrement -> model - 1

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
      HE.button [HA.onClick Decrement] "-",
      HE.text $ show model,
      HE.button [HA.onClick Increment] "+"
]

-- | Events that come from outside the `view`
subscribe :: Array (Subscription Message)
subscribe = []

-- | Mount the application on the given selector
main :: Effect Unit
main = FAN.mount_ (QuerySelector "body") {
      init,
      view,
      update,
      subscribe
}
```

<a href="/concepts" class="direction">Next: Main concepts</a>
