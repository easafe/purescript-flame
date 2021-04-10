-- | Types common to Flame modules
module Flame.Types (
      PreApplication,
      App,
      (:>),
      ToNodeData,
      Tag,
      Key,
      AppId(..),
      ApplicationId,
      Subscription,
      DomRenderingState,
      Source(..),
      EventName,
      DomNode,
      NodeData,
      Html
) where

import Data.Maybe (Maybe)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested (Tuple3)
import Foreign (Foreign)
import Prelude (class Functor, map)

-- | `PreApplication` contains
-- | * `init` – the initial model
-- | * `view` – a function to update your markup
type PreApplication model message = {
      init :: model,
      view :: model -> Html message
}

type ApplicationId = String

newtype AppId a b = AppId a

type EventName = String

data Source = Window | Document | Custom

-- | Subscriptions are events from outside the view, e.g. `window`, `document` or `CustomEvent`
type Subscription message = Tuple3 Source EventName (Foreign -> message)

-- | Abstracts over common fields of an `Application`
type App model message extension = {
      view :: model -> Html message,
      subscribe :: Array (Subscription message) |
      extension
}

-- | Infix tuple constructor
infixr 6 Tuple as :>

type ToNodeData value = forall message. value -> NodeData message

type Tag = String
type Key = String

-- | FFI class that keeps track of DOM rendering
foreign import data DomRenderingState :: Type

-- | A make believe type for DOM nodes
foreign import data DomNode :: Type

-- | Attributes and properties of virtual nodes
foreign import data NodeData :: Type -> Type

--Html can actually be typed, but since it is only used in FFI code, I don't think it'd be very useful
-- | The type of virtual nodes
foreign import data Html :: Type -> Type

--we support events that are not fired if the message is Nothing
foreign import messageMapper :: forall message mapped. (Maybe message -> Maybe mapped) -> Html message -> Html mapped

instance functorHtml :: Functor Html where
      map f html = messageMapper (map f) html
