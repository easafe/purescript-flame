-- | Client side application
module Examples.EffectList.ServerSideRendering.Client.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Examples.EffectList.ServerSideRendering.Shared (Model(..), Message(..))
import Examples.EffectList.ServerSideRendering.Shared as EESS
import Flame as F
import Web.DOM.ParentNode (QuerySelector(..))

update ∷ Model → Message → Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      Roll → model /\
            [ Just <<< Update <$> liftEffect (ER.randomInt 1 6)
            ]
      Update int → Model (Just int) /\ []

main ∷ Effect Unit
main = void $ F.resumeMount_ (QuerySelector "#main")
      { subscribe: []
      , update
      , view: EESS.view
      }
