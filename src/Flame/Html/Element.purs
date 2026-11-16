-- | Definition of HTML elements
module Flame.Html.Element
      ( NodeRenderer
      , Tag
      , text
      , createEmptyElement
      , createElement
      , createElement_
      , createElement'
      , fragment
      , lazy
      , managed
      , managed_
      , svg
      , svg_
      , svg'
      , hr
      , hr_
      , hr'
      , br
      , br'
      , input
      , a
      , a_
      , a'
      , address
      , address_
      , address'
      , area
      , article
      , article_
      , article'
      , aside
      , aside_
      , aside'
      , audio
      , audio_
      , audio'
      , b
      , b_
      , b'
      , base
      , bdi
      , bdi_
      , bdi'
      , bdo
      , bdo_
      , bdo'
      , blockquote
      , blockquote_
      , blockquote'
      , body
      , body_
      , body'
      , button
      , button_
      , button'
      , canvas
      , canvas_
      , canvas'
      , caption
      , caption_
      , caption'
      , cite
      , cite_
      , cite'
      , code
      , code_
      , code'
      , col
      , colgroup
      , colgroup_
      , colgroup'
      , data_
      , data'
      , datalist
      , datalist_
      , datalist'
      , dd
      , dd_
      , dd'
      , del
      , del_
      , del'
      , details
      , details_
      , details'
      , dfn
      , dfn_
      , dfn'
      , dialog
      , dialog_
      , dialog'
      , div
      , div_
      , div'
      , dl
      , dl_
      , dl'
      , dt
      , dt_
      , dt'
      , em
      , em_
      , em'
      , embed
      , fieldset
      , fieldset_
      , fieldset'
      , figure
      , figure_
      , figure'
      , footer
      , footer_
      , footer'
      , form
      , form_
      , form'
      , h1
      , h1_
      , h1'
      , h2
      , h2_
      , h2'
      , h3
      , h3_
      , h3'
      , h4
      , h4_
      , h4'
      , h5
      , h5_
      , h5'
      , h6
      , h6_
      , h6'
      , head
      , head_
      , head'
      , header
      , header_
      , header'
      , hgroup
      , hgroup_
      , hgroup'
      , html
      , html_
      , html'
      , i
      , i_
      , i'
      , iframe
      , iframe_
      , iframe'
      , ins
      , ins_
      , ins'
      , kbd
      , kbd_
      , kbd'
      , keygen
      , label
      , label_
      , label'
      , legend
      , legend_
      , legend'
      , li
      , li_
      , li'
      , link
      , main
      , main_
      , main'
      , map
      , map_
      , map'
      , mark
      , mark_
      , mark'
      , menu
      , menu_
      , menu'
      , menuitem
      , menuitem_
      , menuitem'
      , meta
      , meter
      , meter_
      , meter'
      , nav
      , nav_
      , nav'
      , noscript
      , noscript_
      , noscript'
      , object
      , object_
      , object'
      , ol
      , ol_
      , ol'
      , img
      , optgroup
      , optgroup_
      , optgroup'
      , option
      , option_
      , option'
      , output
      , output_
      , output'
      , p
      , p_
      , p'
      , param
      , pre
      , pre_
      , pre'
      , progress
      , progress_
      , progress'
      , q
      , q_
      , q'
      , rb
      , rb_
      , rb'
      , rp
      , rp_
      , rp'
      , rt
      , rt_
      , rt'
      , rtc
      , rtc_
      , rtc'
      , ruby
      , ruby_
      , ruby'
      , s
      , s_
      , s'
      , section
      , section_
      , section'
      , select
      , select_
      , select'
      , small
      , small_
      , small'
      , source
      , span
      , span_
      , span'
      , strong
      , strong_
      , strong'
      , style
      , style_
      , style'
      , sub
      , sub_
      , sub'
      , summary
      , summary_
      , summary'
      , sup
      , sup_
      , sup'
      , table
      , table_
      , table'
      , tbody
      , tbody_
      , tbody'
      , td
      , td_
      , td'
      , template
      , template_
      , template'
      , textarea
      , textarea_
      , textarea'
      , tfoot
      , tfoot_
      , tfoot'
      , th
      , th_
      , th'
      , thead
      , thead_
      , thead'
      , time
      , time_
      , time'
      , title
      , tr
      , tr_
      , tr'
      , track
      , u
      , u_
      , u'
      , ul
      , ul_
      , ul'
      , var
      , var_
      , var'
      , video
      , video_
      , video'
      , wbr
      , animate
      , animate_
      , animate'
      , animateColor
      , animateColor_
      , animateColor'
      , animateMotion
      , animateMotion_
      , animateMotion'
      , animateTransform
      , animateTransform_
      , animateTransform'
      , circle
      , circle_
      , circle'
      , clipPath
      , clipPath_
      , clipPath'
      , colorProfile
      , colorProfile_
      , colorProfile'
      , cursor
      , cursor_
      , cursor'
      , defs
      , defs_
      , defs'
      , desc
      , desc_
      , desc'
      , discard
      , discard_
      , discard'
      , ellipse
      , ellipse_
      , ellipse'
      , feBlend
      , feBlend_
      , feBlend'
      , feColorMatrix
      , feColorMatrix_
      , feColorMatrix'
      , feComponentTransfer
      , feComponentTransfer_
      , feComponentTransfer'
      , feComposite
      , feComposite_
      , feComposite'
      , feConvolveMatrix
      , feConvolveMatrix_
      , feConvolveMatrix'
      , feDiffuseLighting
      , feDiffuseLighting_
      , feDiffuseLighting'
      , feDisplacementMap
      , feDisplacementMap_
      , feDisplacementMap'
      , feDistantLight
      , feDistantLight_
      , feDistantLight'
      , feDropShadow
      , feDropShadow_
      , feDropShadow'
      , feFlood
      , feFlood_
      , feFlood'
      , feFuncA
      , feFuncA_
      , feFuncA'
      , feFuncB
      , feFuncB_
      , feFuncB'
      , feFuncG
      , feFuncG_
      , feFuncG'
      , feFuncR
      , feFuncR_
      , feFuncR'
      , feGaussianBlur
      , feGaussianBlur_
      , feGaussianBlur'
      , feImage
      , feImage_
      , feImage'
      , feMerge
      , feMerge_
      , feMerge'
      , feMergeNode
      , feMergeNode_
      , feMergeNode'
      , feMorphology
      , feMorphology_
      , feMorphology'
      , feOffset
      , feOffset_
      , feOffset'
      , fePointLight
      , fePointLight_
      , fePointLight'
      , feSpecularLighting
      , feSpecularLighting_
      , feSpecularLighting'
      , feSpotLight
      , feSpotLight_
      , feSpotLight'
      , feTile
      , feTile_
      , feTile'
      , feTurbulence
      , feTurbulence_
      , feTurbulence'
      , filter
      , filter_
      , filter'
      , font
      , font_
      , font'
      , fontFace
      , fontFace_
      , fontFace'
      , fontFaceFormat
      , fontFaceFormat_
      , fontFaceFormat'
      , fontFaceName
      , fontFaceName_
      , fontFaceName'
      , fontFaceSrc
      , fontFaceSrc_
      , fontFaceSrc'
      , fontFaceUri
      , fontFaceUri_
      , fontFaceUri'
      , foreignObject
      , foreignObject_
      , foreignObject'
      , g
      , g_
      , g'
      , glyph
      , glyph_
      , glyph'
      , glyphRef
      , glyphRef_
      , glyphRef'
      , hatch
      , hatch_
      , hatch'
      , hatchpath
      , hatchpath_
      , hatchpath'
      , hkern
      , hkern_
      , hkern'
      , image
      , image_
      , image'
      , line
      , line_
      , line'
      , linearGradient
      , linearGradient_
      , linearGradient'
      , marker
      , marker_
      , marker'
      , mask
      , mask_
      , mask'
      , mesh
      , mesh_
      , mesh'
      , meshgradient
      , meshgradient_
      , meshgradient'
      , meshpatch
      , meshpatch_
      , meshpatch'
      , meshrow
      , meshrow_
      , meshrow'
      , metadata
      , metadata_
      , metadata'
      , missingGlyph
      , missingGlyph_
      , missingGlyph'
      , mpath
      , mpath_
      , mpath'
      , path
      , path_
      , path'
      , pattern
      , pattern_
      , pattern'
      , polygon
      , polygon_
      , polygon'
      , polyline
      , polyline_
      , polyline'
      , radialGradient
      , radialGradient_
      , radialGradient'
      , rect
      , rect_
      , rect'
      , script
      , script_
      , script'
      , set
      , set_
      , set'
      , solidcolor
      , solidcolor_
      , solidcolor'
      , stop
      , stop_
      , stop'
      , switch
      , switch_
      , switch'
      , symbol
      , symbol_
      , symbol'
      , textPath
      , textPath_
      , textPath'
      , tref
      , tref_
      , tref'
      , tspan
      , tspan_
      , tspan'
      , unknown
      , unknown_
      , unknown'
      , use
      , use_
      , use'
      , view
      , view_
      , view'
      , vkern
      , vkern_
      , vkern'
      ) where

import Prelude hiding (map)

import Data.Array as DA
import Data.Maybe (Maybe)
import Data.Maybe as DM
import Effect (Effect)
import Flame.Internal.Fragment as FIF
import Flame.Types (Html, Key, NodeData)
import Web.DOM (Node)

-- | Name of a HTML or SVG element, e.g. `"div"`
type Tag = String

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

-- | Creates a `<svg>` element with attributes and children nodes
svg ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
svg nodeData children = createSvgNode nodeData children

-- | Creates a `<svg>` element with children nodes and no attributes
svg_ ∷ ∀ message. Array (Html message) → Html message
svg_ children = createDatalessSvgNode children

-- | Creates a `<svg>` element with attributes and no children nodes
svg' ∷ ∀ message. Array (NodeData message) → Html message
svg' nodeData = createSingleSvgNode nodeData

-- | Creates an empty `<hr>` element
hr ∷ ∀ message. Html message
hr = createEmptyElement "hr"

-- | Creates a `<hr>` element with children nodes and no attributes
hr_ ∷ ∀ message. Array (Html message) → Html message
hr_ = createElement_ "hr"

-- | Creates a `<hr>` element with attributes and no children nodes
hr' ∷ ∀ message. Array (NodeData message) → Html message
hr' = createElement' "hr"

-- | Creates an empty `<br>` element
br ∷ ∀ message. Html message
br = createEmptyElement "br"

-- | Creates a `<br>` element with attributes and no children nodes
br' ∷ ∀ message. Array (NodeData message) → Html message
br' = createElement' "br"

-- | Creates a `<input>` element with attributes and no children nodes
input ∷ ∀ message. Array (NodeData message) → Html message
input = createElement' "input"

-- | Creates a `<a>` element with attributes and children nodes
a ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
a = createElement "a"

-- | Creates a `<a>` element with children nodes and no attributes
a_ ∷ ∀ message. Array (Html message) → Html message
a_ = createElement_ "a"

-- | Creates a `<a>` element with attributes and no children nodes
a' ∷ ∀ message. Array (NodeData message) → Html message
a' = createElement' "a"

-- | Creates a `<address>` element with attributes and children nodes
address ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
address = createElement "address"

-- | Creates a `<address>` element with children nodes and no attributes
address_ ∷ ∀ message. Array (Html message) → Html message
address_ = createElement_ "address"

