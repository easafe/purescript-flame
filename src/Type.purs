module Flame.Type where

import Prelude

import Control.Monad.State (StateT(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Web.Event.Event (Event)
import Foreign.Object (Object)
import Web.DOM.Element as WDE

type DOMElement = WDE.Element

foreign import data VNodeHookObjectProxy :: Type

--we dont really need hooks for now
-- something missing here is the support for thunks
type VNodeData =
        { attrs :: Object String
        , on :: VNodeEventObject
        , hook :: VNodeHookObjectProxy
        }

foreign import data VNodeEventObject :: Type

newtype VNodeProxy = VNodeProxy
        { sel :: String
        , data :: VNodeData
        , children :: Array VNodeProxy
        , elm :: DOMElement
        }

type Html = Element

type ToNodeData a = forall b. a -> NodeData b

type Tag = String

--snabbom has support for style and class node data but I dont think it is worth it
data NodeData a = Attribute String String | Property String Boolean | Event String a | RawEvent String (Event -> Effect a)

derive instance nodeDataFunctor :: Functor NodeData

data Element a = Node Tag (Array (NodeData a)) (Array (Element a)) | Text String

derive instance elementFunctor :: Functor Element