module Flame.Subscription.Internal.Listener
      ( createMessageListener
      , createSubscription
      , isApplicationInitialized
      , queueMessage
      ) where

import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as EU
import Flame.Application.Internal.Dom as FAID
import Flame.Types (ApplicationId, Source(..), Subscription)
import Foreign (Foreign)
import Foreign as F
import Prelude (Unit, bind, discard, pure, unit, (<<<))

foreign import checkApplicationId_ ∷ EffectFn1 ApplicationId Unit
foreign import registerApplicationId_ ∷ EffectFn1 ApplicationId (Array Foreign)
foreign import isApplicationInitialized_ ∷ EffectFn1 ApplicationId Boolean
foreign import queueMessage_ ∷ ∀ message. EffectFn2 ApplicationId message Unit

-- | Raises an error if application id is not unique
checkApplicationId ∷ ApplicationId → Effect Unit
checkApplicationId = EU.runEffectFn1 checkApplicationId_

-- | Whether the application with the given id is mounted and listening to messages
isApplicationInitialized ∷ ApplicationId → Effect Boolean
isApplicationInitialized = EU.runEffectFn1 isApplicationInitialized_

-- | Holds a message for an application that is not mounted yet
queueMessage ∷ ∀ message. ApplicationId → message → Effect Unit
queueMessage = EU.runEffectFn2 queueMessage_

-- | Listener for external messages
-- |
-- | Implemented as a custom event because messages can be raised from anywhere
createMessageListener ∷ ∀ message. ApplicationId → (message → Effect Unit) → Effect Unit
createMessageListener appId updater = do
      checkApplicationId appId
      FAID.createCustomListener appId (updater <<< F.unsafeFromForeign)
      --messages sent before mounting
      queued ← EU.runEffectFn1 registerApplicationId_ appId
      DF.traverse_ (updater <<< F.unsafeFromForeign) queued

-- | Events from `Application.subscribe`
createSubscription ∷ ∀ message. (message → Effect Unit) → Subscription message → Effect Unit
createSubscription updater (source /\ eventName /\ toMessage) = case source of
      Window → FAID.createWindowListener eventName run
      Document → FAID.createDocumentListener eventName run
      Custom → FAID.createCustomListener eventName run
      where
      run ∷ Foreign → Effect Unit
      run arg = do
            message ← toMessage arg
            case message of
                  Just m → updater m
                  Nothing → pure unit