-- | Creates a `<address>` element with attributes and no children nodes
address' ∷ ∀ message. Array (NodeData message) → Html message
address' = createElement' "address"

-- | Creates a `<area>` element with attributes; `area` is a void element and cannot have children
area ∷ ∀ message. Array (NodeData message) → Html message
area = createElement' "area"

-- | Creates a `<article>` element with attributes and children nodes
article ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
article = createElement "article"

-- | Creates a `<article>` element with children nodes and no attributes
article_ ∷ ∀ message. Array (Html message) → Html message
article_ = createElement_ "article"

-- | Creates a `<article>` element with attributes and no children nodes
article' ∷ ∀ message. Array (NodeData message) → Html message
article' = createElement' "article"

-- | Creates a `<aside>` element with attributes and children nodes
aside ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
aside = createElement "aside"

-- | Creates a `<aside>` element with children nodes and no attributes
aside_ ∷ ∀ message. Array (Html message) → Html message
aside_ = createElement_ "aside"

-- | Creates a `<aside>` element with attributes and no children nodes
aside' ∷ ∀ message. Array (NodeData message) → Html message
aside' = createElement' "aside"

-- | Creates a `<audio>` element with attributes and children nodes
audio ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
audio = createElement "audio"

-- | Creates a `<audio>` element with children nodes and no attributes
audio_ ∷ ∀ message. Array (Html message) → Html message
audio_ = createElement_ "audio"

-- | Creates a `<audio>` element with attributes and no children nodes
audio' ∷ ∀ message. Array (NodeData message) → Html message
audio' = createElement' "audio"

-- | Creates a `<b>` element with attributes and children nodes
b ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
b = createElement "b"

-- | Creates a `<b>` element with children nodes and no attributes
b_ ∷ ∀ message. Array (Html message) → Html message
b_ = createElement_ "b"

-- | Creates a `<b>` element with attributes and no children nodes
b' ∷ ∀ message. Array (NodeData message) → Html message
b' = createElement' "b"

-- | Creates a `<base>` element with attributes; `base` is a void element and cannot have children
base ∷ ∀ message. Array (NodeData message) → Html message
base = createElement' "base"

-- | Creates a `<bdi>` element with attributes and children nodes
bdi ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
bdi = createElement "bdi"

-- | Creates a `<bdi>` element with children nodes and no attributes
bdi_ ∷ ∀ message. Array (Html message) → Html message
bdi_ = createElement_ "bdi"

-- | Creates a `<bdi>` element with attributes and no children nodes
bdi' ∷ ∀ message. Array (NodeData message) → Html message
bdi' = createElement' "bdi"

-- | Creates a `<bdo>` element with attributes and children nodes
bdo ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
bdo = createElement "bdo"

-- | Creates a `<bdo>` element with children nodes and no attributes
bdo_ ∷ ∀ message. Array (Html message) → Html message
bdo_ = createElement_ "bdo"

-- | Creates a `<bdo>` element with attributes and no children nodes
bdo' ∷ ∀ message. Array (NodeData message) → Html message
bdo' = createElement' "bdo"

-- | Creates a `<blockquote>` element with attributes and children nodes
blockquote ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
blockquote = createElement "blockquote"

-- | Creates a `<blockquote>` element with children nodes and no attributes
blockquote_ ∷ ∀ message. Array (Html message) → Html message
blockquote_ = createElement_ "blockquote"

-- | Creates a `<blockquote>` element with attributes and no children nodes
blockquote' ∷ ∀ message. Array (NodeData message) → Html message
blockquote' = createElement' "blockquote"

-- | Creates a `<body>` element with attributes and children nodes
body ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
body = createElement "body"

-- | Creates a `<body>` element with children nodes and no attributes
body_ ∷ ∀ message. Array (Html message) → Html message
body_ = createElement_ "body"

-- | Creates a `<body>` element with attributes and no children nodes
body' ∷ ∀ message. Array (NodeData message) → Html message
body' = createElement' "body"

-- | Creates a `<button>` element with attributes and children nodes
button ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
button = createElement "button"

-- | Creates a `<button>` element with children nodes and no attributes
button_ ∷ ∀ message. Array (Html message) → Html message
button_ = createElement_ "button"

-- | Creates a `<button>` element with attributes and no children nodes
button' ∷ ∀ message. Array (NodeData message) → Html message
button' = createElement' "button"

-- | Creates a `<canvas>` element with attributes and children nodes
canvas ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
canvas = createElement "canvas"

-- | Creates a `<canvas>` element with children nodes and no attributes
canvas_ ∷ ∀ message. Array (Html message) → Html message
canvas_ = createElement_ "canvas"

-- | Creates a `<canvas>` element with attributes and no children nodes
canvas' ∷ ∀ message. Array (NodeData message) → Html message
canvas' = createElement' "canvas"

-- | Creates a `<caption>` element with attributes and children nodes
caption ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
caption = createElement "caption"

-- | Creates a `<caption>` element with children nodes and no attributes
caption_ ∷ ∀ message. Array (Html message) → Html message
caption_ = createElement_ "caption"

-- | Creates a `<caption>` element with attributes and no children nodes
caption' ∷ ∀ message. Array (NodeData message) → Html message
caption' = createElement' "caption"

-- | Creates a `<cite>` element with attributes and children nodes
cite ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
cite = createElement "cite"

-- | Creates a `<cite>` element with children nodes and no attributes
cite_ ∷ ∀ message. Array (Html message) → Html message
cite_ = createElement_ "cite"

-- | Creates a `<cite>` element with attributes and no children nodes
cite' ∷ ∀ message. Array (NodeData message) → Html message
cite' = createElement' "cite"

-- | Creates a `<code>` element with attributes and children nodes
code ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
code = createElement "code"

-- | Creates a `<code>` element with children nodes and no attributes
code_ ∷ ∀ message. Array (Html message) → Html message
code_ = createElement_ "code"

-- | Creates a `<code>` element with attributes and no children nodes
code' ∷ ∀ message. Array (NodeData message) → Html message
code' = createElement' "code"

-- | Creates a `<col>` element with attributes; `col` is a void element and cannot have children
col ∷ ∀ message. Array (NodeData message) → Html message
col = createElement' "col"

-- | Creates a `<colgroup>` element with attributes and children nodes
colgroup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
colgroup = createElement "colgroup"

-- | Creates a `<colgroup>` element with children nodes and no attributes
colgroup_ ∷ ∀ message. Array (Html message) → Html message
colgroup_ = createElement_ "colgroup"

-- | Creates a `<colgroup>` element with attributes and no children nodes
colgroup' ∷ ∀ message. Array (NodeData message) → Html message
colgroup' = createElement' "colgroup"

-- | Creates a `<data>` element with children nodes and no attributes
data_ ∷ ∀ message. Array (Html message) → Html message
data_ = createElement_ "data"

-- | Creates a `<data>` element with attributes and no children nodes
data' ∷ ∀ message. Array (NodeData message) → Html message
data' = createElement' "data"

-- | Creates a `<datalist>` element with attributes and children nodes
datalist ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
datalist = createElement "datalist"

-- | Creates a `<datalist>` element with children nodes and no attributes
datalist_ ∷ ∀ message. Array (Html message) → Html message
datalist_ = createElement_ "datalist"

-- | Creates a `<datalist>` element with attributes and no children nodes
datalist' ∷ ∀ message. Array (NodeData message) → Html message
datalist' = createElement' "datalist"

-- | Creates a `<dd>` element with attributes and children nodes
dd ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dd = createElement "dd"

-- | Creates a `<dd>` element with children nodes and no attributes
dd_ ∷ ∀ message. Array (Html message) → Html message
dd_ = createElement_ "dd"

-- | Creates a `<dd>` element with attributes and no children nodes
dd' ∷ ∀ message. Array (NodeData message) → Html message
dd' = createElement' "dd"

-- | Creates a `<del>` element with attributes and children nodes
del ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
del = createElement "del"

-- | Creates a `<del>` element with children nodes and no attributes
del_ ∷ ∀ message. Array (Html message) → Html message
del_ = createElement_ "del"

-- | Creates a `<del>` element with attributes and no children nodes
del' ∷ ∀ message. Array (NodeData message) → Html message
del' = createElement' "del"

-- | Creates a `<details>` element with attributes and children nodes
details ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
details = createElement "details"

-- | Creates a `<details>` element with children nodes and no attributes
details_ ∷ ∀ message. Array (Html message) → Html message
details_ = createElement_ "details"

-- | Creates a `<details>` element with attributes and no children nodes
details' ∷ ∀ message. Array (NodeData message) → Html message
details' = createElement' "details"

-- | Creates a `<dfn>` element with attributes and children nodes
dfn ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dfn = createElement "dfn"

-- | Creates a `<dfn>` element with children nodes and no attributes
dfn_ ∷ ∀ message. Array (Html message) → Html message
dfn_ = createElement_ "dfn"

-- | Creates a `<dfn>` element with attributes and no children nodes
dfn' ∷ ∀ message. Array (NodeData message) → Html message
dfn' = createElement' "dfn"

-- | Creates a `<dialog>` element with attributes and children nodes
dialog ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dialog = createElement "dialog"

-- | Creates a `<dialog>` element with children nodes and no attributes
dialog_ ∷ ∀ message. Array (Html message) → Html message
dialog_ = createElement_ "dialog"

-- | Creates a `<dialog>` element with attributes and no children nodes
dialog' ∷ ∀ message. Array (NodeData message) → Html message
dialog' = createElement' "dialog"

-- | Creates a `<div>` element with attributes and children nodes
div ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
div = createElement "div"

-- | Creates a `<div>` element with children nodes and no attributes
div_ ∷ ∀ message. Array (Html message) → Html message
div_ = createElement_ "div"

-- | Creates a `<div>` element with attributes and no children nodes
div' ∷ ∀ message. Array (NodeData message) → Html message
div' = createElement' "div"

-- | Creates a `<dl>` element with attributes and children nodes
dl ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dl = createElement "dl"

-- | Creates a `<dl>` element with children nodes and no attributes
dl_ ∷ ∀ message. Array (Html message) → Html message
dl_ = createElement_ "dl"

-- | Creates a `<dl>` element with attributes and no children nodes
dl' ∷ ∀ message. Array (NodeData message) → Html message
dl' = createElement' "dl"

-- | Creates a `<dt>` element with attributes and children nodes
dt ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
dt = createElement "dt"

-- | Creates a `<dt>` element with children nodes and no attributes
dt_ ∷ ∀ message. Array (Html message) → Html message
dt_ = createElement_ "dt"

-- | Creates a `<dt>` element with attributes and no children nodes
dt' ∷ ∀ message. Array (NodeData message) → Html message
dt' = createElement' "dt"

-- | Creates a `<em>` element with attributes and children nodes
em ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
em = createElement "em"

-- | Creates a `<em>` element with children nodes and no attributes
em_ ∷ ∀ message. Array (Html message) → Html message
em_ = createElement_ "em"

-- | Creates a `<em>` element with attributes and no children nodes
em' ∷ ∀ message. Array (NodeData message) → Html message
em' = createElement' "em"

-- | Creates a `<embed>` element with attributes; `embed` is a void element and cannot have children
embed ∷ ∀ message. Array (NodeData message) → Html message
embed = createElement' "embed"

-- | Creates a `<fieldset>` element with attributes and children nodes
fieldset ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fieldset = createElement "fieldset"

