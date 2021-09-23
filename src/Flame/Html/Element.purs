-- | Definition of HTML elements
module Flame.Html.Element where

import Prelude hiding (map)

import Data.Array as DA
import Data.Maybe (Maybe)
import Data.Maybe as DM
import Effect (Effect)
import Flame.Html.Attribute.Internal as FHAI
import Flame.Types (Html, NodeData, Tag, Key)
import Web.DOM (Node)

-- | `ToNode` simplifies element creation by automating common tag operations
-- | * `tag "my-tag" []` becomes short for `tag [id "my-tag"] []`
-- | * `tag [] "content"` becomes short for `tag [] [text "content"]`
-- | * elements with a single attribute or children need not as well to use lists: `tag (enabled True) (tag attrs children)`
class ToNode ∷ ∀ k. Type → k → (k → Type) → Constraint
class ToNode a b c | a → b where
      toNode ∷ a → Array (c b)

instance stringToHtml ∷ ToNode String b Html where
      toNode = DA.singleton <<< text

instance arrayToNodeData ∷ (ToNode a b c) ⇒ ToNode (Array a) b c where
      toNode = DA.concatMap toNode

instance htmlToHtml ∷ ToNode (Html a) a Html where
      toNode = DA.singleton

instance stringToNodeData ∷ ToNode String b NodeData where
      toNode = DA.singleton <<< FHAI.id

instance nodeDataToNodedata ∷ ToNode (NodeData a) a NodeData where
      toNode = DA.singleton

type ToHtml a b h = ToNode a h NodeData ⇒ ToNode b h Html ⇒ a → b → Html h

type ToHtml_ b h = ToNode b h Html ⇒ b → Html h

type ToHtml' a h = ToNode a h NodeData ⇒ a → Html h

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
foreign import createFragmentNode ∷ ∀ message. Array (Html message) → Html message

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
createElement ∷ ∀ a b h. Tag → ToHtml a b h
createElement tag nodeData children = createElementNode tag (toNode nodeData) $ toNode children

-- | Creates an element node with no attributes but children nodes
createElement_ ∷ ∀ b h. Tag → ToHtml_ b h
createElement_ tag children = createDatalessElementNode tag $ toNode children

-- | Creates an element node with attributes but no children nodes
createElement' ∷ ∀ a h. Tag → ToHtml' a h
createElement' tag nodeData = createSingleElementNode tag $ toNode nodeData

-- | Creates a fragment node
-- |
-- | Fragments act as wrappers: only children nodes are rendered
fragment ∷ ∀ b h. ToHtml_ b h
fragment children = createFragmentNode $ toNode children

-- | Creates a lazy node
-- |
-- | Lazy nodes are only updated if the `arg` parameter changes (compared by reference)
lazy ∷ ∀ arg message. Maybe Key → (arg → Html message) → arg → Html message
lazy maybeKey render arg = createLazyNode (DM.maybe [] DA.singleton maybeKey) render arg

-- | Creates a node which the corresponding DOM node is created and updated from the given `arg`
managed ∷ ∀ arg nd message. ToNode nd message NodeData ⇒ NodeRenderer arg → nd → arg → Html message
managed render nodeData arg = createManagedNode render (toNode nodeData) arg

-- | Creates a node (with no attributes) which the corresponding DOM node is created and updated from the given `arg`
managed_ ∷ ∀ arg message. NodeRenderer arg → arg → Html message
managed_ render arg = createDatalessManagedNode render arg

svg ∷ ∀ a b h. ToHtml a b h
svg nodeData children = createSvgNode (toNode nodeData) $ toNode children

svg_ ∷ ∀ b h. ToHtml_ b h
svg_ children = createDatalessSvgNode $ toNode children

svg' ∷ ∀ a h. ToHtml' a h
svg' nodeData = createSingleSvgNode $ toNode nodeData

hr ∷ ∀ h. Html h
hr = createEmptyElement "hr"

hr_ ∷ ∀ b h. ToHtml_ b h
hr_ = createElement_ "hr"

hr' ∷ ∀ a h. ToHtml' a h
hr' = createElement' "hr"

br ∷ ∀ h. Html h
br = createEmptyElement "br"

br' ∷ ∀ a h. ToHtml' a h
br' = createElement' "br"

input ∷ ∀ a h. ToHtml' a h
input = createElement' "input"

input_ ∷ ∀ a h. ToHtml_ a h
input_ = createElement_ "input"

--script generated

a ∷ ∀ a b h. ToHtml a b h
a = createElement "a"

a_ ∷ ∀ b h. ToHtml_ b h
a_ = createElement_ "a"

a' ∷ ∀ a h. ToHtml' a h
a' = createElement' "a"

address ∷ ∀ a b h. ToHtml a b h
address = createElement "address"

address_ ∷ ∀ b h. ToHtml_ b h
address_ = createElement_ "address"

address' ∷ ∀ a h. ToHtml' a h
address' = createElement' "address"

area ∷ ∀ a b h. ToHtml a b h
area = createElement "area"

area_ ∷ ∀ b h. ToHtml_ b h
area_ = createElement_ "area"

area' ∷ ∀ a h. ToHtml' a h
area' = createElement' "area"

article ∷ ∀ a b h. ToHtml a b h
article = createElement "article"

article_ ∷ ∀ b h. ToHtml_ b h
article_ = createElement_ "article"

article' ∷ ∀ a h. ToHtml' a h
article' = createElement' "article"

aside ∷ ∀ a b h. ToHtml a b h
aside = createElement "aside"

aside_ ∷ ∀ b h. ToHtml_ b h
aside_ = createElement_ "aside"

aside' ∷ ∀ a h. ToHtml' a h
aside' = createElement' "aside"

audio ∷ ∀ a b h. ToHtml a b h
audio = createElement "audio"

audio_ ∷ ∀ b h. ToHtml_ b h
audio_ = createElement_ "audio"

audio' ∷ ∀ a h. ToHtml' a h
audio' = createElement' "audio"

b ∷ ∀ a b h. ToHtml a b h
b = createElement "b"

b_ ∷ ∀ b h. ToHtml_ b h
b_ = createElement_ "b"

b' ∷ ∀ a h. ToHtml' a h
b' = createElement' "b"

base ∷ ∀ a b h. ToHtml a b h
base = createElement "base"

base_ ∷ ∀ b h. ToHtml_ b h
base_ = createElement_ "base"

base' ∷ ∀ a h. ToHtml' a h
base' = createElement' "base"

bdi ∷ ∀ a b h. ToHtml a b h
bdi = createElement "bdi"

bdi_ ∷ ∀ b h. ToHtml_ b h
bdi_ = createElement_ "bdi"

bdi' ∷ ∀ a h. ToHtml' a h
bdi' = createElement' "bdi"

bdo ∷ ∀ a b h. ToHtml a b h
bdo = createElement "bdo"

bdo_ ∷ ∀ b h. ToHtml_ b h
bdo_ = createElement_ "bdo"

bdo' ∷ ∀ a h. ToHtml' a h
bdo' = createElement' "bdo"

blockquote ∷ ∀ a b h. ToHtml a b h
blockquote = createElement "blockquote"

blockquote_ ∷ ∀ b h. ToHtml_ b h
blockquote_ = createElement_ "blockquote"

