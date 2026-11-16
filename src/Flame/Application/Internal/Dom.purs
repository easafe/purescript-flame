module Flame.Application.Internal.Dom
      ( querySelector
      , textContent
      , removeElement
      , createWindowListener
      , createDocumentListener
      , createCustomListener
      , dispatchCustomEvent
      ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as DN
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as EU
import Flame.Types (DomNode, EventName)
import Foreign (Foreign)

foreign import querySelector_ ∷ EffectFn1 String (Nullable DomNode)
foreign import textContent_ ∷ EffectFn1 DomNode String
foreign import removeElement_ ∷ EffectFn1 String Unit
foreign import createWindowListener_ ∷ EffectFn2 EventName (Foreign → Effect Unit) Unit
foreign import createDocumentListener_ ∷ EffectFn2 EventName (Foreign → Effect Unit) Unit
foreign import createCustomListener_ ∷ EffectFn2 EventName (Foreign → Effect Unit) Unit
foreign import dispatchCustomEvent_ ∷ ∀ message. EffectFn2 EventName message Unit

-- | First element matching the selector on the document
querySelector ∷ String → Effect (Maybe DomNode)
querySelector selector = do
      selected ← EU.runEffectFn1 querySelector_ selector
      pure $ DN.toMaybe selected

-- | Text content of the node, empty if there is none
textContent ∷ DomNode → Effect String
textContent = EU.runEffectFn1 textContent_

-- | Removes the first element matching the selector from the document
removeElement ∷ String → Effect Unit
removeElement = EU.runEffectFn1 removeElement_

-- | Listens to the event on `window`, passing the event object to the handler
createWindowListener ∷ EventName → (Foreign → Effect Unit) → Effect Unit
createWindowListener = EU.runEffectFn2 createWindowListener_

-- | Listens to the event on `document`, passing the event object to the handler
createDocumentListener ∷ EventName → (Foreign → Effect Unit) → Effect Unit
createDocumentListener = EU.runEffectFn2 createDocumentListener_

-- | Listens to a `CustomEvent` on `document`, passing its `detail` payload to the handler
createCustomListener ∷ EventName → (Foreign → Effect Unit) → Effect Unit
createCustomListener = EU.runEffectFn2 createCustomListener_

-- | Dispatches a `CustomEvent` on `document` with the given payload as `detail`
dispatchCustomEvent ∷ ∀ message. EventName → message → Effect Unit
dispatchCustomEvent = EU.runEffectFn2 dispatchCustomEvent_