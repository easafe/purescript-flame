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

-- | Enables either tuples, arrays or records be used as an argument to `style`
class ToStyleList a where
      toStyleList ∷ a → Object String

instance ToStyleList (Tuple String String) where
      toStyleList (Tuple a b) = FO.singleton a b
else instance Homogeneous r String ⇒ ToStyleList { | r } where
      toStyleList = FO.fromFoldable <<< map go <<< toArray
            where
            go (Tuple name' value') = Tuple (caseify name') value'

            toArray ∷ _ → Array (Tuple String String)
            toArray = FO.toUnfoldable <<< FO.fromHomogeneous
else instance DF.Foldable f ⇒ ToStyleList (f (Tuple String String)) where
      toStyleList = FO.fromFoldable

-- | Sets a react native property
foreign import createProperty ∷ ∀ message v. String → v → NodeData message

foreign import createClass ∷ ∀ message. Array String → NodeData message

foreign import createStyle ∷ ∀ message. Object String → NodeData message

class' ∷ ∀ a b. ToClassList b ⇒ b → NodeData a
class' = createClass <<< map caseify <<< to

-- | Sets the node style
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/ElementCSSInlineStyle/style
style ∷ ∀ a r. ToStyleList r ⇒ r → NodeData a
style record = createStyle $ toStyleList record

style1 ∷ ∀ a. String → String → NodeData a
style1 a b = createStyle $ FO.singleton a b

-- | Transforms its input into a proper html attribute/tag name, i.e. lower case and hyphenated
caseify ∷ String → String
caseify name'
      | name' == DS.toUpper name' = DS.toLower name'
      | otherwise = DS.toLower (DS.singleton head) <> hyphenated
              where
              { head, tail } = PU.unsafePartial (DM.fromJust $ DS.uncons name')

              regex = PU.unsafePartial case DSR.regex "[A-Z]" global of
                    DE.Right rgx → rgx
                    DE.Left err → P.crashWith $ show err

              replacer = const <<< ("-" <> _) <<< DS.toLower

              hyphenated = DSR.replace' regex replacer tail

id ∷ ToStringAttribute
id = createProperty "id"

innerHtml ∷ ToStringAttribute
innerHtml = createProperty "innerHTML"

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

keyboardType :: ToStringAttribute
keyboardType = createProperty "keyboardType"