blockquote' ∷ ∀ a h. ToHtml' a h
blockquote' = createElement' "blockquote"

body ∷ ∀ a b h. ToHtml a b h
body = createElement "body"

body_ ∷ ∀ b h. ToHtml_ b h
body_ = createElement_ "body"

body' ∷ ∀ a h. ToHtml' a h
body' = createElement' "body"

button ∷ ∀ a b h. ToHtml a b h
button = createElement "button"

button_ ∷ ∀ b h. ToHtml_ b h
button_ = createElement_ "button"

button' ∷ ∀ a h. ToHtml' a h
button' = createElement' "button"

canvas ∷ ∀ a b h. ToHtml a b h
canvas = createElement "canvas"

canvas_ ∷ ∀ b h. ToHtml_ b h
canvas_ = createElement_ "canvas"

canvas' ∷ ∀ a h. ToHtml' a h
canvas' = createElement' "canvas"

caption ∷ ∀ a b h. ToHtml a b h
caption = createElement "caption"

caption_ ∷ ∀ b h. ToHtml_ b h
caption_ = createElement_ "caption"

caption' ∷ ∀ a h. ToHtml' a h
caption' = createElement' "caption"

cite ∷ ∀ a b h. ToHtml a b h
cite = createElement "cite"

cite_ ∷ ∀ b h. ToHtml_ b h
cite_ = createElement_ "cite"

cite' ∷ ∀ a h. ToHtml' a h
cite' = createElement' "cite"

code ∷ ∀ a b h. ToHtml a b h
code = createElement "code"

code_ ∷ ∀ b h. ToHtml_ b h
code_ = createElement_ "code"

code' ∷ ∀ a h. ToHtml' a h
code' = createElement' "code"

col ∷ ∀ a b h. ToHtml a b h
col = createElement "col"

col_ ∷ ∀ b h. ToHtml_ b h
col_ = createElement_ "col"

col' ∷ ∀ a h. ToHtml' a h
col' = createElement' "col"

colgroup ∷ ∀ a b h. ToHtml a b h
colgroup = createElement "colgroup"

colgroup_ ∷ ∀ b h. ToHtml_ b h
colgroup_ = createElement_ "colgroup"

colgroup' ∷ ∀ a h. ToHtml' a h
colgroup' = createElement' "colgroup"

data_ ∷ ∀ b h. ToHtml_ b h
data_ = createElement_ "data"

data' ∷ ∀ a h. ToHtml' a h
data' = createElement' "data"

datalist ∷ ∀ a b h. ToHtml a b h
datalist = createElement "datalist"

datalist_ ∷ ∀ b h. ToHtml_ b h
datalist_ = createElement_ "datalist"

datalist' ∷ ∀ a h. ToHtml' a h
datalist' = createElement' "datalist"

dd ∷ ∀ a b h. ToHtml a b h
dd = createElement "dd"

dd_ ∷ ∀ b h. ToHtml_ b h
dd_ = createElement_ "dd"

dd' ∷ ∀ a h. ToHtml' a h
dd' = createElement' "dd"

del ∷ ∀ a b h. ToHtml a b h
del = createElement "del"

del_ ∷ ∀ b h. ToHtml_ b h
del_ = createElement_ "del"

del' ∷ ∀ a h. ToHtml' a h
del' = createElement' "del"

details ∷ ∀ a b h. ToHtml a b h
details = createElement "details"

details_ ∷ ∀ b h. ToHtml_ b h
details_ = createElement_ "details"

details' ∷ ∀ a h. ToHtml' a h
details' = createElement' "details"

dfn ∷ ∀ a b h. ToHtml a b h
dfn = createElement "dfn"

dfn_ ∷ ∀ b h. ToHtml_ b h
dfn_ = createElement_ "dfn"

dfn' ∷ ∀ a h. ToHtml' a h
dfn' = createElement' "dfn"

dialog ∷ ∀ a b h. ToHtml a b h
dialog = createElement "dialog"

dialog_ ∷ ∀ b h. ToHtml_ b h
dialog_ = createElement_ "dialog"

dialog' ∷ ∀ a h. ToHtml' a h
dialog' = createElement' "dialog"

div ∷ ∀ a b h. ToHtml a b h
div = createElement "div"

div_ ∷ ∀ b h. ToHtml_ b h
div_ = createElement_ "div"

div' ∷ ∀ a h. ToHtml' a h
div' = createElement' "div"

dl ∷ ∀ a b h. ToHtml a b h
dl = createElement "dl"

dl_ ∷ ∀ b h. ToHtml_ b h
dl_ = createElement_ "dl"

dl' ∷ ∀ a h. ToHtml' a h
dl' = createElement' "dl"

dt ∷ ∀ a b h. ToHtml a b h
dt = createElement "dt"

dt_ ∷ ∀ b h. ToHtml_ b h
dt_ = createElement_ "dt"

dt' ∷ ∀ a h. ToHtml' a h
dt' = createElement' "dt"

em ∷ ∀ a b h. ToHtml a b h
em = createElement "em"

em_ ∷ ∀ b h. ToHtml_ b h
em_ = createElement_ "em"

em' ∷ ∀ a h. ToHtml' a h
em' = createElement' "em"

embed ∷ ∀ a b h. ToHtml a b h
embed = createElement "embed"

embed_ ∷ ∀ b h. ToHtml_ b h
embed_ = createElement_ "embed"

embed' ∷ ∀ a h. ToHtml' a h
embed' = createElement' "embed"

fieldset ∷ ∀ a b h. ToHtml a b h
fieldset = createElement "fieldset"

fieldset_ ∷ ∀ b h. ToHtml_ b h
fieldset_ = createElement_ "fieldset"

fieldset' ∷ ∀ a h. ToHtml' a h
fieldset' = createElement' "fieldset"

figure ∷ ∀ a b h. ToHtml a b h
figure = createElement "figure"

figure_ ∷ ∀ b h. ToHtml_ b h
figure_ = createElement_ "figure"

figure' ∷ ∀ a h. ToHtml' a h
figure' = createElement' "figure"

footer ∷ ∀ a b h. ToHtml a b h
footer = createElement "footer"

footer_ ∷ ∀ b h. ToHtml_ b h
footer_ = createElement_ "footer"

footer' ∷ ∀ a h. ToHtml' a h
footer' = createElement' "footer"

form ∷ ∀ a b h. ToHtml a b h
form = createElement "form"

form_ ∷ ∀ b h. ToHtml_ b h
form_ = createElement_ "form"

form' ∷ ∀ a h. ToHtml' a h
form' = createElement' "form"

h1 ∷ ∀ a b h. ToHtml a b h
h1 = createElement "h1"

h1_ ∷ ∀ b h. ToHtml_ b h
h1_ = createElement_ "h1"

h1' ∷ ∀ a h. ToHtml' a h
h1' = createElement' "h1"

h2 ∷ ∀ a b h. ToHtml a b h
h2 = createElement "h2"

h2_ ∷ ∀ b h. ToHtml_ b h
h2_ = createElement_ "h2"

h2' ∷ ∀ a h. ToHtml' a h
h2' = createElement' "h2"

h3 ∷ ∀ a b h. ToHtml a b h
h3 = createElement "h3"

h3_ ∷ ∀ b h. ToHtml_ b h
h3_ = createElement_ "h3"

