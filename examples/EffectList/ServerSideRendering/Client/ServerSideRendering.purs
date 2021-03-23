-- | Client side application
module Examples.EffectList.ServerSideRendering.Client.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (QuerySelector(..), (:>))
import Flame as F
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
main = F.resumeMount_ (QuerySelector "body") {
        init: [],
        update,
        view: EESS.view
}
