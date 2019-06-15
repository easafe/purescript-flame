module Flame.DOM(querySelector) where

import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as DN
import Prelude (bind, pure, ($))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Flame.Types (DOMElement)

foreign import querySelector_ :: EffectFn1 String (Nullable DOMElement)

querySelector :: String -> Effect (Maybe DOMElement)
querySelector selector = do
        selected <- runEffectFn1 querySelector_ selector
        pure $ DN.toMaybe selected