h3' ∷ ∀ a h. ToHtml' a h
h3' = createElement' "h3"

h4 ∷ ∀ a b h. ToHtml a b h
h4 = createElement "h4"

h4_ ∷ ∀ b h. ToHtml_ b h
h4_ = createElement_ "h4"

h4' ∷ ∀ a h. ToHtml' a h
h4' = createElement' "h4"

h5 ∷ ∀ a b h. ToHtml a b h
h5 = createElement "h5"

h5_ ∷ ∀ b h. ToHtml_ b h
h5_ = createElement_ "h5"

h5' ∷ ∀ a h. ToHtml' a h
h5' = createElement' "h5"

h6 ∷ ∀ a b h. ToHtml a b h
h6 = createElement "h6"

h6_ ∷ ∀ b h. ToHtml_ b h
h6_ = createElement_ "h6"

h6' ∷ ∀ a h. ToHtml' a h
h6' = createElement' "h6"

head ∷ ∀ a b h. ToHtml a b h
head = createElement "head"

head_ ∷ ∀ b h. ToHtml_ b h
head_ = createElement_ "head"

head' ∷ ∀ a h. ToHtml' a h
head' = createElement' "head"

header ∷ ∀ a b h. ToHtml a b h
header = createElement "header"

header_ ∷ ∀ b h. ToHtml_ b h
header_ = createElement_ "header"

header' ∷ ∀ a h. ToHtml' a h
header' = createElement' "header"

hgroup ∷ ∀ a b h. ToHtml a b h
hgroup = createElement "hgroup"

hgroup_ ∷ ∀ b h. ToHtml_ b h
hgroup_ = createElement_ "hgroup"

hgroup' ∷ ∀ a h. ToHtml' a h
hgroup' = createElement' "hgroup"

html ∷ ∀ a b h. ToHtml a b h
html = createElement "html"

html_ ∷ ∀ b h. ToHtml_ b h
html_ = createElement_ "html"

html' ∷ ∀ a h. ToHtml' a h
html' = createElement' "html"

i ∷ ∀ a b h. ToHtml a b h
i = createElement "i"

i_ ∷ ∀ b h. ToHtml_ b h
i_ = createElement_ "i"

i' ∷ ∀ a h. ToHtml' a h
i' = createElement' "i"

iframe ∷ ∀ a b h. ToHtml a b h
iframe = createElement "iframe"

iframe_ ∷ ∀ b h. ToHtml_ b h
iframe_ = createElement_ "iframe"

iframe' ∷ ∀ a h. ToHtml' a h
iframe' = createElement' "iframe"

ins ∷ ∀ a b h. ToHtml a b h
ins = createElement "ins"

ins_ ∷ ∀ b h. ToHtml_ b h
ins_ = createElement_ "ins"

ins' ∷ ∀ a h. ToHtml' a h
ins' = createElement' "ins"

keygen ∷ ∀ a b h. ToHtml a b h
keygen = createElement "keygen"

keygen_ ∷ ∀ b h. ToHtml_ b h
keygen_ = createElement_ "keygen"

keygen' ∷ ∀ a h. ToHtml' a h
keygen' = createElement' "keygen"

label ∷ ∀ a b h. ToHtml a b h
label = createElement "label"

label_ ∷ ∀ b h. ToHtml_ b h
label_ = createElement_ "label"

label' ∷ ∀ a h. ToHtml' a h
label' = createElement' "label"

legend ∷ ∀ a b h. ToHtml a b h
legend = createElement "legend"

legend_ ∷ ∀ b h. ToHtml_ b h
legend_ = createElement_ "legend"

legend' ∷ ∀ a h. ToHtml' a h
legend' = createElement' "legend"

li ∷ ∀ a b h. ToHtml a b h
li = createElement "li"

li_ ∷ ∀ b h. ToHtml_ b h
li_ = createElement_ "li"

li' ∷ ∀ a h. ToHtml' a h
li' = createElement' "li"

link ∷ ∀ a h. ToHtml' a h
link = createElement' "link"

main ∷ ∀ a b h. ToHtml a b h
main = createElement "main"

main_ ∷ ∀ b h. ToHtml_ b h
main_ = createElement_ "main"

main' ∷ ∀ a h. ToHtml' a h
main' = createElement' "main"

map ∷ ∀ a b h. ToHtml a b h
map = createElement "map"

map_ ∷ ∀ b h. ToHtml_ b h
map_ = createElement_ "map"

map' ∷ ∀ a h. ToHtml' a h
map' = createElement' "map"

mark ∷ ∀ a b h. ToHtml a b h
mark = createElement "mark"

mark_ ∷ ∀ b h. ToHtml_ b h
mark_ = createElement_ "mark"

mark' ∷ ∀ a h. ToHtml' a h
mark' = createElement' "mark"

menu ∷ ∀ a b h. ToHtml a b h
menu = createElement "menu"

menu_ ∷ ∀ b h. ToHtml_ b h
menu_ = createElement_ "menu"

menu' ∷ ∀ a h. ToHtml' a h
menu' = createElement' "menu"

menuitem ∷ ∀ a b h. ToHtml a b h
menuitem = createElement "menuitem"

menuitem_ ∷ ∀ b h. ToHtml_ b h
menuitem_ = createElement_ "menuitem"

menuitem' ∷ ∀ a h. ToHtml' a h
menuitem' = createElement' "menuitem"

meta ∷ ∀ a h. ToHtml' a h
meta = createElement' "meta"

meter ∷ ∀ a b h. ToHtml a b h
meter = createElement "meter"

meter_ ∷ ∀ b h. ToHtml_ b h
meter_ = createElement_ "meter"

meter' ∷ ∀ a h. ToHtml' a h
meter' = createElement' "meter"

nav ∷ ∀ a b h. ToHtml a b h
nav = createElement "nav"

nav_ ∷ ∀ b h. ToHtml_ b h
nav_ = createElement_ "nav"

nav' ∷ ∀ a h. ToHtml' a h
nav' = createElement' "nav"

noscript ∷ ∀ a b h. ToHtml a b h
noscript = createElement "noscript"

noscript_ ∷ ∀ b h. ToHtml_ b h
noscript_ = createElement_ "noscript"

noscript' ∷ ∀ a h. ToHtml' a h
noscript' = createElement' "noscript"

object ∷ ∀ a b h. ToHtml a b h
object = createElement "object"

object_ ∷ ∀ b h. ToHtml_ b h
object_ = createElement_ "object"

object' ∷ ∀ a h. ToHtml' a h
object' = createElement' "object"

ol ∷ ∀ a b h. ToHtml a b h
ol = createElement "ol"

ol_ ∷ ∀ b h. ToHtml_ b h
ol_ = createElement_ "ol"

ol' ∷ ∀ a h. ToHtml' a h
ol' = createElement' "ol"

img ∷ ∀ a h. ToHtml' a h
img = createElement' "img"

optgroup ∷ ∀ a b h. ToHtml a b h
optgroup = createElement "optgroup"

optgroup_ ∷ ∀ b h. ToHtml_ b h
optgroup_ = createElement_ "optgroup"

optgroup' ∷ ∀ a h. ToHtml' a h
optgroup' = createElement' "optgroup"

option ∷ ∀ a b h. ToHtml a b h
option = createElement "option"

option_ ∷ ∀ b h. ToHtml_ b h
option_ = createElement_ "option"

