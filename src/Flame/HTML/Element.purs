-- | Definition of HTML elements
module Flame.HTML.Element where

import Prelude

import Data.Array as DA
import Flame.Types (NodeData, Element(..), Tag)
import Flame.HTML.Attribute.Internal as FHAI

-- | `ToHtml` simplifies element creation by automating common tag operations
-- | * `tag "my-tag" []` becomes short for `tag [id "my-tag"] []`
-- | * `tag [] "content"` becomes short for `tag [] [text "content"]`
-- | * elements with a single attribute or children need not as well to use lists: `tag (enabled True) (tag attrs children)`
-- blaze like syntax would be nicer but the only ps port available (smolder) seems to be slow and not mantained
class ToHtml a b c | a -> b where
	to :: a -> Array (c b)

instance stringToHtml :: ToHtml String b Element where
	to = DA.singleton <<< text

instance arrayToHtml :: (ToHtml a b c) => ToHtml (Array a) b c where
	to = DA.concatMap to

instance htmlToHtml :: ToHtml (Element a) a Element where
	to = DA.singleton

instance stringToElementData :: ToHtml String b NodeData where
	to = DA.singleton <<< FHAI.id

instance attributeEventToElementData :: ToHtml (NodeData a) a NodeData where
	to = DA.singleton

type ToElement a b h = ToHtml a h NodeData => ToHtml b h Element => a -> b -> Element h

type ToElement_ b h = ToHtml b h Element => b -> Element h

type ToElement' a h = ToHtml a h NodeData => a -> Element h

-- | Creates a HTML element with attributes and children nodes
createElement :: forall a b h. Tag -> ToElement a b h
createElement tag attributeEvent = Node tag (to attributeEvent) <<< to

-- | Creates a HTML element with no attributes but children nodes
createElement_ :: forall b h. Tag -> ToElement_ b h
createElement_ tag = Node tag [] <<< to

-- | Creates a HTML element with attributes but no children nodes
createElement' :: forall a h. Tag -> ToElement' a h
createElement' tag attributeEvent = Node tag (to attributeEvent) []

-- | Creates a HTML element with no attributes and no children nodes
createEmptyElement :: forall h. Tag -> Element h
createEmptyElement tag = Node tag [] []

-- | Creates a text node
text :: forall h. String -> Element h
text = Text

hr :: forall h. Element h
hr = createEmptyElement "hr"

hr_ :: forall b h. ToElement_ b h
hr_ = createElement_ "hr"

hr' :: forall a h. ToElement' a h
hr' = createElement' "hr"

br :: forall h. Element h
br = createEmptyElement "br"

br' :: forall a h. ToElement' a h
br' = createElement' "br"

input :: forall a h. ToElement' a h
input = createElement' "input"

input_ :: forall a h. ToElement_ a h
input_ = createElement_ "input"

--script generated

a :: forall a b h. ToElement a b h
a = createElement "a"

a_ :: forall b h. ToElement_ b h
a_ = createElement_ "a"

a' :: forall a h. ToElement' a h
a' = createElement' "a"

address :: forall a b h. ToElement a b h
address = createElement "address"

address_ :: forall b h. ToElement_ b h
address_ = createElement_ "address"

address' :: forall a h. ToElement' a h
address' = createElement' "address"

area :: forall a b h. ToElement a b h
area = createElement "area"

area_ :: forall b h. ToElement_ b h
area_ = createElement_ "area"

area' :: forall a h. ToElement' a h
area' = createElement' "area"

article :: forall a b h. ToElement a b h
article = createElement "article"

article_ :: forall b h. ToElement_ b h
article_ = createElement_ "article"

article' :: forall a h. ToElement' a h
article' = createElement' "article"

aside :: forall a b h. ToElement a b h
aside = createElement "aside"

aside_ :: forall b h. ToElement_ b h
aside_ = createElement_ "aside"

aside' :: forall a h. ToElement' a h
aside' = createElement' "aside"

audio :: forall a b h. ToElement a b h
audio = createElement "audio"

audio_ :: forall b h. ToElement_ b h
audio_ = createElement_ "audio"

audio' :: forall a h. ToElement' a h
audio' = createElement' "audio"

b :: forall a b h. ToElement a b h
b = createElement "b"

b_ :: forall b h. ToElement_ b h
b_ = createElement_ "b"

b' :: forall a h. ToElement' a h
b' = createElement' "b"

base :: forall a b h. ToElement a b h
base = createElement "base"

base_ :: forall b h. ToElement_ b h
base_ = createElement_ "base"

base' :: forall a h. ToElement' a h
base' = createElement' "base"

bdi :: forall a b h. ToElement a b h
bdi = createElement "bdi"

bdi_ :: forall b h. ToElement_ b h
bdi_ = createElement_ "bdi"

bdi' :: forall a h. ToElement' a h
bdi' = createElement' "bdi"

bdo :: forall a b h. ToElement a b h
bdo = createElement "bdo"

bdo_ :: forall b h. ToElement_ b h
bdo_ = createElement_ "bdo"

bdo' :: forall a h. ToElement' a h
bdo' = createElement' "bdo"

blockquote :: forall a b h. ToElement a b h
blockquote = createElement "blockquote"

blockquote_ :: forall b h. ToElement_ b h
blockquote_ = createElement_ "blockquote"

blockquote' :: forall a h. ToElement' a h
blockquote' = createElement' "blockquote"

body :: forall a b h. ToElement a b h
body = createElement "body"

body_ :: forall b h. ToElement_ b h
body_ = createElement_ "body"

body' :: forall a h. ToElement' a h
body' = createElement' "body"

button :: forall a b h. ToElement a b h
button = createElement "button"

button_ :: forall b h. ToElement_ b h
button_ = createElement_ "button"

button' :: forall a h. ToElement' a h
button' = createElement' "button"

canvas :: forall a b h. ToElement a b h
canvas = createElement "canvas"

canvas_ :: forall b h. ToElement_ b h
canvas_ = createElement_ "canvas"

canvas' :: forall a h. ToElement' a h
canvas' = createElement' "canvas"

caption :: forall a b h. ToElement a b h
caption = createElement "caption"

caption_ :: forall b h. ToElement_ b h
caption_ = createElement_ "caption"

caption' :: forall a h. ToElement' a h
caption' = createElement' "caption"

