-- | Definition of HTML elements
module Flame.Html.Element where

import Prelude hiding (map)

import Data.Array as DA
import Data.Maybe (Maybe)
import Data.Maybe as DM
import Effect (Effect)
import Flame.Html.Attribute.Internal as FHAI
import Flame.Internal.Fragment as FIF
import Flame.Types (Html, Key, NodeData, Tag)
import Web.DOM (Node)

-- | `NodeRenderer` contains
-- | * `createNode` – function to create a DOM node from the given data
-- | * `updateNode` – function to update a DOM node from previous and current data
type NodeRenderer arg =
      { createNode ∷ arg → Effect Node
      , updateNode ∷ Node → arg → arg → Effect Node
      }

foreign import createElementNode ∷ ∀ message. Tag → Array (NodeData message) → Array (Html message) → Html message
foreign import createDatalessElementNode ∷ ∀ message. Tag → Array (Html message) → Html message
foreign import createSingleElementNode ∷ ∀ message. Tag → Array (NodeData message) → Html message

--separate functions as svg are special babies
foreign import createSvgNode ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
foreign import createDatalessSvgNode ∷ ∀ message. Array (Html message) → Html message
foreign import createSingleSvgNode ∷ ∀ message. Array (NodeData message) → Html message
foreign import createLazyNode ∷ ∀ message arg. Array String → (arg → Html message) → arg → Html message
foreign import createManagedNode ∷ ∀ arg message. NodeRenderer arg → Array (NodeData message) → arg → Html message
foreign import createDatalessManagedNode ∷ ∀ arg message. NodeRenderer arg → arg → Html message

--this function creates text nodes that are either standalone, or have siblings
-- single text nodes are added instead to the text property of their parents
-- | Creates a text node
foreign import text ∷ ∀ message. String → Html message

-- | Creates an element node with no attributes and no children nodes
foreign import createEmptyElement ∷ ∀ message. Tag → Html message

-- | Creates an element node with attributes and children nodes
createElement ∷ ∀ message. Tag → Array (NodeData message) → Array (Html message) → Html message
createElement tag nodeData children = createElementNode tag nodeData children

-- | Creates an element node with no attributes but children nodes
createElement_ ∷ ∀ message. Tag → Array (Html message) → Html message
createElement_ tag children = createDatalessElementNode tag children

-- | Creates an element node with attributes but no children nodes
createElement' ∷ ∀ message. Tag → Array (NodeData message) → Html message
createElement' tag nodeData = createSingleElementNode tag nodeData

-- | Creates a fragment node
-- |
-- | Fragments act as wrappers: only children nodes are rendered
fragment ∷ ∀ message. Array (Html message) → Html message
fragment children = FIF.createFragmentNode children

-- | Creates a lazy node
-- |
-- | Lazy nodes are only updated if the `arg` parameter changes (compared by reference)
lazy ∷ ∀ arg message. Maybe Key → (arg → Html message) → arg → Html message
lazy maybeKey render arg = createLazyNode (DM.maybe [] DA.singleton maybeKey) render arg

-- | Creates a node which the corresponding DOM node is created and updated from the given `arg`
managed ∷ ∀ arg message. NodeRenderer arg → Array (NodeData message) → arg → Html message
managed render nodeData arg = createManagedNode render nodeData arg

-- | Creates a node (with no attributes) which the corresponding DOM node is created and updated from the given `arg`
managed_ ∷ ∀ arg message. NodeRenderer arg → arg → Html message
managed_ render arg = createDatalessManagedNode render arg

svg ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
svg nodeData children = createSvgNode nodeData children

svg_ ∷ ∀ message. Array (Html message) → Html message
svg_ children = createDatalessSvgNode children

svg' ∷ ∀ message. Array (NodeData message) → Html message
svg' nodeData = createSingleSvgNode nodeData

hr ∷ ∀ message. Html message
hr = createEmptyElement "hr"

hr_ ∷ ∀ message. Array (Html message) → Html message
hr_ = createElement_ "hr"

hr' ∷ ∀ message. Array (NodeData message) → Html message
hr' = createElement' "hr"

br ∷ ∀ message. Html message
br = createEmptyElement "br"

br' ∷ ∀ message. Array (NodeData message) → Html message
br' = createElement' "br"

input ∷ ∀ message. Array (NodeData message) → Html message
input = createElement' "input"

input_ ∷ ∀ message. Array (Html message) → Html message
input_ = createElement_ "input"

--script generated

a ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
a = createElement "a"

a_ ∷ ∀ message. Array (Html message) → Html message
a_ = createElement_ "a"

a' ∷ ∀ message. Array (NodeData message) → Html message
a' = createElement' "a"

address ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
address = createElement "address"

address_ ∷ ∀ message. Array (Html message) → Html message
address_ = createElement_ "address"

address' ∷ ∀ message. Array (NodeData message) → Html message
address' = createElement' "address"

area ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
area = createElement "area"

area_ ∷ ∀ message. Array (Html message) → Html message
area_ = createElement_ "area"

area' ∷ ∀ message. Array (NodeData message) → Html message
area' = createElement' "area"

article ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
article = createElement "article"

article_ ∷ ∀ message. Array (Html message) → Html message
article_ = createElement_ "article"

article' ∷ ∀ message. Array (NodeData message) → Html message
article' = createElement' "article"

aside ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
aside = createElement "aside"

aside_ ∷ ∀ message. Array (Html message) → Html message
aside_ = createElement_ "aside"

aside' ∷ ∀ message. Array (NodeData message) → Html message
aside' = createElement' "aside"

audio ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
audio = createElement "audio"

audio_ ∷ ∀ message. Array (Html message) → Html message
audio_ = createElement_ "audio"

audio' ∷ ∀ message. Array (NodeData message) → Html message
audio' = createElement' "audio"

b ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
b = createElement "b"

b_ ∷ ∀ message. Array (Html message) → Html message
b_ = createElement_ "b"

b' ∷ ∀ message. Array (NodeData message) → Html message
b' = createElement' "b"

base ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
base = createElement "base"

base_ ∷ ∀ message. Array (Html message) → Html message
base_ = createElement_ "base"

base' ∷ ∀ message. Array (NodeData message) → Html message
base' = createElement' "base"

bdi ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
bdi = createElement "bdi"

bdi_ ∷ ∀ message. Array (Html message) → Html message
bdi_ = createElement_ "bdi"

bdi' ∷ ∀ message. Array (NodeData message) → Html message
bdi' = createElement' "bdi"

bdo ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
bdo = createElement "bdo"

