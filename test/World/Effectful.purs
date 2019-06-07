module Test.World.Effectful (mount, EMessage(..), einit, EModel(..)) where

import Prelude

import Data.Array as DA
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show as DGRS
import Data.Maybe (Maybe(..), fromJust)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Flame (Html, World, (:>))
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Partial.Unsafe (unsafePartial)
import Web.Event.Internal.Types (Event)

newtype EModel = EModel {
        times :: Int,
        previousMessages:: Array (Maybe EMessage),
        previousModel :: Maybe EModel
}

data EMessage = Increment | Decrement | Bogus

derive instance genericMessage :: Generic EMessage _

instance showMessage :: Show EMessage where
	show = DGRS.genericShow

derive instance genericModel :: Generic EModel _

instance showModel :: Show EModel where
	show a = DGRS.genericShow a

einit :: EModel
einit = EModel {
        times : 0,
        previousMessages : [],
        previousModel : Nothing
}

update :: World EModel EMessage -> EModel -> EMessage -> Aff EModel
update re (EModel model) message = do
        pure $ EModel $ model {
                times = model.times + 1,
                previousMessages = model.previousMessages <> [re.previousMessage, Just message],
                previousModel = Just re.previousModel
}

view :: EModel -> Html EMessage
view (EModel model) = HE.main_ [
        HE.span "times-span" $ show $ model.times,
        HE.span "previous-messages-span" $ show $ model.previousMessages,
        HE.span "previous-model-span" $ show $ model.previousModel,

        HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

mount :: Effect Unit
mount = F.mount "#mount-point" {
        init: einit :> Just Decrement,
        update,
        view,
        signals: []
}