-- | Creates a `<fieldset>` element with children nodes and no attributes
fieldset_ ∷ ∀ message. Array (Html message) → Html message
fieldset_ = createElement_ "fieldset"

-- | Creates a `<fieldset>` element with attributes and no children nodes
fieldset' ∷ ∀ message. Array (NodeData message) → Html message
fieldset' = createElement' "fieldset"

-- | Creates a `<figure>` element with attributes and children nodes
figure ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
figure = createElement "figure"

-- | Creates a `<figure>` element with children nodes and no attributes
figure_ ∷ ∀ message. Array (Html message) → Html message
figure_ = createElement_ "figure"

-- | Creates a `<figure>` element with attributes and no children nodes
figure' ∷ ∀ message. Array (NodeData message) → Html message
figure' = createElement' "figure"

-- | Creates a `<footer>` element with attributes and children nodes
footer ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
footer = createElement "footer"

-- | Creates a `<footer>` element with children nodes and no attributes
footer_ ∷ ∀ message. Array (Html message) → Html message
footer_ = createElement_ "footer"

-- | Creates a `<footer>` element with attributes and no children nodes
footer' ∷ ∀ message. Array (NodeData message) → Html message
footer' = createElement' "footer"

-- | Creates a `<form>` element with attributes and children nodes
form ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
form = createElement "form"

-- | Creates a `<form>` element with children nodes and no attributes
form_ ∷ ∀ message. Array (Html message) → Html message
form_ = createElement_ "form"

-- | Creates a `<form>` element with attributes and no children nodes
form' ∷ ∀ message. Array (NodeData message) → Html message
form' = createElement' "form"

-- | Creates a `<h1>` element with attributes and children nodes
h1 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h1 = createElement "h1"

-- | Creates a `<h1>` element with children nodes and no attributes
h1_ ∷ ∀ message. Array (Html message) → Html message
h1_ = createElement_ "h1"

-- | Creates a `<h1>` element with attributes and no children nodes
h1' ∷ ∀ message. Array (NodeData message) → Html message
h1' = createElement' "h1"

-- | Creates a `<h2>` element with attributes and children nodes
h2 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h2 = createElement "h2"

-- | Creates a `<h2>` element with children nodes and no attributes
h2_ ∷ ∀ message. Array (Html message) → Html message
h2_ = createElement_ "h2"

-- | Creates a `<h2>` element with attributes and no children nodes
h2' ∷ ∀ message. Array (NodeData message) → Html message
h2' = createElement' "h2"

-- | Creates a `<h3>` element with attributes and children nodes
h3 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h3 = createElement "h3"

-- | Creates a `<h3>` element with children nodes and no attributes
h3_ ∷ ∀ message. Array (Html message) → Html message
h3_ = createElement_ "h3"

-- | Creates a `<h3>` element with attributes and no children nodes
h3' ∷ ∀ message. Array (NodeData message) → Html message
h3' = createElement' "h3"

-- | Creates a `<h4>` element with attributes and children nodes
h4 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h4 = createElement "h4"

-- | Creates a `<h4>` element with children nodes and no attributes
h4_ ∷ ∀ message. Array (Html message) → Html message
h4_ = createElement_ "h4"

-- | Creates a `<h4>` element with attributes and no children nodes
h4' ∷ ∀ message. Array (NodeData message) → Html message
h4' = createElement' "h4"

-- | Creates a `<h5>` element with attributes and children nodes
h5 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h5 = createElement "h5"

-- | Creates a `<h5>` element with children nodes and no attributes
h5_ ∷ ∀ message. Array (Html message) → Html message
h5_ = createElement_ "h5"

-- | Creates a `<h5>` element with attributes and no children nodes
h5' ∷ ∀ message. Array (NodeData message) → Html message
h5' = createElement' "h5"

-- | Creates a `<h6>` element with attributes and children nodes
h6 ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
h6 = createElement "h6"

-- | Creates a `<h6>` element with children nodes and no attributes
h6_ ∷ ∀ message. Array (Html message) → Html message
h6_ = createElement_ "h6"

-- | Creates a `<h6>` element with attributes and no children nodes
h6' ∷ ∀ message. Array (NodeData message) → Html message
h6' = createElement' "h6"

-- | Creates a `<head>` element with attributes and children nodes
head ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
head = createElement "head"

-- | Creates a `<head>` element with children nodes and no attributes
head_ ∷ ∀ message. Array (Html message) → Html message
head_ = createElement_ "head"

-- | Creates a `<head>` element with attributes and no children nodes
head' ∷ ∀ message. Array (NodeData message) → Html message
head' = createElement' "head"

-- | Creates a `<header>` element with attributes and children nodes
header ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
header = createElement "header"

-- | Creates a `<header>` element with children nodes and no attributes
header_ ∷ ∀ message. Array (Html message) → Html message
header_ = createElement_ "header"

-- | Creates a `<header>` element with attributes and no children nodes
header' ∷ ∀ message. Array (NodeData message) → Html message
header' = createElement' "header"

-- | Creates a `<hgroup>` element with attributes and children nodes
hgroup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hgroup = createElement "hgroup"

-- | Creates a `<hgroup>` element with children nodes and no attributes
hgroup_ ∷ ∀ message. Array (Html message) → Html message
hgroup_ = createElement_ "hgroup"

-- | Creates a `<hgroup>` element with attributes and no children nodes
hgroup' ∷ ∀ message. Array (NodeData message) → Html message
hgroup' = createElement' "hgroup"

-- | Creates a `<html>` element with attributes and children nodes
html ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
html = createElement "html"

-- | Creates a `<html>` element with children nodes and no attributes
html_ ∷ ∀ message. Array (Html message) → Html message
html_ = createElement_ "html"

-- | Creates a `<html>` element with attributes and no children nodes
html' ∷ ∀ message. Array (NodeData message) → Html message
html' = createElement' "html"

-- | Creates a `<i>` element with attributes and children nodes
i ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
i = createElement "i"

-- | Creates a `<i>` element with children nodes and no attributes
i_ ∷ ∀ message. Array (Html message) → Html message
i_ = createElement_ "i"

-- | Creates a `<i>` element with attributes and no children nodes
i' ∷ ∀ message. Array (NodeData message) → Html message
i' = createElement' "i"

-- | Creates a `<iframe>` element with attributes and children nodes
iframe ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
iframe = createElement "iframe"

-- | Creates a `<iframe>` element with children nodes and no attributes
iframe_ ∷ ∀ message. Array (Html message) → Html message
iframe_ = createElement_ "iframe"

-- | Creates a `<iframe>` element with attributes and no children nodes
iframe' ∷ ∀ message. Array (NodeData message) → Html message
iframe' = createElement' "iframe"

-- | Creates a `<ins>` element with attributes and children nodes
ins ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ins = createElement "ins"

-- | Creates a `<ins>` element with children nodes and no attributes
ins_ ∷ ∀ message. Array (Html message) → Html message
ins_ = createElement_ "ins"

-- | Creates a `<ins>` element with attributes and no children nodes
ins' ∷ ∀ message. Array (NodeData message) → Html message
ins' = createElement' "ins"

-- | Creates a `<kbd>` element with attributes and children nodes
kbd ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
kbd = createElement "kbd"

-- | Creates a `<kbd>` element with children nodes and no attributes
kbd_ ∷ ∀ message. Array (Html message) → Html message
kbd_ = createElement_ "kbd"

-- | Creates a `<kbd>` element with attributes and no children nodes
kbd' ∷ ∀ message. Array (NodeData message) → Html message
kbd' = createElement' "kbd"

-- | Creates a `<keygen>` element with attributes; `keygen` is a void element and cannot have children
keygen ∷ ∀ message. Array (NodeData message) → Html message
keygen = createElement' "keygen"

-- | Creates a `<label>` element with attributes and children nodes
label ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
label = createElement "label"

-- | Creates a `<label>` element with children nodes and no attributes
label_ ∷ ∀ message. Array (Html message) → Html message
label_ = createElement_ "label"

-- | Creates a `<label>` element with attributes and no children nodes
label' ∷ ∀ message. Array (NodeData message) → Html message
label' = createElement' "label"

-- | Creates a `<legend>` element with attributes and children nodes
legend ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
legend = createElement "legend"

-- | Creates a `<legend>` element with children nodes and no attributes
legend_ ∷ ∀ message. Array (Html message) → Html message
legend_ = createElement_ "legend"

-- | Creates a `<legend>` element with attributes and no children nodes
legend' ∷ ∀ message. Array (NodeData message) → Html message
legend' = createElement' "legend"

-- | Creates a `<li>` element with attributes and children nodes
li ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
li = createElement "li"

-- | Creates a `<li>` element with children nodes and no attributes
li_ ∷ ∀ message. Array (Html message) → Html message
li_ = createElement_ "li"

-- | Creates a `<li>` element with attributes and no children nodes
li' ∷ ∀ message. Array (NodeData message) → Html message
li' = createElement' "li"

-- | Creates a `<link>` element with attributes and no children nodes
link ∷ ∀ message. Array (NodeData message) → Html message
link = createElement' "link"

-- | Creates a `<main>` element with attributes and children nodes
main ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
main = createElement "main"

-- | Creates a `<main>` element with children nodes and no attributes
main_ ∷ ∀ message. Array (Html message) → Html message
main_ = createElement_ "main"

-- | Creates a `<main>` element with attributes and no children nodes
main' ∷ ∀ message. Array (NodeData message) → Html message
main' = createElement' "main"

-- | Creates a `<map>` element with attributes and children nodes
map ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
map = createElement "map"

-- | Creates a `<map>` element with children nodes and no attributes
map_ ∷ ∀ message. Array (Html message) → Html message
map_ = createElement_ "map"

-- | Creates a `<map>` element with attributes and no children nodes
map' ∷ ∀ message. Array (NodeData message) → Html message
map' = createElement' "map"

-- | Creates a `<mark>` element with attributes and children nodes
mark ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mark = createElement "mark"

-- | Creates a `<mark>` element with children nodes and no attributes
mark_ ∷ ∀ message. Array (Html message) → Html message
mark_ = createElement_ "mark"

-- | Creates a `<mark>` element with attributes and no children nodes
mark' ∷ ∀ message. Array (NodeData message) → Html message
mark' = createElement' "mark"

-- | Creates a `<menu>` element with attributes and children nodes
menu ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
menu = createElement "menu"

-- | Creates a `<menu>` element with children nodes and no attributes
menu_ ∷ ∀ message. Array (Html message) → Html message
menu_ = createElement_ "menu"

-- | Creates a `<menu>` element with attributes and no children nodes
menu' ∷ ∀ message. Array (NodeData message) → Html message
menu' = createElement' "menu"

-- | Creates a `<menuitem>` element with attributes and children nodes
menuitem ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
menuitem = createElement "menuitem"

-- | Creates a `<menuitem>` element with children nodes and no attributes
menuitem_ ∷ ∀ message. Array (Html message) → Html message
menuitem_ = createElement_ "menuitem"

-- | Creates a `<menuitem>` element with attributes and no children nodes
menuitem' ∷ ∀ message. Array (NodeData message) → Html message
menuitem' = createElement' "menuitem"

-- | Creates a `<meta>` element with attributes and no children nodes
meta ∷ ∀ message. Array (NodeData message) → Html message
meta = createElement' "meta"

-- | Creates a `<meter>` element with attributes and children nodes
meter ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meter = createElement "meter"

