--adapted from https://github.com/LukaJCB/purescript-snabbdom

module Flame.Renderer(render, renderInitial, toVNodeProxy, emptyVNode) where

import Flame.Type
import Prelude

import Data.Foldable as DF
import Data.Function.Uncurried (Fn1, Fn3, runFn3)
import Data.Function.Uncurried as DFU
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Foreign.Object (Object)
import Foreign.Object as FO
import Type.Data.Boolean (kind Boolean)
import Web.Event.Internal.Types (Event)

foreign import emptyVNode :: VNodeProxy


-- | The insert hook is invoked once the DOM element for a vnode has been inserted into the document and the rest of the patch cycle is done.
-- | This means that you can do DOM measurements (like using getBoundingClientRect in this hook safely, knowing that no elements will be changed afterwards that could affect the position of the inserted elements.
-- |
-- | The destroy hook is invoked on a virtual node when its DOM element is removed from the DOM or if its parent is being removed from the DOM.
-- |
-- | The update hook is invoked whenever an element is being updated
type VNodeHookObject =
        { insert :: Maybe (VNodeProxy -> Effect Unit)
        , destroy :: Maybe (VNodeProxy -> Effect Unit)
        , update :: Maybe (VNodeProxy -> VNodeProxy -> Effect Unit)
        }

foreign import data VDOM :: (Type -> Type)

foreign import getElementImpl_ :: forall a. Fn3 VNodeProxy (a -> Maybe a) (Maybe a) (Maybe DOMElement)

getElementImpl = DFU.runFn3 getElementImpl_

-- | Transform a Object representing a VNodeEventObject into its native counter part
foreign import toVNodeEventObject_ :: Fn1 (Object (Event -> Effect Unit)) VNodeEventObject

toVNodeEventObject = DFU.runFn1 toVNodeEventObject_

-- | Transform a VNodeHookObject into its native counter part
foreign import toVNodeHookObjectProxy_ :: Fn1 VNodeHookObject VNodeHookObjectProxy

toVNodeHookObjectProxy = DFU.runFn1 toVNodeHookObjectProxy_

-- | The patch function returned by init takes two arguments.
-- | The first is a DOM element or a vnode representing the current view.
-- | The second is a vnode representing the new, updated view.
-- | If a DOM element with a parent is passed, newVnode will be turned into a DOM node, and the passed element will be replaced by the created DOM node.
-- | If an old vnode is passed, Snabbdom will efficiently modify it to match the description in the new vnode.
-- | Any old vnode passed must be the resulting vnode from a previous call to patch.
-- | This is necessary since Snabbdom stores information in the vnode.
-- | This makes it possible to implement a simpler and more performant architecture.
-- | This also avoids the creation of a new old vnode tree.
foreign import patch_ :: EffectFn2 VNodeProxy VNodeProxy Unit

patch = EU.runEffectFn2 patch_

-- | Same as patch, but patches an initial DOM Element instead.
foreign import patchInitial_ :: EffectFn2 DOMElement VNodeProxy Unit

patchInitial = EU.runEffectFn2 patchInitial_

-- | Turns a String into a VNode
foreign import text_ :: Fn1 String VNodeProxy

text = DFU.runFn1 text_

-- | It is recommended that you use snabbdom/h to create vnodes.
-- | h accepts a tag/selector as a string, an optional data object and an optional string or array of children.
foreign import h_ :: Fn3 String VNodeData (Array VNodeProxy) VNodeProxy

h = runFn3 h_

-- | A hook that updates the value whenever it's attribute gets updated.
foreign import updateValueHook_ :: EffectFn2 VNodeProxy VNodeProxy Unit

renderInitial :: forall a. DOMElement -> (a -> Effect Unit) -> Element a -> Effect VNodeProxy
renderInitial domElement updater element = do
        patchInitial domElement vNode
        pure vNode
        where vNode = toVNodeProxy updater element

render :: forall a. VNodeProxy -> (a -> Effect Unit) -> Element a -> Effect VNodeProxy
render oldVNode updater element = do
        patch oldVNode vNode
        pure vNode
        where vNode = toVNodeProxy updater element

toVNodeProxy :: forall a. (a -> Effect Unit) -> Element a -> VNodeProxy
toVNodeProxy updater (Text value) = text value
toVNodeProxy updater (Node tag attributesEvents children) = h tag vNodeData $ map (toVNodeProxy updater) children
        where   toVNodeData {attributes, events} =
                        {
                                attrs : attributes,
                                on : toVNodeEventObject events,
                                hook: toVNodeHookObjectProxy { insert: Nothing, destroy: Nothing, update: Nothing }
                        }

                handleRawEvent handler event = do
                        value <- handler event
                        updater value

                unions record@{attributes, events} =
                        case _ of
                                Attribute name value -> record { attributes = FO.insert name value attributes }
                                Property name value ->
                                        if value then record { attributes = FO.insert name name attributes }
                                         else record
                                Event name message -> record { events = FO.insert name (const (updater message)) events }
                                RawEvent name handler -> record { events = FO.insert name (handleRawEvent handler) events }

                vNodeData = toVNodeData $ DF.foldl unions { attributes: FO.empty, events: FO.empty } attributesEvents

-- | Safely get the elm from a VNode
getElement :: VNodeProxy -> Maybe DOMElement
getElement proxy = getElementImpl proxy Just Nothing