cite :: forall a b h. ToElement a b h
cite = createElement "cite"

cite_ :: forall b h. ToElement_ b h
cite_ = createElement_ "cite"

cite' :: forall a h. ToElement' a h
cite' = createElement' "cite"

code :: forall a b h. ToElement a b h
code = createElement "code"

code_ :: forall b h. ToElement_ b h
code_ = createElement_ "code"

code' :: forall a h. ToElement' a h
code' = createElement' "code"

col :: forall a b h. ToElement a b h
col = createElement "col"

col_ :: forall b h. ToElement_ b h
col_ = createElement_ "col"

col' :: forall a h. ToElement' a h
col' = createElement' "col"

colgroup :: forall a b h. ToElement a b h
colgroup = createElement "colgroup"

colgroup_ :: forall b h. ToElement_ b h
colgroup_ = createElement_ "colgroup"

colgroup' :: forall a h. ToElement' a h
colgroup' = createElement' "colgroup"

data_ :: forall b h. ToElement_ b h
data_ = createElement_ "data"

data' :: forall a h. ToElement' a h
data' = createElement' "data"

datalist :: forall a b h. ToElement a b h
datalist = createElement "datalist"

datalist_ :: forall b h. ToElement_ b h
datalist_ = createElement_ "datalist"

datalist' :: forall a h. ToElement' a h
datalist' = createElement' "datalist"

dd :: forall a b h. ToElement a b h
dd = createElement "dd"

dd_ :: forall b h. ToElement_ b h
dd_ = createElement_ "dd"

dd' :: forall a h. ToElement' a h
dd' = createElement' "dd"

del :: forall a b h. ToElement a b h
del = createElement "del"

del_ :: forall b h. ToElement_ b h
del_ = createElement_ "del"

del' :: forall a h. ToElement' a h
del' = createElement' "del"

details :: forall a b h. ToElement a b h
details = createElement "details"

details_ :: forall b h. ToElement_ b h
details_ = createElement_ "details"

details' :: forall a h. ToElement' a h
details' = createElement' "details"

dfn :: forall a b h. ToElement a b h
dfn = createElement "dfn"

dfn_ :: forall b h. ToElement_ b h
dfn_ = createElement_ "dfn"

dfn' :: forall a h. ToElement' a h
dfn' = createElement' "dfn"

dialog :: forall a b h. ToElement a b h
dialog = createElement "dialog"

dialog_ :: forall b h. ToElement_ b h
dialog_ = createElement_ "dialog"

dialog' :: forall a h. ToElement' a h
dialog' = createElement' "dialog"

div :: forall a b h. ToElement a b h
div = createElement "div"

div_ :: forall b h. ToElement_ b h
div_ = createElement_ "div"

div' :: forall a h. ToElement' a h
div' = createElement' "div"

dl :: forall a b h. ToElement a b h
dl = createElement "dl"

dl_ :: forall b h. ToElement_ b h
dl_ = createElement_ "dl"

dl' :: forall a h. ToElement' a h
dl' = createElement' "dl"

dt :: forall a b h. ToElement a b h
dt = createElement "dt"

dt_ :: forall b h. ToElement_ b h
dt_ = createElement_ "dt"

dt' :: forall a h. ToElement' a h
dt' = createElement' "dt"

em :: forall a b h. ToElement a b h
em = createElement "em"

em_ :: forall b h. ToElement_ b h
em_ = createElement_ "em"

em' :: forall a h. ToElement' a h
em' = createElement' "em"

embed :: forall a b h. ToElement a b h
embed = createElement "embed"

embed_ :: forall b h. ToElement_ b h
embed_ = createElement_ "embed"

embed' :: forall a h. ToElement' a h
embed' = createElement' "embed"

fieldset :: forall a b h. ToElement a b h
fieldset = createElement "fieldset"

fieldset_ :: forall b h. ToElement_ b h
fieldset_ = createElement_ "fieldset"

fieldset' :: forall a h. ToElement' a h
fieldset' = createElement' "fieldset"

figure :: forall a b h. ToElement a b h
figure = createElement "figure"

figure_ :: forall b h. ToElement_ b h
figure_ = createElement_ "figure"

figure' :: forall a h. ToElement' a h
figure' = createElement' "figure"

footer :: forall a b h. ToElement a b h
footer = createElement "footer"

footer_ :: forall b h. ToElement_ b h
footer_ = createElement_ "footer"

footer' :: forall a h. ToElement' a h
footer' = createElement' "footer"

form :: forall a b h. ToElement a b h
form = createElement "form"

form_ :: forall b h. ToElement_ b h
form_ = createElement_ "form"

form' :: forall a h. ToElement' a h
form' = createElement' "form"

h1 :: forall a b h. ToElement a b h
h1 = createElement "h1"

h1_ :: forall b h. ToElement_ b h
h1_ = createElement_ "h1"

h1' :: forall a h. ToElement' a h
h1' = createElement' "h1"

h2 :: forall a b h. ToElement a b h
h2 = createElement "h2"

h2_ :: forall b h. ToElement_ b h
h2_ = createElement_ "h2"

h2' :: forall a h. ToElement' a h
h2' = createElement' "h2"

h3 :: forall a b h. ToElement a b h
h3 = createElement "h3"

h3_ :: forall b h. ToElement_ b h
h3_ = createElement_ "h3"

h3' :: forall a h. ToElement' a h
h3' = createElement' "h3"

h4 :: forall a b h. ToElement a b h
h4 = createElement "h4"

h4_ :: forall b h. ToElement_ b h
h4_ = createElement_ "h4"

h4' :: forall a h. ToElement' a h
h4' = createElement' "h4"

h5 :: forall a b h. ToElement a b h
h5 = createElement "h5"

h5_ :: forall b h. ToElement_ b h
h5_ = createElement_ "h5"

h5' :: forall a h. ToElement' a h
h5' = createElement' "h5"

h6 :: forall a b h. ToElement a b h
h6 = createElement "h6"

h6_ :: forall b h. ToElement_ b h
h6_ = createElement_ "h6"

h6' :: forall a h. ToElement' a h
h6' = createElement' "h6"

head :: forall a b h. ToElement a b h
head = createElement "head"

head_ :: forall b h. ToElement_ b h
head_ = createElement_ "head"

head' :: forall a h. ToElement' a h
head' = createElement' "head"