-- | Creates a `<meter>` element with children nodes and no attributes
meter_ ∷ ∀ message. Array (Html message) → Html message
meter_ = createElement_ "meter"

-- | Creates a `<meter>` element with attributes and no children nodes
meter' ∷ ∀ message. Array (NodeData message) → Html message
meter' = createElement' "meter"

-- | Creates a `<nav>` element with attributes and children nodes
nav ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
nav = createElement "nav"

-- | Creates a `<nav>` element with children nodes and no attributes
nav_ ∷ ∀ message. Array (Html message) → Html message
nav_ = createElement_ "nav"

-- | Creates a `<nav>` element with attributes and no children nodes
nav' ∷ ∀ message. Array (NodeData message) → Html message
nav' = createElement' "nav"

-- | Creates a `<noscript>` element with attributes and children nodes
noscript ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
noscript = createElement "noscript"

-- | Creates a `<noscript>` element with children nodes and no attributes
noscript_ ∷ ∀ message. Array (Html message) → Html message
noscript_ = createElement_ "noscript"

-- | Creates a `<noscript>` element with attributes and no children nodes
noscript' ∷ ∀ message. Array (NodeData message) → Html message
noscript' = createElement' "noscript"

-- | Creates a `<object>` element with attributes and children nodes
object ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
object = createElement "object"

-- | Creates a `<object>` element with children nodes and no attributes
object_ ∷ ∀ message. Array (Html message) → Html message
object_ = createElement_ "object"

-- | Creates a `<object>` element with attributes and no children nodes
object' ∷ ∀ message. Array (NodeData message) → Html message
object' = createElement' "object"

-- | Creates a `<ol>` element with attributes and children nodes
ol ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ol = createElement "ol"

-- | Creates a `<ol>` element with children nodes and no attributes
ol_ ∷ ∀ message. Array (Html message) → Html message
ol_ = createElement_ "ol"

-- | Creates a `<ol>` element with attributes and no children nodes
ol' ∷ ∀ message. Array (NodeData message) → Html message
ol' = createElement' "ol"

-- | Creates a `<img>` element with attributes and no children nodes
img ∷ ∀ message. Array (NodeData message) → Html message
img = createElement' "img"

-- | Creates a `<optgroup>` element with attributes and children nodes
optgroup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
optgroup = createElement "optgroup"

-- | Creates a `<optgroup>` element with children nodes and no attributes
optgroup_ ∷ ∀ message. Array (Html message) → Html message
optgroup_ = createElement_ "optgroup"

-- | Creates a `<optgroup>` element with attributes and no children nodes
optgroup' ∷ ∀ message. Array (NodeData message) → Html message
optgroup' = createElement' "optgroup"

-- | Creates a `<option>` element with attributes and children nodes
option ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
option = createElement "option"

-- | Creates a `<option>` element with children nodes and no attributes
option_ ∷ ∀ message. Array (Html message) → Html message
option_ = createElement_ "option"

-- | Creates a `<option>` element with attributes and no children nodes
option' ∷ ∀ message. Array (NodeData message) → Html message
option' = createElement' "option"

-- | Creates a `<output>` element with attributes and children nodes
output ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
output = createElement "output"

-- | Creates a `<output>` element with children nodes and no attributes
output_ ∷ ∀ message. Array (Html message) → Html message
output_ = createElement_ "output"

-- | Creates a `<output>` element with attributes and no children nodes
output' ∷ ∀ message. Array (NodeData message) → Html message
output' = createElement' "output"

-- | Creates a `<p>` element with attributes and children nodes
p ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
p = createElement "p"

-- | Creates a `<p>` element with children nodes and no attributes
p_ ∷ ∀ message. Array (Html message) → Html message
p_ = createElement_ "p"

-- | Creates a `<p>` element with attributes and no children nodes
p' ∷ ∀ message. Array (NodeData message) → Html message
p' = createElement' "p"

-- | Creates a `<param>` element with attributes; `param` is a void element and cannot have children
param ∷ ∀ message. Array (NodeData message) → Html message
param = createElement' "param"

-- | Creates a `<pre>` element with attributes and children nodes
pre ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
pre = createElement "pre"

-- | Creates a `<pre>` element with children nodes and no attributes
pre_ ∷ ∀ message. Array (Html message) → Html message
pre_ = createElement_ "pre"

-- | Creates a `<pre>` element with attributes and no children nodes
pre' ∷ ∀ message. Array (NodeData message) → Html message
pre' = createElement' "pre"

-- | Creates a `<progress>` element with attributes and children nodes
progress ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
progress = createElement "progress"

-- | Creates a `<progress>` element with children nodes and no attributes
progress_ ∷ ∀ message. Array (Html message) → Html message
progress_ = createElement_ "progress"

-- | Creates a `<progress>` element with attributes and no children nodes
progress' ∷ ∀ message. Array (NodeData message) → Html message
progress' = createElement' "progress"

-- | Creates a `<q>` element with attributes and children nodes
q ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
q = createElement "q"

-- | Creates a `<q>` element with children nodes and no attributes
q_ ∷ ∀ message. Array (Html message) → Html message
q_ = createElement_ "q"

-- | Creates a `<q>` element with attributes and no children nodes
q' ∷ ∀ message. Array (NodeData message) → Html message
q' = createElement' "q"

-- | Creates a `<rb>` element with attributes and children nodes
rb ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rb = createElement "rb"

-- | Creates a `<rb>` element with children nodes and no attributes
rb_ ∷ ∀ message. Array (Html message) → Html message
rb_ = createElement_ "rb"

-- | Creates a `<rb>` element with attributes and no children nodes
rb' ∷ ∀ message. Array (NodeData message) → Html message
rb' = createElement' "rb"

-- | Creates a `<rp>` element with attributes and children nodes
rp ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rp = createElement "rp"

-- | Creates a `<rp>` element with children nodes and no attributes
rp_ ∷ ∀ message. Array (Html message) → Html message
rp_ = createElement_ "rp"

-- | Creates a `<rp>` element with attributes and no children nodes
rp' ∷ ∀ message. Array (NodeData message) → Html message
rp' = createElement' "rp"

-- | Creates a `<rt>` element with attributes and children nodes
rt ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rt = createElement "rt"

-- | Creates a `<rt>` element with children nodes and no attributes
rt_ ∷ ∀ message. Array (Html message) → Html message
rt_ = createElement_ "rt"

-- | Creates a `<rt>` element with attributes and no children nodes
rt' ∷ ∀ message. Array (NodeData message) → Html message
rt' = createElement' "rt"

-- | Creates a `<rtc>` element with attributes and children nodes
rtc ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rtc = createElement "rtc"

-- | Creates a `<rtc>` element with children nodes and no attributes
rtc_ ∷ ∀ message. Array (Html message) → Html message
rtc_ = createElement_ "rtc"

-- | Creates a `<rtc>` element with attributes and no children nodes
rtc' ∷ ∀ message. Array (NodeData message) → Html message
rtc' = createElement' "rtc"

-- | Creates a `<ruby>` element with attributes and children nodes
ruby ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ruby = createElement "ruby"

-- | Creates a `<ruby>` element with children nodes and no attributes
ruby_ ∷ ∀ message. Array (Html message) → Html message
ruby_ = createElement_ "ruby"

-- | Creates a `<ruby>` element with attributes and no children nodes
ruby' ∷ ∀ message. Array (NodeData message) → Html message
ruby' = createElement' "ruby"

-- | Creates a `<s>` element with attributes and children nodes
s ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
s = createElement "s"

-- | Creates a `<s>` element with children nodes and no attributes
s_ ∷ ∀ message. Array (Html message) → Html message
s_ = createElement_ "s"

-- | Creates a `<s>` element with attributes and no children nodes
s' ∷ ∀ message. Array (NodeData message) → Html message
s' = createElement' "s"

-- | Creates a `<section>` element with attributes and children nodes
section ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
section = createElement "section"

-- | Creates a `<section>` element with children nodes and no attributes
section_ ∷ ∀ message. Array (Html message) → Html message
section_ = createElement_ "section"

-- | Creates a `<section>` element with attributes and no children nodes
section' ∷ ∀ message. Array (NodeData message) → Html message
section' = createElement' "section"

-- | Creates a `<select>` element with attributes and children nodes
select ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
select = createElement "select"

-- | Creates a `<select>` element with children nodes and no attributes
select_ ∷ ∀ message. Array (Html message) → Html message
select_ = createElement_ "select"

-- | Creates a `<select>` element with attributes and no children nodes
select' ∷ ∀ message. Array (NodeData message) → Html message
select' = createElement' "select"

-- | Creates a `<small>` element with attributes and children nodes
small ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
small = createElement "small"

-- | Creates a `<small>` element with children nodes and no attributes
small_ ∷ ∀ message. Array (Html message) → Html message
small_ = createElement_ "small"

-- | Creates a `<small>` element with attributes and no children nodes
small' ∷ ∀ message. Array (NodeData message) → Html message
small' = createElement' "small"

-- | Creates a `<source>` element with attributes; `source` is a void element and cannot have children
source ∷ ∀ message. Array (NodeData message) → Html message
source = createElement' "source"

-- | Creates a `<span>` element with attributes and children nodes
span ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
span = createElement "span"

-- | Creates a `<span>` element with children nodes and no attributes
span_ ∷ ∀ message. Array (Html message) → Html message
span_ = createElement_ "span"

-- | Creates a `<span>` element with attributes and no children nodes
span' ∷ ∀ message. Array (NodeData message) → Html message
span' = createElement' "span"

-- | Creates a `<strong>` element with attributes and children nodes
strong ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
strong = createElement "strong"

-- | Creates a `<strong>` element with children nodes and no attributes
strong_ ∷ ∀ message. Array (Html message) → Html message
strong_ = createElement_ "strong"

-- | Creates a `<strong>` element with attributes and no children nodes
strong' ∷ ∀ message. Array (NodeData message) → Html message
strong' = createElement' "strong"

-- | Creates a `<style>` element with attributes and children nodes
style ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
style = createElement "style"

-- | Creates a `<style>` element with children nodes and no attributes
style_ ∷ ∀ message. Array (Html message) → Html message
style_ = createElement_ "style"

-- | Creates a `<style>` element with attributes and no children nodes
style' ∷ ∀ message. Array (NodeData message) → Html message
style' = createElement' "style"

-- | Creates a `<sub>` element with attributes and children nodes
sub ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
sub = createElement "sub"

-- | Creates a `<sub>` element with children nodes and no attributes
sub_ ∷ ∀ message. Array (Html message) → Html message
sub_ = createElement_ "sub"

-- | Creates a `<sub>` element with attributes and no children nodes
sub' ∷ ∀ message. Array (NodeData message) → Html message
sub' = createElement' "sub"

-- | Creates a `<summary>` element with attributes and children nodes
summary ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
summary = createElement "summary"

-- | Creates a `<summary>` element with children nodes and no attributes
summary_ ∷ ∀ message. Array (Html message) → Html message
summary_ = createElement_ "summary"

-- | Creates a `<summary>` element with attributes and no children nodes
summary' ∷ ∀ message. Array (NodeData message) → Html message
summary' = createElement' "summary"

-- | Creates a `<sup>` element with attributes and children nodes
sup ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
sup = createElement "sup"

-- | Creates a `<sup>` element with children nodes and no attributes
sup_ ∷ ∀ message. Array (Html message) → Html message
sup_ = createElement_ "sup"

