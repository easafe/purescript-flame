module Test.World.Effectful (mount) where

import Prelude

import Data.Array as DA
import Data.Maybe (Maybe(..), fromJust)
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html, World, (:>))
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Partial.Unsafe (unsafePartial)
import Web.Event.Internal.Types (Event)

newtype Model = Model {
        times :: Int,
        previousMessages:: Array Message,
        savedPreviousMessages:: Array Message,
        previousModel :: Maybe Model,
        event :: Maybe Event
}

data Message = Increment | Decrement | Bogus

init :: Model
init = Model {
        times : 0,
        previousMessages : [Decrement],
        savedPreviousMessages : [],
        previousModel : Nothing,
        event : Nothing
}

update :: World Model Message -> Model -> Message -> Aff Model
update re (Model model) message = pure $ Model $ model {
        times = model.times + 1,
        previousMessages = DA.snoc model.previousMessages message,
        savedPreviousMessages = model.savedPreviousMessages <> [unsafePartial (fromJust re.previousMessage), message],
        previousModel = Just re.previousModel,
        event = re.event
}

view :: Model -> Html Message
view model = HE.main_ [
        HE.button [HA.id "decrement-button", HA.onClick Decrement] "-",
        HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

mount :: Effect Unit
mount = F.mount "#mount-point" {
        init: init :> Just Decrement,
        update,
        view,
        signals: []
}
