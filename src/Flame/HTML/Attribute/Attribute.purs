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
import Flame.Types (NodeData(..), ToNodeData)

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
class' = createAttribute "class" <<< caseify <<< to

style :: forall a r. Homogeneous r String => { | r } -> NodeData a
style record = Attribute "style" <<< DS.joinWith ";" <<< DA.zipWith zipper (FO.keys object) $ FO.values object
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
createAttribute = Attribute

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
hreflang = createAttribute "hreflang"

kind :: ToStringAttribute
kind = createAttribute "kind"

lang :: ToStringAttribute
lang = createAttribute "lang"

max :: ToStringAttribute
max = createAttribute "max"

method :: ToStringAttribute
method = createAttribute "method"

min :: ToStringAttribute
min = createAttribute "min"

name :: ToStringAttribute
name = createAttribute "name"

pattern :: ToStringAttribute
pattern = createAttribute "pattern"

ping :: ToStringAttribute
ping = createAttribute "ping"

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
height = createAttribute "height" <<< show

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
width = createAttribute "width" <<< show

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
media = createAttribute "media"

pubdate :: ToStringAttribute
pubdate = createAttribute "pubdate"

rel :: ToStringAttribute
rel = createAttribute "rel"

cx :: ToStringAttribute
cx = createAttribute "cx"

cy :: ToStringAttribute
cy = createAttribute "cy"

fillOpacity :: ToStringAttribute
fillOpacity = createAttribute "fill-opacity"

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
styleAttr = createAttribute "style"

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
diffuseConstant = createAttribute "diffuseConstant" <<< show

divisor :: ToNumberAttribute
divisor = createAttribute "divisor" <<< show

elevation :: ToNumberAttribute
elevation = createAttribute "elevation" <<< show

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