option' ∷ ∀ a h. ToHtml' a h
option' = createElement' "option"

output ∷ ∀ a b h. ToHtml a b h
output = createElement "output"

output_ ∷ ∀ b h. ToHtml_ b h
output_ = createElement_ "output"

output' ∷ ∀ a h. ToHtml' a h
output' = createElement' "output"

p ∷ ∀ a b h. ToHtml a b h
p = createElement "p"

p_ ∷ ∀ b h. ToHtml_ b h
p_ = createElement_ "p"

p' ∷ ∀ a h. ToHtml' a h
p' = createElement' "p"

param ∷ ∀ a b h. ToHtml a b h
param = createElement "param"

param_ ∷ ∀ b h. ToHtml_ b h
param_ = createElement_ "param"

param' ∷ ∀ a h. ToHtml' a h
param' = createElement' "param"

pre ∷ ∀ a b h. ToHtml a b h
pre = createElement "pre"

pre_ ∷ ∀ b h. ToHtml_ b h
pre_ = createElement_ "pre"

pre' ∷ ∀ a h. ToHtml' a h
pre' = createElement' "pre"

progress ∷ ∀ a b h. ToHtml a b h
progress = createElement "progress"

progress_ ∷ ∀ b h. ToHtml_ b h
progress_ = createElement_ "progress"

progress' ∷ ∀ a h. ToHtml' a h
progress' = createElement' "progress"

q ∷ ∀ a b h. ToHtml a b h
q = createElement "q"

q_ ∷ ∀ b h. ToHtml_ b h
q_ = createElement_ "q"

q' ∷ ∀ a h. ToHtml' a h
q' = createElement' "q"

rb ∷ ∀ a b h. ToHtml a b h
rb = createElement "rb"

rb_ ∷ ∀ b h. ToHtml_ b h
rb_ = createElement_ "rb"

rb' ∷ ∀ a h. ToHtml' a h
rb' = createElement' "rb"

rp ∷ ∀ a b h. ToHtml a b h
rp = createElement "rp"

rp_ ∷ ∀ b h. ToHtml_ b h
rp_ = createElement_ "rp"

rp' ∷ ∀ a h. ToHtml' a h
rp' = createElement' "rp"

rt ∷ ∀ a b h. ToHtml a b h
rt = createElement "rt"

rt_ ∷ ∀ b h. ToHtml_ b h
rt_ = createElement_ "rt"

rt' ∷ ∀ a h. ToHtml' a h
rt' = createElement' "rt"

rtc ∷ ∀ a b h. ToHtml a b h
rtc = createElement "rtc"

rtc_ ∷ ∀ b h. ToHtml_ b h
rtc_ = createElement_ "rtc"

rtc' ∷ ∀ a h. ToHtml' a h
rtc' = createElement' "rtc"

ruby ∷ ∀ a b h. ToHtml a b h
ruby = createElement "ruby"

ruby_ ∷ ∀ b h. ToHtml_ b h
ruby_ = createElement_ "ruby"

ruby' ∷ ∀ a h. ToHtml' a h
ruby' = createElement' "ruby"

s ∷ ∀ a b h. ToHtml a b h
s = createElement "s"

s_ ∷ ∀ b h. ToHtml_ b h
s_ = createElement_ "s"

s' ∷ ∀ a h. ToHtml' a h
s' = createElement' "s"

section ∷ ∀ a b h. ToHtml a b h
section = createElement "section"

section_ ∷ ∀ b h. ToHtml_ b h
section_ = createElement_ "section"

section' ∷ ∀ a h. ToHtml' a h
section' = createElement' "section"

select ∷ ∀ a b h. ToHtml a b h
select = createElement "select"

select_ ∷ ∀ b h. ToHtml_ b h
select_ = createElement_ "select"

select' ∷ ∀ a h. ToHtml' a h
select' = createElement' "select"

small ∷ ∀ a b h. ToHtml a b h
small = createElement "small"

small_ ∷ ∀ b h. ToHtml_ b h
small_ = createElement_ "small"

small' ∷ ∀ a h. ToHtml' a h
small' = createElement' "small"

source ∷ ∀ a b h. ToHtml a b h
source = createElement "source"

source_ ∷ ∀ b h. ToHtml_ b h
source_ = createElement_ "source"

source' ∷ ∀ a h. ToHtml' a h
source' = createElement' "source"

span ∷ ∀ a b h. ToHtml a b h
span = createElement "span"

span_ ∷ ∀ b h. ToHtml_ b h
span_ = createElement_ "span"

span' ∷ ∀ a h. ToHtml' a h
span' = createElement' "span"

strong ∷ ∀ a b h. ToHtml a b h
strong = createElement "strong"

strong_ ∷ ∀ b h. ToHtml_ b h
strong_ = createElement_ "strong"

strong' ∷ ∀ a h. ToHtml' a h
strong' = createElement' "strong"

style ∷ ∀ a b h. ToHtml a b h
style = createElement "style"

style_ ∷ ∀ b h. ToHtml_ b h
style_ = createElement_ "style"

style' ∷ ∀ a h. ToHtml' a h
style' = createElement' "style"

sub ∷ ∀ a b h. ToHtml a b h
sub = createElement "sub"

sub_ ∷ ∀ b h. ToHtml_ b h
sub_ = createElement_ "sub"

sub' ∷ ∀ a h. ToHtml' a h
sub' = createElement' "sub"

summary ∷ ∀ a b h. ToHtml a b h
summary = createElement "summary"

summary_ ∷ ∀ b h. ToHtml_ b h
summary_ = createElement_ "summary"

summary' ∷ ∀ a h. ToHtml' a h
summary' = createElement' "summary"

sup ∷ ∀ a b h. ToHtml a b h
sup = createElement "sup"

sup_ ∷ ∀ b h. ToHtml_ b h
sup_ = createElement_ "sup"

sup' ∷ ∀ a h. ToHtml' a h
sup' = createElement' "sup"

table ∷ ∀ a b h. ToHtml a b h
table = createElement "table"

table_ ∷ ∀ b h. ToHtml_ b h
table_ = createElement_ "table"

table' ∷ ∀ a h. ToHtml' a h
table' = createElement' "table"

tbody ∷ ∀ a b h. ToHtml a b h
tbody = createElement "tbody"

tbody_ ∷ ∀ b h. ToHtml_ b h
tbody_ = createElement_ "tbody"

tbody' ∷ ∀ a h. ToHtml' a h
tbody' = createElement' "tbody"

td ∷ ∀ a b h. ToHtml a b h
td = createElement "td"

td_ ∷ ∀ b h. ToHtml_ b h
td_ = createElement_ "td"

td' ∷ ∀ a h. ToHtml' a h
td' = createElement' "td"

template ∷ ∀ a b h. ToHtml a b h
template = createElement "template"

template_ ∷ ∀ b h. ToHtml_ b h
template_ = createElement_ "template"

template' ∷ ∀ a h. ToHtml' a h
template' = createElement' "template"

textarea ∷ ∀ a b h. ToHtml a b h
textarea = createElement "textarea"

textarea_ ∷ ∀ b h. ToHtml_ b h
textarea_ = createElement_ "textarea"

textarea' ∷ ∀ a h. ToHtml' a h
textarea' = createElement' "textarea"

