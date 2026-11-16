-- | Quick and dirty server, the relevant functions for example sake are serveHTML and markup
module Examples.EffectList.ServerSideRendering.Server.Main where

import Prelude hiding ((/))

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Effect.Console as EC
import Examples.EffectList.ServerSideRendering.Shared (Model(..), Message)
import Examples.EffectList.ServerSideRendering.Shared as EESS
import Flame (Html)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import HTTPurple (Request, ResponseM, ServerM, (/))
import HTTPurple as H
import Node.FS.Aff as FSA
import Web.DOM.ParentNode (QuerySelector(..))

data Route = Home | Script

derive instance Generic Route _

route ∷ H.RouteDuplex' Route
route = H.mkRoute
      { "Home": H.noArgs
      , "Script": scriptName / H.noArgs
      }

-- | Boot up the server
main ∷ ServerM
main = H.serve { port: 3000, onStarted } { route, router }
      where
      onStarted = EC.log "Server running on http://localhost:3000"

router ∷ Request Route → ResponseM
router { route: Script } = serveJavaScript
router { route: Home } = serveHTML

serveJavaScript ∷ ResponseM
serveJavaScript = do
      contents ← FSA.readFile ("examples/src/ServerSideRendering/dist/" <> scriptName)
      H.ok' javaScriptContentType contents
      where
      javaScriptContentType = H.header "Content-Type" "text/javascript"

serveHTML ∷ ResponseM
serveHTML = do
      stringContents ← liftEffect $ F.preMount (QuerySelector "#main") { model: Model Nothing, view: markup }
      H.ok' htmlContentType stringContents
      where
      htmlContentType = H.header "Content-Type" "text/html"

markup ∷ Model → Html Message
markup model = HE.html_
      [ HE.head_
              [ HE.title [ HE.text "Server Side Rendering Dice Example" ]
              , HE.meta [ HA.charset "utf-8" ]
              ]
      , HE.body_ [ EESS.view model ]
      , HE.script' [ HA.type' "text/javascript", HA.src scriptName ]
      ]

scriptName ∷ String
scriptName = "server-side-rendering-client.js"