-- | Creates a `<sup>` element with attributes and no children nodes
sup' ∷ ∀ message. Array (NodeData message) → Html message
sup' = createElement' "sup"

-- | Creates a `<table>` element with attributes and children nodes
table ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
table = createElement "table"

-- | Creates a `<table>` element with children nodes and no attributes
table_ ∷ ∀ message. Array (Html message) → Html message
table_ = createElement_ "table"

-- | Creates a `<table>` element with attributes and no children nodes
table' ∷ ∀ message. Array (NodeData message) → Html message
table' = createElement' "table"

-- | Creates a `<tbody>` element with attributes and children nodes
tbody ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tbody = createElement "tbody"

-- | Creates a `<tbody>` element with children nodes and no attributes
tbody_ ∷ ∀ message. Array (Html message) → Html message
tbody_ = createElement_ "tbody"

-- | Creates a `<tbody>` element with attributes and no children nodes
tbody' ∷ ∀ message. Array (NodeData message) → Html message
tbody' = createElement' "tbody"

-- | Creates a `<td>` element with attributes and children nodes
td ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
td = createElement "td"

-- | Creates a `<td>` element with children nodes and no attributes
td_ ∷ ∀ message. Array (Html message) → Html message
td_ = createElement_ "td"

-- | Creates a `<td>` element with attributes and no children nodes
td' ∷ ∀ message. Array (NodeData message) → Html message
td' = createElement' "td"

-- | Creates a `<template>` element with attributes and children nodes
template ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
template = createElement "template"

-- | Creates a `<template>` element with children nodes and no attributes
template_ ∷ ∀ message. Array (Html message) → Html message
template_ = createElement_ "template"

-- | Creates a `<template>` element with attributes and no children nodes
template' ∷ ∀ message. Array (NodeData message) → Html message
template' = createElement' "template"

-- | Creates a `<textarea>` element with attributes and children nodes
textarea ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
textarea = createElement "textarea"

-- | Creates a `<textarea>` element with children nodes and no attributes
textarea_ ∷ ∀ message. Array (Html message) → Html message
textarea_ = createElement_ "textarea"

-- | Creates a `<textarea>` element with attributes and no children nodes
textarea' ∷ ∀ message. Array (NodeData message) → Html message
textarea' = createElement' "textarea"

-- | Creates a `<tfoot>` element with attributes and children nodes
tfoot ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tfoot = createElement "tfoot"

-- | Creates a `<tfoot>` element with children nodes and no attributes
tfoot_ ∷ ∀ message. Array (Html message) → Html message
tfoot_ = createElement_ "tfoot"

-- | Creates a `<tfoot>` element with attributes and no children nodes
tfoot' ∷ ∀ message. Array (NodeData message) → Html message
tfoot' = createElement' "tfoot"

-- | Creates a `<th>` element with attributes and children nodes
th ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
th = createElement "th"

-- | Creates a `<th>` element with children nodes and no attributes
th_ ∷ ∀ message. Array (Html message) → Html message
th_ = createElement_ "th"

-- | Creates a `<th>` element with attributes and no children nodes
th' ∷ ∀ message. Array (NodeData message) → Html message
th' = createElement' "th"

-- | Creates a `<thead>` element with attributes and children nodes
thead ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
thead = createElement "thead"

-- | Creates a `<thead>` element with children nodes and no attributes
thead_ ∷ ∀ message. Array (Html message) → Html message
thead_ = createElement_ "thead"

-- | Creates a `<thead>` element with attributes and no children nodes
thead' ∷ ∀ message. Array (NodeData message) → Html message
thead' = createElement' "thead"

-- | Creates a `<time>` element with attributes and children nodes
time ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
time = createElement "time"

-- | Creates a `<time>` element with children nodes and no attributes
time_ ∷ ∀ message. Array (Html message) → Html message
time_ = createElement_ "time"

-- | Creates a `<time>` element with attributes and no children nodes
time' ∷ ∀ message. Array (NodeData message) → Html message
time' = createElement' "time"

-- | Creates a `<title>` element with children nodes and no attributes
title ∷ ∀ message. Array (Html message) → Html message
title = createElement_ "title"

-- | Creates a `<tr>` element with attributes and children nodes
tr ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tr = createElement "tr"

-- | Creates a `<tr>` element with children nodes and no attributes
tr_ ∷ ∀ message. Array (Html message) → Html message
tr_ = createElement_ "tr"

-- | Creates a `<tr>` element with attributes and no children nodes
tr' ∷ ∀ message. Array (NodeData message) → Html message
tr' = createElement' "tr"

-- | Creates a `<track>` element with attributes; `track` is a void element and cannot have children
track ∷ ∀ message. Array (NodeData message) → Html message
track = createElement' "track"

-- | Creates a `<u>` element with attributes and children nodes
u ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
u = createElement "u"

-- | Creates a `<u>` element with children nodes and no attributes
u_ ∷ ∀ message. Array (Html message) → Html message
u_ = createElement_ "u"

-- | Creates a `<u>` element with attributes and no children nodes
u' ∷ ∀ message. Array (NodeData message) → Html message
u' = createElement' "u"

-- | Creates a `<ul>` element with attributes and children nodes
ul ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ul = createElement "ul"

-- | Creates a `<ul>` element with children nodes and no attributes
ul_ ∷ ∀ message. Array (Html message) → Html message
ul_ = createElement_ "ul"

-- | Creates a `<ul>` element with attributes and no children nodes
ul' ∷ ∀ message. Array (NodeData message) → Html message
ul' = createElement' "ul"

-- | Creates a `<var>` element with attributes and children nodes
var ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
var = createElement "var"

-- | Creates a `<var>` element with children nodes and no attributes
var_ ∷ ∀ message. Array (Html message) → Html message
var_ = createElement_ "var"

-- | Creates a `<var>` element with attributes and no children nodes
var' ∷ ∀ message. Array (NodeData message) → Html message
var' = createElement' "var"

-- | Creates a `<video>` element with attributes and children nodes
video ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
video = createElement "video"

-- | Creates a `<video>` element with children nodes and no attributes
video_ ∷ ∀ message. Array (Html message) → Html message
video_ = createElement_ "video"

-- | Creates a `<video>` element with attributes and no children nodes
video' ∷ ∀ message. Array (NodeData message) → Html message
video' = createElement' "video"

-- | Creates a `<wbr>` element with attributes; `wbr` is a void element and cannot have children
wbr ∷ ∀ message. Array (NodeData message) → Html message
wbr = createElement' "wbr"

-- | Creates a `<animate>` element with attributes and children nodes
animate ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animate = createElement "animate"

-- | Creates a `<animate>` element with children nodes and no attributes
animate_ ∷ ∀ message. Array (Html message) → Html message
animate_ = createElement_ "animate"

-- | Creates a `<animate>` element with attributes and no children nodes
animate' ∷ ∀ message. Array (NodeData message) → Html message
animate' = createElement' "animate"

-- | Creates a `<animateColor>` element with attributes and children nodes
animateColor ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animateColor = createElement "animateColor"

-- | Creates a `<animateColor>` element with children nodes and no attributes
animateColor_ ∷ ∀ message. Array (Html message) → Html message
animateColor_ = createElement_ "animateColor"

-- | Creates a `<animateColor>` element with attributes and no children nodes
animateColor' ∷ ∀ message. Array (NodeData message) → Html message
animateColor' = createElement' "animateColor"

-- | Creates a `<animateMotion>` element with attributes and children nodes
animateMotion ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animateMotion = createElement "animateMotion"

-- | Creates a `<animateMotion>` element with children nodes and no attributes
animateMotion_ ∷ ∀ message. Array (Html message) → Html message
animateMotion_ = createElement_ "animateMotion"

-- | Creates a `<animateMotion>` element with attributes and no children nodes
animateMotion' ∷ ∀ message. Array (NodeData message) → Html message
animateMotion' = createElement' "animateMotion"

-- | Creates a `<animateTransform>` element with attributes and children nodes
animateTransform ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
animateTransform = createElement "animateTransform"

-- | Creates a `<animateTransform>` element with children nodes and no attributes
animateTransform_ ∷ ∀ message. Array (Html message) → Html message
animateTransform_ = createElement_ "animateTransform"

-- | Creates a `<animateTransform>` element with attributes and no children nodes
animateTransform' ∷ ∀ message. Array (NodeData message) → Html message
animateTransform' = createElement' "animateTransform"

-- | Creates a `<circle>` element with attributes and children nodes
circle ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
circle = createElement "circle"

-- | Creates a `<circle>` element with children nodes and no attributes
circle_ ∷ ∀ message. Array (Html message) → Html message
circle_ = createElement_ "circle"

-- | Creates a `<circle>` element with attributes and no children nodes
circle' ∷ ∀ message. Array (NodeData message) → Html message
circle' = createElement' "circle"

-- | Creates a `<clipPath>` element with attributes and children nodes
clipPath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
clipPath = createElement "clipPath"

-- | Creates a `<clipPath>` element with children nodes and no attributes
clipPath_ ∷ ∀ message. Array (Html message) → Html message
clipPath_ = createElement_ "clipPath"

-- | Creates a `<clipPath>` element with attributes and no children nodes
clipPath' ∷ ∀ message. Array (NodeData message) → Html message
clipPath' = createElement' "clipPath"

-- | Creates a `<color-profile>` element with attributes and children nodes
colorProfile ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
colorProfile = createElement "color-profile"

-- | Creates a `<color-profile>` element with children nodes and no attributes
colorProfile_ ∷ ∀ message. Array (Html message) → Html message
colorProfile_ = createElement_ "color-profile"

-- | Creates a `<color-profile>` element with attributes and no children nodes
colorProfile' ∷ ∀ message. Array (NodeData message) → Html message
colorProfile' = createElement' "color-profile"

-- | Creates a `<cursor>` element with attributes and children nodes
cursor ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
cursor = createElement "cursor"

-- | Creates a `<cursor>` element with children nodes and no attributes
cursor_ ∷ ∀ message. Array (Html message) → Html message
cursor_ = createElement_ "cursor"

-- | Creates a `<cursor>` element with attributes and no children nodes
cursor' ∷ ∀ message. Array (NodeData message) → Html message
cursor' = createElement' "cursor"

-- | Creates a `<defs>` element with attributes and children nodes
defs ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
defs = createElement "defs"

-- | Creates a `<defs>` element with children nodes and no attributes
defs_ ∷ ∀ message. Array (Html message) → Html message
defs_ = createElement_ "defs"

-- | Creates a `<defs>` element with attributes and no children nodes
defs' ∷ ∀ message. Array (NodeData message) → Html message
defs' = createElement' "defs"

-- | Creates a `<desc>` element with attributes and children nodes
desc ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
desc = createElement "desc"

-- | Creates a `<desc>` element with children nodes and no attributes
desc_ ∷ ∀ message. Array (Html message) → Html message
desc_ = createElement_ "desc"

-- | Creates a `<desc>` element with attributes and no children nodes
desc' ∷ ∀ message. Array (NodeData message) → Html message
desc' = createElement' "desc"

-- | Creates a `<discard>` element with attributes and children nodes
discard ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
discard = createElement "discard"

-- | Creates a `<discard>` element with children nodes and no attributes
discard_ ∷ ∀ message. Array (Html message) → Html message
discard_ = createElement_ "discard"