tfoot ∷ ∀ a b h. ToHtml a b h
tfoot = createElement "tfoot"

tfoot_ ∷ ∀ b h. ToHtml_ b h
tfoot_ = createElement_ "tfoot"

tfoot' ∷ ∀ a h. ToHtml' a h
tfoot' = createElement' "tfoot"

th ∷ ∀ a b h. ToHtml a b h
th = createElement "th"

th_ ∷ ∀ b h. ToHtml_ b h
th_ = createElement_ "th"

th' ∷ ∀ a h. ToHtml' a h
th' = createElement' "th"

thead ∷ ∀ a b h. ToHtml a b h
thead = createElement "thead"

thead_ ∷ ∀ b h. ToHtml_ b h
thead_ = createElement_ "thead"

thead' ∷ ∀ a h. ToHtml' a h
thead' = createElement' "thead"

time ∷ ∀ a b h. ToHtml a b h
time = createElement "time"

time_ ∷ ∀ b h. ToHtml_ b h
time_ = createElement_ "time"

time' ∷ ∀ a h. ToHtml' a h
time' = createElement' "time"

title ∷ ∀ b h. ToHtml_ b h
title = createElement_ "title"

tr ∷ ∀ a b h. ToHtml a b h
tr = createElement "tr"

tr_ ∷ ∀ b h. ToHtml_ b h
tr_ = createElement_ "tr"

tr' ∷ ∀ a h. ToHtml' a h
tr' = createElement' "tr"

track ∷ ∀ a b h. ToHtml a b h
track = createElement "track"

track_ ∷ ∀ b h. ToHtml_ b h
track_ = createElement_ "track"

track' ∷ ∀ a h. ToHtml' a h
track' = createElement' "track"

u ∷ ∀ a b h. ToHtml a b h
u = createElement "u"

u_ ∷ ∀ b h. ToHtml_ b h
u_ = createElement_ "u"

u' ∷ ∀ a h. ToHtml' a h
u' = createElement' "u"

ul ∷ ∀ a b h. ToHtml a b h
ul = createElement "ul"

ul_ ∷ ∀ b h. ToHtml_ b h
ul_ = createElement_ "ul"

ul' ∷ ∀ a h. ToHtml' a h
ul' = createElement' "ul"

var ∷ ∀ a b h. ToHtml a b h
var = createElement "var"

var_ ∷ ∀ b h. ToHtml_ b h
var_ = createElement_ "var"

var' ∷ ∀ a h. ToHtml' a h
var' = createElement' "var"

video ∷ ∀ a b h. ToHtml a b h
video = createElement "video"

video_ ∷ ∀ b h. ToHtml_ b h
video_ = createElement_ "video"

video' ∷ ∀ a h. ToHtml' a h
video' = createElement' "video"

wbr ∷ ∀ a b h. ToHtml a b h
wbr = createElement "wbr"

wbr_ ∷ ∀ b h. ToHtml_ b h
wbr_ = createElement_ "wbr"

wbr' ∷ ∀ a h. ToHtml' a h
wbr' = createElement' "wbr"

animate ∷ ∀ a b h. ToHtml a b h
animate = createElement "animate"

animate_ ∷ ∀ b h. ToHtml_ b h
animate_ = createElement_ "animate"

animate' ∷ ∀ a h. ToHtml' a h
animate' = createElement' "animate"

animateColor ∷ ∀ a b h. ToHtml a b h
animateColor = createElement "animateColor"

animateColor_ ∷ ∀ b h. ToHtml_ b h
animateColor_ = createElement_ "animateColor"

animateColor' ∷ ∀ a h. ToHtml' a h
animateColor' = createElement' "animateColor"

animateMotion ∷ ∀ a b h. ToHtml a b h
animateMotion = createElement "animateMotion"

animateMotion_ ∷ ∀ b h. ToHtml_ b h
animateMotion_ = createElement_ "animateMotion"

animateMotion' ∷ ∀ a h. ToHtml' a h
animateMotion' = createElement' "animateMotion"

animateTransform ∷ ∀ a b h. ToHtml a b h
animateTransform = createElement "animateTransform"

animateTransform_ ∷ ∀ b h. ToHtml_ b h
animateTransform_ = createElement_ "animateTransform"

animateTransform' ∷ ∀ a h. ToHtml' a h
animateTransform' = createElement' "animateTransform"

circle ∷ ∀ a b h. ToHtml a b h
circle = createElement "circle"

circle_ ∷ ∀ b h. ToHtml_ b h
circle_ = createElement_ "circle"

circle' ∷ ∀ a h. ToHtml' a h
circle' = createElement' "circle"

clipPath ∷ ∀ a b h. ToHtml a b h
clipPath = createElement "clipPath"

clipPath_ ∷ ∀ b h. ToHtml_ b h
clipPath_ = createElement_ "clipPath"

clipPath' ∷ ∀ a h. ToHtml' a h
clipPath' = createElement' "clipPath"

colorProfile ∷ ∀ a b h. ToHtml a b h
colorProfile = createElement "color-profile"

colorProfile_ ∷ ∀ b h. ToHtml_ b h
colorProfile_ = createElement_ "color-profile"

colorProfile' ∷ ∀ a h. ToHtml' a h
colorProfile' = createElement' "color-profile"

cursor ∷ ∀ a b h. ToHtml a b h
cursor = createElement "cursor"

cursor_ ∷ ∀ b h. ToHtml_ b h
cursor_ = createElement_ "cursor"

cursor' ∷ ∀ a h. ToHtml' a h
cursor' = createElement' "cursor"

defs ∷ ∀ a b h. ToHtml a b h
defs = createElement "defs"

defs_ ∷ ∀ b h. ToHtml_ b h
defs_ = createElement_ "defs"

defs' ∷ ∀ a h. ToHtml' a h
defs' = createElement' "defs"

desc ∷ ∀ a b h. ToHtml a b h
desc = createElement "desc"

desc_ ∷ ∀ b h. ToHtml_ b h
desc_ = createElement_ "desc"

desc' ∷ ∀ a h. ToHtml' a h
desc' = createElement' "desc"

discard ∷ ∀ a b h. ToHtml a b h
discard = createElement "discard"

discard_ ∷ ∀ b h. ToHtml_ b h
discard_ = createElement_ "discard"

discard' ∷ ∀ a h. ToHtml' a h
discard' = createElement' "discard"

ellipse ∷ ∀ a b h. ToHtml a b h
ellipse = createElement "ellipse"

ellipse_ ∷ ∀ b h. ToHtml_ b h
ellipse_ = createElement_ "ellipse"

ellipse' ∷ ∀ a h. ToHtml' a h
ellipse' = createElement' "ellipse"

feBlend ∷ ∀ a b h. ToHtml a b h
feBlend = createElement "feBlend"

feBlend_ ∷ ∀ b h. ToHtml_ b h
feBlend_ = createElement_ "feBlend"

feBlend' ∷ ∀ a h. ToHtml' a h
feBlend' = createElement' "feBlend"

feColorMatrix ∷ ∀ a b h. ToHtml a b h
feColorMatrix = createElement "feColorMatrix"

feColorMatrix_ ∷ ∀ b h. ToHtml_ b h
feColorMatrix_ = createElement_ "feColorMatrix"

