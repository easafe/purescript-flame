-- | Definition of react native elements
module Flame.Native.Element where

import Prelude hiding (map)
import Data.Array as DA

import Flame.Native.Attribute.Internal as FHAI
import Flame.Types (Html, NodeData)

-- | `ToNode` simplifies element creation by automating common tag operations
-- | * `tag "my-tag" []` becomes short for `tag [id "my-tag"] []`
-- | * `tag [] "content"` becomes short for `tag [] [text "content"]`
-- | * elements with a single attribute or children need not as well to use lists: `tag (enabled True) (tag attrs children)`
class ToNode ∷ ∀ k. Type → k → (k → Type) → Constraint
class ToNode a b c | a → b where
      toNode ∷ a → Array (c b)

instance ToNode String b Html where
      toNode = DA.singleton <<< text

instance (ToNode a b c) ⇒ ToNode (Array a) b c where
      toNode = DA.concatMap toNode

instance ToNode (Html a) a Html where
      toNode = DA.singleton

instance ToNode String b NodeData where
      toNode = DA.singleton <<< FHAI.id

instance ToNode (NodeData a) a NodeData where
      toNode = DA.singleton

type ToHtml a b h = ToNode a h NodeData ⇒ ToNode b h Html ⇒ a → b → Html h

type ToHtml_ b h = ToNode b h Html ⇒ b → Html h

type ToHtml' a h = ToNode a h NodeData ⇒ a → Html h

foreign import createViewNode ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message

foreign import createButtonNode ∷ ∀ message. Array (NodeData message) → Array (Html message) -> Html message

foreign import createBrNode :: forall message. Array (NodeData message) -> Html message

foreign import createImageNode :: forall message. Array (NodeData message) -> Html message

foreign import createHrNode :: forall message. Array (NodeData message) -> Html message

foreign import createANode :: forall message. Array (NodeData message) -> Array (Html message) -> Html message

foreign import createInputNode :: forall message. Array (NodeData message) -> Array (Html message) -> Html message

foreign import createBNode :: forall message. Array (NodeData message) -> Array (Html message) -> Html message

-- | Creates a text node
foreign import text ∷ ∀ message. String → Html message

hr' :: forall a h. ToHtml' a h
hr' nodeData = createHrNode (toNode nodeData)

br :: forall message. Html message
br = createBrNode []

br' :: forall a h. ToHtml' a h
br' nodeData = createBrNode (toNode nodeData)

input :: forall a h. ToHtml' a h
input nodeData = createInputNode (toNode nodeData) []

input_ :: forall b h. ToHtml_ b h
input_ children = createInputNode [] $ toNode children

a :: forall a b h. ToHtml a b h
a nodeData children = createANode (toNode nodeData) $ toNode children

a_ :: forall b h. ToHtml_ b h
a_ children = createANode [] $ toNode children

a' :: forall a h. ToHtml' a h
a' nodeData = createANode (toNode nodeData) []

b :: forall a b h. ToHtml a b h
b nodeData children = createBNode (toNode nodeData) $ toNode children

b_ :: forall b h. ToHtml_ b h
b_ children = createBNode [] $ toNode children

b' :: forall a h. ToHtml' a h
b' nodeData = createBNode (toNode nodeData) []

body :: forall a b h. ToHtml a b h
body nodeData children = createViewNode (toNode nodeData) $ toNode children

body_ :: forall b h. ToHtml_ b h
body_ children = createViewNode [] $ toNode children

body' :: forall a h. ToHtml' a h
body' nodeData = createViewNode (toNode nodeData) []

button :: forall a b h. ToHtml a b h
button nodeData children = createButtonNode (toNode nodeData ) $ toNode children

button_ :: forall b h. ToHtml_ b h
button_ children = createButtonNode [] $ toNode children

button' :: forall a h. ToHtml' a h
button' nodeData = createButtonNode (toNode nodeData) []

div :: forall a b h. ToHtml a b h
div nodeData children = createViewNode (toNode nodeData) $ toNode children

div_ :: forall  b h. ToHtml_ b h
div_ children = createViewNode [] $ toNode children

div' :: forall a h. ToHtml' a h
div' nodeData = createViewNode (toNode nodeData) []

img ∷ ∀ a h. ToHtml' a h
img nodeData = createImageNode (toNode nodeData)


-- h1 ∷ ∀ a b h. ToHtml a b h
-- h1 = createElement "h1"

-- h1_ ∷ ∀ b h. ToHtml_ b h
-- h1_ = createElement_ "h1"

-- h1' ∷ ∀ a h. ToHtml' a h
-- h1' = createElement' "h1"

-- h2 ∷ ∀ a b h. ToHtml a b h
-- h2 = createElement "h2"

-- h2_ ∷ ∀ b h. ToHtml_ b h
-- h2_ = createElement_ "h2"

-- h2' ∷ ∀ a h. ToHtml' a h
-- h2' = createElement' "h2"

-- h3 ∷ ∀ a b h. ToHtml a b h
-- h3 = createElement "h3"

-- h3_ ∷ ∀ b h. ToHtml_ b h
-- h3_ = createElement_ "h3"

-- h3' ∷ ∀ a h. ToHtml' a h
-- h3' = createElement' "h3"

-- h4 ∷ ∀ a b h. ToHtml a b h
-- h4 = createElement "h4"

-- h4_ ∷ ∀ b h. ToHtml_ b h
-- h4_ = createElement_ "h4"

-- h4' ∷ ∀ a h. ToHtml' a h
-- h4' = createElement' "h4"

-- h5 ∷ ∀ a b h. ToHtml a b h
-- h5 = createElement "h5"

-- h5_ ∷ ∀ b h. ToHtml_ b h
-- h5_ = createElement_ "h5"

