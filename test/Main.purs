module Test.Main where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show as DGRS
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Newtype (class Newtype)
import Data.String.CodeUnits as DSC
import Effect (Effect)
import Effect.Aff (Milliseconds(..))
import Effect.Aff as AF
import Effect.Class (liftEffect)
import Effect.Exception.Unsafe as EEU
import Flame.Application.Effectful as FAE
import Flame.Application.Internal.Dom as FAD
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Renderer.Internal.Dom as FRID
import Flame.Renderer.Key as FRK
import Flame.Renderer.Lazy as FRL
import Flame.Renderer.String as FRS
import Flame.Types (DomNode)
import Foreign.Object (Object)
import Foreign.Object as FO
import Partial.Unsafe (unsafePartial)
import Partial.Unsafe as PU
import Signal.Channel as SC
import Test.Basic.EffectList as TBEL
import Test.Basic.Effectful as TBE
import Test.Basic.NoEffects as TBN
import Test.Effectful.SlowEffects as TES
import Test.External.EffectList (TEELMessage(..))
import Test.External.EffectList as TEEL
import Test.External.Effectful as TEE
import Test.External.NoEffects as TEN
import Test.ServerSideRendering.Effectful as TSE
import Test.Unit (suite, test)
import Test.Unit.Assert as TUA
import Test.Unit.Main (runTest)
import Unsafe.Coerce as UC
import Web.DOM.Element (Element, getAttribute)
import Web.DOM.Element as WDE
import Web.DOM.HTMLCollection as WDH
import Web.DOM.Node as WDN
import Web.DOM.ParentNode as WDP
import Web.Event.EventTarget as WEE
import Web.Event.Internal.Types (Event)
import Web.HTML as WH
import Web.HTML.HTMLDocument as WDD
import Web.HTML.HTMLInputElement as WHH
import Web.HTML.Window as WHW

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