-- | Creates a `<discard>` element with attributes and no children nodes
discard' ∷ ∀ message. Array (NodeData message) → Html message
discard' = createElement' "discard"

-- | Creates a `<ellipse>` element with attributes and children nodes
ellipse ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
ellipse = createElement "ellipse"

-- | Creates a `<ellipse>` element with children nodes and no attributes
ellipse_ ∷ ∀ message. Array (Html message) → Html message
ellipse_ = createElement_ "ellipse"

-- | Creates a `<ellipse>` element with attributes and no children nodes
ellipse' ∷ ∀ message. Array (NodeData message) → Html message
ellipse' = createElement' "ellipse"

-- | Creates a `<feBlend>` element with attributes and children nodes
feBlend ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feBlend = createElement "feBlend"

-- | Creates a `<feBlend>` element with children nodes and no attributes
feBlend_ ∷ ∀ message. Array (Html message) → Html message
feBlend_ = createElement_ "feBlend"

-- | Creates a `<feBlend>` element with attributes and no children nodes
feBlend' ∷ ∀ message. Array (NodeData message) → Html message
feBlend' = createElement' "feBlend"

-- | Creates a `<feColorMatrix>` element with attributes and children nodes
feColorMatrix ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feColorMatrix = createElement "feColorMatrix"

-- | Creates a `<feColorMatrix>` element with children nodes and no attributes
feColorMatrix_ ∷ ∀ message. Array (Html message) → Html message
feColorMatrix_ = createElement_ "feColorMatrix"

-- | Creates a `<feColorMatrix>` element with attributes and no children nodes
feColorMatrix' ∷ ∀ message. Array (NodeData message) → Html message
feColorMatrix' = createElement' "feColorMatrix"

-- | Creates a `<feComponentTransfer>` element with attributes and children nodes
feComponentTransfer ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feComponentTransfer = createElement "feComponentTransfer"

-- | Creates a `<feComponentTransfer>` element with children nodes and no attributes
feComponentTransfer_ ∷ ∀ message. Array (Html message) → Html message
feComponentTransfer_ = createElement_ "feComponentTransfer"

-- | Creates a `<feComponentTransfer>` element with attributes and no children nodes
feComponentTransfer' ∷ ∀ message. Array (NodeData message) → Html message
feComponentTransfer' = createElement' "feComponentTransfer"

-- | Creates a `<feComposite>` element with attributes and children nodes
feComposite ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feComposite = createElement "feComposite"

-- | Creates a `<feComposite>` element with children nodes and no attributes
feComposite_ ∷ ∀ message. Array (Html message) → Html message
feComposite_ = createElement_ "feComposite"

-- | Creates a `<feComposite>` element with attributes and no children nodes
feComposite' ∷ ∀ message. Array (NodeData message) → Html message
feComposite' = createElement' "feComposite"

-- | Creates a `<feConvolveMatrix>` element with attributes and children nodes
feConvolveMatrix ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feConvolveMatrix = createElement "feConvolveMatrix"

-- | Creates a `<feConvolveMatrix>` element with children nodes and no attributes
feConvolveMatrix_ ∷ ∀ message. Array (Html message) → Html message
feConvolveMatrix_ = createElement_ "feConvolveMatrix"

-- | Creates a `<feConvolveMatrix>` element with attributes and no children nodes
feConvolveMatrix' ∷ ∀ message. Array (NodeData message) → Html message
feConvolveMatrix' = createElement' "feConvolveMatrix"

-- | Creates a `<feDiffuseLighting>` element with attributes and children nodes
feDiffuseLighting ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDiffuseLighting = createElement "feDiffuseLighting"

-- | Creates a `<feDiffuseLighting>` element with children nodes and no attributes
feDiffuseLighting_ ∷ ∀ message. Array (Html message) → Html message
feDiffuseLighting_ = createElement_ "feDiffuseLighting"

-- | Creates a `<feDiffuseLighting>` element with attributes and no children nodes
feDiffuseLighting' ∷ ∀ message. Array (NodeData message) → Html message
feDiffuseLighting' = createElement' "feDiffuseLighting"

-- | Creates a `<feDisplacementMap>` element with attributes and children nodes
feDisplacementMap ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDisplacementMap = createElement "feDisplacementMap"

-- | Creates a `<feDisplacementMap>` element with children nodes and no attributes
feDisplacementMap_ ∷ ∀ message. Array (Html message) → Html message
feDisplacementMap_ = createElement_ "feDisplacementMap"

-- | Creates a `<feDisplacementMap>` element with attributes and no children nodes
feDisplacementMap' ∷ ∀ message. Array (NodeData message) → Html message
feDisplacementMap' = createElement' "feDisplacementMap"

-- | Creates a `<feDistantLight>` element with attributes and children nodes
feDistantLight ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDistantLight = createElement "feDistantLight"

-- | Creates a `<feDistantLight>` element with children nodes and no attributes
feDistantLight_ ∷ ∀ message. Array (Html message) → Html message
feDistantLight_ = createElement_ "feDistantLight"

-- | Creates a `<feDistantLight>` element with attributes and no children nodes
feDistantLight' ∷ ∀ message. Array (NodeData message) → Html message
feDistantLight' = createElement' "feDistantLight"

-- | Creates a `<feDropShadow>` element with attributes and children nodes
feDropShadow ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feDropShadow = createElement "feDropShadow"

-- | Creates a `<feDropShadow>` element with children nodes and no attributes
feDropShadow_ ∷ ∀ message. Array (Html message) → Html message
feDropShadow_ = createElement_ "feDropShadow"

-- | Creates a `<feDropShadow>` element with attributes and no children nodes
feDropShadow' ∷ ∀ message. Array (NodeData message) → Html message
feDropShadow' = createElement' "feDropShadow"

-- | Creates a `<feFlood>` element with attributes and children nodes
feFlood ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFlood = createElement "feFlood"

-- | Creates a `<feFlood>` element with children nodes and no attributes
feFlood_ ∷ ∀ message. Array (Html message) → Html message
feFlood_ = createElement_ "feFlood"

-- | Creates a `<feFlood>` element with attributes and no children nodes
feFlood' ∷ ∀ message. Array (NodeData message) → Html message
feFlood' = createElement' "feFlood"

-- | Creates a `<feFuncA>` element with attributes and children nodes
feFuncA ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncA = createElement "feFuncA"

-- | Creates a `<feFuncA>` element with children nodes and no attributes
feFuncA_ ∷ ∀ message. Array (Html message) → Html message
feFuncA_ = createElement_ "feFuncA"

-- | Creates a `<feFuncA>` element with attributes and no children nodes
feFuncA' ∷ ∀ message. Array (NodeData message) → Html message
feFuncA' = createElement' "feFuncA"

-- | Creates a `<feFuncB>` element with attributes and children nodes
feFuncB ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncB = createElement "feFuncB"

-- | Creates a `<feFuncB>` element with children nodes and no attributes
feFuncB_ ∷ ∀ message. Array (Html message) → Html message
feFuncB_ = createElement_ "feFuncB"

-- | Creates a `<feFuncB>` element with attributes and no children nodes
feFuncB' ∷ ∀ message. Array (NodeData message) → Html message
feFuncB' = createElement' "feFuncB"

-- | Creates a `<feFuncG>` element with attributes and children nodes
feFuncG ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncG = createElement "feFuncG"

-- | Creates a `<feFuncG>` element with children nodes and no attributes
feFuncG_ ∷ ∀ message. Array (Html message) → Html message
feFuncG_ = createElement_ "feFuncG"

-- | Creates a `<feFuncG>` element with attributes and no children nodes
feFuncG' ∷ ∀ message. Array (NodeData message) → Html message
feFuncG' = createElement' "feFuncG"

-- | Creates a `<feFuncR>` element with attributes and children nodes
feFuncR ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feFuncR = createElement "feFuncR"

-- | Creates a `<feFuncR>` element with children nodes and no attributes
feFuncR_ ∷ ∀ message. Array (Html message) → Html message
feFuncR_ = createElement_ "feFuncR"

-- | Creates a `<feFuncR>` element with attributes and no children nodes
feFuncR' ∷ ∀ message. Array (NodeData message) → Html message
feFuncR' = createElement' "feFuncR"

-- | Creates a `<feGaussianBlur>` element with attributes and children nodes
feGaussianBlur ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feGaussianBlur = createElement "feGaussianBlur"

-- | Creates a `<feGaussianBlur>` element with children nodes and no attributes
feGaussianBlur_ ∷ ∀ message. Array (Html message) → Html message
feGaussianBlur_ = createElement_ "feGaussianBlur"

-- | Creates a `<feGaussianBlur>` element with attributes and no children nodes
feGaussianBlur' ∷ ∀ message. Array (NodeData message) → Html message
feGaussianBlur' = createElement' "feGaussianBlur"

-- | Creates a `<feImage>` element with attributes and children nodes
feImage ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feImage = createElement "feImage"

-- | Creates a `<feImage>` element with children nodes and no attributes
feImage_ ∷ ∀ message. Array (Html message) → Html message
feImage_ = createElement_ "feImage"

-- | Creates a `<feImage>` element with attributes and no children nodes
feImage' ∷ ∀ message. Array (NodeData message) → Html message
feImage' = createElement' "feImage"

-- | Creates a `<feMerge>` element with attributes and children nodes
feMerge ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feMerge = createElement "feMerge"

-- | Creates a `<feMerge>` element with children nodes and no attributes
feMerge_ ∷ ∀ message. Array (Html message) → Html message
feMerge_ = createElement_ "feMerge"

-- | Creates a `<feMerge>` element with attributes and no children nodes
feMerge' ∷ ∀ message. Array (NodeData message) → Html message
feMerge' = createElement' "feMerge"

-- | Creates a `<feMergeNode>` element with attributes and children nodes
feMergeNode ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feMergeNode = createElement "feMergeNode"

-- | Creates a `<feMergeNode>` element with children nodes and no attributes
feMergeNode_ ∷ ∀ message. Array (Html message) → Html message
feMergeNode_ = createElement_ "feMergeNode"

-- | Creates a `<feMergeNode>` element with attributes and no children nodes
feMergeNode' ∷ ∀ message. Array (NodeData message) → Html message
feMergeNode' = createElement' "feMergeNode"

-- | Creates a `<feMorphology>` element with attributes and children nodes
feMorphology ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feMorphology = createElement "feMorphology"

-- | Creates a `<feMorphology>` element with children nodes and no attributes
feMorphology_ ∷ ∀ message. Array (Html message) → Html message
feMorphology_ = createElement_ "feMorphology"

-- | Creates a `<feMorphology>` element with attributes and no children nodes
feMorphology' ∷ ∀ message. Array (NodeData message) → Html message
feMorphology' = createElement' "feMorphology"

-- | Creates a `<feOffset>` element with attributes and children nodes
feOffset ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feOffset = createElement "feOffset"

-- | Creates a `<feOffset>` element with children nodes and no attributes
feOffset_ ∷ ∀ message. Array (Html message) → Html message
feOffset_ = createElement_ "feOffset"

-- | Creates a `<feOffset>` element with attributes and no children nodes
feOffset' ∷ ∀ message. Array (NodeData message) → Html message
feOffset' = createElement' "feOffset"

-- | Creates a `<fePointLight>` element with attributes and children nodes
fePointLight ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fePointLight = createElement "fePointLight"

-- | Creates a `<fePointLight>` element with children nodes and no attributes
fePointLight_ ∷ ∀ message. Array (Html message) → Html message
fePointLight_ = createElement_ "fePointLight"

