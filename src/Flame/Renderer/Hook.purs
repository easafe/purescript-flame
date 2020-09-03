-- | Snabbdom VNode hooks
module Flame.Renderer.Hook where

import Prelude ((<<<), Unit)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Foreign (Foreign)
import Foreign as F
import Flame.Types (NodeData(Hook), VNode)

-- | Foreign VNode hook function with single parameter
type HookFn1 = EffectFn1 VNode Unit

-- | Foreign VNode hook function with two parameters
type HookFn2 = EffectFn2 VNode VNode Unit

-- | Foreign VNode hook function with VNode and remove callback parameters
type HookFnRemove = EffectFn2 VNode (Effect Unit) Unit

-- | Creates a hook for given `name` and provided foreign function
createHook :: ∀ msg. String -> Foreign -> NodeData msg
createHook name = Hook name

-- | Attaches a hook for a vnode been added
atInit :: ∀ msg. HookFn1 -> NodeData msg
atInit = createHook "init" <<< F.unsafeToForeign

-- | Attaches a hook for a DOM element been created based on a vnode
atCreate :: ∀ msg. HookFn2 -> NodeData msg
atCreate = createHook "create" <<< F.unsafeToForeign

-- | Attaches a hook for a vnode element been inserted into the DOM
atInsert :: ∀ msg. HookFn1 -> NodeData msg
atInsert = createHook "insert" <<< F.unsafeToForeign

-- | Attaches a hook for a vnode element about to be patched
atPrepatch :: ∀ msg. HookFn2 -> NodeData msg
atPrepatch = createHook "prepatch" <<< F.unsafeToForeign

-- | Attaches a hook for a vnode element being updated
atUpdate :: ∀ msg. HookFn2 -> NodeData msg
atUpdate = createHook "update" <<< F.unsafeToForeign

-- | Attaches a hook for a vnode element been patched
atPostpatch :: ∀ msg. HookFn2 -> NodeData msg
atPostpatch = createHook "postpatch" <<< F.unsafeToForeign

-- | Attaches a hook for a vnode element directly or indirectly being removed
atDestroy :: ∀ msg. HookFn1 -> NodeData msg
atDestroy = createHook "destroy" <<< F.unsafeToForeign

-- | Attaches a hook for a vnode element directly being removed
atRemove :: ∀ msg. HookFnRemove -> NodeData msg
atRemove = createHook "remove" <<< F.unsafeToForeign
