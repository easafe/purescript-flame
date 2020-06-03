-- | Types common to Flame modules
module Flame.Types where

import Prelude

import Data.Array (filter)
import Data.Foldable (all, elem)
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


instance showHtml :: Show (Html message) where
        show (Node tag nodeData childs) = "(Node " <> show tag <> " " <> show (nodeData # filter isShowable) <> " " <> show childs <> ")"
                where isShowable  = case _ of
                        Attribute _ _ -> true
                        Property _ _ -> true
                        _ -> false
        show (Text t) = "(Text " <> show t <> ")"

instance eqHtml :: Eq (Html message) where
        eq (Node tag nodeData childs) (Node tag2 nodeData2 childs2) = tag == tag2 && eqArrayNodeData nodeData nodeData2 && childs == childs2
                where eqArrayNodeData arr1 arr2 = all (flip elem (onlyComparable arr2)) (onlyComparable arr1)
                      onlyComparable = filter case _ of
                        Attribute _ _ -> true
                        Property _ _ -> true
                        _ -> false
        eq (Text t) (Text t2) = t == t2
        eq _ _ = false


-- | Convenience wrapper around `VNodeData`
--snabbom has support for style and class node data but I dont think it is worth it
data NodeData message =
        Attribute String String |
        Property String String |
        Event String message |
        RawEvent String (Event -> Effect message)

derive instance nodeDataFunctor :: Functor NodeData

instance showNodeData :: Show (NodeData message) where
        show (Attribute name val) = "(Attribute " <> show name <> " " <> show val <> ")"
        show (Property name val) = "(Property " <> show name <> " " <> show val <> ")"
        show _ = ""

instance eqNodeData :: Eq (NodeData message) where
        eq (Attribute name val) (Attribute name2 val2) = name == name2 && val == val2
        eq (Property name val) (Property name2 val2) = name == name2 && val == val2
        eq _ _ = false


-- | Infix tuple constructor
infixr 6 Tuple as :>
