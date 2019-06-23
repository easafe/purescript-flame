module Examples.EffectList.ServerSideRendering.Client.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame.Application.EffectList ((:>))
import Flame.Application.EffectList as FAE
import Data.Tuple(Tuple)
import Examples.EffectList.ServerSideRendering.Shared(Model, Message(..))
import Examples.EffectList.ServerSideRendering.Shared as EESS

init :: Model
init = Nothing

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
        Roll -> model :> [
                Just <<< Update <$> liftEffect (ER.randomInt 1 6)
        ]
        Update int -> Just int :> []

main :: Effect Unit
main = FAE.mount_ "main" {
        init: init :> [],
        update,
        view: EESS.view
}
