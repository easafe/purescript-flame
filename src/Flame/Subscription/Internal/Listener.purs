module Flame.Subscription.Internal.Listener (
      createMessageListener,
      createSubscription
) where

import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as EU
import Flame.Application.Internal.Dom as FAID
import Flame.Types (ApplicationId, Source(..), Subscription)
import Foreign as F
import Prelude (Unit, discard, (<<<))

foreign import checkApplicationId_ :: EffectFn1 String Unit

-- | Raises an error if application id is not unique
checkApplicationId :: String -> Effect Unit
checkApplicationId = EU.runEffectFn1 checkApplicationId_

-- | Listener for external messages
-- |
-- | Implemented as a custom event because messages can be raised from anywhere
createMessageListener :: forall message. ApplicationId -> (message -> Effect Unit) -> Effect Unit
createMessageListener appId updater = do
      checkApplicationId appId
      FAID.createCustomListener appId (updater <<< F.unsafeFromForeign)

-- | Events from `Application.subscribe`
createSubscription :: forall message. (message -> Effect Unit) -> Subscription message -> Effect Unit
createSubscription updater (Tuple source (Tuple eventName (Tuple toMessage _))) = case source of
      Window -> FAID.createWindowListener eventName (updater <<< toMessage)
      Document -> FAID.createDocumentListener eventName (updater <<< toMessage)
      Custom -> FAID.createCustomListener eventName (updater <<< toMessage)