bdo_ ∷ ∀ message. Array (Html message) → Html message
bdo_ = createElement_ "bdo"

bdo' ∷ ∀ message. Array (NodeData message) → Html message
bdo' = createElement' "bdo"

blockquote ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
blockquote = createElement "blockquote"

blockquote_ ∷ ∀ message. Array (Html message) → Html message
blockquote_ = createElement_ "blockquote"

blockquote' ∷ ∀ message. Array (NodeData message) → Html message
blockquote' = createElement' "blockquote"

body ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
body = createElement "body"

body_ ∷ ∀ message. Array (Html message) → Html message
body_ = createElement_ "body"

body' ∷ ∀ message. Array (NodeData message) → Html message
body' = createElement' "body"

button ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
button = createElement "button"

button_ ∷ ∀ message. Array (Html message) → Html message
button_ = createElement_ "button"

button' ∷ ∀ message. Array (NodeData message) → Html message
button' = createElement' "button"

canvas ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
canvas = createElement "canvas"

canvas_ ∷ ∀ message. Array (Html message) → Html message
canvas_ = createElement_ "canvas"

canvas' ∷ ∀ message. Array (NodeData message) → Html message
canvas' = createElement' "canvas"

caption ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
caption = createElement "caption"

caption_ ∷ ∀ message. Array (Html message) → Html message
caption_ = createElement_ "caption"

caption' ∷ ∀ message. Array (NodeData message) → Html message
caption' = createElement' "caption"

cite ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
cite = createElement "cite"

cite_ ∷ ∀ message. Array (Html message) → Html message
cite_ = createElement_ "cite"

cite' ∷ ∀ message. Array (NodeData message) → Html message
cite' = createElement' "cite"

code ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
code = createElement "code"

code_ ∷ ∀ message. Array (Html message) → Html message
code_ = createElement_ "code"

code' ∷ ∀ message. Array (NodeData message) → Html message
code' = createElement' "code"

col ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
col = createElement "col"

col_ ∷ ∀ message. Array (Html message) → Html message
col_ = createElement_ "col"

col' ∷ ∀ message. Array (NodeData message) → Html message
col' = createElement' "col"

colgroup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
colgroup = createElement "colgroup"

colgroup_ ∷ ∀ message. Array (Html message) → Html message
colgroup_ = createElement_ "colgroup"

colgroup' ∷ ∀ message. Array (NodeData message) → Html message
colgroup' = createElement' "colgroup"

data_ ∷ ∀ message. Array (Html message) → Html message
data_ = createElement_ "data"

data' ∷ ∀ message. Array (NodeData message) → Html message
data' = createElement' "data"

datalist ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
datalist = createElement "datalist"

datalist_ ∷ ∀ message. Array (Html message) → Html message
datalist_ = createElement_ "datalist"

datalist' ∷ ∀ message. Array (NodeData message) → Html message
datalist' = createElement' "datalist"

dd ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dd = createElement "dd"

dd_ ∷ ∀ message. Array (Html message) → Html message
dd_ = createElement_ "dd"

dd' ∷ ∀ message. Array (NodeData message) → Html message
dd' = createElement' "dd"

del ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
del = createElement "del"

del_ ∷ ∀ message. Array (Html message) → Html message
del_ = createElement_ "del"

del' ∷ ∀ message. Array (NodeData message) → Html message
del' = createElement' "del"

details ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
details = createElement "details"

details_ ∷ ∀ message. Array (Html message) → Html message
details_ = createElement_ "details"

details' ∷ ∀ message. Array (NodeData message) → Html message
details' = createElement' "details"

dfn ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dfn = createElement "dfn"

dfn_ ∷ ∀ message. Array (Html message) → Html message
dfn_ = createElement_ "dfn"

dfn' ∷ ∀ message. Array (NodeData message) → Html message
dfn' = createElement' "dfn"

dialog ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dialog = createElement "dialog"

dialog_ ∷ ∀ message. Array (Html message) → Html message
dialog_ = createElement_ "dialog"

dialog' ∷ ∀ message. Array (NodeData message) → Html message
dialog' = createElement' "dialog"

div ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
div = createElement "div"

div_ ∷ ∀ message. Array (Html message) → Html message
div_ = createElement_ "div"

div' ∷ ∀ message. Array (NodeData message) → Html message
div' = createElement' "div"

dl ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dl = createElement "dl"

dl_ ∷ ∀ message. Array (Html message) → Html message
dl_ = createElement_ "dl"

dl' ∷ ∀ message. Array (NodeData message) → Html message
dl' = createElement' "dl"

dt ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dt = createElement "dt"

dt_ ∷ ∀ message. Array (Html message) → Html message
dt_ = createElement_ "dt"

dt' ∷ ∀ message. Array (NodeData message) → Html message
dt' = createElement' "dt"

em ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
em = createElement "em"

em_ ∷ ∀ message. Array (Html message) → Html message
em_ = createElement_ "em"

em' ∷ ∀ message. Array (NodeData message) → Html message
em' = createElement' "em"

embed ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
embed = createElement "embed"

embed_ ∷ ∀ message. Array (Html message) → Html message
embed_ = createElement_ "embed"

embed' ∷ ∀ message. Array (NodeData message) → Html message
embed' = createElement' "embed"

fieldset ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fieldset = createElement "fieldset"

fieldset_ ∷ ∀ message. Array (Html message) → Html message
fieldset_ = createElement_ "fieldset"

fieldset' ∷ ∀ message. Array (NodeData message) → Html message
fieldset' = createElement' "fieldset"

figure ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
figure = createElement "figure"

figure_ ∷ ∀ message. Array (Html message) → Html message
figure_ = createElement_ "figure"

figure' ∷ ∀ message. Array (NodeData message) → Html message
figure' = createElement' "figure"

footer ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
footer = createElement "footer"

footer_ ∷ ∀ message. Array (Html message) → Html message
footer_ = createElement_ "footer"

footer' ∷ ∀ message. Array (NodeData message) → Html message
footer' = createElement' "footer"

form ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
form = createElement "form"

form_ ∷ ∀ message. Array (Html message) → Html message
form_ = createElement_ "form"

form' ∷ ∀ message. Array (NodeData message) → Html message
form' = createElement' "form"

h1 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h1 = createElement "h1"

h1_ ∷ ∀ message. Array (Html message) → Html message
h1_ = createElement_ "h1"

h1' ∷ ∀ message. Array (NodeData message) → Html message
h1' = createElement' "h1"

h2 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h2 = createElement "h2"