header :: forall a b h. ToElement a b h
header = createElement "header"

header_ :: forall b h. ToElement_ b h
header_ = createElement_ "header"

header' :: forall a h. ToElement' a h
header' = createElement' "header"

hgroup :: forall a b h. ToElement a b h
hgroup = createElement "hgroup"

hgroup_ :: forall b h. ToElement_ b h
hgroup_ = createElement_ "hgroup"

hgroup' :: forall a h. ToElement' a h
hgroup' = createElement' "hgroup"

html :: forall a b h. ToElement a b h
html = createElement "html"

html_ :: forall b h. ToElement_ b h
html_ = createElement_ "html"

html' :: forall a h. ToElement' a h
html' = createElement' "html"

i :: forall a b h. ToElement a b h
i = createElement "i"

i_ :: forall b h. ToElement_ b h
i_ = createElement_ "i"

i' :: forall a h. ToElement' a h
i' = createElement' "i"

iframe :: forall a b h. ToElement a b h
iframe = createElement "iframe"

iframe_ :: forall b h. ToElement_ b h
iframe_ = createElement_ "iframe"

iframe' :: forall a h. ToElement' a h
iframe' = createElement' "iframe"

ins :: forall a b h. ToElement a b h
ins = createElement "ins"

ins_ :: forall b h. ToElement_ b h
ins_ = createElement_ "ins"

ins' :: forall a h. ToElement' a h
ins' = createElement' "ins"

keygen :: forall a b h. ToElement a b h
keygen = createElement "keygen"

keygen_ :: forall b h. ToElement_ b h
keygen_ = createElement_ "keygen"

keygen' :: forall a h. ToElement' a h
keygen' = createElement' "keygen"

label :: forall a b h. ToElement a b h
label = createElement "label"

label_ :: forall b h. ToElement_ b h
label_ = createElement_ "label"

label' :: forall a h. ToElement' a h
label' = createElement' "label"

legend :: forall a b h. ToElement a b h
legend = createElement "legend"

legend_ :: forall b h. ToElement_ b h
legend_ = createElement_ "legend"

legend' :: forall a h. ToElement' a h
legend' = createElement' "legend"

li :: forall a b h. ToElement a b h
li = createElement "li"

li_ :: forall b h. ToElement_ b h
li_ = createElement_ "li"

li' :: forall a h. ToElement' a h
li' = createElement' "li"

link :: forall a b h. ToElement a b h
link = createElement "link"

link_ :: forall b h. ToElement_ b h
link_ = createElement_ "link"

link' :: forall a h. ToElement' a h
link' = createElement' "link"

main :: forall a b h. ToElement a b h
main = createElement "main"

main_ :: forall b h. ToElement_ b h
main_ = createElement_ "main"

main' :: forall a h. ToElement' a h
main' = createElement' "main"

map :: forall a b h. ToElement a b h
map = createElement "map"

map_ :: forall b h. ToElement_ b h
map_ = createElement_ "map"

map' :: forall a h. ToElement' a h
map' = createElement' "map"

mark :: forall a b h. ToElement a b h
mark = createElement "mark"

mark_ :: forall b h. ToElement_ b h
mark_ = createElement_ "mark"

mark' :: forall a h. ToElement' a h
mark' = createElement' "mark"

menu :: forall a b h. ToElement a b h
menu = createElement "menu"

menu_ :: forall b h. ToElement_ b h
menu_ = createElement_ "menu"

menu' :: forall a h. ToElement' a h
menu' = createElement' "menu"

menuitem :: forall a b h. ToElement a b h
menuitem = createElement "menuitem"

menuitem_ :: forall b h. ToElement_ b h
menuitem_ = createElement_ "menuitem"

menuitem' :: forall a h. ToElement' a h
menuitem' = createElement' "menuitem"

meta :: forall a b h. ToElement a b h
meta = createElement "meta"

meta_ :: forall b h. ToElement_ b h
meta_ = createElement_ "meta"

meta' :: forall a h. ToElement' a h
meta' = createElement' "meta"

meter :: forall a b h. ToElement a b h
meter = createElement "meter"

meter_ :: forall b h. ToElement_ b h
meter_ = createElement_ "meter"

meter' :: forall a h. ToElement' a h
meter' = createElement' "meter"

nav :: forall a b h. ToElement a b h
nav = createElement "nav"

nav_ :: forall b h. ToElement_ b h
nav_ = createElement_ "nav"

nav' :: forall a h. ToElement' a h
nav' = createElement' "nav"

noscript :: forall a b h. ToElement a b h
noscript = createElement "noscript"

noscript_ :: forall b h. ToElement_ b h
noscript_ = createElement_ "noscript"

noscript' :: forall a h. ToElement' a h
noscript' = createElement' "noscript"

object :: forall a b h. ToElement a b h
object = createElement "object"

object_ :: forall b h. ToElement_ b h
object_ = createElement_ "object"

object' :: forall a h. ToElement' a h
object' = createElement' "object"

ol :: forall a b h. ToElement a b h
ol = createElement "ol"

ol_ :: forall b h. ToElement_ b h
ol_ = createElement_ "ol"

ol' :: forall a h. ToElement' a h
ol' = createElement' "ol"

optgroup :: forall a b h. ToElement a b h
optgroup = createElement "optgroup"

optgroup_ :: forall b h. ToElement_ b h
optgroup_ = createElement_ "optgroup"

optgroup' :: forall a h. ToElement' a h
optgroup' = createElement' "optgroup"

option :: forall a b h. ToElement a b h
option = createElement "option"

option_ :: forall b h. ToElement_ b h
option_ = createElement_ "option"

option' :: forall a h. ToElement' a h
option' = createElement' "option"

output :: forall a b h. ToElement a b h
output = createElement "output"

output_ :: forall b h. ToElement_ b h
output_ = createElement_ "output"

output' :: forall a h. ToElement' a h
output' = createElement' "output"

p :: forall a b h. ToElement a b h
p = createElement "p"

p_ :: forall b h. ToElement_ b h
p_ = createElement_ "p"

p' :: forall a h. ToElement' a h
p' = createElement' "p"

param :: forall a b h. ToElement a b h
param = createElement "param"

param_ :: forall b h. ToElement_ b h
param_ = createElement_ "param"

param' :: forall a h. ToElement' a h
param' = createElement' "param"

pre :: forall a b h. ToElement a b h
pre = createElement "pre"

