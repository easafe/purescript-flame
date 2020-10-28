module Flame.Application.Internal.Dom(querySelector, textContent, removeElement) where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as DN
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as EU
import Flame.Types (DomNode)

foreign import querySelector_ :: EffectFn1 String (Nullable DomNode)
foreign import textContent_ :: EffectFn1 DomNode String
foreign import removeElement_ :: EffectFn1 String Unit

querySelector :: String -> Effect (Maybe DomNode)
querySelector selector = do
      selected <- EU.runEffectFn1 querySelector_ selector
      pure $ DN.toMaybe selected

textContent :: DomNode -> Effect String
textContent = EU.runEffectFn1 textContent_

removeElement :: String -> Effect Unit
removeElement = EU.runEffectFn1 removeElement_