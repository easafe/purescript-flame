## Flame ![build status](https://github.com/easafe/purescript-flame/actions/workflows/CI.yml/badge.svg)

Flame is a fast & simple framework inspired by the Elm architecture for building web applications in PureScript

### Documentation

See the [project page](https://flame.asafe.dev/) or [pursuit](https://pursuit.purescript.org/packages/purescript-flame)

### Examples

See the [examples folder](/examples)

### Quick start

Install:

```bash
spago install flame
```

Example counter app:

```purescript
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

### Funding

If this project is useful for you, consider [throwing a buck](https://asafe.dev/donate) to keep development possible
