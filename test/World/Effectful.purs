module Test.Environment.Effectful (mount, TWEMessage(..), einit, TWEModel(..)) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show as DGRS
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (QuerySelector(..), Html, Environment, (:>))
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

newtype TWEModel = TWEModel {
        times :: Int,
        previousMessages:: Array (Maybe TWEMessage),
        previousModel :: Maybe TWEModel
}

data TWEMessage = TWEIncrement | TWEDecrement | TWEBogus

derive instance genericMessage :: Generic TWEMessage _

instance showMessage :: Show TWEMessage where
        show = DGRS.genericShow

derive instance genericModel :: Generic TWEModel _

instance showModel :: Show TWEModel where
        show a = DGRS.genericShow a

einit :: TWEModel
einit = TWEModel {
        times : 0,
        previousMessages : [],
        previousModel : Nothing
}

update :: Environment TWEModel TWEMessage -> Aff (TWEModel -> TWEModel)
update { model, message } =
        pure $ \t@(TWEModel model) -> TWEModel model {
                times = model.times + 1,
                previousMessages = model.previousMessages <> [Just message],
                previousModel = Just t
        }

view :: TWEModel -> Html TWEMessage
view (TWEModel model) = HE.main_ [
        HE.span "times-span" $ show $ model.times,
        HE.span "previous-messages-span" $ show $ model.previousMessages,
        HE.span "previous-model-span" $ show $ model.previousModel,

        HE.button [HA.id "increment-button", HA.onClick TWEIncrement] "+"
]

mount :: Effect Unit
mount = F.mount_ (QuerySelector "#mount-point") {
                init: einit :> Just TWEDecrement,
                update,
                view
        }
