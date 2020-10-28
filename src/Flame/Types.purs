-- | Types common to Flame modules
module Flame.Types where

import Prelude

import Data.Array as DA
import Data.Maybe as DM
import Data.Nullable (Nullable)
import Data.Nullable as DN
import Data.String as DS
import Data.Tuple (Tuple(..))
import Flame.Internal.Equality as FIE
import Foreign (Foreign)
import Foreign.Object (Object)
import Foreign.Object as FO

-- | `PreApplication` contains
-- | * `init` – the initial model
-- | * `view` – a function to update your markup
type PreApplication model message = App model message (
      init :: model
)

-- App abstracts over common fields of an `Application`
type App model message extension = {
      view :: model -> Html message |
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

<<<<<<< HEAD
-- | Convenience wrapper around `VNodeData`
--snabbom has support for style and class node data but I dont think it is worth it
data NodeData message =
        Attribute String String |
        Key String |
        Property String String |
        StyleList (Object String) |
        Event String message |
        RawEvent String (Event -> Effect (Maybe message)) |
        Hook String Foreign

derive instance nodeDataFunctor :: Functor NodeData

instance showNodeData :: Show (NodeData message) where
        show (Attribute name val) = "(Attribute " <> name <> " " <> val <> ")"
        show (Property name val) = "(Property " <> name <> " " <> val <> ")"
        show _ = ""

instance eqNodeData :: Eq (NodeData message) where
        eq (Attribute name val) (Attribute name2 val2) = name == name2 && val == val2
        eq (Property name val) (Property name2 val2) = name == name2 && val == val2
        eq _ _ = false

-- | Infix tuple constructor
infixr 6 Tuple as :>
=======
--Html can actually be typed, but since it is only used in FFI code, I don't think it'd be very useful
-- | The type of virtual nodes
foreign import data Html :: Type -> Type
>>>>>>> 2291c71... New virtual node and renderer architecture