-- h5' ∷ ∀ a h. ToHtml' a h
-- h5' = createElement' "h5"

-- h6 ∷ ∀ a b h. ToHtml a b h
-- h6 = createElement "h6"

-- h6_ ∷ ∀ b h. ToHtml_ b h
-- h6_ = createElement_ "h6"

-- h6' ∷ ∀ a h. ToHtml' a h
-- h6' = createElement' "h6"

-- head ∷ ∀ a b h. ToHtml a b h
-- head = createElement "head"

-- head_ ∷ ∀ b h. ToHtml_ b h
-- head_ = createElement_ "head"

-- head' ∷ ∀ a h. ToHtml' a h
-- head' = createElement' "head"

-- html ∷ ∀ a b h. ToHtml a b h
-- html = createElement "html"

-- html_ ∷ ∀ b h. ToHtml_ b h
-- html_ = createElement_ "html"

-- html' ∷ ∀ a h. ToHtml' a h
-- html' = createElement' "html"

-- i ∷ ∀ a b h. ToHtml a b h
-- i = createElement "i"

-- i_ ∷ ∀ b h. ToHtml_ b h
-- i_ = createElement_ "i"

-- i' ∷ ∀ a h. ToHtml' a h
-- i' = createElement' "i"


-- label ∷ ∀ a b h. ToHtml a b h
-- label = createElement "label"

-- label_ ∷ ∀ b h. ToHtml_ b h
-- label_ = createElement_ "label"

-- label' ∷ ∀ a h. ToHtml' a h
-- label' = createElement' "label"


-- li ∷ ∀ a b h. ToHtml a b h
-- li = createElement "li"

-- li_ ∷ ∀ b h. ToHtml_ b h
-- li_ = createElement_ "li"

-- li' ∷ ∀ a h. ToHtml' a h
-- li' = createElement' "li"

-- ol ∷ ∀ a b h. ToHtml a b h
-- ol = createElement "ol"

-- ol_ ∷ ∀ b h. ToHtml_ b h
-- ol_ = createElement_ "ol"

-- ol' ∷ ∀ a h. ToHtml' a h
-- ol' = createElement' "ol"

-- optgroup' ∷ ∀ a h. ToHtml' a h
-- optgroup' = createElement' "optgroup"

-- option ∷ ∀ a b h. ToHtml a b h
-- option = createElement "option"

-- option_ ∷ ∀ b h. ToHtml_ b h
-- option_ = createElement_ "option"

-- option' ∷ ∀ a h. ToHtml' a h
-- option' = createElement' "option"

-- p ∷ ∀ a b h. ToHtml a b h
-- p = createElement "p"

-- p_ ∷ ∀ b h. ToHtml_ b h
-- p_ = createElement_ "p"

-- p' ∷ ∀ a h. ToHtml' a h
-- p' = createElement' "p"

-- select ∷ ∀ a b h. ToHtml a b h
-- select = createElement "select"

-- select_ ∷ ∀ b h. ToHtml_ b h
-- select_ = createElement_ "select"

-- select' ∷ ∀ a h. ToHtml' a h
-- select' = createElement' "select"

-- span ∷ ∀ a b h. ToHtml a b h
-- span = createElement "span"

-- span_ ∷ ∀ b h. ToHtml_ b h
-- span_ = createElement_ "span"

-- span' ∷ ∀ a h. ToHtml' a h
-- span' = createElement' "span"

-- strong ∷ ∀ a b h. ToHtml a b h
-- strong = createElement "strong"

-- strong_ ∷ ∀ b h. ToHtml_ b h
-- strong_ = createElement_ "strong"

-- strong' ∷ ∀ a h. ToHtml' a h
-- strong' = createElement' "strong"


-- table ∷ ∀ a b h. ToHtml a b h
-- table = createElement "table"

-- table_ ∷ ∀ b h. ToHtml_ b h
-- table_ = createElement_ "table"

-- table' ∷ ∀ a h. ToHtml' a h
-- table' = createElement' "table"

-- tbody ∷ ∀ a b h. ToHtml a b h
-- tbody = createElement "tbody"

-- tbody_ ∷ ∀ b h. ToHtml_ b h
-- tbody_ = createElement_ "tbody"

-- tbody' ∷ ∀ a h. ToHtml' a h
-- tbody' = createElement' "tbody"

-- td ∷ ∀ a b h. ToHtml a b h
-- td = createElement "td"

-- td_ ∷ ∀ b h. ToHtml_ b h
-- td_ = createElement_ "td"

-- td' ∷ ∀ a h. ToHtml' a h
-- td' = createElement' "td"

-- textarea ∷ ∀ a b h. ToHtml a b h
-- textarea = createElement "textarea"

-- textarea_ ∷ ∀ b h. ToHtml_ b h
-- textarea_ = createElement_ "textarea"

-- textarea' ∷ ∀ a h. ToHtml' a h
-- textarea' = createElement' "textarea"

-- th ∷ ∀ a b h. ToHtml a b h
-- th = createElement "th"

-- th_ ∷ ∀ b h. ToHtml_ b h
-- th_ = createElement_ "th"

-- th' ∷ ∀ a h. ToHtml' a h
-- th' = createElement' "th"

-- tr ∷ ∀ a b h. ToHtml a b h
-- tr = createElement "tr"

-- tr_ ∷ ∀ b h. ToHtml_ b h
-- tr_ = createElement_ "tr"

-- tr' ∷ ∀ a h. ToHtml' a h
-- tr' = createElement' "tr"

-- ul ∷ ∀ a b h. ToHtml a b h
-- ul = createElement "ul"

-- ul_ ∷ ∀ b h. ToHtml_ b h
-- ul_ = createElement_ "ul"

-- ul' ∷ ∀ a h. ToHtml' a h
-- ul' = createElement' "ul"

