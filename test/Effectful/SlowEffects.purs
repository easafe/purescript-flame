module Test.Effectful.SlowEffects (mount) where

import Prelude

import Data.Array as DA
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..))
import Effect.Aff as EA
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.Effectful (Environment)
import Flame.Application.Effectful as FAE
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE

type Model =
      { current ∷ Int
      , numbers ∷ Array Int
      }

data Message = Bump | BumpAndSnoc

init ∷ Model
init = { current: 0, numbers: [] }

update ∷ Environment Model Message → Aff (Model → Model)
update { message } = case message of
      Bump → pure $ \m@{ current } → m { current = current + 1 }
      BumpAndSnoc → do
            EA.delay $ Milliseconds 500.0
            pure $ \m@{ current, numbers } → m { current = current + 1, numbers = DA.snoc numbers 0 }

view ∷ Model → Html Message
view { current, numbers } = HE.main_
      [ HE.span "text-output-current" $ show current
      , HE.span "text-output-numbers" $ show numbers
      , HE.br
      , HE.button [ HA.id "bump-button", HA.onClick Bump ] "-"
      , HE.button [ HA.id "snoc-button", HA.onClick BumpAndSnoc ] "+"
      ]

mount ∷ Effect Unit
mount = FAE.mount_ (QuerySelector "#mount-point")
      { init: init :> Nothing
      , subscribe: []
      , update
      , view
      }
