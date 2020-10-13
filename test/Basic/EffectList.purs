module Test.Basic.EffectList (mount) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String as DS
import Data.String.CodeUnits as DSC
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as FU
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Web.Event.Event (Event)
import Web.Event.Event as WEE

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
                        pressed <- key event
                        case pressed of
                                "Enter" -> do
                                        WEE.preventDefault event
                                        pure $ Just message
                                _ -> pure Nothing


mount :: Effect Unit
mount = FAE.mount_ (QuerySelector "#mount-point") {
                init: "" :> [],
                update,
                view
        }

--helper functions for onEnterPressed
foreign import key_ :: EffectFn1 Event String

key :: Event -> Effect String
key = FU.runEffectFn1 key_