h2_ ∷ ∀ message. Array (Html message) → Html message
h2_ = createElement_ "h2"

h2' ∷ ∀ message. Array (NodeData message) → Html message
h2' = createElement' "h2"

h3 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h3 = createElement "h3"

h3_ ∷ ∀ message. Array (Html message) → Html message
h3_ = createElement_ "h3"

h3' ∷ ∀ message. Array (NodeData message) → Html message
h3' = createElement' "h3"

h4 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h4 = createElement "h4"

h4_ ∷ ∀ message. Array (Html message) → Html message
h4_ = createElement_ "h4"

h4' ∷ ∀ message. Array (NodeData message) → Html message
h4' = createElement' "h4"

h5 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h5 = createElement "h5"

h5_ ∷ ∀ message. Array (Html message) → Html message
h5_ = createElement_ "h5"

h5' ∷ ∀ message. Array (NodeData message) → Html message
h5' = createElement' "h5"

h6 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h6 = createElement "h6"

h6_ ∷ ∀ message. Array (Html message) → Html message
h6_ = createElement_ "h6"

h6' ∷ ∀ message. Array (NodeData message) → Html message
h6' = createElement' "h6"

head ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
head = createElement "head"

head_ ∷ ∀ message. Array (Html message) → Html message
head_ = createElement_ "head"

head' ∷ ∀ message. Array (NodeData message) → Html message
head' = createElement' "head"

header ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
header = createElement "header"

header_ ∷ ∀ message. Array (Html message) → Html message
header_ = createElement_ "header"

header' ∷ ∀ message. Array (NodeData message) → Html message
header' = createElement' "header"

hgroup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hgroup = createElement "hgroup"

hgroup_ ∷ ∀ message. Array (Html message) → Html message
hgroup_ = createElement_ "hgroup"

hgroup' ∷ ∀ message. Array (NodeData message) → Html message
hgroup' = createElement' "hgroup"

html ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
html = createElement "html"

html_ ∷ ∀ message. Array (Html message) → Html message
html_ = createElement_ "html"

html' ∷ ∀ message. Array (NodeData message) → Html message
html' = createElement' "html"

i ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
i = createElement "i"

i_ ∷ ∀ message. Array (Html message) → Html message
i_ = createElement_ "i"

i' ∷ ∀ message. Array (NodeData message) → Html message
i' = createElement' "i"

iframe ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
iframe = createElement "iframe"

iframe_ ∷ ∀ message. Array (Html message) → Html message
iframe_ = createElement_ "iframe"

iframe' ∷ ∀ message. Array (NodeData message) → Html message
iframe' = createElement' "iframe"

ins ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ins = createElement "ins"

ins_ ∷ ∀ message. Array (Html message) → Html message
ins_ = createElement_ "ins"

ins' ∷ ∀ message. Array (NodeData message) → Html message
ins' = createElement' "ins"

kbd ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
kbd = createElement "kbd"

kbd_ ∷ ∀ message. Array (Html message) → Html message
kbd_ = createElement_ "kbd"

kbd' ∷ ∀ message. Array (NodeData message) → Html message
kbd' = createElement' "kbd"

keygen ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
keygen = createElement "keygen"

keygen_ ∷ ∀ message. Array (Html message) → Html message
keygen_ = createElement_ "keygen"

keygen' ∷ ∀ message. Array (NodeData message) → Html message
keygen' = createElement' "keygen"

label ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
label = createElement "label"

label_ ∷ ∀ message. Array (Html message) → Html message
label_ = createElement_ "label"

label' ∷ ∀ message. Array (NodeData message) → Html message
label' = createElement' "label"

legend ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
legend = createElement "legend"

legend_ ∷ ∀ message. Array (Html message) → Html message
legend_ = createElement_ "legend"

legend' ∷ ∀ message. Array (NodeData message) → Html message
legend' = createElement' "legend"

li ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
li = createElement "li"

li_ ∷ ∀ message. Array (Html message) → Html message
li_ = createElement_ "li"

li' ∷ ∀ message. Array (NodeData message) → Html message
li' = createElement' "li"

link ∷ ∀ message. Array (NodeData message) → Html message
link = createElement' "link"

main ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
main = createElement "main"

main_ ∷ ∀ message. Array (Html message) → Html message
main_ = createElement_ "main"

main' ∷ ∀ message. Array (NodeData message) → Html message
main' = createElement' "main"

map ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
map = createElement "map"

map_ ∷ ∀ message. Array (Html message) → Html message
map_ = createElement_ "map"

map' ∷ ∀ message. Array (NodeData message) → Html message
map' = createElement' "map"

mark ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mark = createElement "mark"

mark_ ∷ ∀ message. Array (Html message) → Html message
mark_ = createElement_ "mark"

mark' ∷ ∀ message. Array (NodeData message) → Html message
mark' = createElement' "mark"

menu ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
menu = createElement "menu"

menu_ ∷ ∀ message. Array (Html message) → Html message
menu_ = createElement_ "menu"

menu' ∷ ∀ message. Array (NodeData message) → Html message
menu' = createElement' "menu"

menuitem ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
menuitem = createElement "menuitem"

menuitem_ ∷ ∀ message. Array (Html message) → Html message
menuitem_ = createElement_ "menuitem"

menuitem' ∷ ∀ message. Array (NodeData message) → Html message
menuitem' = createElement' "menuitem"

meta ∷ ∀ message. Array (NodeData message) → Html message
meta = createElement' "meta"

meter ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meter = createElement "meter"

meter_ ∷ ∀ message. Array (Html message) → Html message
meter_ = createElement_ "meter"

meter' ∷ ∀ message. Array (NodeData message) → Html message
meter' = createElement' "meter"

nav ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
nav = createElement "nav"

nav_ ∷ ∀ message. Array (Html message) → Html message
nav_ = createElement_ "nav"

nav' ∷ ∀ message. Array (NodeData message) → Html message
nav' = createElement' "nav"

noscript ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
noscript = createElement "noscript"

noscript_ ∷ ∀ message. Array (Html message) → Html message
noscript_ = createElement_ "noscript"

noscript' ∷ ∀ message. Array (NodeData message) → Html message
noscript' = createElement' "noscript"

object ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
object = createElement "object"

object_ ∷ ∀ message. Array (Html message) → Html message
object_ = createElement_ "object"

object' ∷ ∀ message. Array (NodeData message) → Html message
object' = createElement' "object"

ol ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ol = createElement "ol"

ol_ ∷ ∀ message. Array (Html message) → Html message
ol_ = createElement_ "ol"