feColorMatrix' ∷ ∀ a h. ToHtml' a h
feColorMatrix' = createElement' "feColorMatrix"

feComponentTransfer ∷ ∀ a b h. ToHtml a b h
feComponentTransfer = createElement "feComponentTransfer"

feComponentTransfer_ ∷ ∀ b h. ToHtml_ b h
feComponentTransfer_ = createElement_ "feComponentTransfer"

feComponentTransfer' ∷ ∀ a h. ToHtml' a h
feComponentTransfer' = createElement' "feComponentTransfer"

feComposite ∷ ∀ a b h. ToHtml a b h
feComposite = createElement "feComposite"

feComposite_ ∷ ∀ b h. ToHtml_ b h
feComposite_ = createElement_ "feComposite"

feComposite' ∷ ∀ a h. ToHtml' a h
feComposite' = createElement' "feComposite"

feConvolveMatrix ∷ ∀ a b h. ToHtml a b h
feConvolveMatrix = createElement "feConvolveMatrix"

feConvolveMatrix_ ∷ ∀ b h. ToHtml_ b h
feConvolveMatrix_ = createElement_ "feConvolveMatrix"

feConvolveMatrix' ∷ ∀ a h. ToHtml' a h
feConvolveMatrix' = createElement' "feConvolveMatrix"

feDiffuseLighting ∷ ∀ a b h. ToHtml a b h
feDiffuseLighting = createElement "feDiffuseLighting"

feDiffuseLighting_ ∷ ∀ b h. ToHtml_ b h
feDiffuseLighting_ = createElement_ "feDiffuseLighting"

feDiffuseLighting' ∷ ∀ a h. ToHtml' a h
feDiffuseLighting' = createElement' "feDiffuseLighting"

feDisplacementMap ∷ ∀ a b h. ToHtml a b h
feDisplacementMap = createElement "feDisplacementMap"

feDisplacementMap_ ∷ ∀ b h. ToHtml_ b h
feDisplacementMap_ = createElement_ "feDisplacementMap"

feDisplacementMap' ∷ ∀ a h. ToHtml' a h
feDisplacementMap' = createElement' "feDisplacementMap"

feDistantLight ∷ ∀ a b h. ToHtml a b h
feDistantLight = createElement "feDistantLight"

feDistantLight_ ∷ ∀ b h. ToHtml_ b h
feDistantLight_ = createElement_ "feDistantLight"

feDistantLight' ∷ ∀ a h. ToHtml' a h
feDistantLight' = createElement' "feDistantLight"

feDropShadow ∷ ∀ a b h. ToHtml a b h
feDropShadow = createElement "feDropShadow"

feDropShadow_ ∷ ∀ b h. ToHtml_ b h
feDropShadow_ = createElement_ "feDropShadow"

feDropShadow' ∷ ∀ a h. ToHtml' a h
feDropShadow' = createElement' "feDropShadow"

feFlood ∷ ∀ a b h. ToHtml a b h
feFlood = createElement "feFlood"

feFlood_ ∷ ∀ b h. ToHtml_ b h
feFlood_ = createElement_ "feFlood"

feFlood' ∷ ∀ a h. ToHtml' a h
feFlood' = createElement' "feFlood"

feFuncA ∷ ∀ a b h. ToHtml a b h
feFuncA = createElement "feFuncA"

feFuncA_ ∷ ∀ b h. ToHtml_ b h
feFuncA_ = createElement_ "feFuncA"

feFuncA' ∷ ∀ a h. ToHtml' a h
feFuncA' = createElement' "feFuncA"

feFuncB ∷ ∀ a b h. ToHtml a b h
feFuncB = createElement "feFuncB"

feFuncB_ ∷ ∀ b h. ToHtml_ b h
feFuncB_ = createElement_ "feFuncB"

feFuncB' ∷ ∀ a h. ToHtml' a h
feFuncB' = createElement' "feFuncB"

feFuncG ∷ ∀ a b h. ToHtml a b h
feFuncG = createElement "feFuncG"

feFuncG_ ∷ ∀ b h. ToHtml_ b h
feFuncG_ = createElement_ "feFuncG"

feFuncG' ∷ ∀ a h. ToHtml' a h
feFuncG' = createElement' "feFuncG"

feFuncR ∷ ∀ a b h. ToHtml a b h
feFuncR = createElement "feFuncR"

feFuncR_ ∷ ∀ b h. ToHtml_ b h
feFuncR_ = createElement_ "feFuncR"

feFuncR' ∷ ∀ a h. ToHtml' a h
feFuncR' = createElement' "feFuncR"

feGaussianBlur ∷ ∀ a b h. ToHtml a b h
feGaussianBlur = createElement "feGaussianBlur"

feGaussianBlur_ ∷ ∀ b h. ToHtml_ b h
feGaussianBlur_ = createElement_ "feGaussianBlur"

feGaussianBlur' ∷ ∀ a h. ToHtml' a h
feGaussianBlur' = createElement' "feGaussianBlur"

feImage ∷ ∀ a b h. ToHtml a b h
feImage = createElement "feImage"

feImage_ ∷ ∀ b h. ToHtml_ b h
feImage_ = createElement_ "feImage"

feImage' ∷ ∀ a h. ToHtml' a h
feImage' = createElement' "feImage"

feMerge ∷ ∀ a b h. ToHtml a b h
feMerge = createElement "feMerge"

feMerge_ ∷ ∀ b h. ToHtml_ b h
feMerge_ = createElement_ "feMerge"

feMerge' ∷ ∀ a h. ToHtml' a h
feMerge' = createElement' "feMerge"

feMergeNode ∷ ∀ a b h. ToHtml a b h
feMergeNode = createElement "feMergeNode"

feMergeNode_ ∷ ∀ b h. ToHtml_ b h
feMergeNode_ = createElement_ "feMergeNode"

feMergeNode' ∷ ∀ a h. ToHtml' a h
feMergeNode' = createElement' "feMergeNode"

feMorphology ∷ ∀ a b h. ToHtml a b h
feMorphology = createElement "feMorphology"

feMorphology_ ∷ ∀ b h. ToHtml_ b h
feMorphology_ = createElement_ "feMorphology"

feMorphology' ∷ ∀ a h. ToHtml' a h
feMorphology' = createElement' "feMorphology"

feOffset ∷ ∀ a b h. ToHtml a b h
feOffset = createElement "feOffset"

feOffset_ ∷ ∀ b h. ToHtml_ b h
feOffset_ = createElement_ "feOffset"

feOffset' ∷ ∀ a h. ToHtml' a h
feOffset' = createElement' "feOffset"

fePointLight ∷ ∀ a b h. ToHtml a b h
fePointLight = createElement "fePointLight"

fePointLight_ ∷ ∀ b h. ToHtml_ b h
fePointLight_ = createElement_ "fePointLight"

fePointLight' ∷ ∀ a h. ToHtml' a h
fePointLight' = createElement' "fePointLight"

feSpecularLighting ∷ ∀ a b h. ToHtml a b h
feSpecularLighting = createElement "feSpecularLighting"

feSpecularLighting_ ∷ ∀ b h. ToHtml_ b h
feSpecularLighting_ = createElement_ "feSpecularLighting"

feSpecularLighting' ∷ ∀ a h. ToHtml' a h
feSpecularLighting' = createElement' "feSpecularLighting"

