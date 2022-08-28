module Test.Main where

import Prelude

import Data.Array as DA
import Data.Generic.Rep (class Generic)
import Data.Show.Generic as DSG
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Newtype (class Newtype)
import Data.String.CodeUnits as DSC
import Data.Tuple (Tuple(..))
import Data.Traversable as DT
import Effect (Effect)
import Effect.Aff (Milliseconds(..))
import Effect.Aff as AF
import Effect.Class (liftEffect)
import Effect.Exception.Unsafe as EEU
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Flame.Application.Effectful as FAE
import Flame.Application.Internal.Dom as FAD
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Renderer.Internal.Dom as FRID
import Flame.Renderer.String as FRS
import Flame.Subscription as FS
import Flame.Subscription.Unsafe.CustomEvent as FSUC
import Partial.Unsafe (unsafePartial)
import Test.Basic.EffectList as TBEL
import Test.Basic.Effectful as TBE
import Test.Functor.Basic as TBF
import Test.Functor.Lazy as TFL
import Test.Basic.NoEffects as TBN
import Test.Effectful.SlowEffects as TES
import Test.ServerSideRendering.Effectful as TSE
import Test.ServerSideRendering.FragmentNode as TSF
import Test.ServerSideRendering.ManagedNode as TSM
import Test.Subscription.Broadcast as TSB
import Test.Subscription.EffectList (TEELMessage(..))
import Test.Subscription.EffectList as TEEL
import Test.Subscription.Effectful as TEE
import Test.Subscription.NoEffects as TEN
import Unsafe.Coerce as UC
import Web.DOM.Element (Element)
import Web.DOM.Element as WDE
import Web.DOM.HTMLCollection as WDHC
import Web.DOM.Node (Node)
import Web.DOM.Node as WDN
import Web.DOM.ParentNode as WDP
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget as WEE
import Web.Event.Internal.Types (Event)
import Web.HTML as WH
import Web.HTML.HTMLDocument as WDD
import Web.HTML.HTMLInputElement as WHH
import Test.Spec.Assertions as TSA
import Test.Spec as TS
import Web.HTML.Window as WHW
import Test.Spec.Runner as TSR
import Test.Spec.Reporter.Console (consoleReporter)

--we use jsdom to provide a browser like enviroment to run tests
-- as of now, dom objects are copied to the global object, as it is easier than having to mess with browersification
-- and headless browers
foreign import unsafeCreateEnviroment :: Effect Unit
foreign import clickEvent :: Effect Event
foreign import inputEvent :: Effect Event
foreign import keydownEvent :: Effect Event
foreign import enterPressedEvent :: Effect Event
foreign import errorEvent :: Effect Event
foreign import offlineEvent :: Effect Event
foreign import getCssText :: Element -> String
foreign import getAllAttributes :: Element -> String
foreign import getAllProperties :: Element -> Array String -> Array String
foreign import innerHtml_ :: EffectFn2 Element String Unit
foreign import createSvg :: Effect Node
foreign import createDiv :: Effect Node

