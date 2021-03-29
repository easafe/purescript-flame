module Test.Basic.EffectList (mount) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.String as DS
import Data.String.CodeUnits as DSC
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.EffectList as FAE
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Partial.Unsafe as UP
import Web.Event.Event as WEE
import Web.UIEvent.KeyboardEvent as WUK

type Model = String

data Message = Current String | Cut | Submit

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      Cut -> model :> [
            Just <<< Current <$> cut model
      ]
      Submit -> "thanks" :> []
      Current text -> text :> []
      where   cut text = do
                  amount <- liftEffect <<< ER.randomInt 1 $ DSC.length text
                  pure $ DS.drop amount text

view :: Model -> Html Message
view model = HE.main_ [
      HE.span [HA.id "text-output"] model,
      --we add extra events for each input to test if the correct message is used
      HE.input [HA.id "text-input", HA.type' "text", HA.onInput Current, HA.onFocus Cut, onEnterPressed Submit],
      HE.input [HA.id "cut-button", HA.type' "button", HA.onClick Cut, HA.onFocus (Current "")]
]
        where onEnterPressed message = HA.createRawEvent "keypress" $ \event -> do
                  let pressed = WUK.key $ UP.unsafePartial (DM.fromJust $ WUK.fromEvent event)
                  case pressed of
                        "Enter" -> do
                              WEE.preventDefault event
                              pure $ Just message
                        _ -> pure Nothing


mount :: Effect Unit
mount = FAE.mount_ (QuerySelector "#mount-point") {
      init: "" :> [],
      subscribe: [],
      update,
      view
}
