-- | Attributes, properties and events of HTML elements
-- |
-- | Re-exports `Flame.Html.Attribute.Internal` and `Flame.Html.Event`
module Flame.Html.Attribute
      ( module Attribute
      , module Event
      , module Types
      ) where

import Flame.Html.Attribute.Internal as Attribute
import Flame.Html.Event as Event
import Flame.Types (EventName) as Types
