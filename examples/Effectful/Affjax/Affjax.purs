module Examples.Effectful.Affjax.Main where

import Prelude

import Affjax as A
import Affjax.ResponseFormat as AR
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.Effectful (AffUpdate)
import Flame.Application.Effectful as FAE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = {
        url :: String,
        result :: Result
}

data Message = UpdateUrl String | Fetch

data Result = NotFetched | Fetching | Ok String | Error String

derive instance eqResult :: Eq Result

init :: Model
init = {
        url: "https://httpbin.org/get",
        result: NotFetched
}

update :: AffUpdate Model Message
update { display, model, message } =
        case message of
                UpdateUrl url -> pure _ { url = url, result = NotFetched }
                Fetch -> do
                        display $ _ { result = Fetching }
                        response <- A.get AR.string model.url
                        pure $ case response.body of
                                Left error -> _ { result = Error $ A.printResponseFormatError error }
                                Right ok -> _ { result =  Ok ok }

view :: Model -> Html Message
view { url, result } = HE.main "main" [
        HE.input [HA.onInput UpdateUrl, HA.value url, HA.type' "text"],
        HE.button [HA.onClick Fetch, HA.disabled $ result == Fetching] "Fetch",
        case result of
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
main = FAE.mount_ (QuerySelector "main") {
        init: init :> Nothing,
        update,
        view
}
