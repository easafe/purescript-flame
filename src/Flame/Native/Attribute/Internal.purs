-- | Definition of react native attributes
module Flame.Native.Attribute.Internal where

import Data.Array as DA
import Data.Either as DE
import Data.Foldable as DF
import Data.Maybe as DM
import Data.String (Pattern(..))
import Data.String as DS
import Data.String.Regex as DSR
import Data.String.Regex.Flags (global)
import Data.Tuple (Tuple(..))
import Flame.Types (NodeData, ToNodeData)
import Foreign.Object (Object)
import Foreign.Object as FO
import Partial as P
import Partial.Unsafe as PU
import Prelude (const, flip, map, not, otherwise, show, ($), (<<<), (<>), (==))
import Type.Row.Homogeneous (class Homogeneous)

type ToStringAttribute = ToNodeData String

type ToIntAttribute = ToNodeData Int

type ToBooleanAttribute = ToNodeData Boolean

type ToNumberAttribute = ToNodeData Number

-- | Enables either strings or records be used as an argument to `class'`
class ToClassList a where
      to ∷ a → Array String

instance ToClassList String where
      to = DA.filter (not <<< DS.null) <<< DS.split (Pattern " ")

instance Homogeneous r Boolean ⇒ ToClassList { | r } where
      to = FO.keys <<< FO.filterWithKey (flip const) <<< FO.fromHomogeneous

-- | Sets a react native property
foreign import createProperty ∷ ∀ message v. String → v → NodeData message

foreign import createClass ∷ ∀ message. Array String → NodeData message

-- | Sets the element style
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/ElementCSSInlineStyle/style
foreign import createStyle ∷ ∀ r message. r -> NodeData message

style :: ∀ r message. Homogeneous r String => { | r } -> NodeData message
style = createStyle

class' ∷ ∀ a b. ToClassList b ⇒ b → NodeData a
class' = createClass <<< to

id ∷ ToStringAttribute
id = createProperty "id"

alt ∷ ToStringAttribute
alt = createProperty "alt"

coords ∷ ToStringAttribute
coords = createProperty "coords"

for ∷ ToStringAttribute
for = createProperty "for"

href ∷ ToStringAttribute
href = createProperty "href"

name ∷ ToStringAttribute
name = createProperty "name"

placeholder ∷ ToStringAttribute
placeholder = createProperty "placeholder"

src ∷ ToStringAttribute
src = createProperty "source"

type' ∷ ToStringAttribute
type' = createProperty "type"

title ∷ ToStringAttribute
title = createProperty "title"

value ∷ ToStringAttribute
value = createProperty "value"

height ∷ ToStringAttribute
height = createProperty "height"

maxlength ∷ ToIntAttribute
maxlength = createProperty "maxlength" <<< show

autocomplete ∷ ToStringAttribute
autocomplete = createProperty "autocomplete"

checked ∷ ToBooleanAttribute
checked = createProperty "checked"

disabled ∷ ToBooleanAttribute
disabled = createProperty "disabled"

selected ∷ ToBooleanAttribute
selected = createProperty "selected"

keyboardType ∷ ToStringAttribute
keyboardType = createProperty "keyboardType"