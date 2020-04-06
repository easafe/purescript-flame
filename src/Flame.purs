-- | Entry module for a default Flame application
module Flame (module Exported) where

import Flame.Application.Effectful (Application, ResumedApplication, World, mount, mount_, resumeMount, resumeMount_) as Exported
import Flame.Application.PreMount (preMount) as Exported
import Flame.Types (Html, (:>), Key, PreApplication) as Exported
import Web.DOM.ParentNode (QuerySelector(..)) as Exported