pre_ :: forall b h. ToElement_ b h
pre_ = createElement_ "pre"

pre' :: forall a h. ToElement' a h
pre' = createElement' "pre"

progress :: forall a b h. ToElement a b h
progress = createElement "progress"

progress_ :: forall b h. ToElement_ b h
progress_ = createElement_ "progress"

progress' :: forall a h. ToElement' a h
progress' = createElement' "progress"

q :: forall a b h. ToElement a b h
q = createElement "q"

q_ :: forall b h. ToElement_ b h
q_ = createElement_ "q"

q' :: forall a h. ToElement' a h
q' = createElement' "q"

rb :: forall a b h. ToElement a b h
rb = createElement "rb"

rb_ :: forall b h. ToElement_ b h
rb_ = createElement_ "rb"

rb' :: forall a h. ToElement' a h
rb' = createElement' "rb"

rp :: forall a b h. ToElement a b h
rp = createElement "rp"

rp_ :: forall b h. ToElement_ b h
rp_ = createElement_ "rp"

rp' :: forall a h. ToElement' a h
rp' = createElement' "rp"

rt :: forall a b h. ToElement a b h
rt = createElement "rt"

rt_ :: forall b h. ToElement_ b h
rt_ = createElement_ "rt"

rt' :: forall a h. ToElement' a h
rt' = createElement' "rt"

rtc :: forall a b h. ToElement a b h
rtc = createElement "rtc"

rtc_ :: forall b h. ToElement_ b h
rtc_ = createElement_ "rtc"

rtc' :: forall a h. ToElement' a h
rtc' = createElement' "rtc"

ruby :: forall a b h. ToElement a b h
ruby = createElement "ruby"

ruby_ :: forall b h. ToElement_ b h
ruby_ = createElement_ "ruby"

ruby' :: forall a h. ToElement' a h
ruby' = createElement' "ruby"

s :: forall a b h. ToElement a b h
s = createElement "s"

s_ :: forall b h. ToElement_ b h
s_ = createElement_ "s"

s' :: forall a h. ToElement' a h
s' = createElement' "s"

section :: forall a b h. ToElement a b h
section = createElement "section"

section_ :: forall b h. ToElement_ b h
section_ = createElement_ "section"

section' :: forall a h. ToElement' a h
section' = createElement' "section"

select :: forall a b h. ToElement a b h
select = createElement "select"

select_ :: forall b h. ToElement_ b h
select_ = createElement_ "select"

select' :: forall a h. ToElement' a h
select' = createElement' "select"

small :: forall a b h. ToElement a b h
small = createElement "small"

small_ :: forall b h. ToElement_ b h
small_ = createElement_ "small"

small' :: forall a h. ToElement' a h
small' = createElement' "small"

source :: forall a b h. ToElement a b h
source = createElement "source"

source_ :: forall b h. ToElement_ b h
source_ = createElement_ "source"

source' :: forall a h. ToElement' a h
source' = createElement' "source"

span :: forall a b h. ToElement a b h
span = createElement "span"

span_ :: forall b h. ToElement_ b h
span_ = createElement_ "span"

span' :: forall a h. ToElement' a h
span' = createElement' "span"

strong :: forall a b h. ToElement a b h
strong = createElement "strong"

strong_ :: forall b h. ToElement_ b h
strong_ = createElement_ "strong"

strong' :: forall a h. ToElement' a h
strong' = createElement' "strong"

style :: forall a b h. ToElement a b h
style = createElement "style"

style_ :: forall b h. ToElement_ b h
style_ = createElement_ "style"

style' :: forall a h. ToElement' a h
style' = createElement' "style"

sub :: forall a b h. ToElement a b h
sub = createElement "sub"

sub_ :: forall b h. ToElement_ b h
sub_ = createElement_ "sub"

sub' :: forall a h. ToElement' a h
sub' = createElement' "sub"

summary :: forall a b h. ToElement a b h
summary = createElement "summary"

summary_ :: forall b h. ToElement_ b h
summary_ = createElement_ "summary"

summary' :: forall a h. ToElement' a h
summary' = createElement' "summary"

sup :: forall a b h. ToElement a b h
sup = createElement "sup"

sup_ :: forall b h. ToElement_ b h
sup_ = createElement_ "sup"

sup' :: forall a h. ToElement' a h
sup' = createElement' "sup"

table :: forall a b h. ToElement a b h
table = createElement "table"

table_ :: forall b h. ToElement_ b h
table_ = createElement_ "table"

table' :: forall a h. ToElement' a h
table' = createElement' "table"

tbody :: forall a b h. ToElement a b h
tbody = createElement "tbody"

tbody_ :: forall b h. ToElement_ b h
tbody_ = createElement_ "tbody"

tbody' :: forall a h. ToElement' a h
tbody' = createElement' "tbody"

td :: forall a b h. ToElement a b h
td = createElement "td"

td_ :: forall b h. ToElement_ b h
td_ = createElement_ "td"

td' :: forall a h. ToElement' a h
td' = createElement' "td"

template :: forall a b h. ToElement a b h
template = createElement "template"

template_ :: forall b h. ToElement_ b h
template_ = createElement_ "template"

template' :: forall a h. ToElement' a h
template' = createElement' "template"

textarea :: forall a b h. ToElement a b h
textarea = createElement "textarea"

textarea_ :: forall b h. ToElement_ b h
textarea_ = createElement_ "textarea"

textarea' :: forall a h. ToElement' a h
textarea' = createElement' "textarea"

tfoot :: forall a b h. ToElement a b h
tfoot = createElement "tfoot"

tfoot_ :: forall b h. ToElement_ b h
tfoot_ = createElement_ "tfoot"

tfoot' :: forall a h. ToElement' a h
tfoot' = createElement' "tfoot"

th :: forall a b h. ToElement a b h
th = createElement "th"

th_ :: forall b h. ToElement_ b h
th_ = createElement_ "th"

th' :: forall a h. ToElement' a h
th' = createElement' "th"

thead :: forall a b h. ToElement a b h
thead = createElement "thead"

thead_ :: forall b h. ToElement_ b h
thead_ = createElement_ "thead"

thead' :: forall a h. ToElement' a h
thead' = createElement' "thead"

time :: forall a b h. ToElement a b h
time = createElement "time"

