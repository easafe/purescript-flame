--adapted from https://github.com/LukaJCB/purescript-snabbdom

-- | Renders changes to the DOM
-- |
-- | Note: Renderer is a wrapper around the snabbdom virtual DOM
module Flame.Renderer(
        render,
        renderInitial,
        renderInitialFrom,
        toVNode,
        emptyVNode
) where

import Data.Foldable as DF
import Data.Function.Uncurried (Fn1, Fn2, Fn3, runFn3)
import Data.Function.Uncurried as DFU
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Flame.Types (DOMElement, Html(..), NodeData(..), VNode(..), VNodeData, VNodeEvents)
import Foreign.Object (Object)
import Foreign.Object as FO
import Prelude (Unit, bind, const, discard, map, pure, ($), (<<<))
import Web.Event.Internal.Types (Event)

foreign import emptyVNode :: VNode
foreign import toVNodeEvents_ :: Fn1 (Object (Event -> Effect Unit)) VNodeEvents
foreign import patch_ :: EffectFn2 VNode VNode Unit
foreign import patchInitial_ :: EffectFn2 DOMElement VNode Unit
foreign import patchInitialFrom_ :: EffectFn2 DOMElement VNode Unit
foreign import toTextVNode_ :: Fn2 DOMElement String VNode
foreign import text_ :: Fn1 String VNode
foreign import h_ :: Fn3 String VNodeData (Array VNode) VNode

-- | Transforms an event function into an actual JavaScript event handler
toVNodeEvents :: Object (Event -> Effect Unit) -> VNodeEvents
toVNodeEvents = DFU.runFn1 toVNodeEvents_

-- | snabbdom patch function
patch :: VNode -> VNode -> Effect Unit
patch = EU.runEffectFn2 patch_

-- | snabbdom patch function on an element
patchInitial :: DOMElement -> VNode -> Effect Unit
patchInitial = EU.runEffectFn2 patchInitial_

-- | snabbdom patch function on element using toVNode
patchInitialFrom :: DOMElement -> VNode -> Effect Unit
patchInitialFrom = EU.runEffectFn2 patchInitialFrom_

-- | Turns a String into a VNode
text :: String -> VNode
text = DFU.runFn1 text_

-- transforms a text only view into a vnode
toTextVNode :: DOMElement -> String -> VNode
toTextVNode = DFU.runFn2 toTextVNode_

-- | snabbdom h function
h :: String -> VNodeData -> Array VNode -> VNode
h = runFn3 h_

-- | Renders markup to a given selector
-- |
-- | This function is necessary since subsequent calls to snabbdom `patch` require a previsouly created VNode
renderInitial :: forall message. DOMElement -> (message -> Effect Unit) -> Html message -> Effect VNode
renderInitial domElement updater element = do
        let vNode =
                case element of
                        Text textContent -> toTextVNode domElement textContent
                        _ -> toVNode updater element
        patchInitial domElement vNode
        pure vNode

renderInitialFrom :: forall message. DOMElement -> (message -> Effect Unit) -> Html message -> Effect VNode
renderInitialFrom domElement updater element = do
        let vNode =
                case element of
                        Text textContent -> toTextVNode domElement textContent
                        _ -> toVNode updater element
        patchInitialFrom domElement vNode
        pure vNode

-- | Renders markup according to the difference between VNodes
render :: forall message. VNode -> (message -> Effect Unit) -> Html message -> Effect VNode
render oldVNode updater element = do
        let vNode =
                case element of
                        Text textContent -> let (VNode node) = oldVNode in toTextVNode node.elm textContent
                        _ -> toVNode updater element
        patch oldVNode vNode
        pure vNode

-- could we make this keyed (key : string | number) somehow?
-- | Transforms an `Html` into a `VNode`
toVNode :: forall message. (message -> Effect Unit) -> Html message -> VNode
toVNode updater (Text value) = text value
toVNode updater (Node tag nodeData children) = h tag vNodeData $ map (toVNode updater) children
        where   toVNodeData { properties, attributes, events } = {
                        attrs: attributes,
                        props: properties,
                        on: toVNodeEvents events
                }

                handleRawEvent handler event = do
                        message <- handler event
                        updater message

                unions record@{ properties, attributes, events } =
                        case _ of
                                Property name value -> record { properties = FO.insert name value properties }
                                Attribute name value -> record { attributes = FO.insert name value attributes }
                                Event name message -> record { events = FO.insert name (const (updater message)) events }
                                RawEvent name handler -> record { events = FO.insert name (handleRawEvent handler) events }

                vNodeData = toVNodeData $ DF.foldl unions { properties: FO.empty, attributes: FO.empty, events: FO.empty } nodeData
