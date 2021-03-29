-- | Entry module for a default Flame application
module Flame (module Exported) where

import Flame.Application.EffectList (Application, noMessages, ResumedApplication, ListUpdate, mount, mount_, resumeMount, resumeMount_) as Exported
import Flame.Application.Internal.PreMount (preMount) as Exported
import Flame.Types (Html, (:>), Key, PreApplication, AppId) as Exported
import Web.DOM.ParentNode (QuerySelector(..)) as Exported