time_ :: forall b h. ToElement_ b h
time_ = createElement_ "time"

time' :: forall a h. ToElement' a h
time' = createElement' "time"

title :: forall a b h. ToElement a b h
title = createElement "title"

title_ :: forall b h. ToElement_ b h
title_ = createElement_ "title"

title' :: forall a h. ToElement' a h
title' = createElement' "title"

tr :: forall a b h. ToElement a b h
tr = createElement "tr"

tr_ :: forall b h. ToElement_ b h
tr_ = createElement_ "tr"

tr' :: forall a h. ToElement' a h
tr' = createElement' "tr"

track :: forall a b h. ToElement a b h
track = createElement "track"

track_ :: forall b h. ToElement_ b h
track_ = createElement_ "track"

track' :: forall a h. ToElement' a h
track' = createElement' "track"

u :: forall a b h. ToElement a b h
u = createElement "u"

u_ :: forall b h. ToElement_ b h
u_ = createElement_ "u"

u' :: forall a h. ToElement' a h
u' = createElement' "u"

ul :: forall a b h. ToElement a b h
ul = createElement "ul"

ul_ :: forall b h. ToElement_ b h
ul_ = createElement_ "ul"

ul' :: forall a h. ToElement' a h
ul' = createElement' "ul"

var :: forall a b h. ToElement a b h
var = createElement "var"

var_ :: forall b h. ToElement_ b h
var_ = createElement_ "var"

var' :: forall a h. ToElement' a h
var' = createElement' "var"

video :: forall a b h. ToElement a b h
video = createElement "video"

video_ :: forall b h. ToElement_ b h
video_ = createElement_ "video"

video' :: forall a h. ToElement' a h
video' = createElement' "video"

wbr :: forall a b h. ToElement a b h
wbr = createElement "wbr"

wbr_ :: forall b h. ToElement_ b h
wbr_ = createElement_ "wbr"

wbr' :: forall a h. ToElement' a h
wbr' = createElement' "wbr"

animate :: forall a b h. ToElement a b h
animate = createElement "animate"

animate_ :: forall b h. ToElement_ b h
animate_ = createElement_ "animate"

animate' :: forall a h. ToElement' a h
animate' = createElement' "animate"

animateColor :: forall a b h. ToElement a b h
animateColor = createElement "animateColor"

animateColor_ :: forall b h. ToElement_ b h
animateColor_ = createElement_ "animateColor"

animateColor' :: forall a h. ToElement' a h
animateColor' = createElement' "animateColor"

animateMotion :: forall a b h. ToElement a b h
animateMotion = createElement "animateMotion"

animateMotion_ :: forall b h. ToElement_ b h
animateMotion_ = createElement_ "animateMotion"

animateMotion' :: forall a h. ToElement' a h
animateMotion' = createElement' "animateMotion"

animateTransform :: forall a b h. ToElement a b h
animateTransform = createElement "animateTransform"

animateTransform_ :: forall b h. ToElement_ b h
animateTransform_ = createElement_ "animateTransform"

animateTransform' :: forall a h. ToElement' a h
animateTransform' = createElement' "animateTransform"

circle :: forall a b h. ToElement a b h
circle = createElement "circle"

circle_ :: forall b h. ToElement_ b h
circle_ = createElement_ "circle"

circle' :: forall a h. ToElement' a h
circle' = createElement' "circle"

clipPath :: forall a b h. ToElement a b h
clipPath = createElement "clipPath"

clipPath_ :: forall b h. ToElement_ b h
clipPath_ = createElement_ "clipPath"

clipPath' :: forall a h. ToElement' a h
clipPath' = createElement' "clipPath"

colorProfile :: forall a b h. ToElement a b h
colorProfile = createElement "color-profile"

colorProfile_ :: forall b h. ToElement_ b h
colorProfile_ = createElement_ "color-profile"

colorProfile' :: forall a h. ToElement' a h
colorProfile' = createElement' "color-profile"

cursor :: forall a b h. ToElement a b h
cursor = createElement "cursor"

cursor_ :: forall b h. ToElement_ b h
cursor_ = createElement_ "cursor"

cursor' :: forall a h. ToElement' a h
cursor' = createElement' "cursor"

defs :: forall a b h. ToElement a b h
defs = createElement "defs"

defs_ :: forall b h. ToElement_ b h
defs_ = createElement_ "defs"

defs' :: forall a h. ToElement' a h
defs' = createElement' "defs"

desc :: forall a b h. ToElement a b h
desc = createElement "desc"

desc_ :: forall b h. ToElement_ b h
desc_ = createElement_ "desc"

desc' :: forall a h. ToElement' a h
desc' = createElement' "desc"

discard :: forall a b h. ToElement a b h
discard = createElement "discard"

discard_ :: forall b h. ToElement_ b h
discard_ = createElement_ "discard"

discard' :: forall a h. ToElement' a h
discard' = createElement' "discard"

ellipse :: forall a b h. ToElement a b h
ellipse = createElement "ellipse"

ellipse_ :: forall b h. ToElement_ b h
ellipse_ = createElement_ "ellipse"

ellipse' :: forall a h. ToElement' a h
ellipse' = createElement' "ellipse"

feBlend :: forall a b h. ToElement a b h
feBlend = createElement "feBlend"

feBlend_ :: forall b h. ToElement_ b h
feBlend_ = createElement_ "feBlend"

feBlend' :: forall a h. ToElement' a h
feBlend' = createElement' "feBlend"

feColorMatrix :: forall a b h. ToElement a b h
feColorMatrix = createElement "feColorMatrix"

feColorMatrix_ :: forall b h. ToElement_ b h
feColorMatrix_ = createElement_ "feColorMatrix"

feColorMatrix' :: forall a h. ToElement' a h
feColorMatrix' = createElement' "feColorMatrix"

feComponentTransfer :: forall a b h. ToElement a b h
feComponentTransfer = createElement "feComponentTransfer"

feComponentTransfer_ :: forall b h. ToElement_ b h
feComponentTransfer_ = createElement_ "feComponentTransfer"

feComponentTransfer' :: forall a h. ToElement' a h
feComponentTransfer' = createElement' "feComponentTransfer"

feComposite :: forall a b h. ToElement a b h
feComposite = createElement "feComposite"

feComposite_ :: forall b h. ToElement_ b h
feComposite_ = createElement_ "feComposite"

