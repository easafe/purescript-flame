module Examples.App.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (AppId(..), Html, (:>))
import Flame.Application.Native as FAN
import Flame.Native.Attribute as HA
import Flame.Native.Element as HE

type Model = Maybe Int

init ∷ Model
init = Nothing

data Message = Roll | Update Int

update ∷ Model → Message → Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      Roll → model :>
            [ Just <<< Update <$> liftEffect (ER.randomInt 1 6)
            ]
      Update int → Just int :> []

view ∷ Model → Html Message
view model = HE.text (show model)

-- HE.div "main"
--       [ HE.text (show model)
--    --   , HE.button [ HA.onClick Roll ] "Roll"
--       ]

main ∷ Effect Unit
main = FAN.mount "App"
      { init: init :> []
      , subscribe: []
      , update
      , view
      }

