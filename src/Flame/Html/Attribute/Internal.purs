-- | Definition of HTML attributes
module Flame.Html.Attribute.Internal
      ( class ToClassList
      , to
      , class ToStyleList
      , toStyleList
      , ToNodeData
      , ToStringAttribute
      , ToIntAttribute
      , ToBooleanAttribute
      , ToNumberAttribute
      , createProperty
      , createAttribute
      , class'
      , style
      , style'
      , style1
      , key
      , id
      , innerHtml
      , content
      , accept
      , acceptCharset
      , accessKey
      , action
      , align
      , alt
      , charset
      , coords
      , dir
      , download
      , downloadAs
      , dropzone
      , enctype
      , for
      , headers
      , href
      , hreflang
      , kind
      , lang
      , max
      , method
      , min
      , name
      , pattern
      , ping
      , placeholder
      , poster
      , preload
      , sandbox
      , scope
      , shape
      , src
      , srcdoc
      , srclang
      , step
      , target
      , title
      , type'
      , useMap
      , value
      , wrap
      , cols
      , colspan
      , height
      , maxlength
      , minlength
      , rows
      , rowspan
      , size
      , start
      , tabindex
      , width
      , contextmenu
      , datetime
      , draggable
      , itemprop
      , list
      , manifest
      , media
      , pubdate
      , rel
      , cx
      , cy
      , fillOpacity
      , fx
      , fy
      , markerHeight
      , markerWidth
      , r
      , strokeDashoffset
      , strokeOpacity
      , strokeWidth
      , textLength
      , x
      , x1
      , x2
      , y
      , y1
      , y2
      , accumulate
      , additive
      , alignmentBaseline
      , attributeName
      , attributeType
      , baseFrequency
      , baselineShift
      , baseProfile
      , begin
      , calcMode
      , clipPathUnits
      , clipPathAttr
      , clipRule
      , color
      , colorInterpolation
      , colorInterpolationFilters
      , colorProfileAttr
      , colorRendering
      , contentScriptType
      , contentStyleType
      , cursorAttr
      , d
      , direction
      , display
      , dominantBaseline
      , dur
      , dx
      , dy
      , edgeMode
      , end
      , fill
      , fillRule
      , filterAttr
      , filterUnits
      , floodColor
      , floodOpacity
      , fontFamily
      , fontSize
      , fontSizeAdjust
      , fontStretch
      , fontStyle
      , fontVariant
      , fontWeight
      , from
      , gradientTransform
      , gradientUnits
      , imageRendering
      , in'
      , in2
      , kernelMatrix
      , kernelUnitLength
      , kerning
      , keySplines
      , keyTimes
      , lengthAdjust
      , letterSpacing
      , lightingColor
      , local
      , markerEnd
      , markerMid
      , markerStart
      , markerUnits
      , maskAttr
      , maskContentUnits
      , maskUnits
      , mode
      , opacity
      , operator
      , order
      , overflow
      , paintOrder
      , patternContentUnits
      , patternTransform
      , patternUnits
      , pointerEvents
      , points
      , preserveAspectRatio
      , primitiveUnits
      , radius
      , repeatCount
      , repeatDur
      , requiredFeatures
      , restart
      , result
      , rx
      , ry
      , shapeRendering
      , stdDeviation
      , stitchTiles
      , stopColor
      , stopOpacity
      , stroke
      , strokeDasharray
      , strokeLinecap
      , strokeLinejoin
      , styleAttr
      , textAnchor
      , textDecoration
      , textRendering
      , transform
      , values
      , vectorEffect
      , viewBox
      , visibility
      , wordSpacing
      , writingMode
      , xChannelSelector
      , yChannelSelector
      , accentHeight
      , ascent
      , azimuth
      , bias
      , diffuseConstant
      , divisor
      , elevation
      , fr
      , k1
      , k2
      , k3
      , k4
      , limitingConeAngle
      , overlinePosition
      , overlineThickness
      , pathLength
      , pointsAtX
      , pointsAtY
      , pointsAtZ
      , refX
      , refY
      , scale
      , seed
      , specularConstant
      , specularExponent
      , strikethroughPosition
      , strikethroughThickness
      , strokeMiterlimit
      , surfaceScale
      , targetX
      , targetY
      , underlinePosition
      , underlineThickness
      , version
      , numOctaves
      , autocomplete
      , autofocus
      , autoplay
      , checked
      , contentEditable
      , controls
      , default
      , disabled
      , hidden
      , isMap
      , loop
      , multiple
      , noValidate
      , readOnly
      , required
      , reversed
      , selected
      , spellcheck
      , externalResourcesRequired
      , preserveAlpha
      ) where

import Data.Array as DA
import Data.Foldable as DF
import Data.Maybe as DM
import Data.String (Pattern(..))
import Data.String as DS
import Data.String.Regex (Regex)
import Data.String.Regex as DSR
import Data.String.Regex.Flags (global)
import Data.String.Regex.Unsafe as DSRU
import Data.Tuple (Tuple(..))
import Flame.Types (NodeData)
import Foreign.Object (Object)
import Foreign.Object as FO
import Prelude (const, map, otherwise, show, ($), (<<<), (<>), (==))
import Type.Row.Homogeneous (class Homogeneous)