feComposite' :: forall a h. ToElement' a h
feComposite' = createElement' "feComposite"

feConvolveMatrix :: forall a b h. ToElement a b h
feConvolveMatrix = createElement "feConvolveMatrix"

feConvolveMatrix_ :: forall b h. ToElement_ b h
feConvolveMatrix_ = createElement_ "feConvolveMatrix"

feConvolveMatrix' :: forall a h. ToElement' a h
feConvolveMatrix' = createElement' "feConvolveMatrix"

feDiffuseLighting :: forall a b h. ToElement a b h
feDiffuseLighting = createElement "feDiffuseLighting"

feDiffuseLighting_ :: forall b h. ToElement_ b h
feDiffuseLighting_ = createElement_ "feDiffuseLighting"

feDiffuseLighting' :: forall a h. ToElement' a h
feDiffuseLighting' = createElement' "feDiffuseLighting"

feDisplacementMap :: forall a b h. ToElement a b h
feDisplacementMap = createElement "feDisplacementMap"

feDisplacementMap_ :: forall b h. ToElement_ b h
feDisplacementMap_ = createElement_ "feDisplacementMap"

feDisplacementMap' :: forall a h. ToElement' a h
feDisplacementMap' = createElement' "feDisplacementMap"

feDistantLight :: forall a b h. ToElement a b h
feDistantLight = createElement "feDistantLight"

feDistantLight_ :: forall b h. ToElement_ b h
feDistantLight_ = createElement_ "feDistantLight"

feDistantLight' :: forall a h. ToElement' a h
feDistantLight' = createElement' "feDistantLight"

feDropShadow :: forall a b h. ToElement a b h
feDropShadow = createElement "feDropShadow"

feDropShadow_ :: forall b h. ToElement_ b h
feDropShadow_ = createElement_ "feDropShadow"

feDropShadow' :: forall a h. ToElement' a h
feDropShadow' = createElement' "feDropShadow"

feFlood :: forall a b h. ToElement a b h
feFlood = createElement "feFlood"

feFlood_ :: forall b h. ToElement_ b h
feFlood_ = createElement_ "feFlood"

feFlood' :: forall a h. ToElement' a h
feFlood' = createElement' "feFlood"

feFuncA :: forall a b h. ToElement a b h
feFuncA = createElement "feFuncA"

feFuncA_ :: forall b h. ToElement_ b h
feFuncA_ = createElement_ "feFuncA"

feFuncA' :: forall a h. ToElement' a h
feFuncA' = createElement' "feFuncA"

feFuncB :: forall a b h. ToElement a b h
feFuncB = createElement "feFuncB"

feFuncB_ :: forall b h. ToElement_ b h
feFuncB_ = createElement_ "feFuncB"

feFuncB' :: forall a h. ToElement' a h
feFuncB' = createElement' "feFuncB"

feFuncG :: forall a b h. ToElement a b h
feFuncG = createElement "feFuncG"

feFuncG_ :: forall b h. ToElement_ b h
feFuncG_ = createElement_ "feFuncG"

feFuncG' :: forall a h. ToElement' a h
feFuncG' = createElement' "feFuncG"

feFuncR :: forall a b h. ToElement a b h
feFuncR = createElement "feFuncR"

feFuncR_ :: forall b h. ToElement_ b h
feFuncR_ = createElement_ "feFuncR"

feFuncR' :: forall a h. ToElement' a h
feFuncR' = createElement' "feFuncR"

feGaussianBlur :: forall a b h. ToElement a b h
feGaussianBlur = createElement "feGaussianBlur"

feGaussianBlur_ :: forall b h. ToElement_ b h
feGaussianBlur_ = createElement_ "feGaussianBlur"

feGaussianBlur' :: forall a h. ToElement' a h
feGaussianBlur' = createElement' "feGaussianBlur"

feImage :: forall a b h. ToElement a b h
feImage = createElement "feImage"

feImage_ :: forall b h. ToElement_ b h
feImage_ = createElement_ "feImage"

feImage' :: forall a h. ToElement' a h
feImage' = createElement' "feImage"

feMerge :: forall a b h. ToElement a b h
feMerge = createElement "feMerge"

feMerge_ :: forall b h. ToElement_ b h
feMerge_ = createElement_ "feMerge"

feMerge' :: forall a h. ToElement' a h
feMerge' = createElement' "feMerge"

feMergeNode :: forall a b h. ToElement a b h
feMergeNode = createElement "feMergeNode"

feMergeNode_ :: forall b h. ToElement_ b h
feMergeNode_ = createElement_ "feMergeNode"

feMergeNode' :: forall a h. ToElement' a h
feMergeNode' = createElement' "feMergeNode"

feMorphology :: forall a b h. ToElement a b h
feMorphology = createElement "feMorphology"

feMorphology_ :: forall b h. ToElement_ b h
feMorphology_ = createElement_ "feMorphology"

feMorphology' :: forall a h. ToElement' a h
feMorphology' = createElement' "feMorphology"

feOffset :: forall a b h. ToElement a b h
feOffset = createElement "feOffset"

feOffset_ :: forall b h. ToElement_ b h
feOffset_ = createElement_ "feOffset"

feOffset' :: forall a h. ToElement' a h
feOffset' = createElement' "feOffset"

fePointLight :: forall a b h. ToElement a b h
fePointLight = createElement "fePointLight"

fePointLight_ :: forall b h. ToElement_ b h
fePointLight_ = createElement_ "fePointLight"

fePointLight' :: forall a h. ToElement' a h
fePointLight' = createElement' "fePointLight"

feSpecularLighting :: forall a b h. ToElement a b h
feSpecularLighting = createElement "feSpecularLighting"

feSpecularLighting_ :: forall b h. ToElement_ b h
feSpecularLighting_ = createElement_ "feSpecularLighting"

feSpecularLighting' :: forall a h. ToElement' a h
feSpecularLighting' = createElement' "feSpecularLighting"

feSpotLight :: forall a b h. ToElement a b h
feSpotLight = createElement "feSpotLight"

feSpotLight_ :: forall b h. ToElement_ b h
feSpotLight_ = createElement_ "feSpotLight"

feSpotLight' :: forall a h. ToElement' a h
feSpotLight' = createElement' "feSpotLight"

feTile :: forall a b h. ToElement a b h
feTile = createElement "feTile"

