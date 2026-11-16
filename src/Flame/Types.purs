-- | Types common to Flame modules
module Flame.Types
      ( Key
      , AppId(..)
      , ApplicationId
      , Subscription
      , DomRenderingState
      , Source(..)
      , EventName
      , DomNode
      , NodeData
      , Html
      ) where

import Data.Maybe (Maybe)
import Data.Tuple.Nested (type (/\))
import Effect (Effect)
import Foreign (Foreign)
import Prelude (class Functor, class Show, map)

-- | Unique name of a mounted application, used to route external messages to it
type ApplicationId = String

-- | Identifies an application that can be fed messages from outside its `view`
-- |
-- | `a` is the identifier (anything with a `Show` instance), `b` is the application message type
newtype AppId ∷ ∀ k. Type → k → Type
newtype AppId a b = AppId a

-- | Name of a DOM event, e.g. `"click"`
type EventName = String

-- | Where a subscription listens for events: the `window` object, the `document` object or a `CustomEvent` dispatched on the document
data Source = Window | Document | Custom

-- | Subscriptions are events from outside the view, e.g. `window`, `document` or `CustomEvent`
type Subscription message = Source /\ EventName /\ (Foreign → Effect (Maybe message))

-- | Key used by keyed rendering to match children nodes between updates
type Key = String

-- | FFI class that keeps track of DOM rendering
foreign import data DomRenderingState ∷ Type

-- | A make believe type for DOM nodes
foreign import data DomNode ∷ Type

instance Show DomNode where
      show _ = "dom node"

-- | Attributes and properties of virtual nodes
foreign import data NodeData ∷ Type → Type

--Html can actually be typed, but since it is only used in FFI code, I don't think it'd be very useful
-- | The type of virtual nodes
foreign import data Html ∷ Type → Type

-- | Maps the messages raised by a given `Html`; events may not fire, hence `Maybe`
foreign import messageMapper ∷ ∀ message mapped. (Maybe message → Maybe mapped) → Html message → Html mapped

instance Functor Html where
      map f html = messageMapper (map f) html