main :: Effect Unit
main =
      runTest do
            -- string rendering operates directing on virtual nodes
            suite "VNode creation" do
                        test "ToHtml instances" do
                              let html = HE.a [HA.id "test"] [HE.text "TEST"]
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<a id="test">TEST</a>""" html'

                              let html2 = HE.a (HA.id "test") [HE.text "TEST"]
                              html2' <- liftEffect $ FRS.render html2
                              TUA.equal """<a id="test">TEST</a>""" html2'

                              let html3 = HE.a "test" [HE.text "TEST"]
                              html3' <- liftEffect $ FRS.render html3
                              TUA.equal """<a id="test">TEST</a>""" html3'

                              let html4 = HE.a "test" $ HE.text "TEST"
                              html4' <- liftEffect $ FRS.render html4
                              TUA.equal """<a id="test">TEST</a>""" html4'

                              let html5 = HE.a "test" "TEST"
                              html5' <- liftEffect $ FRS.render html5
                              TUA.equal """<a id="test">TEST</a>""" html5'

                        test "ToClassList instances" do
                              let html = HE.a [HA.class' "test"] [HE.text "TEST"]
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<a class="test">TEST</a>""" html'

                              let html2 = HE.svg [HA.class' { "test": false, "test2": true, "test3": true }] [HE.text "TEST"]
                              html2' <- liftEffect $ FRS.render html2
                              TUA.equal """<svg class="test2 test3">TEST</svg>""" html2'

                        test "inline style" do
                              let html = HE.a (HA.style { mystyle: "test" }) [HE.text "TEST"]
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<a style="mystyle: test">TEST</a>""" html'

                              let html2 = HE.a [HA.style { width: "23px", display: "none" }] [HE.text "TEST"]
                              html2' <- liftEffect $ FRS.render html2
                              TUA.equal """<a style="width: 23px; display: none">TEST</a>""" html2'

                        test "style merging" do
                              let html = HE.a [ HA.style { mystyle: "test", mylife: "good" }, HA.style { mystyle: "check" } ] [HE.text "TEST"]
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<a style="mystyle: check; mylife: good">TEST</a>""" html'

                              let html2 = HE.a [HA.style { width: "23px", display: "none" }, HA.style { height: "10px" } ] [HE.text "TEST"]
                              html2' <- liftEffect $ FRS.render html2
                              TUA.equal """<a style="width: 23px; display: none; height: 10px">TEST</a>""" html2'

                        test "style/class name case" do
                              html <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "superClass"
                              TUA.equal """<element class="super-class"></element>""" html

                              html2 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "SuperClass"
                              TUA.equal """<element class="super-class"></element>""" html2

                              html3 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "MySuperClass my-other-class"
                              TUA.equal """<element class="my-super-class my-other-class"></element>""" html3

                              html4 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' "SUPERCLASS"
                              TUA.equal """<element class="superclass"></element>""" html4

                              html5 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.style { borderBox : "23", s : "34", borderLeftTopRadius : "20px"}
                              TUA.equal """<element style="border-box: 23; s: 34; border-left-top-radius: 20px"></element>""" html5

                              html6 <- liftEffect <<< FRS.render $ HE.createElement' "element" $ HA.class' { borderBox : true, s : false, borderLeftTopRadius : true}
                              TUA.equal """<element class="border-box border-left-top-radius"></element>""" html6

                        test "custom elements" do
                              let html = HE.createElement' "custom-element" "test"
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<custom-element id="test"></custom-element>""" html'

                              let html2 = HE.createElement' "custom-element" "test"
                              html2' <- liftEffect $ FRS.render html2
                              TUA.equal """<custom-element id="test"></custom-element>""" html2'

                              let html3 = HE.createElement_ "custom-element" "test"
                              html3' <- liftEffect $ FRS.render html3
                              TUA.equal """<custom-element>test</custom-element>""" html3'

                        test "lazy nodes" do
                              let html = FRL.lazy Nothing (const (HE.p [HA.id "p", HA.min "23"] "TEST")) unit
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<p id="p" min="23">TEST</p>""" html'

                        test "nested elements" do
                              let html = HE.html_ [
                                    HE.head_ [HE.title "title"],
                                    HE.body_ [
                                          HE.main_ [
                                                HE.button_ "-",
                                                HE.br,
                                                HE.text "Test",
                                                HE.button_ "+",
                                                HE.hr,
                                                HE.div_ $ HE.div_ [
                                                      HE.span_ [ HE.a_ "here" ]
                                                ]
                                          ]
                                    ]
                              ]
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<html><head><title>title</title></head><body><main><button>-</button><br>Test<button>+</button><hr><div><div><span><a>here</a></span></div></div></main></body></html>""" html'

                        test "nested elements with attributes" do
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
                              TUA.equal """<html lang="en"><head><title>title</title></head><body id="content"><main><button style="display: block; width: 20px">-</button><br>Test<button my-attribute="myValue">+</button><hr style="border: 200px solid blue"><div><div><span><a>here</a></span></div></div></main></body></html>""" html'

                        test "nested elements with properties and attributes" do
                              let html = HE.html [HA.lang "en"] [
                                    HE.head [HA.disabled true] [HE.title "title"],
                                    HE.body "content" [
                                          FRL.lazy Nothing (const (HE.main_ [
                                                HE.button (HA.style { display: "block", width: "20px"}) "-",
                                                HE.br,
                                                HE.text "Test",
                                                HE.button (HA.createAttribute "my-attribute" "myValue") "+",
                                                HE.hr' [HA.autocomplete "off", HA.style { border: "200px solid blue"}] ,
                                                HE.div_ $ HE.div_ [
                                                      HE.span_ [ HE.a [HA.autofocus true] "here" ]
                                                ]
                                          ])) unit
                                    ]
                              ]
                              html' <- liftEffect $ FRS.render html
                              TUA.equal """<html lang="en"><head disabled="true"><title>title</title></head><body id="content"><main><button style="display: block; width: 20px">-</button><br>Test<button my-attribute="myValue">+</button><hr style="border: 200px solid blue" autocomplete="off"><div><div><span><a autofocus="true">here</a></span></div></div></main></body></html>""" html'

            --we also have to test the translation of virtual nodes to actual dom nodes
            suite "DOM node creation" do
                  test "styles" do
                        let html = HE.a [HA.id "link", HA.style {border: "solid", margin: "0px"}] "TEST"
                        state <- mountHtml html
                        nodeStyle <- getStyle "#link"
                        TUA.equal "border: solid; margin: 0px;" nodeStyle

                        let updatedHtml = HE.a [HA.id "link", HA.style {border: "2px", padding: "23px"}] "TEST"
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        updatedNodeStyle <- getStyle "#link"
                        TUA.equal "border: 2px; padding: 23px;" updatedNodeStyle

                        let emptyUpdatedHtml = HE.a [HA.id "link", HA.style {}] "TEST"
                        void <<< liftEffect $ FRID.resume state emptyUpdatedHtml
                        emptyUpdatedNodeStyle <- getStyle "#link"
                        TUA.equal "" emptyUpdatedNodeStyle

                        let fullUpdatedHtml = HE.a [HA.id "link", HA.style {"z-index": "3"}] "TEST"
                        void <<< liftEffect $ FRID.resume state fullUpdatedHtml
                        fullNodeStyle <- getStyle "#link"
                        TUA.equal "z-index: 3;" fullNodeStyle

                  test "element classes" do
                        let html = HE.p (HA.class' "firstClass secondClass thirdClass") "TEST"
                        state <- mountHtml html
                        nodeClass <- getClass "p"
                        TUA.equal "first-class second-class third-class" nodeClass

                        let updatedHtml = HE.p (HA.class' {firstClass: false}) "TEST"
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        updatedNodeClass <- getClass "p"
                        TUA.equal "" updatedNodeClass

                        let emptyUpdatedHtml = HE.p (HA.class' "") "TEST"
                        void <<< liftEffect $ FRID.resume state emptyUpdatedHtml
                        emptyUpdatedNodeClass <- getClass "p"
                        TUA.equal "" emptyUpdatedNodeClass

                        let fullUpdatedHtml = HE.p (HA.class' {some: true, some2: true }) "TEST"
                        void <<< liftEffect $ FRID.resume state fullUpdatedHtml
                        fullNodeClass <- getClass "p"
                        TUA.equal "some some2" fullNodeClass

                  test "svg classes" do
                        let html = HE.svg (HA.class' "firstClass secondClass thirdClass") "TEST"
                        state <- mountHtml html
                        nodeClass <- getSvgClass "svg"
                        TUA.equal (Just "first-class second-class third-class") nodeClass

                        let updatedHtml = HE.svg (HA.class' {firstClass: false}) "TEST"
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        updatedNodeClass <- getSvgClass "svg"
                        TUA.equal (Just "") updatedNodeClass

                        let emptyUpdatedHtml = HE.svg (HA.class' "") "TEST"
                        void <<< liftEffect $ FRID.resume state emptyUpdatedHtml
                        emptyUpdatedNodeClass <- getSvgClass "svg"
                        TUA.equal (Just "") emptyUpdatedNodeClass

                        let fullUpdatedHtml = HE.svg (HA.class' {some: true, some2: true }) "TEST"
                        void <<< liftEffect $ FRID.resume state fullUpdatedHtml
                        fullNodeClass <- getSvgClass "svg"
                        TUA.equal (Just "some some2") fullNodeClass

                  test "attributes" do
                        let html = HE.input [HA.id "t", HA.href "e.com", HA.max "oi"]
                        state <- mountHtml html
                        nodeAttributes <- getAttributes "#t"
                        TUA.equal "id:t href:e.com max:oi" nodeAttributes

                        let updatedHtml = HE.input [HA.id "t", HA.href "e.com", HA.min "ola", HA.ping "pong"]
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        updatedNodeAttributes <- getAttributes "#t"
                        TUA.equal "id:t href:e.com min:ola ping:pong" updatedNodeAttributes

                        let emptyUpdatedHtml = HE.input [HA.id "t"]
                        void <<< liftEffect $ FRID.resume state emptyUpdatedHtml
                        emptyUpdatedNodeAttributes <- getAttributes "#t"
                        -- id is a property
                        TUA.equal "id:t" emptyUpdatedNodeAttributes

                        let fullUpdatedHtml = HE.input [HA.id "t", HA.href "e.com", HA.min "ola", HA.ping "pong"]
                        void <<< liftEffect $ FRID.resume state fullUpdatedHtml
                        fullNodeAttributes <- getAttributes "#t"
                        TUA.equal "id:t href:e.com min:ola ping:pong" fullNodeAttributes

                  test "presential attributes" do
                        let html = HE.input [HA.id "t", HA.type' "checkbox", HA.disabled true, HA.autofocus true]
                        state <- mountHtml html
                        nodeAttributes <- getAttributes "input"
                        TUA.equal "id:t type:checkbox disabled: autofocus:" nodeAttributes

                        let updatedHtml = HE.input [HA.id "t", HA.type' "checkbox", HA.disabled false, HA.autofocus true]
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        updatedNodeAttributes <- getAttributes "input"
                        TUA.equal "id:t type:checkbox autofocus:" updatedNodeAttributes

                  test "properties" do
                        let html = HE.input [HA.id "t", HA.value "a"]
                        state <- mountHtml html
                        nodeProperties <- getProperties "input" ["id", "value"]
                        TUA.equal ["t", "a"] nodeProperties

                        let updatedHtml = HE.input [HA.id "q", HA.pattern "aaa"]
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        --should not remove properties
                        updatedNodeProperties <- getProperties "input" ["id", "pattern"]
                        TUA.equal ["q", "aaa"] updatedNodeProperties

            suite "dom node update" do
                  test "update text nodes" do
                        let html = HE.text "oi"
                        state <- mountHtml html
                        let updatedHtml = HE.text "ola"
                        text <- textContent "#mount-point"
                        TUA.equal "oi" text

                        void <<< liftEffect $ FRID.resume state updatedHtml
                        updatedText <- textContent "#mount-point"
                        TUA.equal "ola" updatedText

                  test "update node tag" do
                        let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                        state <- mountHtml html
                        let updatedHtml = HE.span (HA.class' "test-class") $ HE.input [HA.id "t", HA.value "a"]
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        oldElement <- liftEffect $ FAD.querySelector "#test-div"
                        TUA.assert "removed node" $ DM.isNothing oldElement
                        nodeClass <- getClass "span.test-class"
                        TUA.equal "test-class" nodeClass

                  test "update node type" do
                        let html = HE.div "test-div" $ HE.input [HA.id "t", HA.value "a"]
                        state <- mountHtml html
                        let updatedHtml = HE.svg' (HA.viewBox "0 0 0 0")
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        oldElement <- liftEffect $ FAD.querySelector "#test-div"
                        TUA.assert "removed node" $ DM.isNothing oldElement
                        nodeAttributes <- getAttributes "svg"
                        TUA.equal "viewBox:0 0 0 0" nodeAttributes

                  test "inserting children" do
                        let html = HE.div' "test-div"
                        state <- mountHtml html
                        let updatedHtml = HE.div "test-div" [HE.br, HE.hr]
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        childrenCount <- childrenNodeLengthOf "#test-div"
                        TUA.equal 2 childrenCount

                  test "removing children" do
                        let html = HE.div "test-div" [HE.br, HE.hr]
                        state <- mountHtml html
                        let updatedHtml = HE.div' "test-div"
                        void <<< liftEffect $ FRID.resume state updatedHtml
                        childrenCount <- childrenNodeLengthOf "#test-div"
                        TUA.equal 0 childrenCount

                  --test "fragments"
                  --test "conditional elements"
                  --test "setting inner html"

            suite "diff" do
                  test "updates record fields" do
                        TUA.equal { a: 23, b: "hello", c: true } $ FAE.diff' {c: true} { a : 23, b: "hello", c: false }
                        TUA.equal { a: 23, b: "hello", c: false } $ FAE.diff' {} { a : 23, b: "hello", c: false }

                  test "updates record fields with newtype" do
                        TUA.equal (TestNewtype { a: 23, b: "hello", c: true }) <<< FAE.diff' {c: true} $ TestNewtype { a : 23, b: "hello", c: false }
                        TUA.equal (TestNewtype { a: 23, b: "hello", c: false }) <<< FAE.diff' {} $ TestNewtype { a : 23, b: "hello", c: false }

                  test "updates record fields with functor" do
                        TUA.equal (Just { a: 23, b: "hello", c: true }) <<< FAE.diff' {c: true} $ Just { a : 23, b: "hello", c: false }
                        TUA.equal (Just { a: 23, b: "hello", c: false }) <<< FAE.diff' {} $ Just { a : 23, b: "hello", c: false }

                  test "new copy is returned" do
                        --since diff uses unsafe javascript, make sure the reference is not being written to
                        let model = { a: 1, b: 2}
                        TUA.equal { a: 1, b: 3 } $ FAE.diff' { b: 3 } model
                        TUA.equal { a: 12, b: 2 } $ FAE.diff' { a: 12 } model

--       -- --       suite "Basic test applications" do
--                         --test "events"
--       -- --             test "noeffects" do
--       -- --                   liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TBN.mount
--       -- --                   childrenLength <- childrenNodeLength
--       -- --                   --button, span, button
--       -- --                   TUA.equal 3 childrenLength

--       -- --                   initial <- textContent "#text-output"
--       -- --                   TUA.equal "0" initial

--       -- --                   dispatchEvent clickEvent "#decrement-button"
--       -- --                   current <- textContent "#text-output"
--       -- --                   TUA.equal "-1" current

--       -- --                   dispatchEvent clickEvent "#increment-button"
--       -- --                   dispatchEvent clickEvent "#increment-button"
--       -- --                   current2 <- textContent "#text-output"
--       -- --                   TUA.equal "1" current2

--       -- --             test "effectlist" do
--       -- --                   liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TBEL.mount
--       -- --                   childrenLength <- childrenNodeLength
--       -- --                   --span, input, input
--       -- --                   TUA.equal 3 childrenLength

--       -- --                   let     setInput text = liftEffect do
--       -- --                               element <- unsafeQuerySelector "#text-input"
--       -- --                               WHH.setValue text $ unsafePartial (DM.fromJust $ WHH.fromElement element)
--       -- --                   initial <- textContent "#text-output"
--       -- --                   TUA.equal "" initial

--       -- --                   dispatchEvent clickEvent "#cut-button"
--       -- --                   current <- textContent "#text-output"
--       -- --                   TUA.equal "" current

--       -- --                   setInput "test"
--       -- --                   dispatchEvent inputEvent "#text-input"
--       -- --                   dispatchEvent clickEvent "#cut-button"
--       -- --                   cut <- textContent "#text-output"
--       -- --                   --always remove at least one character
--       -- --                   TUA.assert "cut text" $ DSC.length cut < 4

--       -- --                   dispatchEvent inputEvent "#text-input"
--       -- --                   dispatchEvent enterPressedEvent "#text-input"
--       -- --                   submitted <- textContent "#text-output"
--       -- --                   TUA.equal "thanks" submitted

--       -- --             test "effectful" do
--       -- --                   liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TBE.mount
--       -- --                   childrenLength <- childrenNodeLength
--       -- --                   --span, span, span, br, button, button
--       -- --                   TUA.equal 6 childrenLength

--       -- --                   currentIncrement <- textContent "#text-output-increment"
--       -- --                   currentDecrement <- textContent "#text-output-decrement"
--       -- --                   currentLuckyNumber <- textContent "#text-output-lucky-number"
--       -- --                   TUA.equal "-1" currentDecrement
--       -- --                   TUA.equal "0" currentIncrement
--       -- --                   TUA.equal "2" currentLuckyNumber

--       -- --                   dispatchEvent clickEvent "#decrement-button"
--       -- --                   currentIncrement2 <- textContent "#text-output-increment"
--       -- --                   currentDecrement2 <- textContent "#text-output-decrement"
--       -- --                   currentLuckyNumber2 <- textContent "#text-output-lucky-number"
--       -- --                   TUA.equal "-2" currentDecrement2
--       -- --                   TUA.equal "0" currentIncrement2
--       -- --                   TUA.equal "2" currentLuckyNumber2

--       -- --                   dispatchEvent clickEvent "#increment-button"
--       -- --                   dispatchEvent clickEvent "#increment-button"
--       -- --                   currentIncrement3 <- textContent "#text-output-increment"
--       -- --                   currentDecrement3 <- textContent "#text-output-decrement"
--       -- --                   currentLuckyNumber3 <- textContent "#text-output-lucky-number"
--       -- --                   TUA.equal "2" currentIncrement3
--       -- --                   TUA.equal "-2" currentDecrement3
--       -- --                   TUA.equal "2" currentLuckyNumber3

--       -- --       suite "Effectful specific" do
--       -- --             test "slower effects" do
--       -- --                   liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TES.mount
--       -- --                   outputCurrent <- textContent "#text-output-current"
--       -- --                   outputNumbers <- textContent "#text-output-numbers"
--       -- --                   TUA.equal "0" outputCurrent
--       -- --                   TUA.equal "[]" outputNumbers

--       -- --                   --the event for snoc has a delay, make sure it doesnt overwrite unrelated fields when updating
--       -- --                   dispatchEvent clickEvent "#snoc-button"
--       -- --                   dispatchEvent clickEvent "#bump-button"
--       -- --                   outputCurrent2 <- textContent "#text-output-current"
--       -- --                   outputNumbers2 <- textContent "#text-output-numbers"
--       -- --                   TUA.equal "1" outputCurrent2
--       -- --                   TUA.equal "[]" outputNumbers2

--       -- --                   AF.delay $ Milliseconds 4000.0
--       -- --                   outputCurrent3 <- textContent "#text-output-current"
--       -- --                   outputNumbers3 <- textContent "#text-output-numbers"
--       -- --                   TUA.equal "2" outputCurrent3
--       -- --                   TUA.equal "[0]" outputNumbers3

--       -- --       suite "Custom events test applications" do
--       -- --             test "noeffects" do
--       -- --                   liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TEN.mount
--       -- --                   output <- textContent "#text-output"
--       -- --                   TUA.equal "0" output

--       -- --                   dispatchDocumentEvent clickEvent
--       -- --                   output2 <- textContent "#text-output"
--       -- --                   TUA.equal "-1" output2

--       -- --                   dispatchDocumentEvent keydownEvent
--       -- --                   dispatchDocumentEvent keydownEvent
--       -- --                   dispatchDocumentEvent keydownEvent
--       -- --                   output3 <- textContent "#text-output"
--       -- --                   TUA.equal "2" output3

--       -- --             test "effectlist" do
--       -- --                   channel <- liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TEEL.mount
--       -- --                   output <- textContent "#text-output"
--       -- --                   TUA.equal "0" output

--       -- --                   liftEffect $ SC.send channel [TEELDecrement]
--       -- --                   output2 <- textContent "#text-output"
--       -- --                   TUA.equal "-1" output2

--       -- --                   liftEffect $ SC.send channel [TEELIncrement]
--       -- --                   output3 <- textContent "#text-output"
--       -- --                   TUA.equal "0" output3

--       -- --             test "effectful" do
--       -- --                   liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TEE.mount
--       -- --                   output <- textContent "#text-output"
--       -- --                   TUA.equal "5" output

--       -- --                   dispatchWindowEvent errorEvent
--       -- --                   dispatchWindowEvent errorEvent
--       -- --                   dispatchWindowEvent errorEvent
--       -- --                   output2 <- textContent "#text-output"
--       -- --                   TUA.equal "2" output2

--       -- --                   dispatchWindowEvent offlineEvent
--       -- --                   output3 <- textContent "#text-output"
--       -- --                   TUA.equal "3" output3

--       -- --       suite "Server side rendering" do
--       -- --             test "effectful" do
--       -- --                   liftEffect do
--       -- --                         unsafeCreateEnviroment
--       -- --                         TSE.preMount
--       -- --                   childrenLength <- childrenNodeLengthOf "#mount-point"
--       -- --                   TUA.equal 1 childrenLength

--       -- --                   childrenLength2 <- childrenNodeLength
--       -- --                   initial <- textContent "#text-output"
--       -- --                   TUA.equal 4 childrenLength2
--       -- --                   TUA.equal "2" initial

--       -- --                   liftEffect TSE.mount
--       -- --                   childrenLength3 <- childrenNodeLength
--       -- --                   initial2 <- textContent "#text-output"
--       -- --                   TUA.equal 4 childrenLength3
--       -- --                   TUA.equal "2" initial2

--       -- --                   dispatchEvent clickEvent "#increment-button"
--       -- --                   current <- textContent "#text-output"
--       -- --                   TUA.equal "3" current

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
                  mountPoint <- unsafeQuerySelector selector
                  children <- WDP.children $ WDE.toParentNode mountPoint
                  WDH.length children

            textContent selector = liftEffect do
                  element <- unsafeQuerySelector selector
                  WDN.textContent $ WDE.toNode element

--       -- --       isChecked selector = liftEffect do
--       -- --             element <- unsafeQuerySelector selector
--       -- --             WHH.checked $ PU.unsafePartial $ DM.fromJust $ WHH.fromElement element

--       -- --       isDisabled selector = liftEffect do
--       -- --             element <- unsafeQuerySelector selector
--       -- --             WHH.disabled $ PU.unsafePartial $ DM.fromJust $ WHH.fromElement element

--       -- --       dispatchEvent eventFunction selector = liftEffect $ void do
--       -- --             element <- unsafeQuerySelector selector
--       -- --             event <- eventFunction
--       -- --             WEE.dispatchEvent event $ WDE.toEventTarget element

--       -- --       dispatchDocumentEvent eventFunction = liftEffect $ void do
--       -- --             window <- WH.window
--       -- --             document <- WHW.document window
--       -- --             event <- eventFunction
--       -- --             WEE.dispatchEvent event $ WDD.toEventTarget document

--       -- --       dispatchWindowEvent eventFunction = liftEffect $ void do
--       -- --             window <- WH.window
--       -- --             event <- eventFunction
--       -- --             WEE.dispatchEvent event $ WHW.toEventTarget window

newtype TestNewtype = TestNewtype { a :: Int, b :: String, c :: Boolean }

derive instance genericTestNewtype :: Generic TestNewtype _
derive instance newtypeTestNewtype :: Newtype TestNewtype _
derive instance eqTestNewtype :: Eq TestNewtype
instance showTestNewtype :: Show TestNewtype where
      show = DGRS.genericShow