feTile_ :: forall b h. ToElement_ b h
feTile_ = createElement_ "feTile"

feTile' :: forall a h. ToElement' a h
feTile' = createElement' "feTile"

feTurbulence :: forall a b h. ToElement a b h
feTurbulence = createElement "feTurbulence"

feTurbulence_ :: forall b h. ToElement_ b h
feTurbulence_ = createElement_ "feTurbulence"

feTurbulence' :: forall a h. ToElement' a h
feTurbulence' = createElement' "feTurbulence"

filter :: forall a b h. ToElement a b h
filter = createElement "filter"

filter_ :: forall b h. ToElement_ b h
filter_ = createElement_ "filter"

filter' :: forall a h. ToElement' a h
filter' = createElement' "filter"

font :: forall a b h. ToElement a b h
font = createElement "font"

font_ :: forall b h. ToElement_ b h
font_ = createElement_ "font"

font' :: forall a h. ToElement' a h
font' = createElement' "font"

fontFace :: forall a b h. ToElement a b h
fontFace = createElement "font-face"

fontFace_ :: forall b h. ToElement_ b h
fontFace_ = createElement_ "font-face"

fontFace' :: forall a h. ToElement' a h
fontFace' = createElement' "font-face"

fontFaceFormat :: forall a b h. ToElement a b h
fontFaceFormat = createElement "font-face-format"

fontFaceFormat_ :: forall b h. ToElement_ b h
fontFaceFormat_ = createElement_ "font-face-format"

fontFaceFormat' :: forall a h. ToElement' a h
fontFaceFormat' = createElement' "font-face-format"

fontFaceName :: forall a b h. ToElement a b h
fontFaceName = createElement "font-face-name"

fontFaceName_ :: forall b h. ToElement_ b h
fontFaceName_ = createElement_ "font-face-name"

fontFaceName' :: forall a h. ToElement' a h
fontFaceName' = createElement' "font-face-name"

fontFaceSrc :: forall a b h. ToElement a b h
fontFaceSrc = createElement "font-face-src"

fontFaceSrc_ :: forall b h. ToElement_ b h
fontFaceSrc_ = createElement_ "font-face-src"

fontFaceSrc' :: forall a h. ToElement' a h
fontFaceSrc' = createElement' "font-face-src"

fontFaceUri :: forall a b h. ToElement a b h
fontFaceUri = createElement "font-face-uri"

fontFaceUri_ :: forall b h. ToElement_ b h
fontFaceUri_ = createElement_ "font-face-uri"

fontFaceUri' :: forall a h. ToElement' a h
fontFaceUri' = createElement' "font-face-uri"

foreignObject :: forall a b h. ToElement a b h
foreignObject = createElement "foreignObject"

foreignObject_ :: forall b h. ToElement_ b h
foreignObject_ = createElement_ "foreignObject"

foreignObject' :: forall a h. ToElement' a h
foreignObject' = createElement' "foreignObject"

g :: forall a b h. ToElement a b h
g = createElement "g"

g_ :: forall b h. ToElement_ b h
g_ = createElement_ "g"

g' :: forall a h. ToElement' a h
g' = createElement' "g"

glyph :: forall a b h. ToElement a b h
glyph = createElement "glyph"

glyph_ :: forall b h. ToElement_ b h
glyph_ = createElement_ "glyph"

glyph' :: forall a h. ToElement' a h
glyph' = createElement' "glyph"

glyphRef :: forall a b h. ToElement a b h
glyphRef = createElement "glyphRef"

glyphRef_ :: forall b h. ToElement_ b h
glyphRef_ = createElement_ "glyphRef"

glyphRef' :: forall a h. ToElement' a h
glyphRef' = createElement' "glyphRef"

hatch :: forall a b h. ToElement a b h
hatch = createElement "hatch"

hatch_ :: forall b h. ToElement_ b h
hatch_ = createElement_ "hatch"

hatch' :: forall a h. ToElement' a h
hatch' = createElement' "hatch"

hatchpath :: forall a b h. ToElement a b h
hatchpath = createElement "hatchpath"

hatchpath_ :: forall b h. ToElement_ b h
hatchpath_ = createElement_ "hatchpath"

hatchpath' :: forall a h. ToElement' a h
hatchpath' = createElement' "hatchpath"

hkern :: forall a b h. ToElement a b h
hkern = createElement "hkern"

hkern_ :: forall b h. ToElement_ b h
hkern_ = createElement_ "hkern"

hkern' :: forall a h. ToElement' a h
hkern' = createElement' "hkern"

image :: forall a b h. ToElement a b h
image = createElement "image"

image_ :: forall b h. ToElement_ b h
image_ = createElement_ "image"

image' :: forall a h. ToElement' a h
image' = createElement' "image"

line :: forall a b h. ToElement a b h
line = createElement "line"

line_ :: forall b h. ToElement_ b h
line_ = createElement_ "line"

line' :: forall a h. ToElement' a h
line' = createElement' "line"

linearGradient :: forall a b h. ToElement a b h
linearGradient = createElement "linearGradient"

linearGradient_ :: forall b h. ToElement_ b h
linearGradient_ = createElement_ "linearGradient"

linearGradient' :: forall a h. ToElement' a h
linearGradient' = createElement' "linearGradient"

marker :: forall a b h. ToElement a b h
marker = createElement "marker"

marker_ :: forall b h. ToElement_ b h
marker_ = createElement_ "marker"

marker' :: forall a h. ToElement' a h
marker' = createElement' "marker"

mask :: forall a b h. ToElement a b h
mask = createElement "mask"

mask_ :: forall b h. ToElement_ b h
mask_ = createElement_ "mask"

mask' :: forall a h. ToElement' a h
mask' = createElement' "mask"

mesh :: forall a b h. ToElement a b h
mesh = createElement "mesh"

mesh_ :: forall b h. ToElement_ b h
mesh_ = createElement_ "mesh"

mesh' :: forall a h. ToElement' a h
mesh' = createElement' "mesh"

meshgradient :: forall a b h. ToElement a b h
meshgradient = createElement "meshgradient"

meshgradient_ :: forall b h. ToElement_ b h
meshgradient_ = createElement_ "meshgradient"

meshgradient' :: forall a h. ToElement' a h
meshgradient' = createElement' "meshgradient"

meshpatch :: forall a b h. ToElement a b h
meshpatch = createElement "meshpatch"

