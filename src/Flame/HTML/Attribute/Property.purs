-- | Definition of HTML properties
module Flame.HTML.Property where

import Flame.Types (ToNodeData, NodeData(..))

type ToProperty = ToNodeData Boolean

-- | Creates a property
-- |
-- | A property is a presential (boolean) attribute such as checked or enabled
createProperty :: forall message. String -> Boolean -> NodeData message
createProperty = Property

autocomplete :: ToProperty
autocomplete = createProperty "autocomplete"

autofocus :: ToProperty
autofocus = createProperty "autofocus"

autoplay :: ToProperty
autoplay = createProperty "autoplay"

checked :: ToProperty
checked = createProperty "checked"

contentEditable :: ToProperty
contentEditable = createProperty "contentEditable"

controls :: ToProperty
controls = createProperty "controls"

default :: ToProperty
default = createProperty "default"

disabled :: ToProperty
disabled = createProperty "disabled"

hidden :: ToProperty
hidden = createProperty "hidden"

isMap :: ToProperty
isMap = createProperty "isMap"

loop :: ToProperty
loop = createProperty "loop"

multiple :: ToProperty
multiple = createProperty "multiple"

noValidate :: ToProperty
noValidate = createProperty "noValidate"

readOnly :: ToProperty
readOnly = createProperty "readOnly"

required :: ToProperty
required = createProperty "required"

reversed :: ToProperty
reversed = createProperty "reversed"

selected :: ToProperty
selected = createProperty "selected"

spellcheck :: ToProperty
spellcheck = createProperty "spellcheck"

externalResourcesRequired :: ToProperty
externalResourcesRequired = createProperty "externalResourcesRequired"

preserveAlpha :: ToProperty
preserveAlpha = createProperty "preserveAlpha"