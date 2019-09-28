-- | Definition of HTML attributes
module Flame.HTML.Attribute.Internal where

import Prelude (const, flip, identity, otherwise, show, ($), (<<<), (<>), (==))

import Data.Array as DA
import Data.Either as DE
import Data.Maybe as DM
import Data.String as DS
import Data.String.Regex as DSR
import Data.String.Regex.Flags (global)
import Foreign.Object as FO
import Partial.Unsafe (unsafePartial)
import Type.Row.Homogeneous (class Homogeneous)
import Flame.Types (NodeData(..), ToNodeData, SetTo(..))

type ToStringAttribute = ToNodeData String

type ToIntAttribute = ToNodeData Int

type ToNumberAttribute = ToNodeData Number

-- | Enables either strings or records be used as an argument to `class'`
class ToClassList a where
         to :: a -> String

instance stringClassList :: ToClassList String where
        to = identity

instance recordClassList :: Homogeneous r Boolean => ToClassList { | r } where
        to = DS.joinWith " " <<< FO.keys <<< FO.filterWithKey (flip const) <<< FO.fromHomogeneous

class' :: forall a b. ToClassList b => b -> NodeData a
class' = createSetAttribute "class" <<< caseify <<< to

style :: forall a r. Homogeneous r String => { | r } -> NodeData a
style record = Attribute Props "style" <<< DS.joinWith ";" <<< DA.zipWith zipper (FO.keys object) $ FO.values object
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

-- | Creates a HTML attribute
-- |
-- | Attributes have name and value opposed to properties, which are presential only
createAttribute :: forall message. String -> String -> NodeData message
createAttribute = Attribute Props

-- | Creates a HTML attribute that uses setAttribute
-- |
-- | Attributes have name and value opposed to properties, which are presential only
createSetAttribute :: forall message. String -> String -> NodeData message
createSetAttribute = Attribute Attrs

--script generated

id :: ToStringAttribute
id = createAttribute "id"

content :: ToStringAttribute
content = createAttribute "content"

accept :: ToStringAttribute
accept = createAttribute "accept"

acceptCharset :: ToStringAttribute
acceptCharset = createAttribute "acceptCharset"

accessKey :: ToStringAttribute
accessKey = createAttribute "accessKey"

action :: ToStringAttribute
action = createAttribute "action"

align :: ToStringAttribute
align = createAttribute "align"

alt :: ToStringAttribute
alt = createAttribute "alt"

charset :: ToStringAttribute
charset = createAttribute "charset"

coords :: ToStringAttribute
coords = createAttribute "coords"

dir :: ToStringAttribute
dir = createAttribute "dir"

download :: ToStringAttribute
download = createAttribute "download"

downloadAs :: ToStringAttribute
downloadAs = createAttribute "downloadAs"

dropzone :: ToStringAttribute
dropzone = createAttribute "dropzone"

enctype :: ToStringAttribute
enctype = createAttribute "enctype"

for :: ToStringAttribute
for = createAttribute "htmlFor"

headers :: ToStringAttribute
headers = createAttribute "headers"

href :: ToStringAttribute
href = createAttribute "href"

hreflang :: ToStringAttribute
hreflang = createSetAttribute "hreflang"

kind :: ToStringAttribute
kind = createAttribute "kind"

lang :: ToStringAttribute
lang = createAttribute "lang"

max :: ToStringAttribute
max = createSetAttribute "max"

method :: ToStringAttribute
method = createSetAttribute "method"

min :: ToStringAttribute
min = createSetAttribute "min"

name :: ToStringAttribute
name = createAttribute "name"

pattern :: ToStringAttribute
pattern = createAttribute "pattern"

ping :: ToStringAttribute
ping = createSetAttribute "ping"

placeholder :: ToStringAttribute
placeholder = createAttribute "placeholder"

poster :: ToStringAttribute
poster = createAttribute "poster"

preload :: ToStringAttribute
preload = createAttribute "preload"

sandbox :: ToStringAttribute
sandbox = createAttribute "sandbox"

scope :: ToStringAttribute
scope = createAttribute "scope"

shape :: ToStringAttribute
shape = createAttribute "shape"

src :: ToStringAttribute
src = createAttribute "src"

