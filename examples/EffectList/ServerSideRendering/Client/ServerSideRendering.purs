-- | Client side application
module Examples.EffectList.ServerSideRendering.Client.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (QuerySelector(..), (:>))
import Flame.Application.EffectList as FAE
import Data.Tuple(Tuple)
import Examples.EffectList.ServerSideRendering.Shared(Model(..), Message(..))
import Examples.EffectList.ServerSideRendering.Shared as EESS

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update m@(Model model) = case _ of
        Roll -> m :> [
                Just <<< Update <$> liftEffect (ER.randomInt 1 6)
        ]
        Update int -> Model (Just int) :> []

main :: Effect Unit
main = FAE.resumeMount_ (QuerySelector "main") {
        init: [],
        update,
        view: EESS.view
}
