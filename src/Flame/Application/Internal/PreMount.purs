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
import Flame.Serialization (class Serializable)
import Flame.Serialization as FS
import Flame.Types (Html, PreApplication)
import Prelude (bind, discard, pure, ($), (<>))
import Web.DOM.ParentNode (QuerySelector(..))

-- | Adds the serialized state node as the first child of the given markup (or of `body` for full pages)
foreign import injectState ∷ ∀ message. Html message → Html message → Html message

-- | Tag of the element that carries the serialized state
tagSerializedState ∷ String
tagSerializedState = "template-state"

-- | Id of the element that carries the serialized state for the given (sanitized) selector
idSerializedState ∷ String → String
idSerializedState = ("pre-mount-" <> _)

-- | Attribute that ties the serialized state to the given (sanitized) selector
attributeSerializedState ∷ String → String
attributeSerializedState = ("__pre-mount-" <> _)

-- | Strips everything but ASCII letters so a selector can be used in an id
onlyLetters ∷ String → String
onlyLetters = DSR.replace (DSRU.unsafeRegex "[^a-zA-Z]" global) ""

-- | Selector that finds the serialized state element for the given (sanitized) selector
selectorSerializedState ∷ String → String
selectorSerializedState selector = tagSerializedState <> "#" <> idSerializedState selector <> "[" <> attributeSerializedState selector <> "=" <> selector <> "]"

-- | Reads, unserializes and removes from the DOM the state rendered by `preMount` for the given selector
serializedState ∷ ∀ model. Serializable model ⇒ String → Effect model
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

-- | Renders the application markup to a string with its serialized model embedded, so it can later be hydrated with `resumeMount`
preMount ∷ ∀ model message. Serializable model ⇒ QuerySelector → PreApplication model message → Effect String
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