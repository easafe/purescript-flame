-- | Types common to Flame modules
module Flame.Types where

import Prelude

import Data.Tuple (Tuple(..))
import Effect (Effect)
import Foreign.Object (Object)
import Web.DOM.Element as WDE
import Web.Event.Event (Event)

-- | Represents a list of events listeners
foreign import data VNodeEvents :: Type

-- | Data (properties, attributes, events) attached to a VNode
-- something missing here is the support for thunks
type VNodeData = {
        -- we need attrs mainly for svg
        attrs :: Object String,
        props :: Object String,
        on :: VNodeEvents
}

-- | Virtual DOM representation
newtype VNode = VNode {
        sel :: String,
        data :: VNodeData,
        children :: Array VNode,
        elm :: DOMElement
}

-- App abstracts over common fields of an `Application`
type App model message extension = {
        view :: model -> Html message |
        extension
}

-- | `PreApplication` contains
-- | * `init` – the initial model
-- | * `view` – a function to update your markup
type PreApplication model message = App model message (
        init :: model
)

-- | A native HTML element
type DOMElement = WDE.Element

type ToNodeData message = forall b. message -> NodeData b

type Tag = String

type Key = String

--add support for react like fragment nodes?
-- | Convenience wrapper around `VNode`
data Html message =
        Node Tag (Array (NodeData message)) (Array (Html message)) |
        Text String

derive instance elementFunctor :: Functor Html

-- | Convenience wrapper around `VNodeData`
--snabbom has support for style and class node data but I dont think it is worth it
data NodeData message =
        Attribute String String |
        Property String String |
        Event String message |
        RawEvent String (Event -> Effect message)

derive instance nodeDataFunctor :: Functor NodeData

-- | Infix tuple constructor
infixr 6 Tuple as :>
