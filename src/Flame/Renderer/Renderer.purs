--adapted from https://github.com/LukaJCB/purescript-snabbdom

-- | Renders changes to the DOM
-- |
-- | Note: Renderer is a wrapper around the snabbdom virtual DOM
module Flame.Renderer(
        render,
        renderInitial,
        toVNodeProxy,
        emptyVNode
) where

import Data.Foldable as DF
import Data.Function.Uncurried (Fn1, Fn3, runFn3)
import Data.Function.Uncurried as DFU
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Flame.Types (DOMElement, Element(..), NodeData(..), VNodeData, VNodeEvents, VNode)
import Foreign.Object (Object)
import Foreign.Object as FO
import Prelude (Unit, bind, discard, map, pure, show, unit, ($), (<<<))
import Type.Data.Boolean (kind Boolean)
import Web.Event.Internal.Types (Event)

foreign import emptyVNode :: VNode
foreign import toVNodeEvents_ :: Fn1 (Object (Event -> Effect Unit)) VNodeEvents
foreign import patch_ :: EffectFn2 VNode VNode Unit
foreign import patchInitial_ :: EffectFn2 DOMElement VNode Unit
foreign import text_ :: Fn1 String VNode
foreign import h_ :: Fn3 String VNodeData (Array VNode) VNode

-- | Transforms an event function into an actual JavaScript event handler
toVNodeEvents :: Object (Event -> Effect Unit) -> VNodeEvents
toVNodeEvents = DFU.runFn1 toVNodeEvents_

-- | snabbdom patch function
patch :: VNode -> VNode -> Effect Unit
patch = EU.runEffectFn2 patch_

-- | snabbdom patchInitial function
patchInitial :: DOMElement -> VNode -> Effect Unit
patchInitial = EU.runEffectFn2 patchInitial_

-- | Turns a String into a VNode
text :: String -> VNode
text = DFU.runFn1 text_

-- | snabbdom h function
h :: String -> VNodeData -> Array VNode -> VNode
h = runFn3 h_

-- | Renders markup to a given selector
-- |
-- | This function is necessary since subsequent calls to snabbdom `patch` require a previsouly created VNode
renderInitial :: forall message. DOMElement -> (message -> Maybe Event -> Effect Unit) -> Element message -> Effect VNode
renderInitial domElement updater element = do
        let vNode = toVNodeProxy updater element
        patchInitial domElement vNode
        pure vNode

-- | Renders markup according to the difference between VNodes
render :: forall message. VNode -> (message -> Maybe Event -> Effect Unit) -> Element message -> Effect VNode
render oldVNode updater element = do
        let vNode = toVNodeProxy updater element
        patch oldVNode vNode
        pure vNode

-- could we make this keyed (key : string | number) somehow?
-- | Transforms an Element into a VNode
toVNodeProxy :: forall message. (message -> Maybe Event -> Effect Unit) -> Element message -> VNode
toVNodeProxy updater (Text value) = text value
toVNodeProxy updater (Node tag nodeData children) = h tag vNodeData $ map (toVNodeProxy updater) children
        where   toVNodeData {attributesProperties, events} =
                        {
                                props: attributesProperties,
                                on: toVNodeEvents events
                        }

                handleRawEvent handler event = do
                        message <- handler event
                        updater message (Just event)

                unions record@{attributesProperties, events} =
                        case _ of
                                Attribute name value -> record { attributesProperties = FO.insert name value attributesProperties }
                                Property name value ->
                                        if value then record { attributesProperties = FO.insert name name attributesProperties }
                                         else record
                                Event name message -> record { events = FO.insert name (updater message <<< Just) events }
                                RawEvent name handler -> record { events = FO.insert name (handleRawEvent handler) events }

                vNodeData = toVNodeData $ DF.foldl unions { attributesProperties: FO.empty, events: FO.empty } nodeData