srcdoc :: ToStringAttribute
srcdoc = createAttribute "srcdoc"

srclang :: ToStringAttribute
srclang = createAttribute "srclang"

step :: ToStringAttribute
step = createAttribute "step"

target :: ToStringAttribute
target = createAttribute "target"

title :: ToStringAttribute
title = createAttribute "title"

type' :: ToStringAttribute
type' = createAttribute "type"

useMap :: ToStringAttribute
useMap = createAttribute "useMap"

value :: ToStringAttribute
value = createAttribute "value"

wrap :: ToStringAttribute
wrap = createAttribute "wrap"

cols :: ToIntAttribute
cols = createAttribute "cols" <<< show

colspan :: ToIntAttribute
colspan = createAttribute "colspan" <<< show

height :: ToIntAttribute
height = createSetAttribute "height" <<< show

maxlength :: ToIntAttribute
maxlength = createAttribute "maxlength" <<< show

minlength :: ToIntAttribute
minlength = createAttribute "minlength" <<< show

rows :: ToIntAttribute
rows = createAttribute "rows" <<< show

rowspan :: ToIntAttribute
rowspan = createAttribute "rowspan" <<< show

size :: ToIntAttribute
size = createAttribute "size" <<< show

start :: ToIntAttribute
start = createAttribute "start" <<< show

tabindex :: ToIntAttribute
tabindex = createAttribute "tabindex" <<< show

width :: ToIntAttribute
width = createSetAttribute "width" <<< show

contextmenu :: ToStringAttribute
contextmenu = createAttribute "contextmenu"

datetime :: ToStringAttribute
datetime = createAttribute "datetime"

draggable :: ToStringAttribute
draggable = createAttribute "draggable"

itemprop :: ToStringAttribute
itemprop = createAttribute "itemprop"

list :: ToStringAttribute
list = createAttribute "list"

manifest :: ToStringAttribute
manifest = createAttribute "manifest"

media :: ToStringAttribute
media = createSetAttribute "media"

pubdate :: ToStringAttribute
pubdate = createAttribute "pubdate"

rel :: ToStringAttribute
rel = createAttribute "rel"

cx :: ToStringAttribute
cx = createSetAttribute "cx"

cy :: ToStringAttribute
cy = createSetAttribute "cy"

fillOpacity :: ToStringAttribute
fillOpacity = createAttribute "fill-opacity"

fx :: ToStringAttribute
fx = createSetAttribute "fx"

fy :: ToStringAttribute
fy = createSetAttribute "fy"

markerHeight :: ToStringAttribute
markerHeight = createSetAttribute "markerHeight"

markerWidth :: ToStringAttribute
markerWidth = createSetAttribute "markerWidth"

r :: ToStringAttribute
r = createSetAttribute "r"

strokeDashoffset :: ToStringAttribute
strokeDashoffset = createSetAttribute "stroke-dashoffset"

strokeOpacity :: ToStringAttribute
strokeOpacity = createSetAttribute "stroke-opacity"

strokeWidth :: ToStringAttribute
strokeWidth = createSetAttribute "stroke-width"

textLength :: ToStringAttribute
textLength = createSetAttribute "textLength"

x :: ToStringAttribute
x = createSetAttribute "x"

x1 :: ToStringAttribute
x1 = createSetAttribute "x1"

x2 :: ToStringAttribute
x2 = createSetAttribute "x2"

y :: ToStringAttribute
y = createSetAttribute "y"

y1 :: ToStringAttribute
y1 = createSetAttribute "y1"

y2 :: ToStringAttribute
y2 = createSetAttribute "y2"

accumulate :: ToStringAttribute
accumulate = createSetAttribute "accumulate"

additive :: ToStringAttribute
additive = createSetAttribute "additive"

alignmentBaseline :: ToStringAttribute
alignmentBaseline = createSetAttribute "alignment-baseline"

createAttributeName :: ToStringAttribute
createAttributeName = createSetAttribute "createAttributeName"

createAttributeType :: ToStringAttribute
createAttributeType = createSetAttribute "createAttributeType"

baseFrequency :: ToStringAttribute
baseFrequency = createSetAttribute "baseFrequency"

