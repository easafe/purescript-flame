--elm like way of updating
module Flame.Application.EffectList where

import Prelude
import Effect.Aff(Aff)
import Flame.Type

type Application model message = App model message ( update :: model -> message -> Tuple model (Array (Aff message)))


emptyApp :: Application Unit Unit
emptyApp = {
        init: unit,
        update,
        view: const (FHE.createEmptyElement "bs"),
        inputs : []
}
        where update f model message = pure model


mount :: forall model message. String -> Application model message -> Effect Unit
mount selector application = do
        maybeEl <- HD.querySelector selector
        case maybeEl of
                Just el -> startApplication el application
                Nothing -> EC.log $ "No element matching selector " <> show selector <> " found!"