-- | Attribute or property setter that takes a `value` and works for any message type
type ToNodeData value = ∀ message. value → NodeData message

-- | Setter for string valued attributes and properties
type ToStringAttribute = ToNodeData String

-- | Setter for integer valued attributes and properties
type ToIntAttribute = ToNodeData Int

-- | Setter for boolean valued attributes and properties
type ToBooleanAttribute = ToNodeData Boolean

-- | Setter for number valued attributes and properties
type ToNumberAttribute = ToNodeData Number

-- | Enables either strings or records be used as an argument to `class'`
class ToClassList a where
      to ∷ a → Array String

instance ToClassList String where
      to = DA.mapMaybe nonEmpty <<< DS.split (Pattern " ")
            where
            nonEmpty name'
                  | DS.null name' = DM.Nothing
                  | otherwise = DM.Just $ caseify name'

instance ToClassList (Array String) where
      to = map caseify

instance Homogeneous r Boolean ⇒ ToClassList { | r } where
      to = DA.catMaybes <<< FO.toArrayWithKey enabled <<< FO.fromHomogeneous
            where
            enabled name' isSet
                  | isSet = DM.Just $ caseify name'
                  | otherwise = DM.Nothing

-- | Enables either tuples, arrays or records be used as an argument to `style`
class ToStyleList a where
      toStyleList ∷ a → Object String

instance ToStyleList (Tuple String String) where
      toStyleList (Tuple a b) = FO.singleton a b
