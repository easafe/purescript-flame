module Test.External.Effectful (mount) where

-- | Counter example using a side effects free function
import Prelude

import Data.Maybe (Maybe(..))
import Data.Traversable as DF
import Data.Traversable as DT
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (QuerySelector(..), Html, (:>), AffUpdate)
import Flame as F
import Flame.HTML.Element as HE
import Flame.HTML.Attribute as HA
import Flame.External as FE
import Web.Event.Internal.Types (Event)

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement Event

-- | `update` is called to handle events
update :: AffUpdate Model Message
update { model, message } =
        pure $ (case message of
                Increment -> (_ + 1)
                Decrement _ -> (_ - 1))

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
        HE.span "text-output" $ show model,
        HE.br,
        HE.button (HA.onClick Increment) "+"
]

-- | Mount the application on the given selector
mount :: Effect Unit
mount = do
        channel <- F.mount (QuerySelector "#mount-point") {
                init : 5 :> Nothing,
                update,
                view
        }
        FE.send [FE.onError' (Just Decrement), FE.onOffline (Just Increment)] channel