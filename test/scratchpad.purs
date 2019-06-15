-- | Testing playground, do not depend on this file
module Test.ScratchPad where

import Prelude

import Effect (Effect)
import Flame (Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Element as HE
import Flame.Signal as FS
import Web.Event.Internal.Types (Event)

-- | The model represents the state of the app
type Model = {times :: Int, key :: String}

-- | This datatype is used to signal events to `update`
data Message = Click Event | Key String | E

-- | Initial state of the app
init :: Model
init = { times :  0, key : "" }

-- | `update` is called to handle events
update :: Model -> Message -> Model
update model = case _ of
        Click event -> model {times = model.times + 1}
        E -> model {times = model.times + 1}
        Key key -> model {key = key}

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [HE.text $ "You have clicked " <> show model.times <> " times", HE.br, HE.text $ "You have pressed " <> model.key  ]

-- | Mount the application on the given selector
main :: Effect Unit
main = do
        channel <- FAN.mount "main" {
                init,
                update,
                view
        }
        FS.send [FS.onClick' [Click]] channel