else instance Homogeneous r String ⇒ ToStyleList { | r } where
      toStyleList = FO.fromFoldable <<< FO.toArrayWithKey go <<< FO.fromHomogeneous
            where
            go name' value' = Tuple (caseify name') value'
else instance DF.Foldable f ⇒ ToStyleList (f (Tuple String String)) where
      toStyleList = FO.fromFoldable

--these functions cheat by only creating the necessary key on NodeData
-- | Sets a DOM property
foreign import createProperty ∷ ∀ message. String → String → NodeData message
-- | Creates a HTML attribute
foreign import createAttribute ∷ ∀ message. String → String → NodeData message
-- | Sets the class list of a node
foreign import createClass ∷ ∀ message. Array String → NodeData message
-- | Sets inline styles of a node
foreign import createStyle ∷ ∀ message. Object String → NodeData message
-- | Sets the key of a node for keyed rendering
foreign import createKey ∷ ∀ message. String → NodeData message

-- | Converts a boolean into the string value boolean DOM properties expect
booleanToFalsyString ∷ Boolean → String
booleanToFalsyString =
      case _ of
            true → "true"
            false → ""

-- | Converts a boolean into the literal `true`/`false` strings used by SVG boolean attributes and `contentEditable`
booleanToString ∷ Boolean → String
booleanToString =
      case _ of
            true → "true"
            false → "false"

-- | Sets the class list of the node; see `ToClassList` for the accepted inputs
class' ∷ ∀ a b. ToClassList b ⇒ b → NodeData a
class' = createClass <<< to

-- | Sets the node style
-- |
-- | https://developer.mozilla.org/en-US/docs/Web/API/ElementCSSInlineStyle/style
style ∷ ∀ a r. ToStyleList r ⇒ r → NodeData a
style record = createStyle $ toStyleList record

-- | Sets a single style property
style' ∷ ∀ a. String → String → NodeData a
style' a b = createStyle $ FO.singleton a b

-- | Deprecated: use `style'`
style1 ∷ ∀ a. String → String → NodeData a
style1 = style'

-- | Transforms its input into a proper html attribute/tag name, i.e. lower case and hyphenated
-- |
-- | Names that are already lower case are returned as they are
caseify ∷ String → String
caseify name' =
      let
            lowered = DS.toLower name'
      in
            if name' == lowered then
                  name'
            else if name' == DS.toUpper name' then
                  lowered
            else case DS.uncons name' of
                  DM.Nothing → name'
                  DM.Just { head, tail } → DS.toLower (DS.singleton head) <> DSR.replace' upperCaseRegex hyphenate tail
      where
      hyphenate = const <<< ("-" <> _) <<< DS.toLower

-- | Matches the upper case letters to be hyphenated by `caseify`
upperCaseRegex ∷ Regex
upperCaseRegex = DSRU.unsafeRegex "[A-Z]" global

-- | Set the key attribute for "keyed" rendering
key ∷ ToStringAttribute
key = createKey

--script generated

-- | Sets the `id` property
id ∷ ToStringAttribute
id = createProperty "id"

-- | Sets the `innerHTML` property
innerHtml ∷ ToStringAttribute
innerHtml = createProperty "innerHTML"

-- | Sets the `content` property
content ∷ ToStringAttribute
content = createProperty "content"

-- | Sets the `accept` property
accept ∷ ToStringAttribute
accept = createProperty "accept"

-- | Sets the `acceptCharset` property
acceptCharset ∷ ToStringAttribute
acceptCharset = createProperty "acceptCharset"

-- | Sets the `accessKey` property
accessKey ∷ ToStringAttribute
accessKey = createProperty "accessKey"

-- | Sets the `action` property
action ∷ ToStringAttribute
action = createProperty "action"

-- | Sets the `align` property
align ∷ ToStringAttribute
align = createProperty "align"

-- | Sets the `alt` property
alt ∷ ToStringAttribute
alt = createProperty "alt"

-- | Sets the `charset` attribute
charset ∷ ToStringAttribute
charset = createAttribute "charset"

-- | Sets the `coords` property
coords ∷ ToStringAttribute
coords = createProperty "coords"

-- | Sets the `dir` property
dir ∷ ToStringAttribute
dir = createProperty "dir"

-- | Sets the `download` property
download ∷ ToStringAttribute
download = createProperty "download"

-- | Sets the `downloadAs` property
downloadAs ∷ ToStringAttribute
downloadAs = createProperty "downloadAs"

-- | Sets the `dropzone` attribute
dropzone ∷ ToStringAttribute
dropzone = createAttribute "dropzone"

-- | Sets the `enctype` property
enctype ∷ ToStringAttribute
enctype = createProperty "enctype"

-- | Sets the `for` attribute
for ∷ ToStringAttribute
for = createAttribute "for"

-- | Sets the `headers` property
headers ∷ ToStringAttribute
headers = createProperty "headers"

-- | Sets the `href` attribute
href ∷ ToStringAttribute
href = createAttribute "href"

-- | Sets the `hreflang` property
hreflang ∷ ToStringAttribute
hreflang = createProperty "hreflang"

-- | Sets the `kind` property
kind ∷ ToStringAttribute
kind = createProperty "kind"

-- | Sets the `lang` property
lang ∷ ToStringAttribute
lang = createProperty "lang"

-- | Sets the `max` attribute
max ∷ ToStringAttribute
max = createAttribute "max"

-- | Sets the `method` property
method ∷ ToStringAttribute
method = createProperty "method"

-- | Sets the `min` attribute
min ∷ ToStringAttribute
min = createAttribute "min"

-- | Sets the `name` property
name ∷ ToStringAttribute
name = createProperty "name"

-- | Sets the `pattern` property
pattern ∷ ToStringAttribute
pattern = createProperty "pattern"

-- | Sets the `ping` property
ping ∷ ToStringAttribute
ping = createProperty "ping"

-- | Sets the `placeholder` property
placeholder ∷ ToStringAttribute
placeholder = createProperty "placeholder"

-- | Sets the `poster` property
poster ∷ ToStringAttribute
poster = createProperty "poster"

-- | Sets the `preload` property
preload ∷ ToStringAttribute
preload = createProperty "preload"

-- | Sets the `sandbox` property
sandbox ∷ ToStringAttribute
sandbox = createProperty "sandbox"

-- | Sets the `scope` property
scope ∷ ToStringAttribute
scope = createProperty "scope"

-- | Sets the `shape` property
shape ∷ ToStringAttribute
shape = createProperty "shape"

-- | Sets the `src` property
src ∷ ToStringAttribute
src = createProperty "src"

-- | Sets the `srcdoc` property
srcdoc ∷ ToStringAttribute
srcdoc = createProperty "srcdoc"

-- | Sets the `srclang` property
srclang ∷ ToStringAttribute
srclang = createProperty "srclang"

-- | Sets the `step` property
step ∷ ToStringAttribute
step = createProperty "step"

-- | Sets the `target` property
target ∷ ToStringAttribute
target = createProperty "target"

-- | Sets the `title` property
title ∷ ToStringAttribute
title = createProperty "title"

-- | Sets the `type` property
type' ∷ ToStringAttribute
type' = createProperty "type"

-- | Sets the `useMap` property
useMap ∷ ToStringAttribute
useMap = createProperty "useMap"

-- | Sets the `value` property
value ∷ ToStringAttribute
value = createProperty "value"

-- | Sets the `wrap` property
wrap ∷ ToStringAttribute
wrap = createProperty "wrap"

-- | Sets the `cols` property
cols ∷ ToIntAttribute
cols = createProperty "cols" <<< show

-- | Sets the `colSpan` property
colspan ∷ ToIntAttribute
colspan = createProperty "colSpan" <<< show

-- | Sets the `height` attribute
height ∷ ToStringAttribute
height = createAttribute "height"

-- | Sets the `maxLength` property
maxlength ∷ ToIntAttribute
maxlength = createProperty "maxLength" <<< show

-- | Sets the `minLength` property
minlength ∷ ToIntAttribute
minlength = createProperty "minLength" <<< show

-- | Sets the `rows` property
rows ∷ ToIntAttribute
rows = createProperty "rows" <<< show

-- | Sets the `rowSpan` property
rowspan ∷ ToIntAttribute
rowspan = createProperty "rowSpan" <<< show

-- | Sets the `size` property
size ∷ ToIntAttribute
size = createProperty "size" <<< show

-- | Sets the `start` property
start ∷ ToIntAttribute
start = createProperty "start" <<< show

-- | Sets the `tabIndex` property
tabindex ∷ ToIntAttribute
tabindex = createProperty "tabIndex" <<< show

-- | Sets the `width` attribute
width ∷ ToStringAttribute
width = createAttribute "width"

-- | Sets the `contextmenu` attribute
contextmenu ∷ ToStringAttribute
contextmenu = createAttribute "contextmenu"

-- | Sets the `dateTime` property
datetime ∷ ToStringAttribute
datetime = createProperty "dateTime"

-- | Sets the `draggable` property
draggable ∷ ToStringAttribute
draggable = createProperty "draggable"

-- | Sets the `itemprop` attribute
itemprop ∷ ToStringAttribute
itemprop = createAttribute "itemprop"

-- | Sets the `list` attribute
list ∷ ToStringAttribute
list = createAttribute "list"

-- | Sets the `manifest` attribute
manifest ∷ ToStringAttribute
manifest = createAttribute "manifest"

-- | Sets the `media` property
media ∷ ToStringAttribute
media = createProperty "media"

-- | Sets the `pubdate` attribute
pubdate ∷ ToStringAttribute
pubdate = createAttribute "pubdate"

-- | Sets the `rel` property
rel ∷ ToStringAttribute
rel = createProperty "rel"

-- | Sets the `cx` attribute
cx ∷ ToStringAttribute
cx = createAttribute "cx"

-- | Sets the `cy` attribute
cy ∷ ToStringAttribute
cy = createAttribute "cy"

-- | Sets the `fill-opacity` attribute
fillOpacity ∷ ToStringAttribute
fillOpacity = createAttribute "fill-opacity"

-- | Sets the `fx` attribute
fx ∷ ToStringAttribute
fx = createAttribute "fx"

-- | Sets the `fy` attribute
fy ∷ ToStringAttribute
fy = createAttribute "fy"

-- | Sets the `markerHeight` attribute
markerHeight ∷ ToStringAttribute
markerHeight = createAttribute "markerHeight"

-- | Sets the `markerWidth` attribute
markerWidth ∷ ToStringAttribute
markerWidth = createAttribute "markerWidth"

-- | Sets the `r` attribute
r ∷ ToStringAttribute
r = createAttribute "r"

-- | Sets the `stroke-dashoffset` attribute
strokeDashoffset ∷ ToStringAttribute
strokeDashoffset = createAttribute "stroke-dashoffset"

-- | Sets the `stroke-opacity` attribute
strokeOpacity ∷ ToStringAttribute
strokeOpacity = createAttribute "stroke-opacity"

-- | Sets the `stroke-width` attribute
strokeWidth ∷ ToStringAttribute
strokeWidth = createAttribute "stroke-width"

-- | Sets the `textLength` attribute
textLength ∷ ToStringAttribute
textLength = createAttribute "textLength"

-- | Sets the `x` attribute
x ∷ ToStringAttribute
x = createAttribute "x"

-- | Sets the `x1` attribute
x1 ∷ ToStringAttribute
x1 = createAttribute "x1"

-- | Sets the `x2` attribute
x2 ∷ ToStringAttribute
x2 = createAttribute "x2"

-- | Sets the `y` attribute
y ∷ ToStringAttribute
y = createAttribute "y"

-- | Sets the `y1` attribute
y1 ∷ ToStringAttribute
y1 = createAttribute "y1"

-- | Sets the `y2` attribute
y2 ∷ ToStringAttribute
y2 = createAttribute "y2"

-- | Sets the `accumulate` attribute
accumulate ∷ ToStringAttribute
accumulate = createAttribute "accumulate"

-- | Sets the `additive` attribute
additive ∷ ToStringAttribute
additive = createAttribute "additive"

-- | Sets the `alignment-baseline` attribute
alignmentBaseline ∷ ToStringAttribute
alignmentBaseline = createAttribute "alignment-baseline"

-- | Sets the `attributeName` attribute
attributeName ∷ ToStringAttribute
attributeName = createAttribute "attributeName"

-- | Sets the `attributeType` attribute
attributeType ∷ ToStringAttribute
attributeType = createAttribute "attributeType"

-- | Sets the `baseFrequency` attribute
baseFrequency ∷ ToStringAttribute
baseFrequency = createAttribute "baseFrequency"

-- | Sets the `baseline-shift` attribute
baselineShift ∷ ToStringAttribute
baselineShift = createAttribute "baseline-shift"

-- | Sets the `baseProfile` attribute
baseProfile ∷ ToStringAttribute
baseProfile = createAttribute "baseProfile"

-- | Sets the `begin` attribute
begin ∷ ToStringAttribute
begin = createAttribute "begin"

-- | Sets the `calcMode` attribute
calcMode ∷ ToStringAttribute
calcMode = createAttribute "calcMode"

-- | Sets the `clipPathUnits` attribute
clipPathUnits ∷ ToStringAttribute
clipPathUnits = createAttribute "clipPathUnits"

-- | Sets the `clip-path` attribute
clipPathAttr ∷ ToStringAttribute
clipPathAttr = createAttribute "clip-path"

-- | Sets the `clip-rule` attribute
clipRule ∷ ToStringAttribute
clipRule = createAttribute "clip-rule"

-- | Sets the `color` attribute
color ∷ ToStringAttribute
color = createAttribute "color"

-- | Sets the `color-interpolation` attribute
colorInterpolation ∷ ToStringAttribute
colorInterpolation = createAttribute "color-interpolation"

-- | Sets the `color-interpolation-filters` attribute
colorInterpolationFilters ∷ ToStringAttribute
colorInterpolationFilters = createAttribute "color-interpolation-filters"

-- | Sets the `color-profile` attribute
colorProfileAttr ∷ ToStringAttribute
colorProfileAttr = createAttribute "color-profile"

-- | Sets the `color-rendering` attribute
colorRendering ∷ ToStringAttribute
colorRendering = createAttribute "color-rendering"

-- | Sets the `contentScriptType` attribute
contentScriptType ∷ ToStringAttribute
contentScriptType = createAttribute "contentScriptType"

-- | Sets the `contentStyleType` attribute
contentStyleType ∷ ToStringAttribute
contentStyleType = createAttribute "contentStyleType"

-- | Sets the `cursor` attribute
cursorAttr ∷ ToStringAttribute
cursorAttr = createAttribute "cursor"

-- | Sets the `d` attribute
d ∷ ToStringAttribute
d = createAttribute "d"

-- | Sets the `direction` attribute
direction ∷ ToStringAttribute
direction = createAttribute "direction"

-- | Sets the `display` attribute
display ∷ ToStringAttribute
display = createAttribute "display"

-- | Sets the `dominant-baseline` attribute
dominantBaseline ∷ ToStringAttribute
dominantBaseline = createAttribute "dominant-baseline"

-- | Sets the `dur` attribute
dur ∷ ToStringAttribute
dur = createAttribute "dur"

-- | Sets the `dx` attribute
dx ∷ ToStringAttribute
dx = createAttribute "dx"

-- | Sets the `dy` attribute
dy ∷ ToStringAttribute
dy = createAttribute "dy"

-- | Sets the `edgeMode` attribute
edgeMode ∷ ToStringAttribute
edgeMode = createAttribute "edgeMode"

-- | Sets the `end` attribute
end ∷ ToStringAttribute
end = createAttribute "end"

-- | Sets the `fill` attribute
fill ∷ ToStringAttribute
fill = createAttribute "fill"

-- | Sets the `fill-rule` attribute
fillRule ∷ ToStringAttribute
fillRule = createAttribute "fill-rule"

-- | Sets the `filter` attribute
filterAttr ∷ ToStringAttribute
filterAttr = createAttribute "filter"

-- | Sets the `filterUnits` attribute
filterUnits ∷ ToStringAttribute
filterUnits = createAttribute "filterUnits"

-- | Sets the `flood-color` attribute
floodColor ∷ ToStringAttribute
floodColor = createAttribute "flood-color"

-- | Sets the `flood-opacity` attribute
floodOpacity ∷ ToStringAttribute
floodOpacity = createAttribute "flood-opacity"

-- | Sets the `font-family` attribute
fontFamily ∷ ToStringAttribute
fontFamily = createAttribute "font-family"

-- | Sets the `font-size` attribute
fontSize ∷ ToStringAttribute
fontSize = createAttribute "font-size"

-- | Sets the `font-size-adjust` attribute
fontSizeAdjust ∷ ToStringAttribute
fontSizeAdjust = createAttribute "font-size-adjust"

-- | Sets the `font-stretch` attribute
fontStretch ∷ ToStringAttribute
fontStretch = createAttribute "font-stretch"

-- | Sets the `font-style` attribute
fontStyle ∷ ToStringAttribute
fontStyle = createAttribute "font-style"

-- | Sets the `font-variant` attribute
fontVariant ∷ ToStringAttribute
fontVariant = createAttribute "font-variant"

-- | Sets the `font-weight` attribute
fontWeight ∷ ToStringAttribute
fontWeight = createAttribute "font-weight"

-- | Sets the `from` attribute
from ∷ ToStringAttribute
from = createAttribute "from"

-- | Sets the `gradientTransform` attribute
gradientTransform ∷ ToStringAttribute
gradientTransform = createAttribute "gradientTransform"

-- | Sets the `gradientUnits` attribute
gradientUnits ∷ ToStringAttribute
gradientUnits = createAttribute "gradientUnits"

-- | Sets the `image-rendering` attribute
imageRendering ∷ ToStringAttribute
imageRendering = createAttribute "image-rendering"

-- | Sets the `in` attribute
in' ∷ ToStringAttribute
in' = createAttribute "in"

-- | Sets the `in2` attribute
in2 ∷ ToStringAttribute
in2 = createAttribute "in2"

-- | Sets the `kernelMatrix` attribute
kernelMatrix ∷ ToStringAttribute
kernelMatrix = createAttribute "kernelMatrix"

-- | Sets the `kernelUnitLength` attribute
kernelUnitLength ∷ ToStringAttribute
kernelUnitLength = createAttribute "kernelUnitLength"

-- | Sets the `kerning` attribute
kerning ∷ ToStringAttribute
kerning = createAttribute "kerning"

-- | Sets the `keySplines` attribute
keySplines ∷ ToStringAttribute
keySplines = createAttribute "keySplines"

-- | Sets the `keyTimes` attribute
keyTimes ∷ ToStringAttribute
keyTimes = createAttribute "keyTimes"

-- | Sets the `lengthAdjust` attribute
lengthAdjust ∷ ToStringAttribute
lengthAdjust = createAttribute "lengthAdjust"

-- | Sets the `letter-spacing` attribute
letterSpacing ∷ ToStringAttribute
letterSpacing = createAttribute "letter-spacing"

-- | Sets the `lighting-color` attribute
lightingColor ∷ ToStringAttribute
lightingColor = createAttribute "lighting-color"

-- | Sets the `local` attribute
local ∷ ToStringAttribute
local = createAttribute "local"

-- | Sets the `marker-end` attribute
markerEnd ∷ ToStringAttribute
markerEnd = createAttribute "marker-end"

-- | Sets the `marker-mid` attribute
markerMid ∷ ToStringAttribute
markerMid = createAttribute "marker-mid"

-- | Sets the `marker-start` attribute
markerStart ∷ ToStringAttribute
markerStart = createAttribute "marker-start"

-- | Sets the `markerUnits` attribute
markerUnits ∷ ToStringAttribute
markerUnits = createAttribute "markerUnits"

-- | Sets the `mask` attribute
maskAttr ∷ ToStringAttribute
maskAttr = createAttribute "mask"

-- | Sets the `maskContentUnits` attribute
maskContentUnits ∷ ToStringAttribute
maskContentUnits = createAttribute "maskContentUnits"

-- | Sets the `maskUnits` attribute
maskUnits ∷ ToStringAttribute
maskUnits = createAttribute "maskUnits"

-- | Sets the `mode` attribute
mode ∷ ToStringAttribute
mode = createAttribute "mode"

-- | Sets the `opacity` attribute
opacity ∷ ToStringAttribute
opacity = createAttribute "opacity"

-- | Sets the `operator` attribute
operator ∷ ToStringAttribute
operator = createAttribute "operator"

-- | Sets the `order` attribute
order ∷ ToStringAttribute
order = createAttribute "order"

-- | Sets the `overflow` attribute
overflow ∷ ToStringAttribute
overflow = createAttribute "overflow"

-- | Sets the `paint-order` attribute
paintOrder ∷ ToStringAttribute
paintOrder = createAttribute "paint-order"

-- | Sets the `patternContentUnits` attribute
patternContentUnits ∷ ToStringAttribute
patternContentUnits = createAttribute "patternContentUnits"

-- | Sets the `patternTransform` attribute
patternTransform ∷ ToStringAttribute
patternTransform = createAttribute "patternTransform"

-- | Sets the `patternUnits` attribute
patternUnits ∷ ToStringAttribute
patternUnits = createAttribute "patternUnits"

-- | Sets the `pointer-events` attribute
pointerEvents ∷ ToStringAttribute
pointerEvents = createAttribute "pointer-events"

-- | Sets the `points` attribute
points ∷ ToStringAttribute
points = createAttribute "points"

-- | Sets the `preserveAspectRatio` attribute
preserveAspectRatio ∷ ToStringAttribute
preserveAspectRatio = createAttribute "preserveAspectRatio"

-- | Sets the `primitiveUnits` attribute
primitiveUnits ∷ ToStringAttribute
primitiveUnits = createAttribute "primitiveUnits"

-- | Sets the `radius` attribute
radius ∷ ToStringAttribute
radius = createAttribute "radius"

-- | Sets the `repeatCount` attribute
repeatCount ∷ ToStringAttribute
repeatCount = createAttribute "repeatCount"

-- | Sets the `repeatDur` attribute
repeatDur ∷ ToStringAttribute
repeatDur = createAttribute "repeatDur"

-- | Sets the `requiredFeatures` attribute
requiredFeatures ∷ ToStringAttribute
requiredFeatures = createAttribute "requiredFeatures"

-- | Sets the `restart` attribute
restart ∷ ToStringAttribute
restart = createAttribute "restart"

-- | Sets the `result` attribute
result ∷ ToStringAttribute
result = createAttribute "result"

-- | Sets the `rx` attribute
rx ∷ ToStringAttribute
rx = createAttribute "rx"

-- | Sets the `ry` attribute
ry ∷ ToStringAttribute
ry = createAttribute "ry"

-- | Sets the `shape-rendering` attribute
shapeRendering ∷ ToStringAttribute
shapeRendering = createAttribute "shape-rendering"

-- | Sets the `stdDeviation` attribute
stdDeviation ∷ ToStringAttribute
stdDeviation = createAttribute "stdDeviation"

-- | Sets the `stitchTiles` attribute
stitchTiles ∷ ToStringAttribute
stitchTiles = createAttribute "stitchTiles"

-- | Sets the `stop-color` attribute
stopColor ∷ ToStringAttribute
stopColor = createAttribute "stop-color"

-- | Sets the `stop-opacity` attribute
stopOpacity ∷ ToStringAttribute
stopOpacity = createAttribute "stop-opacity"

-- | Sets the `stroke` attribute
stroke ∷ ToStringAttribute
stroke = createAttribute "stroke"

-- | Sets the `stroke-dasharray` attribute
strokeDasharray ∷ ToStringAttribute
strokeDasharray = createAttribute "stroke-dasharray"

-- | Sets the `stroke-linecap` attribute
strokeLinecap ∷ ToStringAttribute
strokeLinecap = createAttribute "stroke-linecap"

-- | Sets the `stroke-linejoin` attribute
strokeLinejoin ∷ ToStringAttribute
strokeLinejoin = createAttribute "stroke-linejoin"

-- | Sets the `style` attribute
styleAttr ∷ ToStringAttribute
styleAttr = createAttribute "style"

-- | Sets the `text-anchor` attribute
textAnchor ∷ ToStringAttribute
textAnchor = createAttribute "text-anchor"

-- | Sets the `text-decoration` attribute
textDecoration ∷ ToStringAttribute
textDecoration = createAttribute "text-decoration"

-- | Sets the `text-rendering` attribute
textRendering ∷ ToStringAttribute
textRendering = createAttribute "text-rendering"

-- | Sets the `transform` attribute
transform ∷ ToStringAttribute
transform = createAttribute "transform"

-- | Sets the `values` attribute
values ∷ ToStringAttribute
values = createAttribute "values"

-- | Sets the `vector-effect` attribute
vectorEffect ∷ ToStringAttribute
vectorEffect = createAttribute "vector-effect"

-- | Sets the `viewBox` attribute
viewBox ∷ ToStringAttribute
viewBox = createAttribute "viewBox"

-- | Sets the `visibility` attribute
visibility ∷ ToStringAttribute
visibility = createAttribute "visibility"

-- | Sets the `word-spacing` attribute
wordSpacing ∷ ToStringAttribute
wordSpacing = createAttribute "word-spacing"

-- | Sets the `writing-mode` attribute
writingMode ∷ ToStringAttribute
writingMode = createAttribute "writing-mode"

-- | Sets the `xChannelSelector` attribute
xChannelSelector ∷ ToStringAttribute
xChannelSelector = createAttribute "xChannelSelector"

-- | Sets the `yChannelSelector` attribute
yChannelSelector ∷ ToStringAttribute
yChannelSelector = createAttribute "yChannelSelector"

-- | Sets the `accent-height` attribute
accentHeight ∷ ToNumberAttribute
accentHeight = createAttribute "accent-height" <<< show

-- | Sets the `ascent` attribute
ascent ∷ ToNumberAttribute
ascent = createAttribute "ascent" <<< show

-- | Sets the `azimuth` attribute
azimuth ∷ ToNumberAttribute
azimuth = createAttribute "azimuth" <<< show

-- | Sets the `bias` attribute
bias ∷ ToNumberAttribute
bias = createAttribute "bias" <<< show

-- | Sets the `diffuseConstant` attribute
diffuseConstant ∷ ToNumberAttribute
diffuseConstant = createAttribute "diffuseConstant" <<< show

-- | Sets the `divisor` attribute
divisor ∷ ToNumberAttribute
divisor = createAttribute "divisor" <<< show

-- | Sets the `elevation` attribute
elevation ∷ ToNumberAttribute
elevation = createAttribute "elevation" <<< show

-- | Sets the `fr` attribute
fr ∷ ToNumberAttribute
fr = createAttribute "fr" <<< show

-- | Sets the `k1` attribute
k1 ∷ ToNumberAttribute
k1 = createAttribute "k1" <<< show

-- | Sets the `k2` attribute
k2 ∷ ToNumberAttribute
k2 = createAttribute "k2" <<< show

-- | Sets the `k3` attribute
k3 ∷ ToNumberAttribute
k3 = createAttribute "k3" <<< show

-- | Sets the `k4` attribute
k4 ∷ ToNumberAttribute
k4 = createAttribute "k4" <<< show

-- | Sets the `limitingConeAngle` attribute
limitingConeAngle ∷ ToNumberAttribute
limitingConeAngle = createAttribute "limitingConeAngle" <<< show

-- | Sets the `overline-position` attribute
overlinePosition ∷ ToNumberAttribute
overlinePosition = createAttribute "overline-position" <<< show

-- | Sets the `overline-thickness` attribute
overlineThickness ∷ ToNumberAttribute
overlineThickness = createAttribute "overline-thickness" <<< show

-- | Sets the `pathLength` attribute
pathLength ∷ ToNumberAttribute
pathLength = createAttribute "pathLength" <<< show

-- | Sets the `pointsAtX` attribute
pointsAtX ∷ ToNumberAttribute
pointsAtX = createAttribute "pointsAtX" <<< show

-- | Sets the `pointsAtY` attribute
pointsAtY ∷ ToNumberAttribute
pointsAtY = createAttribute "pointsAtY" <<< show

-- | Sets the `pointsAtZ` attribute
pointsAtZ ∷ ToNumberAttribute
pointsAtZ = createAttribute "pointsAtZ" <<< show

-- | Sets the `refX` attribute
refX ∷ ToNumberAttribute
refX = createAttribute "refX" <<< show

-- | Sets the `refY` attribute
refY ∷ ToNumberAttribute
refY = createAttribute "refY" <<< show

-- | Sets the `scale` attribute
scale ∷ ToNumberAttribute
scale = createAttribute "scale" <<< show

-- | Sets the `seed` attribute
seed ∷ ToNumberAttribute
seed = createAttribute "seed" <<< show

-- | Sets the `specularConstant` attribute
specularConstant ∷ ToNumberAttribute
specularConstant = createAttribute "specularConstant" <<< show

-- | Sets the `specularExponent` attribute
specularExponent ∷ ToNumberAttribute
specularExponent = createAttribute "specularExponent" <<< show

-- | Sets the `strikethrough-position` attribute
strikethroughPosition ∷ ToNumberAttribute
strikethroughPosition = createAttribute "strikethrough-position" <<< show

-- | Sets the `strikethrough-thickness` attribute
strikethroughThickness ∷ ToNumberAttribute
strikethroughThickness = createAttribute "strikethrough-thickness" <<< show

-- | Sets the `stroke-miterlimit` attribute
strokeMiterlimit ∷ ToNumberAttribute
strokeMiterlimit = createAttribute "stroke-miterlimit" <<< show

-- | Sets the `surfaceScale` attribute
surfaceScale ∷ ToNumberAttribute
surfaceScale = createAttribute "surfaceScale" <<< show

-- | Sets the `targetX` attribute
targetX ∷ ToNumberAttribute
targetX = createAttribute "targetX" <<< show

-- | Sets the `targetY` attribute
targetY ∷ ToNumberAttribute
targetY = createAttribute "targetY" <<< show

-- | Sets the `underline-position` attribute
underlinePosition ∷ ToNumberAttribute
underlinePosition = createAttribute "underline-position" <<< show

-- | Sets the `underline-thickness` attribute
underlineThickness ∷ ToNumberAttribute
underlineThickness = createAttribute "underline-thickness" <<< show

-- | Sets the `version` attribute
version ∷ ToNumberAttribute
version = createAttribute "version" <<< show

-- | Sets the `numOctaves` attribute
numOctaves ∷ ToIntAttribute
numOctaves = createAttribute "numOctaves" <<< show

-- | Sets the `autocomplete` property
autocomplete ∷ ToStringAttribute
autocomplete = createProperty "autocomplete"

-- | Sets the `autofocus` property
autofocus ∷ ToBooleanAttribute
autofocus = createProperty "autofocus" <<< booleanToFalsyString

-- | Sets the `autoplay` property
autoplay ∷ ToBooleanAttribute
autoplay = createProperty "autoplay" <<< booleanToFalsyString

-- | Sets the `checked` property
checked ∷ ToBooleanAttribute
checked = createProperty "checked" <<< booleanToFalsyString

-- | Sets the `contentEditable` property
contentEditable ∷ ToBooleanAttribute
contentEditable = createProperty "contentEditable" <<< booleanToString

-- | Sets the `controls` property
controls ∷ ToBooleanAttribute
controls = createProperty "controls" <<< booleanToFalsyString

-- | Sets the `default` property
default ∷ ToBooleanAttribute
default = createProperty "default" <<< booleanToFalsyString

-- | Sets the `disabled` property
disabled ∷ ToBooleanAttribute
disabled = createProperty "disabled" <<< booleanToFalsyString

-- | Sets the `hidden` property
hidden ∷ ToBooleanAttribute
hidden = createProperty "hidden" <<< booleanToFalsyString

-- | Sets the `isMap` property
isMap ∷ ToBooleanAttribute
isMap = createProperty "isMap" <<< booleanToFalsyString

-- | Sets the `loop` property
loop ∷ ToBooleanAttribute
loop = createProperty "loop" <<< booleanToFalsyString

-- | Sets the `multiple` property
multiple ∷ ToBooleanAttribute
multiple = createProperty "multiple" <<< booleanToFalsyString

-- | Sets the `noValidate` property
noValidate ∷ ToBooleanAttribute
noValidate = createProperty "noValidate" <<< booleanToFalsyString

-- | Sets the `readOnly` property
readOnly ∷ ToBooleanAttribute
readOnly = createProperty "readOnly" <<< booleanToFalsyString

-- | Sets the `required` property
required ∷ ToBooleanAttribute
required = createProperty "required" <<< booleanToFalsyString

-- | Sets the `reversed` property
reversed ∷ ToBooleanAttribute
reversed = createProperty "reversed" <<< booleanToFalsyString

-- | Sets the `selected` property
selected ∷ ToBooleanAttribute
selected = createProperty "selected" <<< booleanToFalsyString

-- | Sets the `spellcheck` property
spellcheck ∷ ToBooleanAttribute
spellcheck = createProperty "spellcheck" <<< booleanToFalsyString

-- | Sets the `externalResourcesRequired` attribute
externalResourcesRequired ∷ ToBooleanAttribute
externalResourcesRequired = createAttribute "externalResourcesRequired" <<< booleanToString

-- | Sets the `preserveAlpha` attribute
preserveAlpha ∷ ToBooleanAttribute
preserveAlpha = createAttribute "preserveAlpha" <<< booleanToString