ol' ∷ ∀ message. Array (NodeData message) → Html message
ol' = createElement' "ol"

img ∷ ∀ message. Array (NodeData message) → Html message
img = createElement' "img"

optgroup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
optgroup = createElement "optgroup"

optgroup_ ∷ ∀ message. Array (Html message) → Html message
optgroup_ = createElement_ "optgroup"

optgroup' ∷ ∀ message. Array (NodeData message) → Html message
optgroup' = createElement' "optgroup"

option ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
option = createElement "option"

option_ ∷ ∀ message. Array (Html message) → Html message
option_ = createElement_ "option"

option' ∷ ∀ message. Array (NodeData message) → Html message
option' = createElement' "option"

output ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
output = createElement "output"

output_ ∷ ∀ message. Array (Html message) → Html message
output_ = createElement_ "output"

output' ∷ ∀ message. Array (NodeData message) → Html message
output' = createElement' "output"

p ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
p = createElement "p"

p_ ∷ ∀ message. Array (Html message) → Html message
p_ = createElement_ "p"

p' ∷ ∀ message. Array (NodeData message) → Html message
p' = createElement' "p"

param ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
param = createElement "param"

param_ ∷ ∀ message. Array (Html message) → Html message
param_ = createElement_ "param"

param' ∷ ∀ message. Array (NodeData message) → Html message
param' = createElement' "param"

pre ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
pre = createElement "pre"

pre_ ∷ ∀ message. Array (Html message) → Html message
pre_ = createElement_ "pre"

pre' ∷ ∀ message. Array (NodeData message) → Html message
pre' = createElement' "pre"

progress ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
progress = createElement "progress"

progress_ ∷ ∀ message. Array (Html message) → Html message
progress_ = createElement_ "progress"

progress' ∷ ∀ message. Array (NodeData message) → Html message
progress' = createElement' "progress"

q ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
q = createElement "q"

q_ ∷ ∀ message. Array (Html message) → Html message
q_ = createElement_ "q"

q' ∷ ∀ message. Array (NodeData message) → Html message
q' = createElement' "q"

rb ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rb = createElement "rb"

rb_ ∷ ∀ message. Array (Html message) → Html message
rb_ = createElement_ "rb"

rb' ∷ ∀ message. Array (NodeData message) → Html message
rb' = createElement' "rb"

rp ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rp = createElement "rp"

rp_ ∷ ∀ message. Array (Html message) → Html message
rp_ = createElement_ "rp"

rp' ∷ ∀ message. Array (NodeData message) → Html message
rp' = createElement' "rp"

rt ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rt = createElement "rt"

rt_ ∷ ∀ message. Array (Html message) → Html message
rt_ = createElement_ "rt"

rt' ∷ ∀ message. Array (NodeData message) → Html message
rt' = createElement' "rt"

rtc ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rtc = createElement "rtc"

rtc_ ∷ ∀ message. Array (Html message) → Html message
rtc_ = createElement_ "rtc"

rtc' ∷ ∀ message. Array (NodeData message) → Html message
rtc' = createElement' "rtc"

ruby ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ruby = createElement "ruby"

ruby_ ∷ ∀ message. Array (Html message) → Html message
ruby_ = createElement_ "ruby"

ruby' ∷ ∀ message. Array (NodeData message) → Html message
ruby' = createElement' "ruby"

s ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
s = createElement "s"

s_ ∷ ∀ message. Array (Html message) → Html message
s_ = createElement_ "s"

s' ∷ ∀ message. Array (NodeData message) → Html message
s' = createElement' "s"

section ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
section = createElement "section"

section_ ∷ ∀ message. Array (Html message) → Html message
section_ = createElement_ "section"

section' ∷ ∀ message. Array (NodeData message) → Html message
section' = createElement' "section"

select ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
select = createElement "select"

select_ ∷ ∀ message. Array (Html message) → Html message
select_ = createElement_ "select"

select' ∷ ∀ message. Array (NodeData message) → Html message
select' = createElement' "select"

small ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
small = createElement "small"

small_ ∷ ∀ message. Array (Html message) → Html message
small_ = createElement_ "small"

small' ∷ ∀ message. Array (NodeData message) → Html message
small' = createElement' "small"

source ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
source = createElement "source"

source_ ∷ ∀ message. Array (Html message) → Html message
source_ = createElement_ "source"

source' ∷ ∀ message. Array (NodeData message) → Html message
source' = createElement' "source"

span ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
span = createElement "span"

span_ ∷ ∀ message. Array (Html message) → Html message
span_ = createElement_ "span"

span' ∷ ∀ message. Array (NodeData message) → Html message
span' = createElement' "span"

strong ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
strong = createElement "strong"

strong_ ∷ ∀ message. Array (Html message) → Html message
strong_ = createElement_ "strong"

strong' ∷ ∀ message. Array (NodeData message) → Html message
strong' = createElement' "strong"

style ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
style = createElement "style"

style_ ∷ ∀ message. Array (Html message) → Html message
style_ = createElement_ "style"

style' ∷ ∀ message. Array (NodeData message) → Html message
style' = createElement' "style"

sub ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
sub = createElement "sub"

sub_ ∷ ∀ message. Array (Html message) → Html message
sub_ = createElement_ "sub"

sub' ∷ ∀ message. Array (NodeData message) → Html message
sub' = createElement' "sub"

summary ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
summary = createElement "summary"

summary_ ∷ ∀ message. Array (Html message) → Html message
summary_ = createElement_ "summary"

summary' ∷ ∀ message. Array (NodeData message) → Html message
summary' = createElement' "summary"

sup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
sup = createElement "sup"

sup_ ∷ ∀ message. Array (Html message) → Html message
sup_ = createElement_ "sup"

sup' ∷ ∀ message. Array (NodeData message) → Html message
sup' = createElement' "sup"

table ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
table = createElement "table"

table_ ∷ ∀ message. Array (Html message) → Html message
table_ = createElement_ "table"

table' ∷ ∀ message. Array (NodeData message) → Html message
table' = createElement' "table"

tbody ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tbody = createElement "tbody"

tbody_ ∷ ∀ message. Array (Html message) → Html message
tbody_ = createElement_ "tbody"

tbody' ∷ ∀ message. Array (NodeData message) → Html message
tbody' = createElement' "tbody"

td ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
td = createElement "td"

td_ ∷ ∀ message. Array (Html message) → Html message
td_ = createElement_ "td"

td' ∷ ∀ message. Array (NodeData message) → Html message
td' = createElement' "td"

template ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
template = createElement "template"

