module Examples.EffectList.Special.Main where

import Prelude

import Data.Array ((:))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (Html)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.ParentNode (QuerySelector(..))

type Model =
      { current ∷ Maybe Int
      , history ∷ Array Int
      }

init ∷ Model
init =
      { current: Nothing
      , history: []
      }

data Message = Roll | Update Int

update ∷ Model → Message → Tuple Model (Array (Aff (Maybe Message)))
update model@{ history } = case _ of
      Roll → model /\
            [ Just <<< Update <$> liftEffect (ER.randomInt 1 6)
            ]
      Update roll →
            model
                  { current = Just roll
                  , history = roll : history
                  } /\ []

view ∷ Model → Html Message
view model = HE.fragment
      [ -- only children elements will be rendered
        HE.text $ show model.current
      , HE.button [ HA.onClick Roll ] [ HE.text "Roll" ]
      , HE.br
      , HE.span_ [ HE.text "History" ]
      , HE.div_ $ map lazyEntry model.history
      ]

lazyEntry ∷ Int → Html Message
lazyEntry roll = HE.lazy Nothing toEntry roll -- lazy node will only be recomputed in case the roll changes
      where
      rolled = show roll
      toEntry = const (HE.div [ HA.key rolled ] [ HE.text rolled ]) -- keyed rendering for rolls

main ∷ Effect Unit
main = F.mount_ (QuerySelector "body")
      { model: init
      , subscribe: []
      , update
      , view
      }
