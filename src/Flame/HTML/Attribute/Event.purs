-- | Definition of HTML events
module Flame.HTML.Event where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as FU
import Flame.Types (NodeData(..))
import Web.Event.Event (Event)

type EventName = String

--this way we dont need to worry about every possible element type
foreign import nodeValue :: EffectFn1 Event String

-- | Raises the given `message` for the given event
createEvent :: forall message. EventName -> message -> NodeData message
createEvent = Event

-- | Raises the given `message` for the given event, but also supplies the event itself
createRawEvent :: forall message. String -> (Event -> Effect message) -> NodeData message
createRawEvent = RawEvent

onClick :: forall a. a -> NodeData a
onClick = createEvent "click"

-- | This event fires when the value of an input, select, textarea, contenteditable or designMode on elements changes
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