template_ ∷ ∀ message. Array (Html message) → Html message
template_ = createElement_ "template"

template' ∷ ∀ message. Array (NodeData message) → Html message
template' = createElement' "template"

textarea ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
textarea = createElement "textarea"

textarea_ ∷ ∀ message. Array (Html message) → Html message
textarea_ = createElement_ "textarea"

textarea' ∷ ∀ message. Array (NodeData message) → Html message
textarea' = createElement' "textarea"

tfoot ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tfoot = createElement "tfoot"

tfoot_ ∷ ∀ message. Array (Html message) → Html message
tfoot_ = createElement_ "tfoot"

tfoot' ∷ ∀ message. Array (NodeData message) → Html message
tfoot' = createElement' "tfoot"

th ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
th = createElement "th"

th_ ∷ ∀ message. Array (Html message) → Html message
th_ = createElement_ "th"

th' ∷ ∀ message. Array (NodeData message) → Html message
th' = createElement' "th"

thead ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
thead = createElement "thead"

thead_ ∷ ∀ message. Array (Html message) → Html message
thead_ = createElement_ "thead"

thead' ∷ ∀ message. Array (NodeData message) → Html message
thead' = createElement' "thead"

time ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
time = createElement "time"

time_ ∷ ∀ message. Array (Html message) → Html message
time_ = createElement_ "time"

time' ∷ ∀ message. Array (NodeData message) → Html message
time' = createElement' "time"

title ∷ ∀ message. Array (Html message) → Html message
title = createElement_ "title"

tr ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tr = createElement "tr"

tr_ ∷ ∀ message. Array (Html message) → Html message
tr_ = createElement_ "tr"

tr' ∷ ∀ message. Array (NodeData message) → Html message
tr' = createElement' "tr"

track ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
track = createElement "track"

track_ ∷ ∀ message. Array (Html message) → Html message
track_ = createElement_ "track"

track' ∷ ∀ message. Array (NodeData message) → Html message
track' = createElement' "track"

u ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
u = createElement "u"

u_ ∷ ∀ message. Array (Html message) → Html message
u_ = createElement_ "u"

u' ∷ ∀ message. Array (NodeData message) → Html message
u' = createElement' "u"

ul ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ul = createElement "ul"

ul_ ∷ ∀ message. Array (Html message) → Html message
ul_ = createElement_ "ul"

ul' ∷ ∀ message. Array (NodeData message) → Html message
ul' = createElement' "ul"

var ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
var = createElement "var"

var_ ∷ ∀ message. Array (Html message) → Html message
var_ = createElement_ "var"

var' ∷ ∀ message. Array (NodeData message) → Html message
var' = createElement' "var"

video ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
video = createElement "video"

video_ ∷ ∀ message. Array (Html message) → Html message
video_ = createElement_ "video"

video' ∷ ∀ message. Array (NodeData message) → Html message
video' = createElement' "video"

wbr ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
wbr = createElement "wbr"

wbr_ ∷ ∀ message. Array (Html message) → Html message
wbr_ = createElement_ "wbr"

wbr' ∷ ∀ message. Array (NodeData message) → Html message
wbr' = createElement' "wbr"

animate ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animate = createElement "animate"

animate_ ∷ ∀ message. Array (Html message) → Html message
animate_ = createElement_ "animate"

animate' ∷ ∀ message. Array (NodeData message) → Html message
animate' = createElement' "animate"

animateColor ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animateColor = createElement "animateColor"

animateColor_ ∷ ∀ message. Array (Html message) → Html message
animateColor_ = createElement_ "animateColor"

animateColor' ∷ ∀ message. Array (NodeData message) → Html message
animateColor' = createElement' "animateColor"

animateMotion ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animateMotion = createElement "animateMotion"

animateMotion_ ∷ ∀ message. Array (Html message) → Html message
animateMotion_ = createElement_ "animateMotion"

animateMotion' ∷ ∀ message. Array (NodeData message) → Html message
animateMotion' = createElement' "animateMotion"

animateTransform ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animateTransform = createElement "animateTransform"

animateTransform_ ∷ ∀ message. Array (Html message) → Html message
animateTransform_ = createElement_ "animateTransform"

animateTransform' ∷ ∀ message. Array (NodeData message) → Html message
animateTransform' = createElement' "animateTransform"

circle ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
circle = createElement "circle"

circle_ ∷ ∀ message. Array (Html message) → Html message
circle_ = createElement_ "circle"

circle' ∷ ∀ message. Array (NodeData message) → Html message
circle' = createElement' "circle"

clipPath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
clipPath = createElement "clipPath"

clipPath_ ∷ ∀ message. Array (Html message) → Html message
clipPath_ = createElement_ "clipPath"

clipPath' ∷ ∀ message. Array (NodeData message) → Html message
clipPath' = createElement' "clipPath"

colorProfile ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
colorProfile = createElement "color-profile"

colorProfile_ ∷ ∀ message. Array (Html message) → Html message
colorProfile_ = createElement_ "color-profile"

colorProfile' ∷ ∀ message. Array (NodeData message) → Html message
colorProfile' = createElement' "color-profile"

cursor ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
cursor = createElement "cursor"

cursor_ ∷ ∀ message. Array (Html message) → Html message
cursor_ = createElement_ "cursor"

cursor' ∷ ∀ message. Array (NodeData message) → Html message
cursor' = createElement' "cursor"

defs ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
defs = createElement "defs"

defs_ ∷ ∀ message. Array (Html message) → Html message
defs_ = createElement_ "defs"

defs' ∷ ∀ message. Array (NodeData message) → Html message
defs' = createElement' "defs"

desc ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
desc = createElement "desc"

desc_ ∷ ∀ message. Array (Html message) → Html message
desc_ = createElement_ "desc"

desc' ∷ ∀ message. Array (NodeData message) → Html message
desc' = createElement' "desc"

discard ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
discard = createElement "discard"

discard_ ∷ ∀ message. Array (Html message) → Html message
discard_ = createElement_ "discard"

discard' ∷ ∀ message. Array (NodeData message) → Html message
discard' = createElement' "discard"

ellipse ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ellipse = createElement "ellipse"

ellipse_ ∷ ∀ message. Array (Html message) → Html message
ellipse_ = createElement_ "ellipse"

ellipse' ∷ ∀ message. Array (NodeData message) → Html message
ellipse' = createElement' "ellipse"

feBlend ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feBlend = createElement "feBlend"

feBlend_ ∷ ∀ message. Array (Html message) → Html message
feBlend_ = createElement_ "feBlend"