baselineShift :: ToStringAttribute
baselineShift = createSetAttribute "baseline-shift"

baseProfile :: ToStringAttribute
baseProfile = createSetAttribute "baseProfile"

begin :: ToStringAttribute
begin = createSetAttribute "begin"

calcMode :: ToStringAttribute
calcMode = createSetAttribute "calcMode"

clipPathUnits :: ToStringAttribute
clipPathUnits = createSetAttribute "clipPathUnits"

clipPathAttr :: ToStringAttribute
clipPathAttr = createSetAttribute "clip-path"

clipRule :: ToStringAttribute
clipRule = createSetAttribute "clip-rule"

color :: ToStringAttribute
color = createSetAttribute "color"

colorInterpolation :: ToStringAttribute
colorInterpolation = createSetAttribute "color-interpolation"

colorInterpolationFilters :: ToStringAttribute
colorInterpolationFilters = createSetAttribute "color-interpolation-filters"

colorProfileAttr :: ToStringAttribute
colorProfileAttr = createSetAttribute "color-profile"

colorRendering :: ToStringAttribute
colorRendering = createSetAttribute "color-rendering"

contentScriptType :: ToStringAttribute
contentScriptType = createSetAttribute "contentScriptType"

contentStyleType :: ToStringAttribute
contentStyleType = createSetAttribute "contentStyleType"

cursorAttr :: ToStringAttribute
cursorAttr = createSetAttribute "cursor"

d :: ToStringAttribute
d = createSetAttribute "d"

direction :: ToStringAttribute
direction = createSetAttribute "direction"

display :: ToStringAttribute
display = createSetAttribute "display"

dominantBaseline :: ToStringAttribute
dominantBaseline = createSetAttribute "dominant-baseline"

dur :: ToStringAttribute
dur = createSetAttribute "dur"

dx :: ToStringAttribute
dx = createSetAttribute "dx"

dy :: ToStringAttribute
dy = createSetAttribute "dy"

edgeMode :: ToStringAttribute
edgeMode = createSetAttribute "edgeMode"

end :: ToStringAttribute
end = createSetAttribute "end"

fill :: ToStringAttribute
fill = createSetAttribute "fill"

fillRule :: ToStringAttribute
fillRule = createSetAttribute "fill-rule"

filterAttr :: ToStringAttribute
filterAttr = createSetAttribute "filter"

filterUnits :: ToStringAttribute
filterUnits = createSetAttribute "filterUnits"

floodColor :: ToStringAttribute
floodColor = createSetAttribute "flood-color"

floodOpacity :: ToStringAttribute
floodOpacity = createSetAttribute "flood-opacity"

fontFamily :: ToStringAttribute
fontFamily = createSetAttribute "font-family"

fontSize :: ToStringAttribute
fontSize = createSetAttribute "font-size"

fontSizeAdjust :: ToStringAttribute
fontSizeAdjust = createSetAttribute "font-size-adjust"

fontStretch :: ToStringAttribute
fontStretch = createSetAttribute "font-stretch"

fontStyle :: ToStringAttribute
fontStyle = createSetAttribute "font-style"

fontVariant :: ToStringAttribute
fontVariant = createSetAttribute "font-variant"

fontWeight :: ToStringAttribute
fontWeight = createSetAttribute "font-weight"

from :: ToStringAttribute
from = createSetAttribute "from"

gradientTransform :: ToStringAttribute
gradientTransform = createSetAttribute "gradientTransform"

gradientUnits :: ToStringAttribute
gradientUnits = createSetAttribute "gradientUnits"

imageRendering :: ToStringAttribute
imageRendering = createSetAttribute "image-rendering"

in' :: ToStringAttribute
in' = createSetAttribute "in"

in2 :: ToStringAttribute
in2 = createSetAttribute "in2"

kernelMatrix :: ToStringAttribute
kernelMatrix = createSetAttribute "kernelMatrix"

kernelUnitLength :: ToStringAttribute
kernelUnitLength = createSetAttribute "kernelUnitLength"

kerning :: ToStringAttribute
kerning = createSetAttribute "kerning"

keySplines :: ToStringAttribute
keySplines = createSetAttribute "keySplines"

keyTimes :: ToStringAttribute
keyTimes = createSetAttribute "keyTimes"

