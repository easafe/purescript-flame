module Flame.Html.Event where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as FU
import Flame.Type (NodeData(..))
import Web.Event.Event (Event)

type EventName = String

--this way we dont need to worry about every possible element type
foreign import nodeValue :: EffectFn1 Event String

createEvent :: forall a . EventName -> a -> NodeData a
createEvent = Event

--createRawEvent :: forall a . EventName -> (forall m. Monad m => Event -> m a) -> NodeData a
createRawEvent = RawEvent

onClick :: forall a. a -> NodeData a
onClick = createEvent "click"

onInput :: forall a. (String -> a) -> NodeData a
onInput constructor = createRawEvent "input" handler
        where   handler event = constructor <$> FU.runEffectFn1 nodeValue event

-- onCheck :: forall msg. (Boolean -> msg) -> Trait msg
-- onCheck f = on "change" $ \event -> do
--         let maybeInputElement = event # Event.target >>= Node.fromEventTarget >>= HTMLInputElement.fromNode

--         value <- case maybeInputElement of
--                 Just inputElement -> HTMLInputElement.checked inputElement
--                 Nothing -> pure false
--         pure $ f value

-- onSubmit :: forall msg. msg -> Trait msg
-- onSubmit msg = on "submit" $ \event -> do
--         Event.preventDefault event
--         pure msg
