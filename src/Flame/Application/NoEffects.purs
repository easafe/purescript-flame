--a side effect free function for update
module Flame.Application.NoEffects where

import Flame.Type

type Application model message = App model message ( update :: model -> message -> message )


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