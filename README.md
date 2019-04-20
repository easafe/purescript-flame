# Flame

Flame is a fast & simple framework for building web applications in PureScript inspired by [purescript-hedwig](https://github.com/utkarshkukreti/purescript-hedwig)

## Documentation

See the [project page](https://purescript-flame.github.io) or [pursuit](https://pursuit.purescript.org/packages/purescript-flame)

## Examples

See the [examples folder](/examples)

## Quick start

Install:

```bash
npm install snabbdom snabbom-html # for server side rendering
bower install purescript-flame
```

Bare bone application:

```purescript
module Application.Main where

import Prelude

import Effect (Effect)
import Flame (Html)
-- Update strategy for side effects free functions; see docs for other strategies
import Flame.Application.NoEffects as FAN
import Flame.HTML.Element as HE
import Flame.HTML.Attribute as HA

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
main = FAN.mount "main" {
        init,
        update,
        view,
        inputs: []
}
```

## License

Flame is [MIT licensed](LICENSE).