meshpatch_ :: forall b h. ToElement_ b h
meshpatch_ = createElement_ "meshpatch"

meshpatch' :: forall a h. ToElement' a h
meshpatch' = createElement' "meshpatch"

meshrow :: forall a b h. ToElement a b h
meshrow = createElement "meshrow"

meshrow_ :: forall b h. ToElement_ b h
meshrow_ = createElement_ "meshrow"

meshrow' :: forall a h. ToElement' a h
meshrow' = createElement' "meshrow"

metadata :: forall a b h. ToElement a b h
metadata = createElement "metadata"

metadata_ :: forall b h. ToElement_ b h
metadata_ = createElement_ "metadata"

metadata' :: forall a h. ToElement' a h
metadata' = createElement' "metadata"

missingGlyph :: forall a b h. ToElement a b h
missingGlyph = createElement "missing-glyph"

missingGlyph_ :: forall b h. ToElement_ b h
missingGlyph_ = createElement_ "missing-glyph"

missingGlyph' :: forall a h. ToElement' a h
missingGlyph' = createElement' "missing-glyph"

mpath :: forall a b h. ToElement a b h
mpath = createElement "mpath"

mpath_ :: forall b h. ToElement_ b h
mpath_ = createElement_ "mpath"

mpath' :: forall a h. ToElement' a h
mpath' = createElement' "mpath"

path :: forall a b h. ToElement a b h
path = createElement "path"

path_ :: forall b h. ToElement_ b h
path_ = createElement_ "path"

path' :: forall a h. ToElement' a h
path' = createElement' "path"

pattern :: forall a b h. ToElement a b h
pattern = createElement "pattern"

pattern_ :: forall b h. ToElement_ b h
pattern_ = createElement_ "pattern"

pattern' :: forall a h. ToElement' a h
pattern' = createElement' "pattern"

polygon :: forall a b h. ToElement a b h
polygon = createElement "polygon"

polygon_ :: forall b h. ToElement_ b h
polygon_ = createElement_ "polygon"

polygon' :: forall a h. ToElement' a h
polygon' = createElement' "polygon"

polyline :: forall a b h. ToElement a b h
polyline = createElement "polyline"

polyline_ :: forall b h. ToElement_ b h
polyline_ = createElement_ "polyline"

polyline' :: forall a h. ToElement' a h
polyline' = createElement' "polyline"

radialGradient :: forall a b h. ToElement a b h
radialGradient = createElement "radialGradient"

radialGradient_ :: forall b h. ToElement_ b h
radialGradient_ = createElement_ "radialGradient"

radialGradient' :: forall a h. ToElement' a h
radialGradient' = createElement' "radialGradient"

rect :: forall a b h. ToElement a b h
rect = createElement "rect"

rect_ :: forall b h. ToElement_ b h
rect_ = createElement_ "rect"

rect' :: forall a h. ToElement' a h
rect' = createElement' "rect"

script :: forall a b h. ToElement a b h
script = createElement "script"

script_ :: forall b h. ToElement_ b h
script_ = createElement_ "script"

script' :: forall a h. ToElement' a h
script' = createElement' "script"

set :: forall a b h. ToElement a b h
set = createElement "set"

set_ :: forall b h. ToElement_ b h
set_ = createElement_ "set"

set' :: forall a h. ToElement' a h
set' = createElement' "set"

solidcolor :: forall a b h. ToElement a b h
solidcolor = createElement "solidcolor"

solidcolor_ :: forall b h. ToElement_ b h
solidcolor_ = createElement_ "solidcolor"

solidcolor' :: forall a h. ToElement' a h
solidcolor' = createElement' "solidcolor"

stop :: forall a b h. ToElement a b h
stop = createElement "stop"

stop_ :: forall b h. ToElement_ b h
stop_ = createElement_ "stop"

stop' :: forall a h. ToElement' a h
stop' = createElement' "stop"

svg :: forall a b h. ToElement a b h
svg = createElement "svg"

svg_ :: forall b h. ToElement_ b h
svg_ = createElement_ "svg"

svg' :: forall a h. ToElement' a h
svg' = createElement' "svg"

switch :: forall a b h. ToElement a b h
switch = createElement "switch"

switch_ :: forall b h. ToElement_ b h
switch_ = createElement_ "switch"

switch' :: forall a h. ToElement' a h
switch' = createElement' "switch"

symbol :: forall a b h. ToElement a b h
symbol = createElement "symbol"

symbol_ :: forall b h. ToElement_ b h
symbol_ = createElement_ "symbol"

symbol' :: forall a h. ToElement' a h
symbol' = createElement' "symbol"

textPath :: forall a b h. ToElement a b h
textPath = createElement "textPath"

textPath_ :: forall b h. ToElement_ b h
textPath_ = createElement_ "textPath"

textPath' :: forall a h. ToElement' a h
textPath' = createElement' "textPath"

tref :: forall a b h. ToElement a b h
tref = createElement "tref"

tref_ :: forall b h. ToElement_ b h
tref_ = createElement_ "tref"

tref' :: forall a h. ToElement' a h
tref' = createElement' "tref"

tspan :: forall a b h. ToElement a b h
tspan = createElement "tspan"

tspan_ :: forall b h. ToElement_ b h
tspan_ = createElement_ "tspan"

tspan' :: forall a h. ToElement' a h
tspan' = createElement' "tspan"

unknown :: forall a b h. ToElement a b h
unknown = createElement "unknown"

unknown_ :: forall b h. ToElement_ b h
unknown_ = createElement_ "unknown"

unknown' :: forall a h. ToElement' a h
unknown' = createElement' "unknown"

use :: forall a b h. ToElement a b h
use = createElement "use"

use_ :: forall b h. ToElement_ b h
use_ = createElement_ "use"

use' :: forall a h. ToElement' a h
use' = createElement' "use"

view :: forall a b h. ToElement a b h
view = createElement "view"

view_ :: forall b h. ToElement_ b h
view_ = createElement_ "view"

view' :: forall a h. ToElement' a h
view' = createElement' "view"

vkern :: forall a b h. ToElement a b h
vkern = createElement "vkern"

vkern_ :: forall b h. ToElement_ b h
vkern_ = createElement_ "vkern"

vkern' :: forall a h. ToElement' a h
vkern' = createElement' "vkern"
