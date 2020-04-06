-- | Definition of HTML attributes
module Flame.HTML.Attribute.Internal where

import Data.Array as DA
import Data.Either as DE
import Data.Maybe as DM
import Data.String as DS
import Data.String.Regex as DSR
import Data.String.Regex.Flags (global)
import Flame.Types (NodeData(..), ToNodeData)
import Foreign.Object as FO
import Partial.Unsafe (unsafePartial)
import Prelude (const, flip, identity, otherwise, show, ($), (<<<), (<>), (==))
import Type.Row.Homogeneous (class Homogeneous)

type ToStringAttribute = ToNodeData String

type ToIntAttribute = ToNodeData Int

type ToBooleanProperty = ToNodeData Boolean

type ToNumberAttribute = ToNodeData Number

-- | Enables either strings or records be used as an argument to `class'`
class ToClassList a where
         to :: a -> String

instance stringClassList :: ToClassList String where
        to = identity

instance recordClassList :: Homogeneous r Boolean => ToClassList { | r } where
        to = DS.joinWith " " <<< FO.keys <<< FO.filterWithKey (flip const) <<< FO.fromHomogeneous

-- the distinction between property, attribute and boolean attributes is a mess imposed by snabbdom

-- | Sets a DOM property
createProperty :: forall message. String -> String -> NodeData message
createProperty = Property

-- | Creates a HTML attribute
createAttribute :: forall message. String -> String -> NodeData message
createAttribute = Attribute

booleanToFalsyString :: Boolean -> String
booleanToFalsyString =
        case _ of
                true -> "true"
                false -> ""

class' :: forall a b. ToClassList b => b -> NodeData a
class' = createAttribute "class" <<< caseify <<< to

style :: forall a r. Homogeneous r String => { | r } -> NodeData a
style record = Property "style" <<< DS.joinWith ";" <<< DA.zipWith zipper (FO.keys object) $ FO.values object
        where   object = FO.fromHomogeneous record

                zipper name' value' = caseify name' <> ":" <> value'

