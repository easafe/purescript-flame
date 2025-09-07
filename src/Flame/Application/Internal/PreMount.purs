module Flame.Application.Internal.PreMount where

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.String.Regex as DSR
import Data.String.Regex.Flags (global)
import Data.String.Regex.Unsafe as DSRU
import Effect (Effect)
import Effect.Exception as EE
import Flame.Application.Internal.Dom as FAD
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Renderer.String as FRS
import Flame.Serialization (class UnserializeState, class SerializeState)
import Flame.Serialization as FS
import Flame.Types (Html, PreApplication)
import Prelude (bind, discard, pure, ($), (<>))
import Web.DOM.ParentNode (QuerySelector(..))

foreign import injectState ∷ ∀ message. Html message → Html message → Html message

tagSerializedState ∷ String
tagSerializedState = "template-state"

idSerializedState ∷ String → String
idSerializedState = ("pre-mount-" <> _)

attributeSerializedState ∷ String → String
attributeSerializedState = ("__pre-mount-" <> _)

onlyLetters ∷ String → String
onlyLetters = DSR.replace (DSRU.unsafeRegex "[^aA-zZ]" global) ""

selectorSerializedState ∷ String → String
selectorSerializedState selector = tagSerializedState <> "#" <> idSerializedState selector <> "[" <> attributeSerializedState selector <> "=" <> selector <> "]"

serializedState ∷ ∀ model. UnserializeState model ⇒ String → Effect model
serializedState selector = do
      maybeElement ← FAD.querySelector stateSelector
      case maybeElement of
            Just el → do
                  contents ← FAD.textContent el
                  case FS.unserialize contents of
                        Right model → do
                              FAD.removeElement stateSelector
                              pure model
                        Left message → EE.throw $ "Error resuming application mount: serialized state is invalid! " <> message
            Nothing → EE.throw $ "Error resuming application mount: serialized state (" <> stateSelector <> ") not found!"
      where
      stateSelector = selectorSerializedState $ onlyLetters selector

preMount ∷ ∀ model message. SerializeState model ⇒ QuerySelector → PreApplication model message → Effect String
preMount (QuerySelector selector) application = do
      let html = injectState state $ application.view application.model
      FRS.render html
      where
      sanitizedSelector = onlyLetters selector
      state =
            HE.createElement tagSerializedState
                  [ HA.style { display: "none" }
                  , HA.id $ idSerializedState sanitizedSelector
                  , HA.createAttribute (attributeSerializedState sanitizedSelector) sanitizedSelector
                  ]
                  [ HE.text $ FS.serialize application.model ]