-- | Creates a `<fePointLight>` element with attributes and no children nodes
fePointLight' ∷ ∀ message. Array (NodeData message) → Html message
fePointLight' = createElement' "fePointLight"

-- | Creates a `<feSpecularLighting>` element with attributes and children nodes
feSpecularLighting ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feSpecularLighting = createElement "feSpecularLighting"

-- | Creates a `<feSpecularLighting>` element with children nodes and no attributes
feSpecularLighting_ ∷ ∀ message. Array (Html message) → Html message
feSpecularLighting_ = createElement_ "feSpecularLighting"

-- | Creates a `<feSpecularLighting>` element with attributes and no children nodes
feSpecularLighting' ∷ ∀ message. Array (NodeData message) → Html message
feSpecularLighting' = createElement' "feSpecularLighting"

-- | Creates a `<feSpotLight>` element with attributes and children nodes
feSpotLight ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feSpotLight = createElement "feSpotLight"

-- | Creates a `<feSpotLight>` element with children nodes and no attributes
feSpotLight_ ∷ ∀ message. Array (Html message) → Html message
feSpotLight_ = createElement_ "feSpotLight"

-- | Creates a `<feSpotLight>` element with attributes and no children nodes
feSpotLight' ∷ ∀ message. Array (NodeData message) → Html message
feSpotLight' = createElement' "feSpotLight"

-- | Creates a `<feTile>` element with attributes and children nodes
feTile ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feTile = createElement "feTile"

-- | Creates a `<feTile>` element with children nodes and no attributes
feTile_ ∷ ∀ message. Array (Html message) → Html message
feTile_ = createElement_ "feTile"

-- | Creates a `<feTile>` element with attributes and no children nodes
feTile' ∷ ∀ message. Array (NodeData message) → Html message
feTile' = createElement' "feTile"

-- | Creates a `<feTurbulence>` element with attributes and children nodes
feTurbulence ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
feTurbulence = createElement "feTurbulence"

-- | Creates a `<feTurbulence>` element with children nodes and no attributes
feTurbulence_ ∷ ∀ message. Array (Html message) → Html message
feTurbulence_ = createElement_ "feTurbulence"

-- | Creates a `<feTurbulence>` element with attributes and no children nodes
feTurbulence' ∷ ∀ message. Array (NodeData message) → Html message
feTurbulence' = createElement' "feTurbulence"

-- | Creates a `<filter>` element with attributes and children nodes
filter ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
filter = createElement "filter"

-- | Creates a `<filter>` element with children nodes and no attributes
filter_ ∷ ∀ message. Array (Html message) → Html message
filter_ = createElement_ "filter"

-- | Creates a `<filter>` element with attributes and no children nodes
filter' ∷ ∀ message. Array (NodeData message) → Html message
filter' = createElement' "filter"

-- | Creates a `<font>` element with attributes and children nodes
font ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
font = createElement "font"

-- | Creates a `<font>` element with children nodes and no attributes
font_ ∷ ∀ message. Array (Html message) → Html message
font_ = createElement_ "font"

-- | Creates a `<font>` element with attributes and no children nodes
font' ∷ ∀ message. Array (NodeData message) → Html message
font' = createElement' "font"

-- | Creates a `<font-face>` element with attributes and children nodes
fontFace ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFace = createElement "font-face"

-- | Creates a `<font-face>` element with children nodes and no attributes
fontFace_ ∷ ∀ message. Array (Html message) → Html message
fontFace_ = createElement_ "font-face"

-- | Creates a `<font-face>` element with attributes and no children nodes
fontFace' ∷ ∀ message. Array (NodeData message) → Html message
fontFace' = createElement' "font-face"

-- | Creates a `<font-face-format>` element with attributes and children nodes
fontFaceFormat ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceFormat = createElement "font-face-format"

-- | Creates a `<font-face-format>` element with children nodes and no attributes
fontFaceFormat_ ∷ ∀ message. Array (Html message) → Html message
fontFaceFormat_ = createElement_ "font-face-format"

-- | Creates a `<font-face-format>` element with attributes and no children nodes
fontFaceFormat' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceFormat' = createElement' "font-face-format"

-- | Creates a `<font-face-name>` element with attributes and children nodes
fontFaceName ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceName = createElement "font-face-name"

-- | Creates a `<font-face-name>` element with children nodes and no attributes
fontFaceName_ ∷ ∀ message. Array (Html message) → Html message
fontFaceName_ = createElement_ "font-face-name"

-- | Creates a `<font-face-name>` element with attributes and no children nodes
fontFaceName' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceName' = createElement' "font-face-name"

-- | Creates a `<font-face-src>` element with attributes and children nodes
fontFaceSrc ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceSrc = createElement "font-face-src"

-- | Creates a `<font-face-src>` element with children nodes and no attributes
fontFaceSrc_ ∷ ∀ message. Array (Html message) → Html message
fontFaceSrc_ = createElement_ "font-face-src"

-- | Creates a `<font-face-src>` element with attributes and no children nodes
fontFaceSrc' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceSrc' = createElement' "font-face-src"

-- | Creates a `<font-face-uri>` element with attributes and children nodes
fontFaceUri ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
fontFaceUri = createElement "font-face-uri"

-- | Creates a `<font-face-uri>` element with children nodes and no attributes
fontFaceUri_ ∷ ∀ message. Array (Html message) → Html message
fontFaceUri_ = createElement_ "font-face-uri"

-- | Creates a `<font-face-uri>` element with attributes and no children nodes
fontFaceUri' ∷ ∀ message. Array (NodeData message) → Html message
fontFaceUri' = createElement' "font-face-uri"

-- | Creates a `<foreignObject>` element with attributes and children nodes
foreignObject ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
foreignObject = createElement "foreignObject"

-- | Creates a `<foreignObject>` element with children nodes and no attributes
foreignObject_ ∷ ∀ message. Array (Html message) → Html message
foreignObject_ = createElement_ "foreignObject"

-- | Creates a `<foreignObject>` element with attributes and no children nodes
foreignObject' ∷ ∀ message. Array (NodeData message) → Html message
foreignObject' = createElement' "foreignObject"

-- | Creates a `<g>` element with attributes and children nodes
g ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
g = createElement "g"

-- | Creates a `<g>` element with children nodes and no attributes
g_ ∷ ∀ message. Array (Html message) → Html message
g_ = createElement_ "g"

-- | Creates a `<g>` element with attributes and no children nodes
g' ∷ ∀ message. Array (NodeData message) → Html message
g' = createElement' "g"

-- | Creates a `<glyph>` element with attributes and children nodes
glyph ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
glyph = createElement "glyph"

-- | Creates a `<glyph>` element with children nodes and no attributes
glyph_ ∷ ∀ message. Array (Html message) → Html message
glyph_ = createElement_ "glyph"

-- | Creates a `<glyph>` element with attributes and no children nodes
glyph' ∷ ∀ message. Array (NodeData message) → Html message
glyph' = createElement' "glyph"

-- | Creates a `<glyphRef>` element with attributes and children nodes
glyphRef ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
glyphRef = createElement "glyphRef"

-- | Creates a `<glyphRef>` element with children nodes and no attributes
glyphRef_ ∷ ∀ message. Array (Html message) → Html message
glyphRef_ = createElement_ "glyphRef"

-- | Creates a `<glyphRef>` element with attributes and no children nodes
glyphRef' ∷ ∀ message. Array (NodeData message) → Html message
glyphRef' = createElement' "glyphRef"

-- | Creates a `<hatch>` element with attributes and children nodes
hatch ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hatch = createElement "hatch"

-- | Creates a `<hatch>` element with children nodes and no attributes
hatch_ ∷ ∀ message. Array (Html message) → Html message
hatch_ = createElement_ "hatch"

-- | Creates a `<hatch>` element with attributes and no children nodes
hatch' ∷ ∀ message. Array (NodeData message) → Html message
hatch' = createElement' "hatch"

-- | Creates a `<hatchpath>` element with attributes and children nodes
hatchpath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hatchpath = createElement "hatchpath"

-- | Creates a `<hatchpath>` element with children nodes and no attributes
hatchpath_ ∷ ∀ message. Array (Html message) → Html message
hatchpath_ = createElement_ "hatchpath"

-- | Creates a `<hatchpath>` element with attributes and no children nodes
hatchpath' ∷ ∀ message. Array (NodeData message) → Html message
hatchpath' = createElement' "hatchpath"

-- | Creates a `<hkern>` element with attributes and children nodes
hkern ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
hkern = createElement "hkern"

-- | Creates a `<hkern>` element with children nodes and no attributes
hkern_ ∷ ∀ message. Array (Html message) → Html message
hkern_ = createElement_ "hkern"

-- | Creates a `<hkern>` element with attributes and no children nodes
hkern' ∷ ∀ message. Array (NodeData message) → Html message
hkern' = createElement' "hkern"

-- | Creates a `<image>` element with attributes and children nodes
image ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
image = createElement "image"

-- | Creates a `<image>` element with children nodes and no attributes
image_ ∷ ∀ message. Array (Html message) → Html message
image_ = createElement_ "image"

-- | Creates a `<image>` element with attributes and no children nodes
image' ∷ ∀ message. Array (NodeData message) → Html message
image' = createElement' "image"

-- | Creates a `<line>` element with attributes and children nodes
line ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
line = createElement "line"

-- | Creates a `<line>` element with children nodes and no attributes
line_ ∷ ∀ message. Array (Html message) → Html message
line_ = createElement_ "line"

-- | Creates a `<line>` element with attributes and no children nodes
line' ∷ ∀ message. Array (NodeData message) → Html message
line' = createElement' "line"

-- | Creates a `<linearGradient>` element with attributes and children nodes
linearGradient ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
linearGradient = createElement "linearGradient"

-- | Creates a `<linearGradient>` element with children nodes and no attributes
linearGradient_ ∷ ∀ message. Array (Html message) → Html message
linearGradient_ = createElement_ "linearGradient"

-- | Creates a `<linearGradient>` element with attributes and no children nodes
linearGradient' ∷ ∀ message. Array (NodeData message) → Html message
linearGradient' = createElement' "linearGradient"

-- | Creates a `<marker>` element with attributes and children nodes
marker ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
marker = createElement "marker"

-- | Creates a `<marker>` element with children nodes and no attributes
marker_ ∷ ∀ message. Array (Html message) → Html message
marker_ = createElement_ "marker"

-- | Creates a `<marker>` element with attributes and no children nodes
marker' ∷ ∀ message. Array (NodeData message) → Html message
marker' = createElement' "marker"

-- | Creates a `<mask>` element with attributes and children nodes
mask ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mask = createElement "mask"

-- | Creates a `<mask>` element with children nodes and no attributes
mask_ ∷ ∀ message. Array (Html message) → Html message
mask_ = createElement_ "mask"

-- | Creates a `<mask>` element with attributes and no children nodes
mask' ∷ ∀ message. Array (NodeData message) → Html message
mask' = createElement' "mask"

-- | Creates a `<mesh>` element with attributes and children nodes
mesh ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mesh = createElement "mesh"

-- | Creates a `<mesh>` element with children nodes and no attributes
mesh_ ∷ ∀ message. Array (Html message) → Html message
mesh_ = createElement_ "mesh"