lengthAdjust :: ToStringAttribute
lengthAdjust = createSetAttribute "lengthAdjust"

letterSpacing :: ToStringAttribute
letterSpacing = createSetAttribute "letter-spacing"

lightingColor :: ToStringAttribute
lightingColor = createSetAttribute "lighting-color"

local :: ToStringAttribute
local = createSetAttribute "local"

markerEnd :: ToStringAttribute
markerEnd = createSetAttribute "marker-end"

markerMid :: ToStringAttribute
markerMid = createSetAttribute "marker-mid"

markerStart :: ToStringAttribute
markerStart = createSetAttribute "marker-start"

markerUnits :: ToStringAttribute
markerUnits = createSetAttribute "markerUnits"

maskAttr :: ToStringAttribute
maskAttr = createSetAttribute "mask"

maskContentUnits :: ToStringAttribute
maskContentUnits = createSetAttribute "maskContentUnits"

maskUnits :: ToStringAttribute
maskUnits = createSetAttribute "maskUnits"

mode :: ToStringAttribute
mode = createSetAttribute "mode"

opacity :: ToStringAttribute
opacity = createSetAttribute "opacity"

operator :: ToStringAttribute
operator = createSetAttribute "operator"

order :: ToStringAttribute
order = createSetAttribute "order"

overflow :: ToStringAttribute
overflow = createSetAttribute "overflow"

paintOrder :: ToStringAttribute
paintOrder = createSetAttribute "paint-order"

patternContentUnits :: ToStringAttribute
patternContentUnits = createSetAttribute "patternContentUnits"

patternTransform :: ToStringAttribute
patternTransform = createSetAttribute "patternTransform"

patternUnits :: ToStringAttribute
patternUnits = createSetAttribute "patternUnits"

pointerEvents :: ToStringAttribute
pointerEvents = createSetAttribute "pointer-events"

points :: ToStringAttribute
points = createSetAttribute "points"

preserveAspectRatio :: ToStringAttribute
preserveAspectRatio = createSetAttribute "preserveAspectRatio"

primitiveUnits :: ToStringAttribute
primitiveUnits = createSetAttribute "primitiveUnits"

radius :: ToStringAttribute
radius = createSetAttribute "radius"

repeatCount :: ToStringAttribute
repeatCount = createSetAttribute "repeatCount"

repeatDur :: ToStringAttribute
repeatDur = createSetAttribute "repeatDur"

requiredFeatures :: ToStringAttribute
requiredFeatures = createSetAttribute "requiredFeatures"

restart :: ToStringAttribute
restart = createSetAttribute "restart"

result :: ToStringAttribute
result = createSetAttribute "result"

rx :: ToStringAttribute
rx = createSetAttribute "rx"

ry :: ToStringAttribute
ry = createSetAttribute "ry"

shapeRendering :: ToStringAttribute
shapeRendering = createSetAttribute "shape-rendering"

stdDeviation :: ToStringAttribute
stdDeviation = createSetAttribute "stdDeviation"

stitchTiles :: ToStringAttribute
stitchTiles = createSetAttribute "stitchTiles"

stopColor :: ToStringAttribute
stopColor = createSetAttribute "stop-color"

stopOpacity :: ToStringAttribute
stopOpacity = createSetAttribute "stop-opacity"

stroke :: ToStringAttribute
stroke = createSetAttribute "stroke"

strokeDasharray :: ToStringAttribute
strokeDasharray = createSetAttribute "stroke-dasharray"

strokeLinecap :: ToStringAttribute
strokeLinecap = createSetAttribute "stroke-linecap"

strokeLinejoin :: ToStringAttribute
strokeLinejoin = createSetAttribute "stroke-linejoin"

styleAttr :: ToStringAttribute
styleAttr = createAttribute "style"

textAnchor :: ToStringAttribute
textAnchor = createSetAttribute "text-anchor"

textDecoration :: ToStringAttribute
textDecoration = createSetAttribute "text-decoration"

textRendering :: ToStringAttribute
textRendering = createSetAttribute "text-rendering"

transform :: ToStringAttribute
transform = createSetAttribute "transform"

values :: ToStringAttribute
values = createSetAttribute "values"

