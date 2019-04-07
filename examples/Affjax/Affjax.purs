module Examples.Affjax where

import Prelude

import Effect.Aff (Aff)
import Affjax as A
import Affjax.ResponseFormat as AR
import Data.Either (Either(..))
import Effect (Effect)
import Flame (Html)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Property as HP
import Flame.Html.Element as HE
import Flame.Html.Event as HV

type Model = {
        url :: String,
        result :: Result
}

data Message = UpdateUrl String | Fetch | Fetched Result

data Result = NotFetched | Fetching | Ok String | Error String

derive instance eqResult :: Eq Result

init :: Model
init = {
        url: "https://httpbin.org/get",
        result: NotFetched
}

update :: Model -> Message -> Aff Model
update model (UpdateUrl url) = pure $ model { url = url, result = NotFetched }
update model (Fetched result) = pure $ model { result = result }
update model Fetch = do
        F.updateWith' $ model { result = Fetching }
        response <- A.get AR.string model.url
        pure $ case response.body of
                Left error -> model { result = Error $ A.printResponseFormatError error }
                Right ok -> model { result =  Ok ok }

view :: Model -> Html Message
view model = HE.main "main" [
        HE.input' [HV.onInput UpdateUrl, HA.value model.url, HA.type' "text"],
        HE.button [HV.onClick Fetch, HP.disabled $ model.result == Fetching] "Fetch",
        case model.result of
                NotFetched ->
                        HE.div_ "Not Fetched..."
                Fetching ->
                        HE.div_ "Fetching..."
                Ok ok ->
                        HE.pre_ <<< HE.code_ $ "Ok: " <> ok
                Error error ->
                        HE.div_ $ "Error: " <> error
]

main :: Effect Unit
main = do
        F.mount "main" { init, update, view, inputs : [] }
