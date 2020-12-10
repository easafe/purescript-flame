-- | Types common to Flame modules
module Flame.Types where

import Prelude

import Data.Tuple (Tuple(..))

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

--Html can actually be typed, but since it is only used in FFI code, I don't think it'd be very useful
-- | The type of virtual nodes
foreign import data Html :: Type -> Type
