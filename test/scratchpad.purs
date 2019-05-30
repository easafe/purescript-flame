-- | Testing playground, do not depend on this file
module Test.Test where

import Prelude

import Data.Traversable as DT
import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Flame (Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Signal as FS

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data Message = Click

-- | Initial state of the app
init :: Model
init = 0

-- | `update` is called to handle events
update :: Model -> Message -> Model
update model = case _ of
        Click -> model + 1

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" $ "You have clicked " <> show model <> " times"

-- | Mount the application on the given selector
main :: Effect Unit
main = do
        signals <- DT.sequence [FS.onClick Click]
        FAN.mount "main" {
                init,
                update,
                view,
                signals
}
