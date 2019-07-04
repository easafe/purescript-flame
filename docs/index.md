---
layout: default
title: Getting started
---

## Simple, fast & type safe web applications

Flame is a PureScript frontend framework inspired by [purescript-hedwig](https://github.com/utkarshkukreti/purescript-hedwig) and Elm with focus on simplicity and performance. Featuring:

* Different strategies for state updating -- see [Handling events](events)

* [Signal](https://pursuit.purescript.org/packages/purescript-signal) based interface for handling custom events -- see [Handling external events](events#handling-external-events)

* Server side rendering -- see [Rendering the app](rendering)

* Performance comparable to native JavaScript frameworks -- see [benchmarks](benchmarks)

## Quick start

Install:

```bash
npm install snabbdom snabbdom-to-html # the latter is used for server side rendering
bower install purescript-flame
```

Example counter app:

```haskell
module App.Main where

import Prelude

import Effect (Effect)
import Flame (Html)
-- Update strategy for side effects free functions; see docs for other strategies
import Flame.Application.NoEffects as FAN
import Flame.HTML.Element as HE
import Flame.HTML.Attribute as HA
import Web.DOM.ParentNode (QuerySelector(..))

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
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

-- | Mount the application on the given selector
main :: Effect Unit
main = FAN.mount_ (QuerySelector "main") {
        init,
        update,
        view
}
```

<a href="/concepts" class="direction">Next: Main concepts</a>