-- | Transforms its input into a proper html attribute/tag name, i.e. lower case and hyphenated
caseify :: String -> String
caseify name'
        | name' == DS.toUpper name' = DS.toLower name'
        | otherwise = DS.toLower (DS.singleton head) <> hyphenated
        where   {head, tail} = unsafePartial (DM.fromJust $ DS.uncons name')

                regex = unsafePartial (DE.fromRight $ DSR.regex "[A-Z]" global)
                replacer = const <<< ("-" <> _) <<< DS.toLower

                hyphenated = DSR.replace' regex replacer tail

--script generated

id :: ToStringAttribute
id = createProperty "id"

content :: ToStringAttribute
content = createProperty "content"

accept :: ToStringAttribute
accept = createProperty "accept"

acceptCharset :: ToStringAttribute
acceptCharset = createProperty "acceptCharset"

accessKey :: ToStringAttribute
accessKey = createProperty "accessKey"

action :: ToStringAttribute
action = createProperty "action"

align :: ToStringAttribute
align = createProperty "align"

alt :: ToStringAttribute
alt = createProperty "alt"

charset :: ToStringAttribute
charset = createProperty "charset"

coords :: ToStringAttribute
coords = createProperty "coords"

dir :: ToStringAttribute
dir = createProperty "dir"

download :: ToStringAttribute
download = createProperty "download"

downloadAs :: ToStringAttribute
downloadAs = createProperty "downloadAs"

dropzone :: ToStringAttribute
dropzone = createProperty "dropzone"

enctype :: ToStringAttribute
enctype = createProperty "enctype"

for :: ToStringAttribute
for = createProperty "htmlFor"

headers :: ToStringAttribute
headers = createProperty "headers"

href :: ToStringAttribute
href = createProperty "href"

hreflang :: ToStringAttribute
hreflang = createAttribute "hreflang"

kind :: ToStringAttribute
kind = createProperty "kind"

lang :: ToStringAttribute
lang = createProperty "lang"

max :: ToStringAttribute
max = createAttribute "max"

method :: ToStringAttribute
method = createAttribute "method"

min :: ToStringAttribute
min = createAttribute "min"

name :: ToStringAttribute
name = createProperty "name"

pattern :: ToStringAttribute
pattern = createProperty "pattern"

ping :: ToStringAttribute
ping = createAttribute "ping"

placeholder :: ToStringAttribute
placeholder = createProperty "placeholder"

poster :: ToStringAttribute
poster = createProperty "poster"

preload :: ToStringAttribute
preload = createProperty "preload"

sandbox :: ToStringAttribute
sandbox = createProperty "sandbox"

scope :: ToStringAttribute
scope = createProperty "scope"

shape :: ToStringAttribute
shape = createProperty "shape"

src :: ToStringAttribute
src = createProperty "src"

srcdoc :: ToStringAttribute
srcdoc = createProperty "srcdoc"

srclang :: ToStringAttribute
srclang = createProperty "srclang"

step :: ToStringAttribute
step = createProperty "step"

target :: ToStringAttribute
target = createProperty "target"

title :: ToStringAttribute
title = createProperty "title"

type' :: ToStringAttribute
type' = createProperty "type"

useMap :: ToStringAttribute
useMap = createProperty "useMap"

value :: ToStringAttribute
value = createProperty "value"

wrap :: ToStringAttribute
wrap = createProperty "wrap"

cols :: ToIntAttribute
cols = createProperty "cols" <<< show

colspan :: ToIntAttribute
colspan = createProperty "colspan" <<< show

height :: ToIntAttribute
height = createAttribute "height" <<< show

maxlength :: ToIntAttribute
maxlength = createProperty "maxlength" <<< show

minlength :: ToIntAttribute
minlength = createProperty "minlength" <<< show

rows :: ToIntAttribute
rows = createProperty "rows" <<< show

rowspan :: ToIntAttribute
rowspan = createProperty "rowspan" <<< show

size :: ToIntAttribute
size = createProperty "size" <<< show

start :: ToIntAttribute
start = createProperty "start" <<< show

tabindex :: ToIntAttribute
tabindex = createProperty "tabindex" <<< show

width :: ToIntAttribute
width = createAttribute "width" <<< show

contextmenu :: ToStringAttribute
contextmenu = createProperty "contextmenu"

datetime :: ToStringAttribute
datetime = createProperty "datetime"

draggable :: ToStringAttribute
draggable = createProperty "draggable"

itemprop :: ToStringAttribute
itemprop = createProperty "itemprop"

list :: ToStringAttribute
list = createProperty "list"

manifest :: ToStringAttribute
manifest = createProperty "manifest"

media :: ToStringAttribute
media = createAttribute "media"

pubdate :: ToStringAttribute
pubdate = createProperty "pubdate"

rel :: ToStringAttribute
rel = createProperty "rel"

cx :: ToStringAttribute
cx = createAttribute "cx"

cy :: ToStringAttribute
cy = createAttribute "cy"

fillOpacity :: ToStringAttribute
fillOpacity = createProperty "fill-opacity"

fx :: ToStringAttribute
fx = createAttribute "fx"

fy :: ToStringAttribute
fy = createAttribute "fy"

markerHeight :: ToStringAttribute
markerHeight = createAttribute "markerHeight"

markerWidth :: ToStringAttribute
markerWidth = createAttribute "markerWidth"

r :: ToStringAttribute
r = createAttribute "r"

strokeDashoffset :: ToStringAttribute
strokeDashoffset = createAttribute "stroke-dashoffset"

strokeOpacity :: ToStringAttribute
strokeOpacity = createAttribute "stroke-opacity"

strokeWidth :: ToStringAttribute
strokeWidth = createAttribute "stroke-width"

textLength :: ToStringAttribute
textLength = createAttribute "textLength"

x :: ToStringAttribute
x = createAttribute "x"

x1 :: ToStringAttribute
x1 = createAttribute "x1"

x2 :: ToStringAttribute
x2 = createAttribute "x2"

y :: ToStringAttribute
y = createAttribute "y"

y1 :: ToStringAttribute
y1 = createAttribute "y1"

y2 :: ToStringAttribute
y2 = createAttribute "y2"

accumulate :: ToStringAttribute
accumulate = createAttribute "accumulate"

additive :: ToStringAttribute
additive = createAttribute "additive"

alignmentBaseline :: ToStringAttribute
alignmentBaseline = createAttribute "alignment-baseline"

createAttributeName :: ToStringAttribute
createAttributeName = createAttribute "createAttributeName"

createAttributeType :: ToStringAttribute
createAttributeType = createAttribute "createAttributeType"

baseFrequency :: ToStringAttribute
baseFrequency = createAttribute "baseFrequency"

baselineShift :: ToStringAttribute
baselineShift = createAttribute "baseline-shift"

baseProfile :: ToStringAttribute
baseProfile = createAttribute "baseProfile"

begin :: ToStringAttribute
begin = createAttribute "begin"

calcMode :: ToStringAttribute
calcMode = createAttribute "calcMode"

clipPathUnits :: ToStringAttribute
clipPathUnits = createAttribute "clipPathUnits"

clipPathAttr :: ToStringAttribute
clipPathAttr = createAttribute "clip-path"

clipRule :: ToStringAttribute
clipRule = createAttribute "clip-rule"

color :: ToStringAttribute
color = createAttribute "color"

colorInterpolation :: ToStringAttribute
colorInterpolation = createAttribute "color-interpolation"

colorInterpolationFilters :: ToStringAttribute
colorInterpolationFilters = createAttribute "color-interpolation-filters"

colorProfileAttr :: ToStringAttribute
colorProfileAttr = createAttribute "color-profile"

colorRendering :: ToStringAttribute
colorRendering = createAttribute "color-rendering"

contentScriptType :: ToStringAttribute
contentScriptType = createAttribute "contentScriptType"

contentStyleType :: ToStringAttribute
contentStyleType = createAttribute "contentStyleType"

cursorAttr :: ToStringAttribute
cursorAttr = createAttribute "cursor"

d :: ToStringAttribute
d = createAttribute "d"

direction :: ToStringAttribute
direction = createAttribute "direction"

display :: ToStringAttribute
display = createAttribute "display"

dominantBaseline :: ToStringAttribute
dominantBaseline = createAttribute "dominant-baseline"

dur :: ToStringAttribute
dur = createAttribute "dur"

dx :: ToStringAttribute
dx = createAttribute "dx"

dy :: ToStringAttribute
dy = createAttribute "dy"

edgeMode :: ToStringAttribute
edgeMode = createAttribute "edgeMode"

end :: ToStringAttribute
end = createAttribute "end"

fill :: ToStringAttribute
fill = createAttribute "fill"

fillRule :: ToStringAttribute
fillRule = createAttribute "fill-rule"

filterAttr :: ToStringAttribute
filterAttr = createAttribute "filter"

filterUnits :: ToStringAttribute
filterUnits = createAttribute "filterUnits"

floodColor :: ToStringAttribute
floodColor = createAttribute "flood-color"

floodOpacity :: ToStringAttribute
floodOpacity = createAttribute "flood-opacity"

fontFamily :: ToStringAttribute
fontFamily = createAttribute "font-family"

fontSize :: ToStringAttribute
fontSize = createAttribute "font-size"

fontSizeAdjust :: ToStringAttribute
fontSizeAdjust = createAttribute "font-size-adjust"

fontStretch :: ToStringAttribute
fontStretch = createAttribute "font-stretch"

fontStyle :: ToStringAttribute
fontStyle = createAttribute "font-style"

fontVariant :: ToStringAttribute
fontVariant = createAttribute "font-variant"

fontWeight :: ToStringAttribute
fontWeight = createAttribute "font-weight"

from :: ToStringAttribute
from = createAttribute "from"

gradientTransform :: ToStringAttribute
gradientTransform = createAttribute "gradientTransform"

gradientUnits :: ToStringAttribute
gradientUnits = createAttribute "gradientUnits"

imageRendering :: ToStringAttribute
imageRendering = createAttribute "image-rendering"

in' :: ToStringAttribute
in' = createAttribute "in"

in2 :: ToStringAttribute
in2 = createAttribute "in2"

kernelMatrix :: ToStringAttribute
kernelMatrix = createAttribute "kernelMatrix"

kernelUnitLength :: ToStringAttribute
kernelUnitLength = createAttribute "kernelUnitLength"

kerning :: ToStringAttribute
kerning = createAttribute "kerning"

keySplines :: ToStringAttribute
keySplines = createAttribute "keySplines"

keyTimes :: ToStringAttribute
keyTimes = createAttribute "keyTimes"

lengthAdjust :: ToStringAttribute
lengthAdjust = createAttribute "lengthAdjust"

letterSpacing :: ToStringAttribute
letterSpacing = createAttribute "letter-spacing"

lightingColor :: ToStringAttribute
lightingColor = createAttribute "lighting-color"

local :: ToStringAttribute
local = createAttribute "local"

markerEnd :: ToStringAttribute
markerEnd = createAttribute "marker-end"

markerMid :: ToStringAttribute
markerMid = createAttribute "marker-mid"

markerStart :: ToStringAttribute
markerStart = createAttribute "marker-start"

markerUnits :: ToStringAttribute
markerUnits = createAttribute "markerUnits"

maskAttr :: ToStringAttribute
maskAttr = createAttribute "mask"

maskContentUnits :: ToStringAttribute
maskContentUnits = createAttribute "maskContentUnits"

maskUnits :: ToStringAttribute
maskUnits = createAttribute "maskUnits"

mode :: ToStringAttribute
mode = createAttribute "mode"

opacity :: ToStringAttribute
opacity = createAttribute "opacity"

operator :: ToStringAttribute
operator = createAttribute "operator"

order :: ToStringAttribute
order = createAttribute "order"

overflow :: ToStringAttribute
overflow = createAttribute "overflow"

paintOrder :: ToStringAttribute
paintOrder = createAttribute "paint-order"

patternContentUnits :: ToStringAttribute
patternContentUnits = createAttribute "patternContentUnits"

patternTransform :: ToStringAttribute
patternTransform = createAttribute "patternTransform"

patternUnits :: ToStringAttribute
patternUnits = createAttribute "patternUnits"

pointerEvents :: ToStringAttribute
pointerEvents = createAttribute "pointer-events"

points :: ToStringAttribute
points = createAttribute "points"

preserveAspectRatio :: ToStringAttribute
preserveAspectRatio = createAttribute "preserveAspectRatio"

primitiveUnits :: ToStringAttribute
primitiveUnits = createAttribute "primitiveUnits"

radius :: ToStringAttribute
radius = createAttribute "radius"

repeatCount :: ToStringAttribute
repeatCount = createAttribute "repeatCount"

repeatDur :: ToStringAttribute
repeatDur = createAttribute "repeatDur"

requiredFeatures :: ToStringAttribute
requiredFeatures = createAttribute "requiredFeatures"

restart :: ToStringAttribute
restart = createAttribute "restart"

result :: ToStringAttribute
result = createAttribute "result"

rx :: ToStringAttribute
rx = createAttribute "rx"

ry :: ToStringAttribute
ry = createAttribute "ry"

shapeRendering :: ToStringAttribute
shapeRendering = createAttribute "shape-rendering"

stdDeviation :: ToStringAttribute
stdDeviation = createAttribute "stdDeviation"

stitchTiles :: ToStringAttribute
stitchTiles = createAttribute "stitchTiles"

stopColor :: ToStringAttribute
stopColor = createAttribute "stop-color"

stopOpacity :: ToStringAttribute
stopOpacity = createAttribute "stop-opacity"

stroke :: ToStringAttribute
stroke = createAttribute "stroke"

strokeDasharray :: ToStringAttribute
strokeDasharray = createAttribute "stroke-dasharray"

strokeLinecap :: ToStringAttribute
strokeLinecap = createAttribute "stroke-linecap"

strokeLinejoin :: ToStringAttribute
strokeLinejoin = createAttribute "stroke-linejoin"

styleAttr :: ToStringAttribute
styleAttr = createProperty "style"

textAnchor :: ToStringAttribute
textAnchor = createAttribute "text-anchor"

textDecoration :: ToStringAttribute
textDecoration = createAttribute "text-decoration"

textRendering :: ToStringAttribute
textRendering = createAttribute "text-rendering"

transform :: ToStringAttribute
transform = createAttribute "transform"

values :: ToStringAttribute
values = createAttribute "values"

vectorEffect :: ToStringAttribute
vectorEffect = createAttribute "vector-effect"

viewBox :: ToStringAttribute
viewBox = createAttribute "viewBox"

visibility :: ToStringAttribute
visibility = createAttribute "visibility"

wordSpacing :: ToStringAttribute
wordSpacing = createAttribute "word-spacing"

writingMode :: ToStringAttribute
writingMode = createAttribute "writing-mode"

xChannelSelector :: ToStringAttribute
xChannelSelector = createAttribute "xChannelSelector"

yChannelSelector :: ToStringAttribute
yChannelSelector = createAttribute "yChannelSelector"

accentHeight :: ToNumberAttribute
accentHeight = createAttribute "accent-height" <<< show

ascent :: ToNumberAttribute
ascent = createAttribute "ascent" <<< show

azimuth :: ToNumberAttribute
azimuth = createAttribute "azimuth" <<< show

bias :: ToNumberAttribute
bias = createAttribute "bias" <<< show

diffuseConstant :: ToNumberAttribute
diffuseConstant = createProperty "diffuseConstant" <<< show

divisor :: ToNumberAttribute
divisor = createAttribute "divisor" <<< show

elevation :: ToNumberAttribute
elevation = createProperty "elevation" <<< show

fr :: ToNumberAttribute
fr = createAttribute "fr" <<< show

k1 :: ToNumberAttribute
k1 = createAttribute "k1" <<< show

k2 :: ToNumberAttribute
k2 = createAttribute "k2" <<< show

k3 :: ToNumberAttribute
k3 = createAttribute "k3" <<< show

k4 :: ToNumberAttribute
k4 = createAttribute "k4" <<< show

limitingConeAngle :: ToNumberAttribute
limitingConeAngle = createAttribute "limitingConeAngle" <<< show

overlinePosition :: ToNumberAttribute
overlinePosition = createAttribute "overline-position" <<< show

overlineThickness :: ToNumberAttribute
overlineThickness = createAttribute "overline-thickness" <<< show

pathLength :: ToNumberAttribute
pathLength = createAttribute "pathLength" <<< show

pointsAtX :: ToNumberAttribute
pointsAtX = createAttribute "pointsAtX" <<< show

pointsAtY :: ToNumberAttribute
pointsAtY = createAttribute "pointsAtY" <<< show

pointsAtZ :: ToNumberAttribute
pointsAtZ = createAttribute "pointsAtZ" <<< show

refX :: ToNumberAttribute
refX = createAttribute "refX" <<< show

refY :: ToNumberAttribute
refY = createAttribute "refY" <<< show

scale :: ToNumberAttribute
scale = createAttribute "scale" <<< show

seed :: ToNumberAttribute
seed = createAttribute "seed" <<< show

specularConstant :: ToNumberAttribute
specularConstant = createAttribute "specularConstant" <<< show

specularExponent :: ToNumberAttribute
specularExponent = createAttribute "specularExponent" <<< show

strikethroughPosition :: ToNumberAttribute
strikethroughPosition = createAttribute "strikethrough-position" <<< show

strikethroughThickness :: ToNumberAttribute
strikethroughThickness = createAttribute "strikethrough-thickness" <<< show

strokeMiterlimit :: ToNumberAttribute
strokeMiterlimit = createAttribute "stroke-miterlimit" <<< show

surfaceScale :: ToNumberAttribute
surfaceScale = createAttribute "surfaceScale" <<< show

targetX :: ToNumberAttribute
targetX = createAttribute "targetX" <<< show

targetY :: ToNumberAttribute
targetY = createAttribute "targetY" <<< show

underlinePosition :: ToNumberAttribute
underlinePosition = createAttribute "underline-position" <<< show

underlineThickness :: ToNumberAttribute
underlineThickness = createAttribute "underline-thickness" <<< show

version :: ToNumberAttribute
version = createAttribute "version" <<< show

numOctaves :: ToIntAttribute
numOctaves = createAttribute "numOctaves" <<< show

autocomplete :: ToBooleanProperty
autocomplete = createProperty "autocomplete" <<< booleanToFalsyString

autofocus :: ToBooleanProperty
autofocus = createProperty "autofocus" <<< booleanToFalsyString

autoplay :: ToBooleanProperty
autoplay = createProperty "autoplay" <<< booleanToFalsyString

checked :: ToBooleanProperty
checked = createProperty "checked" <<< booleanToFalsyString

contentEditable :: ToBooleanProperty
contentEditable = createProperty "contentEditable" <<< booleanToFalsyString

controls :: ToBooleanProperty
controls = createProperty "controls" <<< booleanToFalsyString

default :: ToBooleanProperty
default = createProperty "default" <<< booleanToFalsyString

disabled :: ToBooleanProperty
disabled = createProperty "disabled" <<< booleanToFalsyString

hidden :: ToBooleanProperty
hidden = createProperty "hidden" <<< booleanToFalsyString

isMap :: ToBooleanProperty
isMap = createProperty "isMap" <<< booleanToFalsyString

loop :: ToBooleanProperty
loop = createProperty "loop" <<< booleanToFalsyString

multiple :: ToBooleanProperty
multiple = createProperty "multiple" <<< booleanToFalsyString

noValidate :: ToBooleanProperty
noValidate = createProperty "noValidate" <<< booleanToFalsyString

readOnly :: ToBooleanProperty
readOnly = createProperty "readOnly" <<< booleanToFalsyString

required :: ToBooleanProperty
required = createProperty "required" <<< booleanToFalsyString

reversed :: ToBooleanProperty
reversed = createProperty "reversed" <<< booleanToFalsyString

selected :: ToBooleanProperty
selected = createProperty "selected" <<< booleanToFalsyString

spellcheck :: ToBooleanProperty
spellcheck = createProperty "spellcheck" <<< booleanToFalsyString

externalResourcesRequired :: ToBooleanProperty
externalResourcesRequired = createProperty "externalResourcesRequired" <<< booleanToFalsyString

preserveAlpha :: ToBooleanProperty
preserveAlpha = createProperty "preserveAlpha" <<< booleanToFalsyString