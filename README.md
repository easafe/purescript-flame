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
import Flame (Html, Update)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.ParentNode (QuerySelector(..))

-- | The model represents the state of the app
type Model = Int

-- | Data type used to represent events
data Message = Increment | Decrement

-- | Initial state of the app
init :: Model
init = 0

-- | `update` is called to handle events
update :: Update Model Message
update model = F.noMessages <<< case _ of
      Increment -> model + 1
      Decrement -> model - 1

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main [ HA.id "main" ]
      [ HE.button [ HA.onClick Decrement ] [ HE.text "-" ]
      , HE.text $ show model
      , HE.button [ HA.onClick Increment ] [ HE.text "+" ]
      ]

-- | Mount the application on the given selector
main :: Effect Unit
main = F.mount_ (QuerySelector "body")
      { model: init
      , subscribe: [] -- events that come from outside the `view`
      , update
      , view
      }
```

### Tools

[breeze](https://github.com/easafe/haskell-breeze) can be used to generate Flame markup from HTML

### Licensing

Licenses for loadash, stage0 and snabbdom-to-html added under [licenses](licenses/) since parts of the rendering code was adapted from these projects

### Funding

If this project is useful for you, consider [throwing a buck](https://asafe.dev/donate) to keep development possible
