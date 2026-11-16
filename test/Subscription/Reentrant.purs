-- | Application whose managed node raises a message while the view is being rendered
module Test.Subscription.Reentrant (mount, Message(..)) where

import Prelude

import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Subscription as FS
import Flame.Types (AppId(..))
import Web.DOM (Node)
import Web.DOM.ParentNode (QuerySelector(..))

foreign import createDiv ∷ Effect Node

type Model = Int

data Message = Tick | Rendered

appId ∷ AppId String Message
appId = AppId "reentrant"

update ∷ Model → Message → Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      Tick → (model + 1) /\ []
      Rendered → (model + 10) /\ []

view ∷ Model → Html Message
view model = HE.main [ HA.id "main" ]
      [ HE.span [ HA.id "text-output" ] [ HE.text $ show model ]
      , HE.managed { createNode: const createDiv, updateNode } [] model
      ]
      where
      updateNode node _ current = do
            --dispatching is synchronous, so this message is raised in the middle of the patch
            when (current == 1) $ FS.send appId Rendered
            pure node

mount ∷ Effect (AppId String Message)
mount = do
      F.mount (QuerySelector "#mount-point") appId
            { model: 0
            , subscribe: []
            , update
            , view
            }
      pure appId
