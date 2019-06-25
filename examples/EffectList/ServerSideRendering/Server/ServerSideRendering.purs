module Examples.EffectList.ServerSideRendering.Server.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Effect.Console as EC
import Examples.EffectList.ServerSideRendering.Shared (Model(..), Message)
import Examples.EffectList.ServerSideRendering.Shared as EESS
import Flame (Html)
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Application.EffectList as FAE
import HTTPure (ResponseM, ServerM, Request)
import HTTPure as H
import Node.FS.Aff as FSA

-- | Boot up the server
main :: ServerM
main = H.serve 3000 routes $ EC.log "Server running on http://localhost:3000"

routes :: Request -> ResponseM
routes { path:  p }
        | p == [scriptName] = serveJavaScript
        | otherwise = serveHTML

serveJavaScript :: ResponseM
serveJavaScript = do
        contents <- FSA.readFile ("examples/EffectList/ServerSideRendering/dist/" <> scriptName)
        H.ok' javaScriptContentType contents
        where javaScriptContentType = H.header "Content-Type" "text/javascript"

serveHTML :: ResponseM
serveHTML = do
        stringContents <- liftEffect $ FAE.preMount "main" { init: Model Nothing, view: markup }
        H.ok' htmlContentType stringContents
        where htmlContentType = H.header "Content-Type" "text/html"

markup :: Model -> Html Message
markup model = HE.html_ [
        HE.head_ [
                HE.title "Server Side Rendering Dice Example",
                HE.meta $ HA.charset "utf-8"
        ],
        HE.body_ $ EESS.view model,
        HE.script' [HA.type' "text/javascript", HA.src scriptName]
]

scriptName :: String
scriptName = "server-side-rendering-client.js"