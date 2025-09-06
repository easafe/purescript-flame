module Examples.EffectList.Affjax.Main where

import Prelude

import Affjax.ResponseFormat as AR
import Affjax.Web as A
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Flame (Html, Update)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.ParentNode (QuerySelector(..))

type Model =
      { url ∷ String
      , result ∷ Result
      }

data Message = UpdateUrl String | Fetch | Fetched Result

data Result = NotFetched | Fetching | Ok String | Error String

derive instance eqResult ∷ Eq Result

init ∷ Model
init =
      { url: "https://httpbin.org/get"
      , result: NotFetched
      }

update ∷ Update Model Message
update model =
      case _ of
            UpdateUrl url → F.noMessages $ model { url = url, result = NotFetched }
            Fetch → model { result = Fetching } /\
                  [ do
                          response ← A.get AR.string model.url
                          pure <<< Just <<< Fetched $ case response of
                                Left error → Error $ A.printError error
                                Right payload → Ok payload.body
                  ]
            Fetched result → F.noMessages $ model { result = result }

view ∷ Model → Html Message
view { url, result } = HE.main [HA.id "main"]
      [ HE.input [ HA.onInput UpdateUrl, HA.value url, HA.type' "text" ]
      , HE.button [ HA.onClick Fetch, HA.disabled $ result == Fetching ] "Fetch"
      , case result of
              NotFetched →
                    HE.div_ "Not Fetched..."
              Fetching →
                    HE.div_ "Fetching..."
              Ok ok →
                    HE.pre_ <<< HE.code_ $ "Ok: " <> ok
              Error error →
                    HE.div_ $ "Error: " <> error
      ]

main ∷ Effect Unit
main = F.mount_ (QuerySelector "body")
      { model:  init
      , subscribe: []
      , update
      , view
      }