feBlend' ∷ ∀ message. Array (NodeData message) → Html message
feBlend' = createElement' "feBlend"

feColorMatrix ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feColorMatrix = createElement "feColorMatrix"

feColorMatrix_ ∷ ∀ message. Array (Html message) → Html message
feColorMatrix_ = createElement_ "feColorMatrix"

feColorMatrix' ∷ ∀ message. Array (NodeData message) → Html message
feColorMatrix' = createElement' "feColorMatrix"

feComponentTransfer ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feComponentTransfer = createElement "feComponentTransfer"

feComponentTransfer_ ∷ ∀ message. Array (Html message) → Html message
feComponentTransfer_ = createElement_ "feComponentTransfer"

feComponentTransfer' ∷ ∀ message. Array (NodeData message) → Html message
feComponentTransfer' = createElement' "feComponentTransfer"

feComposite ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feComposite = createElement "feComposite"

feComposite_ ∷ ∀ message. Array (Html message) → Html message
feComposite_ = createElement_ "feComposite"

feComposite' ∷ ∀ message. Array (NodeData message) → Html message
feComposite' = createElement' "feComposite"

feConvolveMatrix ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feConvolveMatrix = createElement "feConvolveMatrix"

feConvolveMatrix_ ∷ ∀ message. Array (Html message) → Html message
feConvolveMatrix_ = createElement_ "feConvolveMatrix"

feConvolveMatrix' ∷ ∀ message. Array (NodeData message) → Html message
feConvolveMatrix' = createElement' "feConvolveMatrix"

feDiffuseLighting ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDiffuseLighting = createElement "feDiffuseLighting"

feDiffuseLighting_ ∷ ∀ message. Array (Html message) → Html message
feDiffuseLighting_ = createElement_ "feDiffuseLighting"

feDiffuseLighting' ∷ ∀ message. Array (NodeData message) → Html message
feDiffuseLighting' = createElement' "feDiffuseLighting"

feDisplacementMap ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDisplacementMap = createElement "feDisplacementMap"

feDisplacementMap_ ∷ ∀ message. Array (Html message) → Html message
feDisplacementMap_ = createElement_ "feDisplacementMap"

feDisplacementMap' ∷ ∀ message. Array (NodeData message) → Html message
feDisplacementMap' = createElement' "feDisplacementMap"

feDistantLight ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDistantLight = createElement "feDistantLight"

feDistantLight_ ∷ ∀ message. Array (Html message) → Html message
feDistantLight_ = createElement_ "feDistantLight"

feDistantLight' ∷ ∀ message. Array (NodeData message) → Html message
feDistantLight' = createElement' "feDistantLight"

feDropShadow ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDropShadow = createElement "feDropShadow"

feDropShadow_ ∷ ∀ message. Array (Html message) → Html message
feDropShadow_ = createElement_ "feDropShadow"

feDropShadow' ∷ ∀ message. Array (NodeData message) → Html message
feDropShadow' = createElement' "feDropShadow"

feFlood ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFlood = createElement "feFlood"

feFlood_ ∷ ∀ message. Array (Html message) → Html message
feFlood_ = createElement_ "feFlood"

feFlood' ∷ ∀ message. Array (NodeData message) → Html message
feFlood' = createElement' "feFlood"

feFuncA ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncA = createElement "feFuncA"

feFuncA_ ∷ ∀ message. Array (Html message) → Html message
feFuncA_ = createElement_ "feFuncA"

feFuncA' ∷ ∀ message. Array (NodeData message) → Html message
feFuncA' = createElement' "feFuncA"

feFuncB ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncB = createElement "feFuncB"

feFuncB_ ∷ ∀ message. Array (Html message) → Html message
feFuncB_ = createElement_ "feFuncB"

feFuncB' ∷ ∀ message. Array (NodeData message) → Html message
feFuncB' = createElement' "feFuncB"

feFuncG ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncG = createElement "feFuncG"

feFuncG_ ∷ ∀ message. Array (Html message) → Html message
feFuncG_ = createElement_ "feFuncG"

feFuncG' ∷ ∀ message. Array (NodeData message) → Html message
feFuncG' = createElement' "feFuncG"

feFuncR ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncR = createElement "feFuncR"

feFuncR_ ∷ ∀ message. Array (Html message) → Html message
feFuncR_ = createElement_ "feFuncR"

feFuncR' ∷ ∀ message. Array (NodeData message) → Html message
feFuncR' = createElement' "feFuncR"

feGaussianBlur ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feGaussianBlur = createElement "feGaussianBlur"

feGaussianBlur_ ∷ ∀ message. Array (Html message) → Html message
feGaussianBlur_ = createElement_ "feGaussianBlur"

feGaussianBlur' ∷ ∀ message. Array (NodeData message) → Html message
feGaussianBlur' = createElement' "feGaussianBlur"

feImage ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feImage = createElement "feImage"

feImage_ ∷ ∀ message. Array (Html message) → Html message
feImage_ = createElement_ "feImage"

feImage' ∷ ∀ message. Array (NodeData message) → Html message
feImage' = createElement' "feImage"

feMerge ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feMerge = createElement "feMerge"

feMerge_ ∷ ∀ message. Array (Html message) → Html message
feMerge_ = createElement_ "feMerge"

feMerge' ∷ ∀ message. Array (NodeData message) → Html message
feMerge' = createElement' "feMerge"

feMergeNode ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feMergeNode = createElement "feMergeNode"

feMergeNode_ ∷ ∀ message. Array (Html message) → Html message
feMergeNode_ = createElement_ "feMergeNode"

feMergeNode' ∷ ∀ message. Array (NodeData message) → Html message
feMergeNode' = createElement' "feMergeNode"

feMorphology ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feMorphology = createElement "feMorphology"

feMorphology_ ∷ ∀ message. Array (Html message) → Html message
feMorphology_ = createElement_ "feMorphology"

feMorphology' ∷ ∀ message. Array (NodeData message) → Html message
feMorphology' = createElement' "feMorphology"

feOffset ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feOffset = createElement "feOffset"

feOffset_ ∷ ∀ message. Array (Html message) → Html message
feOffset_ = createElement_ "feOffset"

feOffset' ∷ ∀ message. Array (NodeData message) → Html message
feOffset' = createElement' "feOffset"

fePointLight ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fePointLight = createElement "fePointLight"

fePointLight_ ∷ ∀ message. Array (Html message) → Html message
fePointLight_ = createElement_ "fePointLight"

fePointLight' ∷ ∀ message. Array (NodeData message) → Html message
fePointLight' = createElement' "fePointLight"

