module Test.Signal.Effectful (mount) where

-- | Counter example using a side effects free function
import Prelude

import Data.Maybe (Maybe(..))
import Data.Traversable as DT
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html, (:>))
import Flame as F
import Flame.HTML.Element as HE
import Flame.Signal as FS
import Web.Event.Internal.Types (Event)

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement Event

-- | `update` is called to handle events
update :: _ -> Model -> Message -> Aff Model
update _ model =
        pure <<< (case _ of
                Increment -> model + 1
                Decrement _ -> model - 1)

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
        HE.span "text-output" $ show model
]

-- | Mount the application on the given selector
mount :: Effect Unit
mount = do
        signals <- DT.sequence [FS.onError' Decrement, FS.onOffline Increment]
        F.mount "#mount-point" {
                init : 5 :> Nothing,
                update,
                view,
                signals
}