-- | Snabbdom VNode hooks
module Flame.Renderer.Hook where

import Prelude ((<<<))

import Foreign (Foreign, unsafeToForeign)
import Flame.Types (NodeData(Hook), HookData(..), HookFn1, HookFn2, HookFnRemove)

-- | Attaches a hook for a vnode been added
atInit :: ∀ msg. HookFn1 -> NodeData msg
atInit = Hook <<< HookInit

-- | Attaches a hook for a DOM element been created based on a vnode
atCreate :: ∀ msg. HookFn2 -> NodeData msg
atCreate = Hook <<< HookCreate

-- | Attaches a hook for a vnode element been inserted into the DOM
atInsert :: ∀ msg. HookFn1 -> NodeData msg
atInsert = Hook <<< HookInsert

-- | Attaches a hook for a vnode element about to be patched
atPrepatch :: ∀ msg. HookFn2 -> NodeData msg
atPrepatch = Hook <<< HookPrepatch

-- | Attaches a hook for a vnode element being updated
atUpdate :: ∀ msg. HookFn2 -> NodeData msg
atUpdate = Hook <<< HookUpdate

-- | Attaches a hook for a vnode element been patched
atPostpatch :: ∀ msg. HookFn2 -> NodeData msg
atPostpatch = Hook <<< HookPostpatch

-- | Attaches a hook for a vnode element directly or indirectly being removed
atDestroy :: ∀ msg. HookFn1 -> NodeData msg
atDestroy = Hook <<< HookDestroy

-- | Attaches a hook for a vnode element directly being removed
atRemove :: ∀ msg. HookFnRemove -> NodeData msg
atRemove = Hook <<< HookRemove


-- | Retrieve hook's name
hookName :: HookData -> String
hookName hd = case hd of
        HookInit _ -> "init"
        HookCreate _ -> "create"
        HookInsert _ -> "insert"
        HookPrepatch _ -> "prepatch"
        HookUpdate _ -> "update"
        HookPostpatch _ -> "postpatch"
        HookDestroy _ -> "destroy"
        HookRemove _ -> "remove"

-- | Retrieve hook's function.
-- We need this to transfer the function to Snabbdom outside,
-- so we have to implement a dirty hack.
hookFn :: HookData -> Foreign
hookFn hd = case hd of
        HookInit fn -> unsafeToForeign fn
        HookCreate fn -> unsafeToForeign fn
        HookInsert fn -> unsafeToForeign fn
        HookPrepatch fn -> unsafeToForeign fn
        HookUpdate fn -> unsafeToForeign fn
        HookPostpatch fn -> unsafeToForeign fn
        HookDestroy fn -> unsafeToForeign fn
        HookRemove fn -> unsafeToForeign fn