-- | Creates a `<mesh>` element with attributes and no children nodes
mesh' ∷ ∀ message. Array (NodeData message) → Html message
mesh' = createElement' "mesh"

-- | Creates a `<meshgradient>` element with attributes and children nodes
meshgradient ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meshgradient = createElement "meshgradient"

-- | Creates a `<meshgradient>` element with children nodes and no attributes
meshgradient_ ∷ ∀ message. Array (Html message) → Html message
meshgradient_ = createElement_ "meshgradient"

-- | Creates a `<meshgradient>` element with attributes and no children nodes
meshgradient' ∷ ∀ message. Array (NodeData message) → Html message
meshgradient' = createElement' "meshgradient"

-- | Creates a `<meshpatch>` element with attributes and children nodes
meshpatch ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meshpatch = createElement "meshpatch"

-- | Creates a `<meshpatch>` element with children nodes and no attributes
meshpatch_ ∷ ∀ message. Array (Html message) → Html message
meshpatch_ = createElement_ "meshpatch"

-- | Creates a `<meshpatch>` element with attributes and no children nodes
meshpatch' ∷ ∀ message. Array (NodeData message) → Html message
meshpatch' = createElement' "meshpatch"

-- | Creates a `<meshrow>` element with attributes and children nodes
meshrow ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
meshrow = createElement "meshrow"

-- | Creates a `<meshrow>` element with children nodes and no attributes
meshrow_ ∷ ∀ message. Array (Html message) → Html message
meshrow_ = createElement_ "meshrow"

-- | Creates a `<meshrow>` element with attributes and no children nodes
meshrow' ∷ ∀ message. Array (NodeData message) → Html message
meshrow' = createElement' "meshrow"

-- | Creates a `<metadata>` element with attributes and children nodes
metadata ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
metadata = createElement "metadata"

-- | Creates a `<metadata>` element with children nodes and no attributes
metadata_ ∷ ∀ message. Array (Html message) → Html message
metadata_ = createElement_ "metadata"

-- | Creates a `<metadata>` element with attributes and no children nodes
metadata' ∷ ∀ message. Array (NodeData message) → Html message
metadata' = createElement' "metadata"

-- | Creates a `<missing-glyph>` element with attributes and children nodes
missingGlyph ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
missingGlyph = createElement "missing-glyph"

-- | Creates a `<missing-glyph>` element with children nodes and no attributes
missingGlyph_ ∷ ∀ message. Array (Html message) → Html message
missingGlyph_ = createElement_ "missing-glyph"

-- | Creates a `<missing-glyph>` element with attributes and no children nodes
missingGlyph' ∷ ∀ message. Array (NodeData message) → Html message
missingGlyph' = createElement' "missing-glyph"

-- | Creates a `<mpath>` element with attributes and children nodes
mpath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
mpath = createElement "mpath"

-- | Creates a `<mpath>` element with children nodes and no attributes
mpath_ ∷ ∀ message. Array (Html message) → Html message
mpath_ = createElement_ "mpath"

-- | Creates a `<mpath>` element with attributes and no children nodes
mpath' ∷ ∀ message. Array (NodeData message) → Html message
mpath' = createElement' "mpath"

-- | Creates a `<path>` element with attributes and children nodes
path ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
path = createElement "path"

-- | Creates a `<path>` element with children nodes and no attributes
path_ ∷ ∀ message. Array (Html message) → Html message
path_ = createElement_ "path"

-- | Creates a `<path>` element with attributes and no children nodes
path' ∷ ∀ message. Array (NodeData message) → Html message
path' = createElement' "path"

-- | Creates a `<pattern>` element with attributes and children nodes
pattern ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
pattern = createElement "pattern"

-- | Creates a `<pattern>` element with children nodes and no attributes
pattern_ ∷ ∀ message. Array (Html message) → Html message
pattern_ = createElement_ "pattern"

-- | Creates a `<pattern>` element with attributes and no children nodes
pattern' ∷ ∀ message. Array (NodeData message) → Html message
pattern' = createElement' "pattern"

-- | Creates a `<polygon>` element with attributes and children nodes
polygon ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
polygon = createElement "polygon"

-- | Creates a `<polygon>` element with children nodes and no attributes
polygon_ ∷ ∀ message. Array (Html message) → Html message
polygon_ = createElement_ "polygon"

-- | Creates a `<polygon>` element with attributes and no children nodes
polygon' ∷ ∀ message. Array (NodeData message) → Html message
polygon' = createElement' "polygon"

-- | Creates a `<polyline>` element with attributes and children nodes
polyline ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
polyline = createElement "polyline"

-- | Creates a `<polyline>` element with children nodes and no attributes
polyline_ ∷ ∀ message. Array (Html message) → Html message
polyline_ = createElement_ "polyline"

-- | Creates a `<polyline>` element with attributes and no children nodes
polyline' ∷ ∀ message. Array (NodeData message) → Html message
polyline' = createElement' "polyline"

-- | Creates a `<radialGradient>` element with attributes and children nodes
radialGradient ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
radialGradient = createElement "radialGradient"

-- | Creates a `<radialGradient>` element with children nodes and no attributes
radialGradient_ ∷ ∀ message. Array (Html message) → Html message
radialGradient_ = createElement_ "radialGradient"

-- | Creates a `<radialGradient>` element with attributes and no children nodes
radialGradient' ∷ ∀ message. Array (NodeData message) → Html message
radialGradient' = createElement' "radialGradient"

-- | Creates a `<rect>` element with attributes and children nodes
rect ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
rect = createElement "rect"

-- | Creates a `<rect>` element with children nodes and no attributes
rect_ ∷ ∀ message. Array (Html message) → Html message
rect_ = createElement_ "rect"

-- | Creates a `<rect>` element with attributes and no children nodes
rect' ∷ ∀ message. Array (NodeData message) → Html message
rect' = createElement' "rect"

-- | Creates a `<script>` element with attributes and children nodes
script ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
script = createElement "script"

-- | Creates a `<script>` element with children nodes and no attributes
script_ ∷ ∀ message. Array (Html message) → Html message
script_ = createElement_ "script"

-- | Creates a `<script>` element with attributes and no children nodes
script' ∷ ∀ message. Array (NodeData message) → Html message
script' = createElement' "script"

-- | Creates a `<set>` element with attributes and children nodes
set ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
set = createElement "set"

-- | Creates a `<set>` element with children nodes and no attributes
set_ ∷ ∀ message. Array (Html message) → Html message
set_ = createElement_ "set"

-- | Creates a `<set>` element with attributes and no children nodes
set' ∷ ∀ message. Array (NodeData message) → Html message
set' = createElement' "set"

-- | Creates a `<solidcolor>` element with attributes and children nodes
solidcolor ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
solidcolor = createElement "solidcolor"

-- | Creates a `<solidcolor>` element with children nodes and no attributes
solidcolor_ ∷ ∀ message. Array (Html message) → Html message
solidcolor_ = createElement_ "solidcolor"

-- | Creates a `<solidcolor>` element with attributes and no children nodes
solidcolor' ∷ ∀ message. Array (NodeData message) → Html message
solidcolor' = createElement' "solidcolor"

-- | Creates a `<stop>` element with attributes and children nodes
stop ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
stop = createElement "stop"

-- | Creates a `<stop>` element with children nodes and no attributes
stop_ ∷ ∀ message. Array (Html message) → Html message
stop_ = createElement_ "stop"

-- | Creates a `<stop>` element with attributes and no children nodes
stop' ∷ ∀ message. Array (NodeData message) → Html message
stop' = createElement' "stop"

-- | Creates a `<switch>` element with attributes and children nodes
switch ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
switch = createElement "switch"

-- | Creates a `<switch>` element with children nodes and no attributes
switch_ ∷ ∀ message. Array (Html message) → Html message
switch_ = createElement_ "switch"

-- | Creates a `<switch>` element with attributes and no children nodes
switch' ∷ ∀ message. Array (NodeData message) → Html message
switch' = createElement' "switch"

-- | Creates a `<symbol>` element with attributes and children nodes
symbol ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
symbol = createElement "symbol"

-- | Creates a `<symbol>` element with children nodes and no attributes
symbol_ ∷ ∀ message. Array (Html message) → Html message
symbol_ = createElement_ "symbol"

-- | Creates a `<symbol>` element with attributes and no children nodes
symbol' ∷ ∀ message. Array (NodeData message) → Html message
symbol' = createElement' "symbol"

-- | Creates a `<textPath>` element with attributes and children nodes
textPath ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
textPath = createElement "textPath"

-- | Creates a `<textPath>` element with children nodes and no attributes
textPath_ ∷ ∀ message. Array (Html message) → Html message
textPath_ = createElement_ "textPath"

-- | Creates a `<textPath>` element with attributes and no children nodes
textPath' ∷ ∀ message. Array (NodeData message) → Html message
textPath' = createElement' "textPath"

-- | Creates a `<tref>` element with attributes and children nodes
tref ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tref = createElement "tref"

-- | Creates a `<tref>` element with children nodes and no attributes
tref_ ∷ ∀ message. Array (Html message) → Html message
tref_ = createElement_ "tref"

-- | Creates a `<tref>` element with attributes and no children nodes
tref' ∷ ∀ message. Array (NodeData message) → Html message
tref' = createElement' "tref"

-- | Creates a `<tspan>` element with attributes and children nodes
tspan ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
tspan = createElement "tspan"

-- | Creates a `<tspan>` element with children nodes and no attributes
tspan_ ∷ ∀ message. Array (Html message) → Html message
tspan_ = createElement_ "tspan"

-- | Creates a `<tspan>` element with attributes and no children nodes
tspan' ∷ ∀ message. Array (NodeData message) → Html message
tspan' = createElement' "tspan"

-- | Creates a `<unknown>` element with attributes and children nodes
unknown ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
unknown = createElement "unknown"

-- | Creates a `<unknown>` element with children nodes and no attributes
unknown_ ∷ ∀ message. Array (Html message) → Html message
unknown_ = createElement_ "unknown"

-- | Creates a `<unknown>` element with attributes and no children nodes
unknown' ∷ ∀ message. Array (NodeData message) → Html message
unknown' = createElement' "unknown"

-- | Creates a `<use>` element with attributes and children nodes
use ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
use = createElement "use"

-- | Creates a `<use>` element with children nodes and no attributes
use_ ∷ ∀ message. Array (Html message) → Html message
use_ = createElement_ "use"

-- | Creates a `<use>` element with attributes and no children nodes
use' ∷ ∀ message. Array (NodeData message) → Html message
use' = createElement' "use"

-- | Creates a `<view>` element with attributes and children nodes
view ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
view = createElement "view"

-- | Creates a `<view>` element with children nodes and no attributes
view_ ∷ ∀ message. Array (Html message) → Html message
view_ = createElement_ "view"

-- | Creates a `<view>` element with attributes and no children nodes
view' ∷ ∀ message. Array (NodeData message) → Html message
view' = createElement' "view"

-- | Creates a `<vkern>` element with attributes and children nodes
vkern ∷ ∀ message. Array (NodeData message) → Array (Html message) → Html message
vkern = createElement "vkern"

-- | Creates a `<vkern>` element with children nodes and no attributes
vkern_ ∷ ∀ message. Array (Html message) → Html message
vkern_ = createElement_ "vkern"

-- | Creates a `<vkern>` element with attributes and no children nodes
vkern' ∷ ∀ message. Array (NodeData message) → Html message
vkern' = createElement' "vkern"