vectorEffect :: ToStringAttribute
vectorEffect = createSetAttribute "vector-effect"

viewBox :: ToStringAttribute
viewBox = createSetAttribute "viewBox"

visibility :: ToStringAttribute
visibility = createSetAttribute "visibility"

wordSpacing :: ToStringAttribute
wordSpacing = createSetAttribute "word-spacing"

writingMode :: ToStringAttribute
writingMode = createSetAttribute "writing-mode"

xChannelSelector :: ToStringAttribute
xChannelSelector = createSetAttribute "xChannelSelector"

yChannelSelector :: ToStringAttribute
yChannelSelector = createSetAttribute "yChannelSelector"

accentHeight :: ToNumberAttribute
accentHeight = createSetAttribute "accent-height" <<< show

ascent :: ToNumberAttribute
ascent = createSetAttribute "ascent" <<< show

azimuth :: ToNumberAttribute
azimuth = createSetAttribute "azimuth" <<< show

bias :: ToNumberAttribute
bias = createSetAttribute "bias" <<< show

diffuseConstant :: ToNumberAttribute
diffuseConstant = createAttribute "diffuseConstant" <<< show

divisor :: ToNumberAttribute
divisor = createSetAttribute "divisor" <<< show

elevation :: ToNumberAttribute
elevation = createAttribute "elevation" <<< show

fr :: ToNumberAttribute
fr = createSetAttribute "fr" <<< show

k1 :: ToNumberAttribute
k1 = createSetAttribute "k1" <<< show

k2 :: ToNumberAttribute
k2 = createSetAttribute "k2" <<< show

k3 :: ToNumberAttribute
k3 = createSetAttribute "k3" <<< show

k4 :: ToNumberAttribute
k4 = createSetAttribute "k4" <<< show

limitingConeAngle :: ToNumberAttribute
limitingConeAngle = createSetAttribute "limitingConeAngle" <<< show

overlinePosition :: ToNumberAttribute
overlinePosition = createSetAttribute "overline-position" <<< show

overlineThickness :: ToNumberAttribute
overlineThickness = createSetAttribute "overline-thickness" <<< show

pathLength :: ToNumberAttribute
pathLength = createSetAttribute "pathLength" <<< show

pointsAtX :: ToNumberAttribute
pointsAtX = createSetAttribute "pointsAtX" <<< show

pointsAtY :: ToNumberAttribute
pointsAtY = createSetAttribute "pointsAtY" <<< show

pointsAtZ :: ToNumberAttribute
pointsAtZ = createSetAttribute "pointsAtZ" <<< show

refX :: ToNumberAttribute
refX = createSetAttribute "refX" <<< show

refY :: ToNumberAttribute
refY = createSetAttribute "refY" <<< show

scale :: ToNumberAttribute
scale = createSetAttribute "scale" <<< show

seed :: ToNumberAttribute
seed = createSetAttribute "seed" <<< show

specularConstant :: ToNumberAttribute
specularConstant = createSetAttribute "specularConstant" <<< show

specularExponent :: ToNumberAttribute
specularExponent = createSetAttribute "specularExponent" <<< show

strikethroughPosition :: ToNumberAttribute
strikethroughPosition = createSetAttribute "strikethrough-position" <<< show

strikethroughThickness :: ToNumberAttribute
strikethroughThickness = createSetAttribute "strikethrough-thickness" <<< show

strokeMiterlimit :: ToNumberAttribute
strokeMiterlimit = createSetAttribute "stroke-miterlimit" <<< show

surfaceScale :: ToNumberAttribute
surfaceScale = createSetAttribute "surfaceScale" <<< show

targetX :: ToNumberAttribute
targetX = createSetAttribute "targetX" <<< show

targetY :: ToNumberAttribute
targetY = createSetAttribute "targetY" <<< show

underlinePosition :: ToNumberAttribute
underlinePosition = createSetAttribute "underline-position" <<< show

underlineThickness :: ToNumberAttribute
underlineThickness = createSetAttribute "underline-thickness" <<< show

version :: ToNumberAttribute
version = createSetAttribute "version" <<< show

numOctaves :: ToIntAttribute
numOctaves = createSetAttribute "numOctaves" <<< show