feSpotLight ∷ ∀ a b h. ToHtml a b h
feSpotLight = createElement "feSpotLight"

feSpotLight_ ∷ ∀ b h. ToHtml_ b h
feSpotLight_ = createElement_ "feSpotLight"

feSpotLight' ∷ ∀ a h. ToHtml' a h
feSpotLight' = createElement' "feSpotLight"

feTile ∷ ∀ a b h. ToHtml a b h
feTile = createElement "feTile"

feTile_ ∷ ∀ b h. ToHtml_ b h
feTile_ = createElement_ "feTile"

feTile' ∷ ∀ a h. ToHtml' a h
feTile' = createElement' "feTile"

feTurbulence ∷ ∀ a b h. ToHtml a b h
feTurbulence = createElement "feTurbulence"

feTurbulence_ ∷ ∀ b h. ToHtml_ b h
feTurbulence_ = createElement_ "feTurbulence"

feTurbulence' ∷ ∀ a h. ToHtml' a h
feTurbulence' = createElement' "feTurbulence"

filter ∷ ∀ a b h. ToHtml a b h
filter = createElement "filter"

filter_ ∷ ∀ b h. ToHtml_ b h
filter_ = createElement_ "filter"

filter' ∷ ∀ a h. ToHtml' a h
filter' = createElement' "filter"

font ∷ ∀ a b h. ToHtml a b h
font = createElement "font"

font_ ∷ ∀ b h. ToHtml_ b h
font_ = createElement_ "font"

font' ∷ ∀ a h. ToHtml' a h
font' = createElement' "font"

fontFace ∷ ∀ a b h. ToHtml a b h
fontFace = createElement "font-face"

fontFace_ ∷ ∀ b h. ToHtml_ b h
fontFace_ = createElement_ "font-face"

fontFace' ∷ ∀ a h. ToHtml' a h
fontFace' = createElement' "font-face"

fontFaceFormat ∷ ∀ a b h. ToHtml a b h
fontFaceFormat = createElement "font-face-format"

fontFaceFormat_ ∷ ∀ b h. ToHtml_ b h
fontFaceFormat_ = createElement_ "font-face-format"

fontFaceFormat' ∷ ∀ a h. ToHtml' a h
fontFaceFormat' = createElement' "font-face-format"

fontFaceName ∷ ∀ a b h. ToHtml a b h
fontFaceName = createElement "font-face-name"

fontFaceName_ ∷ ∀ b h. ToHtml_ b h
fontFaceName_ = createElement_ "font-face-name"

fontFaceName' ∷ ∀ a h. ToHtml' a h
fontFaceName' = createElement' "font-face-name"

fontFaceSrc ∷ ∀ a b h. ToHtml a b h
fontFaceSrc = createElement "font-face-src"

fontFaceSrc_ ∷ ∀ b h. ToHtml_ b h
fontFaceSrc_ = createElement_ "font-face-src"

fontFaceSrc' ∷ ∀ a h. ToHtml' a h
fontFaceSrc' = createElement' "font-face-src"

fontFaceUri ∷ ∀ a b h. ToHtml a b h
fontFaceUri = createElement "font-face-uri"

fontFaceUri_ ∷ ∀ b h. ToHtml_ b h
fontFaceUri_ = createElement_ "font-face-uri"

fontFaceUri' ∷ ∀ a h. ToHtml' a h
fontFaceUri' = createElement' "font-face-uri"

foreignObject ∷ ∀ a b h. ToHtml a b h
foreignObject = createElement "foreignObject"

foreignObject_ ∷ ∀ b h. ToHtml_ b h
foreignObject_ = createElement_ "foreignObject"

foreignObject' ∷ ∀ a h. ToHtml' a h
foreignObject' = createElement' "foreignObject"

g ∷ ∀ a b h. ToHtml a b h
g = createElement "g"

g_ ∷ ∀ b h. ToHtml_ b h
g_ = createElement_ "g"

g' ∷ ∀ a h. ToHtml' a h
g' = createElement' "g"

glyph ∷ ∀ a b h. ToHtml a b h
glyph = createElement "glyph"

glyph_ ∷ ∀ b h. ToHtml_ b h
glyph_ = createElement_ "glyph"

glyph' ∷ ∀ a h. ToHtml' a h
glyph' = createElement' "glyph"

glyphRef ∷ ∀ a b h. ToHtml a b h
glyphRef = createElement "glyphRef"

glyphRef_ ∷ ∀ b h. ToHtml_ b h
glyphRef_ = createElement_ "glyphRef"

glyphRef' ∷ ∀ a h. ToHtml' a h
glyphRef' = createElement' "glyphRef"

hatch ∷ ∀ a b h. ToHtml a b h
hatch = createElement "hatch"

hatch_ ∷ ∀ b h. ToHtml_ b h
hatch_ = createElement_ "hatch"

hatch' ∷ ∀ a h. ToHtml' a h
hatch' = createElement' "hatch"

hatchpath ∷ ∀ a b h. ToHtml a b h
hatchpath = createElement "hatchpath"

hatchpath_ ∷ ∀ b h. ToHtml_ b h
hatchpath_ = createElement_ "hatchpath"

hatchpath' ∷ ∀ a h. ToHtml' a h
hatchpath' = createElement' "hatchpath"

hkern ∷ ∀ a b h. ToHtml a b h
hkern = createElement "hkern"

hkern_ ∷ ∀ b h. ToHtml_ b h
hkern_ = createElement_ "hkern"

hkern' ∷ ∀ a h. ToHtml' a h
hkern' = createElement' "hkern"

image ∷ ∀ a b h. ToHtml a b h
image = createElement "image"

image_ ∷ ∀ b h. ToHtml_ b h
image_ = createElement_ "image"

image' ∷ ∀ a h. ToHtml' a h
image' = createElement' "image"

line ∷ ∀ a b h. ToHtml a b h
line = createElement "line"

line_ ∷ ∀ b h. ToHtml_ b h
line_ = createElement_ "line"

line' ∷ ∀ a h. ToHtml' a h
line' = createElement' "line"

linearGradient ∷ ∀ a b h. ToHtml a b h
linearGradient = createElement "linearGradient"

linearGradient_ ∷ ∀ b h. ToHtml_ b h
linearGradient_ = createElement_ "linearGradient"

linearGradient' ∷ ∀ a h. ToHtml' a h
linearGradient' = createElement' "linearGradient"

marker ∷ ∀ a b h. ToHtml a b h
marker = createElement "marker"

marker_ ∷ ∀ b h. ToHtml_ b h
marker_ = createElement_ "marker"

marker' ∷ ∀ a h. ToHtml' a h
marker' = createElement' "marker"

mask ∷ ∀ a b h. ToHtml a b h
mask = createElement "mask"

mask_ ∷ ∀ b h. ToHtml_ b h
mask_ = createElement_ "mask"

mask' ∷ ∀ a h. ToHtml' a h
mask' = createElement' "mask"

mesh ∷ ∀ a b h. ToHtml a b h
mesh = createElement "mesh"

mesh_ ∷ ∀ b h. ToHtml_ b h
mesh_ = createElement_ "mesh"

mesh' ∷ ∀ a h. ToHtml' a h
mesh' = createElement' "mesh"

meshgradient ∷ ∀ a b h. ToHtml a b h
meshgradient = createElement "meshgradient"