main :: Effect Unit
main = AF.launchAff_ $ TSR.runSpec [consoleReporter] do
      TS.describe "Server side virtual node creation" do
            TS.it "ToHtml instances" do
                  let html = HE.a [HA.id "test"] [HE.text "TEST"]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<a id="test">TEST</a>""" html'

                  let html2 = HE.a (HA.id "test") [HE.text "TEST"]
                  html2' <- liftEffect $ FRS.render html2
                  TSA.shouldEqual """<a id="test">TEST</a>""" html2'

                  let html3 = HE.kbd "test" [HE.text "TEST"]
                  html3' <- liftEffect $ FRS.render html3
                  TSA.shouldEqual """<kbd id="test">TEST</kbd>""" html3'

                  let html4 = HE.a "test" $ HE.text "TEST"
                  html4' <- liftEffect $ FRS.render html4
                  TSA.shouldEqual """<a id="test">TEST</a>""" html4'

                  let html5 = HE.a "test" "TEST"
                  html5' <- liftEffect $ FRS.render html5
                  TSA.shouldEqual """<a id="test">TEST</a>""" html5'

            TS.it "ToClassList instances" do
                  let html = HE.a [HA.class' "test"] [HE.text "TEST"]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<a class="test">TEST</a>""" html'

                  let html2 = HE.svg [HA.class' { "test": false, "test2": true, "test3": true }] [HE.text "TEST"]
                  html2' <- liftEffect $ FRS.render html2
                  TSA.shouldEqual """<svg class="test2 test3">TEST</svg>""" html2'

            TS.it "inline style" do
                  let html = HE.a (HA.style { mystyle: "test" }) [HE.text "TEST"]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<a style="mystyle: test">TEST</a>""" html'

                  let html2 = HE.a [HA.style { width: "23px", display: "none" }] [HE.text "TEST"]
                  html2' <- liftEffect $ FRS.render html2
                  TSA.shouldEqual """<a style="width: 23px; display: none">TEST</a>""" html2'

                  let html3 = HE.a (HA.style1 "mystyle" "test-test") [HE.text "TEST"]
                  html3' <- liftEffect $ FRS.render html3
                  TSA.shouldEqual """<a style="mystyle: test-test">TEST</a>""" html3'

            TS.it "styles merge" do
                  let html = HE.a [ HA.style { mystyle: "test", mylife: "good" }, HA.style { mystyle: "check" } ] [HE.text "TEST"]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<a style="mystyle: check; mylife: good">TEST</a>""" html'

                  let html2 = HE.a [HA.style { width: "23px", display: "none" }, HA.style { height: "10px" } ] [HE.text "TEST"]
                  html2' <- liftEffect $ FRS.render html2
                  TSA.shouldEqual """<a style="width: 23px; display: none; height: 10px">TEST</a>""" html2'

                  let html3 = HE.a [HA.style [ Tuple "width" "64px", Tuple "display" "none" ], HA.style (Tuple "height" "10px") ] [HE.text "TEST"]
                  html3' <- liftEffect $ FRS.render html3
                  TSA.shouldEqual """<a style="width: 64px; display: none; height: 10px">TEST</a>""" html3'

            TS.it "classes merge" do
                  let html = HE.a [ HA.class' "a b", HA.class' { c: true } ] [HE.text "TEST"]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<a class="a b c">TEST</a>""" html'

            TS.it "style/class name case" do
                  html <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "superClass"
                  TSA.shouldEqual """<element class="super-class"></element>""" html

                  html2 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "SuperClass"
                  TSA.shouldEqual """<element class="super-class"></element>""" html2

                  html3 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "MySuperClass my-other-class"
                  TSA.shouldEqual """<element class="my-super-class my-other-class"></element>""" html3

                  html4 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "SUPERCLASS"
                  TSA.shouldEqual """<element class="superclass"></element>""" html4

                  html5 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.style { borderBox : "23", s : "34", borderLeftTopRadius : "20px"}
                  TSA.shouldEqual """<element style="border-box: 23; s: 34; border-left-top-radius: 20px"></element>""" html5

                  html6 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' { borderBox : true, s : false, borderLeftTopRadius : true}
                  TSA.shouldEqual """<element class="border-box border-left-top-radius"></element>""" html6

            TS.it "custom elements" do
                  let html = HE.createElement' "custom-element" "test"
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<custom-element id="test"></custom-element>""" html'

                  let html2 = HE.createElement' "custom-element" "test"
                  html2' <- liftEffect $ FRS.render html2
                  TSA.shouldEqual """<custom-element id="test"></custom-element>""" html2'

                  let html3 = HE.createElement_ "custom-element" "test"
                  html3' <- liftEffect $ FRS.render html3
                  TSA.shouldEqual """<custom-element>test</custom-element>""" html3'

            TS.it "lazy nodes" do
                  let html = HE.lazy Nothing (const (HE.p [HA.id "p", HA.min "23"] "TEST")) unit
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<p id="p" min="23">TEST</p>""" html'

            TS.it "fragment nodes" do
                  let html = HE.fragment [
                        HE.a [HA.class' "test"] [HE.text "TEST"],
                        HE.a [HA.class' "test-2"] [HE.text "TEST-2"]
                  ]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<a class="test">TEST</a><a class="test-2">TEST-2</a>""" html'

            TS.it "svg nodes" do
                  let html = HE.svg [HA.id "oi", HA.class' "ola", HA.viewBox "0 0 23 0"] <<< HE.path' $ HA.d "234"
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<svg class="ola" id="oi" viewBox="0 0 23 0"><path d="234" /></svg>""" html'

            TS.it "managed nodes are ignored" do
                  let html = HE.div [ HA.class' "a b" ] $ HE.managed_ {createNode: const createDiv, updateNode: \e _ _ -> pure e} unit
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<div class="a b"></div>""" html'

            TS.it "nested elements" do
                  let html = HE.html_ [
                        HE.head_ [HE.title "title"],
                        HE.body_ [
                              HE.main_ [
                                    HE.button_ "-",
                                    HE.br,
                                    HE.text "Test",
                                    HE.button_ "+",
                                    HE.svg (HA.viewBox "0 0 23 0") <<< HE.path' $ HA.d "234",
                                    HE.div_ $ HE.div_ [
                                          HE.span_ [ HE.a_ "here" ]
                                    ]
                              ]
                        ]
                  ]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<!DOCTYPE html><html><head><title>title</title></head><body><main><button>-</button><br>Test<button>+</button><svg viewBox="0 0 23 0"><path d="234" /></svg><div><div><span><a>here</a></span></div></div></main></body></html>""" html'

            TS.it "nested nodes with attributes" do
                  let html = HE.html [HA.lang "en"] [
                        HE.head_ [HE.title "title"],
                        HE.body "content" [
                              HE.main_ [
                                    HE.button (HA.style { display: "block", width: "20px"}) "-",
                                    HE.br,
                                    HE.text "Test",
                                    HE.button (HA.createAttribute "my-attribute" "myValue") "+",
                                    HE.hr' [HA.style { border: "200px solid blue"}] ,
                                    HE.div_ $ HE.div_ [
                                          HE.span_ [ HE.a_ "here" ]
                                    ]
                              ]
                        ]
                  ]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<!DOCTYPE html><html lang="en"><head><title>title</title></head><body id="content"><main><button style="display: block; width: 20px">-</button><br>Test<button my-attribute="myValue">+</button><hr style="border: 200px solid blue"><div><div><span><a>here</a></span></div></div></main></body></html>""" html'

            TS.it "nested nodes with properties and attributes" do
                  let html = HE.html [HA.lang "en"] [
                        HE.head [HA.disabled true] [HE.title "title"],
                        HE.body "content" [
                              HE.lazy Nothing (const (HE.main_ [
                                    HE.button (HA.style { display: "block", width: "20px"}) "-",
                                    HE.br,
                                    HE.text "Test",
                                    HE.button (HA.createAttribute "my-attribute" "myValue") "+",
                                    HE.hr' [HA.autocomplete "off", HA.style { border: "200px solid blue"}] ,
                                    HE.div_ $ HE.div_ [
                                          --empty data should not be rendered
                                          HE.span (HA.class' "") [ HE.a [HA.autofocus true] "here" ]
                                    ]
                              ])) unit
                        ]
                  ]
                  html' <- liftEffect $ FRS.render html
                  TSA.shouldEqual """<!DOCTYPE html><html lang="en"><head disabled="disabled"><title>title</title></head><body id="content"><main><button style="display: block; width: 20px">-</button><br>Test<button my-attribute="myValue">+</button><hr style="border: 200px solid blue" autocomplete="off"><div><div><span><a autofocus="autofocus">here</a></span></div></div></main></body></html>""" html'

      TS.describe "root node" do
            TS.it "root node is unchanged" do
                  liftEffect unsafeCreateEnviroment
                  let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                  void $ mountHtml' html
                  rootNode <- liftEffect $ FAD.querySelector "#mount-point"
                  TSA.shouldSatisfy rootNode DM.isJust

            TS.it "root node external children are unchanged" do
                  liftEffect unsafeCreateEnviroment
                  rootNode <- liftEffect $ unsafeQuerySelector "#mount-point"
                  liftEffect $ innerHtml rootNode """<div id="oi"></div>"""
                  let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                  state <- mountHtml' html
                  childrenCount <- childrenNodeLengthOf "#mount-point"
                  TSA.shouldEqual 2 childrenCount
                  divNode <- liftEffect $ FAD.querySelector "#oi"
                  TSA.shouldSatisfy divNode DM.isJust

      --we also have to test the translation of virtual nodes to actual dom nodes
      TS.describe "DOM node creation" do
            TS.it "styles" do
                  let html = HE.a [HA.id "link", HA.style {border: "solid", margin: "0px"}] "TEST"
                  state <- mountHtml html
                  nodeStyle <- getStyle "#link"
                  TSA.shouldEqual "border: solid; margin: 0px;" nodeStyle

                  let updatedHtml = HE.a [HA.id "link", HA.style {border: "2px", padding: "23px"}] "TEST"
                  liftEffect $ FRID.resume state updatedHtml
                  updatedNodeStyle <- getStyle "#link"
                  TSA.shouldEqual "border: 2px; padding: 23px;" updatedNodeStyle

                  let emptyUpdatedHtml = HE.a [HA.id "link", HA.style {}] "TEST"
                  liftEffect $ FRID.resume state emptyUpdatedHtml
                  emptyUpdatedNodeStyle <- getStyle "#link"
                  TSA.shouldEqual "" emptyUpdatedNodeStyle

                  let fullUpdatedHtml = HE.a [HA.id "link", HA.style {"z-index": "3"}] "TEST"
                  liftEffect $ FRID.resume state fullUpdatedHtml
                  fullNodeStyle <- getStyle "#link"
                  TSA.shouldEqual "z-index: 3;" fullNodeStyle

            TS.it "element classes" do
                  let html = HE.p (HA.class' "firstClass secondClass thirdClass") "TEST"
                  state <- mountHtml html
                  nodeClass <- getClass "p"
                  TSA.shouldEqual "first-class second-class third-class" nodeClass

                  let updatedHtml = HE.p (HA.class' {firstClass: false}) "TEST"
                  liftEffect $ FRID.resume state updatedHtml
                  updatedNodeClass <- getClass "p"
                  TSA.shouldEqual "" updatedNodeClass

                  let emptyUpdatedHtml = HE.p (HA.class' "") "TEST"
                  liftEffect $ FRID.resume state emptyUpdatedHtml
                  emptyUpdatedNodeClass <- getClass "p"
                  TSA.shouldEqual "" emptyUpdatedNodeClass

                  let fullUpdatedHtml = HE.p (HA.class' {some: true, some2: true }) "TEST"
                  liftEffect $ FRID.resume state fullUpdatedHtml
                  fullNodeClass <- getClass "p"
                  TSA.shouldEqual "some some2" fullNodeClass

            TS.it "svg classes" do
                  let html = HE.svg (HA.class' "firstClass secondClass thirdClass") "TEST"
                  state <- mountHtml html
                  nodeClass <- getSvgClass "svg"
                  TSA.shouldEqual (Just "first-class second-class third-class") nodeClass

                  let updatedHtml = HE.svg (HA.class' {firstClass: false}) "TEST"
                  liftEffect $ FRID.resume state updatedHtml
                  updatedNodeClass <- getSvgClass "svg"
                  TSA.shouldEqual (Just "") updatedNodeClass

                  let emptyUpdatedHtml = HE.svg (HA.class' "") "TEST"
                  liftEffect $ FRID.resume state emptyUpdatedHtml
                  emptyUpdatedNodeClass <- getSvgClass "svg"
                  TSA.shouldEqual (Just "") emptyUpdatedNodeClass

                  let fullUpdatedHtml = HE.svg (HA.class' {some: true, some2: true }) "TEST"
                  liftEffect $ FRID.resume state fullUpdatedHtml
                  fullNodeClass <- getSvgClass "svg"
                  TSA.shouldEqual (Just "some some2") fullNodeClass

            TS.it "attributes" do
                  let html = HE.input [HA.id "t", HA.href "e.com", HA.max "oi"]
                  state <- mountHtml html
                  nodeAttributes <- getAttributes "#t"
                  TSA.shouldEqual "href:e.com max:oi id:t" nodeAttributes

                  let updatedHtml = HE.input [HA.id "t", HA.href "e.com", HA.min "ola", HA.ping "pong"]
                  liftEffect $ FRID.resume state updatedHtml
                  updatedNodeAttributes <- getAttributes "#t"
                  TSA.shouldEqual "href:e.com id:t min:ola ping:pong" updatedNodeAttributes

                  let emptyUpdatedHtml = HE.input [HA.id "t"]
                  liftEffect $ FRID.resume state emptyUpdatedHtml
                  emptyUpdatedNodeAttributes <- getAttributes "#t"
                  --id is a property that also has an attribute
                  TSA.shouldEqual "id:t" emptyUpdatedNodeAttributes

                  let fullUpdatedHtml = HE.input [HA.id "t", HA.href "e.com", HA.min "ola", HA.ping "pong"]
                  liftEffect $ FRID.resume state fullUpdatedHtml
                  fullNodeAttributes <- getAttributes "#t"
                  TSA.shouldEqual "id:t href:e.com min:ola ping:pong" fullNodeAttributes

            TS.it "presential attributes" do
                  let html = HE.input [HA.id "t", HA.type' "checkbox", HA.disabled true, HA.autofocus true]
                  state <- mountHtml html
                  nodeAttributes <- getAttributes "input"
                  TSA.shouldEqual "id:t type:checkbox disabled: autofocus:" nodeAttributes

                  let updatedHtml = HE.input [HA.id "t", HA.type' "checkbox", HA.disabled false, HA.autofocus true]
                  liftEffect $ FRID.resume state updatedHtml
                  updatedNodeAttributes <- getAttributes "input"
                  TSA.shouldEqual "id:t type:checkbox autofocus:" updatedNodeAttributes

            TS.it "properties" do
                  let html = HE.input [HA.id "t", HA.value "a"]
                  state <- mountHtml html
                  nodeProperties <- getProperties "input" ["id", "value"]
                  TSA.shouldEqual ["t", "a"] nodeProperties

                  let updatedHtml = HE.input [HA.id "q", HA.pattern "aaa"]
                  liftEffect $ FRID.resume state updatedHtml
                  updatedNodeProperties <- getProperties "input" ["id", "pattern"]
                  TSA.shouldEqual ["q", "aaa"] updatedNodeProperties

            TS.it "text property of lazy nodes" do
                  let html = HE.lazy Nothing (const (HE.div_ "oi")) unit
                  void $ mountHtml html
                  text <- textContent "#mount-point"
                  TSA.shouldEqual "oi" text

            TS.it "nested svg elements have correct namespace" do
                  let html = HE.svg
                        [ HA.viewBox "0 0 100 100"
                        , HA.createAttribute "xmlns" "http://www.w3.org/2000/svg"
                        ]
                        [ HE.g [ HA.fill "white", HA.stroke "green", HA.strokeWidth "5" ]
                            [ HE.circle' [ HA.cx "40", HA.cy "40", HA.r "25" ], HE.circle' [ HA.cx "60", HA.cy "60", HA.r "25" ] ]
                        ]
                  void $ mountHtml html
                  let verifyNodeAndChildren node = do
                        TSA.shouldEqual (Just "http://www.w3.org/2000/svg") (WDE.namespaceURI node)
                        children <- liftEffect $ childrenNode' node
                        DT.for_ children verifyNodeAndChildren
                  svg <- liftEffect $ unsafeQuerySelector "svg"
                  verifyNodeAndChildren svg


      TS.describe "dom node update" do
            TS.it "update text nodes" do
                  let html = HE.text "oi"
                  state <- mountHtml html
                  let updatedHtml = HE.text "ola"
                  text <- textContent "#mount-point"
                  TSA.shouldEqual "oi" text

                  liftEffect $ FRID.resume state updatedHtml
                  updatedText <- textContent "#mount-point"
                  TSA.shouldEqual "ola" updatedText

            TS.it "unset text property" do
                  --nodes with a single text node child have the textContent property set
                  let html = HE.div "test-div" "oi"
                  state <- mountHtml html
                  text <- textContent "#test-div"
                  TSA.shouldEqual "oi" text

                  let updatedHtml = HE.div' "test-div"
                  liftEffect $ FRID.resume state updatedHtml
                  text2 <- textContent "#test-div"
                  TSA.shouldEqual "" text2

            TS.it "text to children" do
                  --nodes with a single text node child have the textContent property set
                  let html = HE.div "test-div" "oi"
                  state <- mountHtml html
                  text <- textContent "#test-div"
                  TSA.shouldEqual "oi" text

                  let updatedHtml = HE.div "test-div" [HE.span_ "ola", HE.div_ "hah", HE.br]
                  liftEffect $ FRID.resume state updatedHtml
                  text2 <- textContent "#test-div"
                  --from children
                  TSA.shouldEqual "olahah" text2
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 3 childrenCount

            TS.it "children to text" do
                  --nodes with a single text node child have the textContent property set
                  let html = HE.div "test-div" [HE.span_ "ola", HE.div_ "hah", HE.br]
                  state <- mountHtml html
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 3 childrenCount

                  let updatedHtml = HE.div "test-div" "oi"
                  liftEffect $ FRID.resume state updatedHtml
                  text <- textContent "#test-div"
                  TSA.shouldEqual "oi" text
                  childrenCount2 <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 0 childrenCount2

            TS.it "update node tag" do
                  let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                  state <- mountHtml html
                  let updatedHtml = HE.span (HA.class' "test-class") $ HE.input [HA.id "t", HA.value "a"]
                  liftEffect $ FRID.resume state updatedHtml
                  oldElement <- liftEffect $ FAD.querySelector "#test-div"
                  TSA.shouldSatisfy oldElement DM.isNothing
                  nodeClass <- getClass "span.test-class"
                  TSA.shouldEqual "test-class" nodeClass

            TS.it "update node type" do
                  let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                  state <- mountHtml html
                  let updatedHtml = HE.svg' (HA.viewBox "0 0 0 0")
                  liftEffect $ FRID.resume state updatedHtml
                  oldElement <- liftEffect $ FAD.querySelector "#test-div"
                  TSA.shouldSatisfy oldElement DM.isNothing
                  nodeAttributes <- getAttributes "svg"
                  TSA.shouldEqual "viewBox:0 0 0 0" nodeAttributes

            TS.it "inserting children" do
                  let html = HE.div' "test-div"
                  state <- mountHtml html
                  let updatedHtml = HE.div "test-div" [HE.br, HE.hr]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 2 childrenCount

            TS.it "removing children" do
                  let html = HE.div "test-div" [HE.br, HE.hr]
                  state <- mountHtml html
                  let updatedHtml = HE.div' "test-div"
                  liftEffect $ FRID.resume state updatedHtml
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 0 childrenCount

            TS.it "removing children with innerHtml" do
                  let html = HE.div "test-div" [HE.br, HE.hr]
                  state <- mountHtml html
                  let updatedHtml = HE.div' [HA.id "test-div", HA.innerHtml "<p>oi</p>"]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 1 childrenCount
                  p <- liftEffect $ FAD.querySelector "p"
                  TSA.shouldSatisfy p DM.isJust

            TS.it "removing and inserting children with innerHtml" do
                  let html = HE.div' [HA.id "test-div", HA.innerHtml "<p>oi</p>"]
                  state <- mountHtml html
                  let updatedHtml = HE.div (HA.id "test-div") [HE.br, HE.hr]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 2 childrenCount
                  hr <- liftEffect $ FAD.querySelector "br"
                  TSA.shouldSatisfy hr DM.isJust

            TS.it "fragments" do
                  let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                  state <- mountHtml html
                  let updatedHtml = HE.fragment $ HE.lazy Nothing (const (HE.svg' (HA.viewBox "0 0 0 0"))) unit
                  liftEffect $ FRID.resume state updatedHtml
                  oldElement <- liftEffect $ FAD.querySelector "#test-div"
                  TSA.shouldSatisfy oldElement DM.isNothing
                  nodeAttributes <- getAttributes "svg"
                  TSA.shouldEqual "viewBox:0 0 0 0" nodeAttributes

            TS.it "managed nodes" do
                  let html = HE.managed { createNode: const createSvg, updateNode: \_ _ _ -> createSvg } [HA.id "oi", HA.class' "ola", HA.viewBox "0 0 23 0"] unit
                  state <- mountHtml html
                  svgElement <- liftEffect $ FAD.querySelector "svg"
                  TSA.shouldSatisfy svgElement DM.isJust
                  nodeAttributes <- getAttributes "svg"
                  TSA.shouldEqual "class:ola viewbox:0 0 23 0 id:oi" nodeAttributes

                  divElement <- liftEffect createDiv
                  liftEffect $ innerHtml ( UC.unsafeCoerce divElement) """<span class="oi"></span>"""
                  let updatedHtml = HE.managed_ { createNode: const (pure divElement), updateNode: \e _ _ -> pure divElement } unit
                  liftEffect $ FRID.resume state updatedHtml
                  oldElement <- liftEffect $ FAD.querySelector "svg"
                  TSA.shouldSatisfy oldElement DM.isNothing
                  divElementCreated <- liftEffect $ FAD.querySelector "#mount-point div"
                  TSA.shouldSatisfy divElementCreated DM.isJust

                  let updatedHtml2 = HE.managed { createNode: const (pure divElement), updateNode: \e _ _ -> pure e } [HA.class' "test"] unit
                  liftEffect $ FRID.resume state updatedHtml2
                  spanElement <- liftEffect $ FAD.querySelector "span"
                  TSA.shouldSatisfy spanElement DM.isJust
                  nodeClass <- getClass "#mount-point div"
                  TSA.shouldEqual "test" nodeClass

            TS.it "setting inner html" do
                  let html = HE.div_ $ HE.div' [HA.id "test-div", HA.innerHtml "<span>Test</span>"]
                  state <- mountHtml html
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 1 childrenCount

                  let updatedHtml = HE.main_ $ HE.div' [HA.id "test-div", HA.innerHtml "<span>Test</span><hr>"]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenCount2 <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 2 childrenCount2

                  let updatedHtml2 = HE.main_ "oi"
                  liftEffect $ FRID.resume state updatedHtml2
                  oldElement <- liftEffect $ FAD.querySelector "#test-div"
                  TSA.shouldSatisfy oldElement DM.isNothing

            TS.it "replacing child nodes (type)" do
                  let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                  state <- mountHtml html

                  let updatedHtml = HE.div "test-div" $ HE.svg' (HA.viewBox "0 0 0 0")
                  liftEffect $ FRID.resume state updatedHtml
                  oldElement <- liftEffect $ FAD.querySelector "input"
                  TSA.shouldSatisfy oldElement DM.isNothing
                  nodeAttributes <- getAttributes "svg"
                  TSA.shouldEqual "viewBox:0 0 0 0" nodeAttributes

            TS.it "replacing child nodes (tag)" do
                  let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                  state <- mountHtml html

                  let updatedHtml = HE.div "test-div" $ HE.div_ "test"
                  liftEffect $ FRID.resume state updatedHtml
                  oldElement <- liftEffect $ FAD.querySelector "input"
                  TSA.shouldSatisfy oldElement DM.isNothing
                  nodeAttributes <- getAttributes "#test-div div"
                  TSA.shouldEqual "" nodeAttributes

            TS.it "replacing child nodes (number of children)" do
                  let html = HE.div "test-div" [HE.input [HA.id "t", HA.value "a"], HE.div (HA.class' "inside-div") "test", HE.span "test-span" $ HE.br]
                  state <- mountHtml html

                  let updatedHtml = HE.div "test-div" [HE.main_ "oi", HE.section_ $ HE.hr]
                  liftEffect $ FRID.resume state updatedHtml
                  oldElements <- liftEffect $ DT.traverse FAD.querySelector ["input", "#test-div div", "#test-div span"]
                  TSA.shouldSatisfy oldElements (DA.all DM.isNothing)
                  nodeAttributes <- getAttributes "#test-div main"
                  TSA.shouldEqual "" nodeAttributes
                  nodeAttributes2 <- getAttributes "#test-div section"
                  TSA.shouldEqual "" nodeAttributes

      TS.describe "events" do
            TS.it "event sets dom property" do
                  let html = HE.input [HA.onClick unit]
                  state <- mountHtml html
                  nodeProperties <- getProperties "input" [eventPrefix <> "click"]
                  TSA.shouldSatisfy nodeProperties ((_ == 1) <<< DA.length)

            TS.it "removing event also removes dom property" do
                  let html = HE.input [HA.onClick unit, HA.onScroll unit]
                  state <- mountHtml html
                  let updatedHtml = HE.input [HA.onClick unit]
                  liftEffect $ FRID.resume state updatedHtml
                  nodeProperties <- getProperties "input" [eventPrefix <> "click", eventPrefix <> "scroll"]
                  TSA.shouldSatisfy nodeProperties ((_ == 1) <<< DA.length)

      TS.describe "keyed" do
            TS.it "common prefix" do
                  let html = HE.div "test-div" [HE.span' [HA.key "1"], HE.span' [HA.key "2"]]
                  state <- mountHtml html
                  let updatedHtml = HE.div "test-div" [HE.span' [HA.key "1"], HE.span' [HA.key "2"], HE.span' [HA.key "3"]]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 3 childrenCount

            TS.it "common suffix" do
                  let html = HE.div "test-div" [HE.span' [HA.key "2"], HE.span' [HA.key "3"]]
                  state <- mountHtml html
                  let updatedHtml = HE.div "test-div" [HE.span' [HA.key "1"], HE.span' [HA.key "2"], HE.span' [HA.key "3"]]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenCount <- childrenNodeLengthOf "#test-div"
                  TSA.shouldEqual 3 childrenCount

            TS.it "swap backwards" do
                  let html = HE.div "test-div" [HE.span' [HA.key "1", HA.id "1"], HE.span' [HA.key "2", HA.id "2"], HE.span' [HA.key "3", HA.id "3"]]
                  state <- mountHtml html
                  childrenIds <- childNodeIds "#test-div"
                  TSA.shouldEqual ["1", "2", "3"] childrenIds
                  let updatedHtml = HE.div "test-div" [HE.span' [HA.key "3", HA.id "3"], HE.span' [HA.key "2", HA.id "2"], HE.span' [HA.key "1", HA.id "1"]]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenIdsSwapped <- childNodeIds "#test-div"
                  TSA.shouldEqual ["3", "2", "1"] childrenIdsSwapped

            TS.it "swap forward" do
                  let html = HE.div "test-div" [HE.span' [HA.key "3", HA.id "3"], HE.span' [HA.key "2", HA.id "2"], HE.span' [HA.key "1", HA.id "1"]]
                  state <- mountHtml html
                  childrenIds <- childNodeIds "#test-div"
                  TSA.shouldEqual ["3", "2", "1"] childrenIds
                  let updatedHtml = HE.div "test-div" [HE.span' [HA.key "1", HA.id "1"], HE.span' [HA.key "2", HA.id "2"], HE.span' [HA.key "3", HA.id "3"]]
                  liftEffect $ FRID.resume state updatedHtml
                  childrenIdsSwapped <- childNodeIds "#test-div"
                  TSA.shouldEqual ["1", "2", "3"] childrenIdsSwapped

            -- TS.it "remove nodes" do
            -- TS.it "remove all nodes" do
            -- TS.it "move nodes" do
            -- TS.it "move and remove nodes" do
            -- TS.it "move and add nodes" do

      TS.describe "diff" do
            TS.it "updates record fields" do
                  TSA.shouldEqual { a: 23, b: "hello", c: true } $ FAE.diff' {c: true} { a : 23, b: "hello", c: false }
                  TSA.shouldEqual { a: 23, b: "hello", c: false } $ FAE.diff' {} { a : 23, b: "hello", c: false }

            TS.it "updates record fields with newtype" do
                  TSA.shouldEqual (TestNewtype { a: 23, b: "hello", c: true }) <<< FAE.diff' {c: true} $ TestNewtype { a : 23, b: "hello", c: false }
                  TSA.shouldEqual (TestNewtype { a: 23, b: "hello", c: false }) <<< FAE.diff' {} $ TestNewtype { a : 23, b: "hello", c: false }

            TS.it "updates record fields with functor" do
                  TSA.shouldEqual (Just { a: 23, b: "hello", c: true }) <<< FAE.diff' {c: true} $ Just { a : 23, b: "hello", c: false }
                  TSA.shouldEqual (Just { a: 23, b: "hello", c: false }) <<< FAE.diff' {} $ Just { a : 23, b: "hello", c: false }

            TS.it "new copy is returned" do
                  --since diff uses unsafe javascript, make sure the reference is not being written to
                  let model = { a: 1, b: 2}
                  TSA.shouldEqual { a: 1, b: 3 } $ FAE.diff' { b: 3 } model
                  TSA.shouldEqual { a: 12, b: 2 } $ FAE.diff' { a: 12 } model

      TS.describe "Basic applications" do
            TS.it "noeffects" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TBN.mount
                  childrenLength <- childrenNodeLength
                  --button, span, button
                  TSA.shouldEqual 3 childrenLength

                  initial <- textContent "#text-output"
                  TSA.shouldEqual "0" initial

                  dispatchEvent clickEvent "#decrement-button"
                  current <- textContent "#text-output"
                  TSA.shouldEqual "-1" current

                  dispatchEvent clickEvent "#increment-button"
                  dispatchEvent clickEvent "#increment-button"
                  current2 <- textContent "#text-output"
                  TSA.shouldEqual "1" current2

            TS.it "effectlist" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TBEL.mount
                  childrenLength <- childrenNodeLength
                  --span, input, input
                  TSA.shouldEqual 3 childrenLength

                  let   setInput text = liftEffect do
                              element <- unsafeQuerySelector "#text-input"
                              WHH.setValue text $ unsafePartial (DM.fromJust $ WHH.fromElement element)
                  initial <- textContent "#text-output"
                  TSA.shouldEqual "" initial

                  dispatchEvent clickEvent "#cut-button"
                  current <- textContent "#text-output"
                  TSA.shouldEqual "" current

                  setInput "test"
                  dispatchEvent inputEvent "#text-input"
                  dispatchEvent clickEvent "#cut-button"
                  cut <- textContent "#text-output"
                  --always remove at least one character
                  TSA.shouldSatisfy cut ((_ < 4) <<< DSC.length)

                  dispatchEvent inputEvent "#text-input"
                  dispatchEvent enterPressedEvent "#text-input"
                  submitted <- textContent "#text-output"
                  TSA.shouldEqual "thanks" submitted

            TS.it "effectful" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TBE.mount
                  childrenLength <- childrenNodeLength
                  --span, span, span, br, button, button
                  TSA.shouldEqual 6 childrenLength

                  currentIncrement <- textContent "#text-output-increment"
                  currentDecrement <- textContent "#text-output-decrement"
                  currentLuckyNumber <- textContent "#text-output-lucky-number"
                  TSA.shouldEqual "-1" currentDecrement
                  TSA.shouldEqual "0" currentIncrement
                  TSA.shouldEqual "2" currentLuckyNumber

                  dispatchEvent clickEvent "#decrement-button"
                  currentIncrement2 <- textContent "#text-output-increment"
                  currentDecrement2 <- textContent "#text-output-decrement"
                  currentLuckyNumber2 <- textContent "#text-output-lucky-number"
                  TSA.shouldEqual "-2" currentDecrement2
                  TSA.shouldEqual "0" currentIncrement2
                  TSA.shouldEqual "2" currentLuckyNumber2

                  dispatchEvent clickEvent "#increment-button"
                  dispatchEvent clickEvent "#increment-button"
                  currentIncrement3 <- textContent "#text-output-increment"
                  currentDecrement3 <- textContent "#text-output-decrement"
                  currentLuckyNumber3 <- textContent "#text-output-lucky-number"
                  TSA.shouldEqual "2" currentIncrement3
                  TSA.shouldEqual "-2" currentDecrement3
                  TSA.shouldEqual "2" currentLuckyNumber3

      TS.describe "functor" do
            TS.it "basic" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TBF.mount
                  childrenLength <- childrenNodeLength
                  --button, div
                  TSA.shouldEqual 2 childrenLength

                  dispatchEvent clickEvent "#add-button"
                  initial <- textContent "#text-output-0"
                  TSA.shouldEqual "0" initial

                  dispatchEvent clickEvent "#decrement-button-0"
                  current <- textContent "#text-output-0"
                  TSA.shouldEqual "-1" current

                  dispatchEvent clickEvent "#add-button"
                  dispatchEvent clickEvent "#increment-button-1"
                  dispatchEvent clickEvent "#increment-button-1"
                  current2 <- textContent "#text-output-1"
                  TSA.shouldEqual "2" current2

            TS.it "lazy" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TFL.mount
                  childrenLength <- childrenNodeLength
                  --div
                  TSA.shouldEqual 1 childrenLength

                  dispatchEvent clickEvent "#add-button"
                  initial <- textContent "#add-button"
                  TSA.shouldEqual "Current Value: 1001" initial

                  dispatchEvent clickEvent "#add-button"
                  dispatchEvent clickEvent "#add-button"
                  current2 <- textContent "#add-button"
                  TSA.shouldEqual "Current Value: 3001" current2

      TS.describe "Effectful specific" do
            TS.it "slower effects" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TES.mount
                  outputCurrent <- textContent "#text-output-current"
                  outputNumbers <- textContent "#text-output-numbers"
                  TSA.shouldEqual "0" outputCurrent
                  TSA.shouldEqual "[]" outputNumbers

                  --the event for snoc has a delay, make sure it doesnt overwrite unrelated fields when updating
                  dispatchEvent clickEvent "#snoc-button"
                  dispatchEvent clickEvent "#bump-button"
                  outputCurrent2 <- textContent "#text-output-current"
                  outputNumbers2 <- textContent "#text-output-numbers"
                  TSA.shouldEqual "1" outputCurrent2
                  TSA.shouldEqual "[]" outputNumbers2

                  AF.delay $ Milliseconds 1000.0
                  outputCurrent3 <- textContent "#text-output-current"
                  outputNumbers3 <- textContent "#text-output-numbers"
                  TSA.shouldEqual "2" outputCurrent3
                  TSA.shouldEqual "[0]" outputNumbers3

      TS.describe "Subscription applications" do
            TS.it "noeffects" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TEN.mount
                  output <- textContent "#text-output"
                  TSA.shouldEqual "0" output

                  dispatchDocumentEvent clickEvent
                  output2 <- textContent "#text-output"
                  TSA.shouldEqual "-1" output2

                  dispatchDocumentEvent keydownEvent
                  dispatchDocumentEvent keydownEvent
                  dispatchDocumentEvent keydownEvent
                  output3 <- textContent "#text-output"
                  TSA.shouldEqual "2" output3

            TS.it "effectlist" do
                  id <- liftEffect do
                        unsafeCreateEnviroment
                        TEEL.mount
                  output <- textContent "#text-output"
                  TSA.shouldEqual "0" output

                  liftEffect $ FS.send id TEELDecrement
                  output2 <- textContent "#text-output"
                  TSA.shouldEqual "-1" output2

                  liftEffect $ FS.send id TEELIncrement
                  output3 <- textContent "#text-output"
                  TSA.shouldEqual "0" output3

            TS.it "effectful" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TEE.mount
                  output <- textContent "#text-output"
                  TSA.shouldEqual "5" output

                  dispatchWindowEvent errorEvent
                  dispatchWindowEvent errorEvent
                  dispatchWindowEvent errorEvent
                  output2 <- textContent "#text-output"
                  TSA.shouldEqual "2" output2

                  dispatchWindowEvent offlineEvent
                  output3 <- textContent "#text-output"
                  TSA.shouldEqual "3" output3

            TS.it "broadcast" do
                  id <- liftEffect do
                        unsafeCreateEnviroment
                        TSB.mount
                  output <- textContent "#text-output"
                  TSA.shouldEqual "0" output

                  liftEffect <<< FSUC.broadcast (EventType "decrement-event") $ Just 34
                  output2 <- textContent "#text-output"
                  TSA.shouldEqual "-34" output2

                  liftEffect $ FSUC.broadcast' (EventType "increment-event")
                  output3 <- textContent "#text-output"
                  TSA.shouldEqual "-33" output3

      TS.describe "Server side rendering" do
            TS.it "effectful" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TSE.preMount
                  childrenLength <- childrenNodeLengthOf "#mount-point"
                  TSA.shouldEqual 1 childrenLength

                  childrenLength2 <- childrenNodeLengthOf "#my-id"
                  --before resuming mount there is an extra element with the serialized state
                  TSA.shouldEqual 4 childrenLength2
                  initial <- textContent "#text-output"
                  TSA.shouldEqual "2" initial

                  liftEffect TSE.mount
                  childrenLength3 <-  childrenNodeLengthOf "#my-id"
                  TSA.shouldEqual 4 childrenLength3
                  initial2 <- textContent "#text-output"
                  TSA.shouldEqual "2" initial2

                  dispatchEvent clickEvent "#increment-button"
                  current <- textContent "#text-output"
                  TSA.shouldEqual "3" current

            TS.it "managed nodes" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TSM.preMount
                  childrenLength <- childrenNodeLengthOf "#mount-point"
                  TSA.shouldEqual 1 childrenLength

                  childrenLength2 <- childrenNodeLengthOf "#my-id"
                  TSA.shouldEqual 3 childrenLength2
                  --managed nodes are not rendered server-side
                  span <- liftEffect $ FAD.querySelector "#text-output"
                  TSA.shouldSatisfy span DM.isNothing

                  liftEffect TSM.mount
                  childrenLength3 <- childrenNodeLengthOf "#my-id"
                  TSA.shouldEqual 3 childrenLength3
                  initial2 <- textContent "#text-output"
                  TSA.shouldEqual "2" initial2

                  dispatchEvent clickEvent "#increment-button"
                  current <- textContent "#text-output"
                  TSA.shouldEqual "3" current

            TS.it "fragment nodes" do
                  liftEffect do
                        unsafeCreateEnviroment
                        TSF.preMount
                  childrenLength <- childrenNodeLengthOf "#mount-point"
                  TSA.shouldEqual 1 childrenLength

                  childrenLength2 <- childrenNodeLengthOf "#my-id"
                  TSA.shouldEqual 4 childrenLength2
                  initial <- textContent "#text-output"
                  TSA.shouldEqual "2" initial

                  liftEffect TSF.mount
                  childrenLength3 <-  childrenNodeLengthOf "#my-id"
                  TSA.shouldEqual 4 childrenLength3
                  initial2 <- textContent "#text-output"
                  TSA.shouldEqual "2" initial2

                  dispatchEvent clickEvent "#increment-button"
                  current <- textContent "#text-output"
                  TSA.shouldEqual "3" current

      where unsafeQuerySelector :: String -> Effect Element
            unsafeQuerySelector selector = do
                  maybeElement <- FAD.querySelector selector
                  case maybeElement of
                        Nothing -> EEU.unsafeThrow $ "Selector not found! " <> selector
                        Just element -> pure $ UC.unsafeCoerce element

            mountHtml html = liftEffect do
                  unsafeCreateEnviroment
                  mountDiv <- unsafePartial (DM.fromJust <$> FAD.querySelector "#mount-point")
                  FRID.start mountDiv (const (pure unit)) html

            mountHtml' html = liftEffect do
                  mountDiv <- unsafePartial (DM.fromJust <$> FAD.querySelector "#mount-point")
                  FRID.start mountDiv (const (pure unit)) html

            getStyle selector = liftEffect do
                  element <- unsafeQuerySelector selector
                  pure $ getCssText element

            getClass selector = liftEffect do
                  element <- unsafeQuerySelector selector
                  WDE.className element

            getSvgClass selector = liftEffect do
                  element <- unsafeQuerySelector selector
                  WDE.getAttribute "class" element

            getAttributes selector = liftEffect do
                  element <- unsafeQuerySelector selector
                  pure $ getAllAttributes element

            getProperties selector list = liftEffect do
                  element <- unsafeQuerySelector selector
                  pure $ getAllProperties element list

            childrenNodeLength = childrenNodeLengthOf "main"

            childrenNodeLengthOf selector = liftEffect do
                  c <- childrenNode selector
                  pure $ DA.length c

            childrenNode selector = do
                  mountPoint <- unsafeQuerySelector selector
                  children <- WDP.children $ WDE.toParentNode mountPoint
                  WDHC.toArray children

            childrenNode' parent = do
                  children <- WDP.children $ WDE.toParentNode parent
                  WDHC.toArray children

            textContent selector = liftEffect do
                  element <- unsafeQuerySelector selector
                  WDN.textContent $ WDE.toNode element

            eventPrefix = "__flame_"

            innerHtml = EU.runEffectFn2 innerHtml_

            dispatchEvent eventFunction selector = liftEffect $ void do
                  element <- unsafeQuerySelector selector
                  event <- eventFunction
                  WEE.dispatchEvent event $ WDE.toEventTarget element

            dispatchDocumentEvent eventFunction = liftEffect $ void do
                  window <- WH.window
                  document <- WHW.document window
                  event <- eventFunction
                  WEE.dispatchEvent event $ WDD.toEventTarget document

            dispatchWindowEvent eventFunction = liftEffect $ void do
                  window <- WH.window
                  event <- eventFunction
                  WEE.dispatchEvent event $ WHW.toEventTarget window

            childNodeIds selector = liftEffect do
                  children <- childrenNode selector
                  liftEffect $ DT.traverse WDE.id children

newtype TestNewtype = TestNewtype { a :: Int, b :: String, c :: Boolean }

derive instance genericTestNewtype :: Generic TestNewtype _
derive instance newtypeTestNewtype :: Newtype TestNewtype _
derive instance eqTestNewtype :: Eq TestNewtype
instance showTestNewtype :: Show TestNewtype where
      show = DSG.genericShow