feSpecularLighting ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feSpecularLighting = createElement "feSpecularLighting"

feSpecularLighting_ ∷ ∀ message. Array (Html message) → Html message
feSpecularLighting_ = createElement_ "feSpecularLighting"

feSpecularLighting' ∷ ∀ message. Array (NodeData message) → Html message
feSpecularLighting' = createElement' "feSpecularLighting"

feSpotLight ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feSpotLight = createElement "feSpotLight"

feSpotLight_ ∷ ∀ message. Array (Html message) → Html message
feSpotLight_ = createElement_ "feSpotLight"

feSpotLight' ∷ ∀ message. Array (NodeData message) → Html message
feSpotLight' = createElement' "feSpotLight"

feTile ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feTile = createElement "feTile"

feTile_ ∷ ∀ message. Array (Html message) → Html message
feTile_ = createElement_ "feTile"

feTile' ∷ ∀ message. Array (NodeData message) → Html message
feTile' = createElement' "feTile"

feTurbulence ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feTurbulence = createElement "feTurbulence"

feTurbulence_ ∷ ∀ message. Array (Html message) → Html message
feTurbulence_ = createElement_ "feTurbulence"

feTurbulence' ∷ ∀ message. Array (NodeData message) → Html message
feTurbulence' = createElement' "feTurbulence"

filter ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
filter = createElement "filter"

filter_ ∷ ∀ message. Array (Html message) → Html message
filter_ = createElement_ "filter"

filter' ∷ ∀ message. Array (NodeData message) → Html message
filter' = createElement' "filter"

font ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
font = createElement "font"

font_ ∷ ∀ message. Array (Html message) → Html message
font_ = createElement_ "font"

font' ∷ ∀ message. Array (NodeData message) → Html message
font' = createElement' "font"

fontFace ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFace = createElement "font-face"

fontFace_ ∷ ∀ message. Array (Html message) → Html message
fontFace_ = createElement_ "font-face"

fontFace' ∷ ∀ message. Array (NodeData message) → Html message
fontFace' = createElement' "font-face"

fontFaceFormat ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceFormat = createElement "font-face-format"

fontFaceFormat_ ∷ ∀ message. Array (Html message) → Html message
fontFaceFormat_ = createElement_ "font-face-format"

fontFaceFormat' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceFormat' = createElement' "font-face-format"

fontFaceName ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceName = createElement "font-face-name"

fontFaceName_ ∷ ∀ message. Array (Html message) → Html message
fontFaceName_ = createElement_ "font-face-name"

fontFaceName' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceName' = createElement' "font-face-name"

fontFaceSrc ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceSrc = createElement "font-face-src"

fontFaceSrc_ ∷ ∀ message. Array (Html message) → Html message
fontFaceSrc_ = createElement_ "font-face-src"

fontFaceSrc' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceSrc' = createElement' "font-face-src"

fontFaceUri ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceUri = createElement "font-face-uri"

fontFaceUri_ ∷ ∀ message. Array (Html message) → Html message
fontFaceUri_ = createElement_ "font-face-uri"

fontFaceUri' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceUri' = createElement' "font-face-uri"

foreignObject ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
foreignObject = createElement "foreignObject"

foreignObject_ ∷ ∀ message. Array (Html message) → Html message
foreignObject_ = createElement_ "foreignObject"

foreignObject' ∷ ∀ message. Array (NodeData message) → Html message
foreignObject' = createElement' "foreignObject"

g ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
g = createElement "g"

g_ ∷ ∀ message. Array (Html message) → Html message
g_ = createElement_ "g"

g' ∷ ∀ message. Array (NodeData message) → Html message
g' = createElement' "g"

glyph ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
glyph = createElement "glyph"

glyph_ ∷ ∀ message. Array (Html message) → Html message
glyph_ = createElement_ "glyph"

glyph' ∷ ∀ message. Array (NodeData message) → Html message
glyph' = createElement' "glyph"

glyphRef ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
glyphRef = createElement "glyphRef"

glyphRef_ ∷ ∀ message. Array (Html message) → Html message
glyphRef_ = createElement_ "glyphRef"

glyphRef' ∷ ∀ message. Array (NodeData message) → Html message
glyphRef' = createElement' "glyphRef"

hatch ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hatch = createElement "hatch"

hatch_ ∷ ∀ message. Array (Html message) → Html message
hatch_ = createElement_ "hatch"

hatch' ∷ ∀ message. Array (NodeData message) → Html message
hatch' = createElement' "hatch"

hatchpath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hatchpath = createElement "hatchpath"

hatchpath_ ∷ ∀ message. Array (Html message) → Html message
hatchpath_ = createElement_ "hatchpath"

hatchpath' ∷ ∀ message. Array (NodeData message) → Html message
hatchpath' = createElement' "hatchpath"

hkern ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hkern = createElement "hkern"

hkern_ ∷ ∀ message. Array (Html message) → Html message
hkern_ = createElement_ "hkern"

hkern' ∷ ∀ message. Array (NodeData message) → Html message
hkern' = createElement' "hkern"

image ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
image = createElement "image"

image_ ∷ ∀ message. Array (Html message) → Html message
image_ = createElement_ "image"

image' ∷ ∀ message. Array (NodeData message) → Html message
image' = createElement' "image"

line ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
line = createElement "line"

line_ ∷ ∀ message. Array (Html message) → Html message
line_ = createElement_ "line"

line' ∷ ∀ message. Array (NodeData message) → Html message
line' = createElement' "line"

linearGradient ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
linearGradient = createElement "linearGradient"

linearGradient_ ∷ ∀ message. Array (Html message) → Html message
linearGradient_ = createElement_ "linearGradient"

linearGradient' ∷ ∀ message. Array (NodeData message) → Html message
linearGradient' = createElement' "linearGradient"

marker ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
marker = createElement "marker"

marker_ ∷ ∀ message. Array (Html message) → Html message
marker_ = createElement_ "marker"

marker' ∷ ∀ message. Array (NodeData message) → Html message
marker' = createElement' "marker"

mask ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mask = createElement "mask"

mask_ ∷ ∀ message. Array (Html message) → Html message
mask_ = createElement_ "mask"

mask' ∷ ∀ message. Array (NodeData message) → Html message
mask' = createElement' "mask"

mesh ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mesh = createElement "mesh"

mesh_ ∷ ∀ message. Array (Html message) → Html message
mesh_ = createElement_ "mesh"

mesh' ∷ ∀ message. Array (NodeData message) → Html message
mesh' = createElement' "mesh"