meshgradient_ ∷ ∀ b h. ToHtml_ b h
meshgradient_ = createElement_ "meshgradient"

meshgradient' ∷ ∀ a h. ToHtml' a h
meshgradient' = createElement' "meshgradient"

meshpatch ∷ ∀ a b h. ToHtml a b h
meshpatch = createElement "meshpatch"

meshpatch_ ∷ ∀ b h. ToHtml_ b h
meshpatch_ = createElement_ "meshpatch"

meshpatch' ∷ ∀ a h. ToHtml' a h
meshpatch' = createElement' "meshpatch"

meshrow ∷ ∀ a b h. ToHtml a b h
meshrow = createElement "meshrow"

meshrow_ ∷ ∀ b h. ToHtml_ b h
meshrow_ = createElement_ "meshrow"

meshrow' ∷ ∀ a h. ToHtml' a h
meshrow' = createElement' "meshrow"

metadata ∷ ∀ a b h. ToHtml a b h
metadata = createElement "metadata"

metadata_ ∷ ∀ b h. ToHtml_ b h
metadata_ = createElement_ "metadata"

metadata' ∷ ∀ a h. ToHtml' a h
metadata' = createElement' "metadata"

missingGlyph ∷ ∀ a b h. ToHtml a b h
missingGlyph = createElement "missing-glyph"

missingGlyph_ ∷ ∀ b h. ToHtml_ b h
missingGlyph_ = createElement_ "missing-glyph"

missingGlyph' ∷ ∀ a h. ToHtml' a h
missingGlyph' = createElement' "missing-glyph"

mpath ∷ ∀ a b h. ToHtml a b h
mpath = createElement "mpath"

mpath_ ∷ ∀ b h. ToHtml_ b h
mpath_ = createElement_ "mpath"

mpath' ∷ ∀ a h. ToHtml' a h
mpath' = createElement' "mpath"

path ∷ ∀ a b h. ToHtml a b h
path = createElement "path"

path_ ∷ ∀ b h. ToHtml_ b h
path_ = createElement_ "path"

path' ∷ ∀ a h. ToHtml' a h
path' = createElement' "path"

pattern ∷ ∀ a b h. ToHtml a b h
pattern = createElement "pattern"

pattern_ ∷ ∀ b h. ToHtml_ b h
pattern_ = createElement_ "pattern"

pattern' ∷ ∀ a h. ToHtml' a h
pattern' = createElement' "pattern"

polygon ∷ ∀ a b h. ToHtml a b h
polygon = createElement "polygon"

polygon_ ∷ ∀ b h. ToHtml_ b h
polygon_ = createElement_ "polygon"

polygon' ∷ ∀ a h. ToHtml' a h
polygon' = createElement' "polygon"

polyline ∷ ∀ a b h. ToHtml a b h
polyline = createElement "polyline"

polyline_ ∷ ∀ b h. ToHtml_ b h
polyline_ = createElement_ "polyline"

polyline' ∷ ∀ a h. ToHtml' a h
polyline' = createElement' "polyline"

radialGradient ∷ ∀ a b h. ToHtml a b h
radialGradient = createElement "radialGradient"

radialGradient_ ∷ ∀ b h. ToHtml_ b h
radialGradient_ = createElement_ "radialGradient"

radialGradient' ∷ ∀ a h. ToHtml' a h
radialGradient' = createElement' "radialGradient"

rect ∷ ∀ a b h. ToHtml a b h
rect = createElement "rect"

rect_ ∷ ∀ b h. ToHtml_ b h
rect_ = createElement_ "rect"

rect' ∷ ∀ a h. ToHtml' a h
rect' = createElement' "rect"

script ∷ ∀ a b h. ToHtml a b h
script = createElement "script"

script_ ∷ ∀ b h. ToHtml_ b h
script_ = createElement_ "script"

script' ∷ ∀ a h. ToHtml' a h
script' = createElement' "script"

set ∷ ∀ a b h. ToHtml a b h
set = createElement "set"

set_ ∷ ∀ b h. ToHtml_ b h
set_ = createElement_ "set"

set' ∷ ∀ a h. ToHtml' a h
set' = createElement' "set"

solidcolor ∷ ∀ a b h. ToHtml a b h
solidcolor = createElement "solidcolor"

solidcolor_ ∷ ∀ b h. ToHtml_ b h
solidcolor_ = createElement_ "solidcolor"

solidcolor' ∷ ∀ a h. ToHtml' a h
solidcolor' = createElement' "solidcolor"

stop ∷ ∀ a b h. ToHtml a b h
stop = createElement "stop"

stop_ ∷ ∀ b h. ToHtml_ b h
stop_ = createElement_ "stop"

stop' ∷ ∀ a h. ToHtml' a h
stop' = createElement' "stop"

switch ∷ ∀ a b h. ToHtml a b h
switch = createElement "switch"

switch_ ∷ ∀ b h. ToHtml_ b h
switch_ = createElement_ "switch"

switch' ∷ ∀ a h. ToHtml' a h
switch' = createElement' "switch"

symbol ∷ ∀ a b h. ToHtml a b h
symbol = createElement "symbol"

symbol_ ∷ ∀ b h. ToHtml_ b h
symbol_ = createElement_ "symbol"

symbol' ∷ ∀ a h. ToHtml' a h
symbol' = createElement' "symbol"

textPath ∷ ∀ a b h. ToHtml a b h
textPath = createElement "textPath"

textPath_ ∷ ∀ b h. ToHtml_ b h
textPath_ = createElement_ "textPath"

textPath' ∷ ∀ a h. ToHtml' a h
textPath' = createElement' "textPath"

tref ∷ ∀ a b h. ToHtml a b h
tref = createElement "tref"

tref_ ∷ ∀ b h. ToHtml_ b h
tref_ = createElement_ "tref"

tref' ∷ ∀ a h. ToHtml' a h
tref' = createElement' "tref"

tspan ∷ ∀ a b h. ToHtml a b h
tspan = createElement "tspan"

tspan_ ∷ ∀ b h. ToHtml_ b h
tspan_ = createElement_ "tspan"

tspan' ∷ ∀ a h. ToHtml' a h
tspan' = createElement' "tspan"

unknown ∷ ∀ a b h. ToHtml a b h
unknown = createElement "unknown"

unknown_ ∷ ∀ b h. ToHtml_ b h
unknown_ = createElement_ "unknown"

unknown' ∷ ∀ a h. ToHtml' a h
unknown' = createElement' "unknown"

use ∷ ∀ a b h. ToHtml a b h
use = createElement "use"

use_ ∷ ∀ b h. ToHtml_ b h
use_ = createElement_ "use"

use' ∷ ∀ a h. ToHtml' a h
use' = createElement' "use"

view ∷ ∀ a b h. ToHtml a b h
view = createElement "view"

view_ ∷ ∀ b h. ToHtml_ b h
view_ = createElement_ "view"

view' ∷ ∀ a h. ToHtml' a h
view' = createElement' "view"

vkern ∷ ∀ a b h. ToHtml a b h
vkern = createElement "vkern"

vkern_ ∷ ∀ b h. ToHtml_ b h
vkern_ = createElement_ "vkern"

vkern' ∷ ∀ a h. ToHtml' a h
vkern' = createElement' "vkern"