meshgradient ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meshgradient = createElement "meshgradient"

meshgradient_ ∷ ∀ message. Array (Html message) → Html message
meshgradient_ = createElement_ "meshgradient"

meshgradient' ∷ ∀ message. Array (NodeData message) → Html message
meshgradient' = createElement' "meshgradient"

meshpatch ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meshpatch = createElement "meshpatch"

meshpatch_ ∷ ∀ message. Array (Html message) → Html message
meshpatch_ = createElement_ "meshpatch"

meshpatch' ∷ ∀ message. Array (NodeData message) → Html message
meshpatch' = createElement' "meshpatch"

meshrow ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meshrow = createElement "meshrow"

meshrow_ ∷ ∀ message. Array (Html message) → Html message
meshrow_ = createElement_ "meshrow"

meshrow' ∷ ∀ message. Array (NodeData message) → Html message
meshrow' = createElement' "meshrow"

metadata ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
metadata = createElement "metadata"

metadata_ ∷ ∀ message. Array (Html message) → Html message
metadata_ = createElement_ "metadata"

metadata' ∷ ∀ message. Array (NodeData message) → Html message
metadata' = createElement' "metadata"

missingGlyph ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
missingGlyph = createElement "missing-glyph"

missingGlyph_ ∷ ∀ message. Array (Html message) → Html message
missingGlyph_ = createElement_ "missing-glyph"

missingGlyph' ∷ ∀ message. Array (NodeData message) → Html message
missingGlyph' = createElement' "missing-glyph"

mpath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mpath = createElement "mpath"

mpath_ ∷ ∀ message. Array (Html message) → Html message
mpath_ = createElement_ "mpath"

mpath' ∷ ∀ message. Array (NodeData message) → Html message
mpath' = createElement' "mpath"

path ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
path = createElement "path"

path_ ∷ ∀ message. Array (Html message) → Html message
path_ = createElement_ "path"

path' ∷ ∀ message. Array (NodeData message) → Html message
path' = createElement' "path"

pattern ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
pattern = createElement "pattern"

pattern_ ∷ ∀ message. Array (Html message) → Html message
pattern_ = createElement_ "pattern"

pattern' ∷ ∀ message. Array (NodeData message) → Html message
pattern' = createElement' "pattern"

polygon ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
polygon = createElement "polygon"

polygon_ ∷ ∀ message. Array (Html message) → Html message
polygon_ = createElement_ "polygon"

polygon' ∷ ∀ message. Array (NodeData message) → Html message
polygon' = createElement' "polygon"

polyline ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
polyline = createElement "polyline"

polyline_ ∷ ∀ message. Array (Html message) → Html message
polyline_ = createElement_ "polyline"

polyline' ∷ ∀ message. Array (NodeData message) → Html message
polyline' = createElement' "polyline"

radialGradient ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
radialGradient = createElement "radialGradient"

radialGradient_ ∷ ∀ message. Array (Html message) → Html message
radialGradient_ = createElement_ "radialGradient"

radialGradient' ∷ ∀ message. Array (NodeData message) → Html message
radialGradient' = createElement' "radialGradient"

rect ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rect = createElement "rect"

rect_ ∷ ∀ message. Array (Html message) → Html message
rect_ = createElement_ "rect"

rect' ∷ ∀ message. Array (NodeData message) → Html message
rect' = createElement' "rect"

script ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
script = createElement "script"

script_ ∷ ∀ message. Array (Html message) → Html message
script_ = createElement_ "script"

script' ∷ ∀ message. Array (NodeData message) → Html message
script' = createElement' "script"

set ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
set = createElement "set"

set_ ∷ ∀ message. Array (Html message) → Html message
set_ = createElement_ "set"

set' ∷ ∀ message. Array (NodeData message) → Html message
set' = createElement' "set"

solidcolor ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
solidcolor = createElement "solidcolor"

solidcolor_ ∷ ∀ message. Array (Html message) → Html message
solidcolor_ = createElement_ "solidcolor"

solidcolor' ∷ ∀ message. Array (NodeData message) → Html message
solidcolor' = createElement' "solidcolor"

stop ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
stop = createElement "stop"

stop_ ∷ ∀ message. Array (Html message) → Html message
stop_ = createElement_ "stop"

stop' ∷ ∀ message. Array (NodeData message) → Html message
stop' = createElement' "stop"

switch ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
switch = createElement "switch"

switch_ ∷ ∀ message. Array (Html message) → Html message
switch_ = createElement_ "switch"

switch' ∷ ∀ message. Array (NodeData message) → Html message
switch' = createElement' "switch"

symbol ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
symbol = createElement "symbol"

symbol_ ∷ ∀ message. Array (Html message) → Html message
symbol_ = createElement_ "symbol"

symbol' ∷ ∀ message. Array (NodeData message) → Html message
symbol' = createElement' "symbol"

textPath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
textPath = createElement "textPath"

textPath_ ∷ ∀ message. Array (Html message) → Html message
textPath_ = createElement_ "textPath"

textPath' ∷ ∀ message. Array (NodeData message) → Html message
textPath' = createElement' "textPath"

tref ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tref = createElement "tref"

tref_ ∷ ∀ message. Array (Html message) → Html message
tref_ = createElement_ "tref"

tref' ∷ ∀ message. Array (NodeData message) → Html message
tref' = createElement' "tref"

tspan ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tspan = createElement "tspan"

tspan_ ∷ ∀ message. Array (Html message) → Html message
tspan_ = createElement_ "tspan"

tspan' ∷ ∀ message. Array (NodeData message) → Html message
tspan' = createElement' "tspan"

unknown ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
unknown = createElement "unknown"

unknown_ ∷ ∀ message. Array (Html message) → Html message
unknown_ = createElement_ "unknown"

unknown' ∷ ∀ message. Array (NodeData message) → Html message
unknown' = createElement' "unknown"

use ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
use = createElement "use"

use_ ∷ ∀ message. Array (Html message) → Html message
use_ = createElement_ "use"

use' ∷ ∀ message. Array (NodeData message) → Html message
use' = createElement' "use"

view ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
view = createElement "view"

view_ ∷ ∀ message. Array (Html message) → Html message
view_ = createElement_ "view"

view' ∷ ∀ message. Array (NodeData message) → Html message
view' = createElement' "view"

vkern ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
vkern = createElement "vkern"

vkern_ ∷ ∀ message. Array (Html message) → Html message
vkern_ = createElement_ "vkern"

vkern' ∷ ∀ message. Array (NodeData message) → Html message
vkern' = createElement' "vkern"
