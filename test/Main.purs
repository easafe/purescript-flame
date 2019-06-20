module Test.Main where

import Prelude

import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.String.CodeUnits as DS
import Data.Traversable as DF
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Flame.Application.DOM as FD
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Renderer.String as HS
import Partial.Unsafe (unsafePartial)
import Signal.Channel as SC
import Test.Basic.EffectList as TBEL
import Test.Basic.Effectful as TBE
import Test.Basic.NoEffects as TBN
import Test.External.Effectful as TEE
import Test.External.NoEffects as TEN
import Test.External.EffectList as TEEL
import Test.External.EffectList (TEELMessage(..))
import Test.Unit (suite, test)
import Test.Unit.Assert as TUA
import Test.Unit.Main (runTest)
import Test.World.Effectful (TWEMessage(..), TWEModel(..), einit)
import Test.World.Effectful as TWE
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
foreign import errorEvent :: Effect Event
foreign import offlineEvent :: Effect Event

main :: Effect Unit
main =
        runTest do
                suite "VNode creation" do
                        test "ToHtml instances" do
                                let html = HE.a [HA.id "test"] [HE.text "TEST"]
                                html' <- liftEffect $ HS.render html
                                TUA.equal """<a id="test">TEST</a>""" html'

                                let html2 = HE.a (HA.id "test") [HE.text "TEST"]
                                html2' <- liftEffect $ HS.render html2
                                TUA.equal """<a id="test">TEST</a>""" html2'

                                let html3 = HE.a "test" [HE.text "TEST"]
                                html3' <- liftEffect $ HS.render html3
                                TUA.equal """<a id="test">TEST</a>""" html3'

                                let html4 = HE.a "test" $ HE.text "TEST"
                                html4' <- liftEffect $ HS.render html4
                                TUA.equal """<a id="test">TEST</a>""" html4'

                                let html5 = HE.a "test" "TEST"
                                html5' <- liftEffect $ HS.render html5
                                TUA.equal """<a id="test">TEST</a>""" html5'

                        test "ToClassList instances" do
                                let html = HE.a [HA.class' "test"] [HE.text "TEST"]
                                html' <- liftEffect $ HS.render html
                                TUA.equal """<a class="test">TEST</a>""" html'

                                let html2 = HE.a [HA.class' { "test": false, "test2": true, "test3": true }] [HE.text "TEST"]
                                html2' <- liftEffect $ HS.render html2
                                TUA.equal """<a class="test2 test3">TEST</a>""" html2'

                        test "inline style" do
                                let html = HE.a (HA.style { mystyle: "test" }) [HE.text "TEST"]
                                html' <- liftEffect $ HS.render html
                                TUA.equal """<a style="mystyle:test">TEST</a>""" html'

                                let html2 = HE.a [HA.style { width: "23px", display: "none" }] [HE.text "TEST"]
                                html2' <- liftEffect $ HS.render html2
                                TUA.equal """<a style="width:23px;display:none">TEST</a>""" html2'

                        test "style/class name case" do
                                html <- liftEffect <<< HS.render $ HE.createElement' "element" $ HA.class' "superClass"
                                TUA.equal """<element class="super-class"></element>""" html

                                html2 <- liftEffect <<< HS.render $ HE.createElement' "element" $ HA.class' "SuperClass"
                                TUA.equal """<element class="super-class"></element>""" html2

                                html3 <- liftEffect <<< HS.render $ HE.createElement' "element" $ HA.class' "MySuperClass my-other-class"
                                TUA.equal """<element class="my-super-class my-other-class"></element>""" html3

                                html4 <- liftEffect <<< HS.render $ HE.createElement' "element" $ HA.class' "SUPERCLASS"
                                TUA.equal """<element class="superclass"></element>""" html4

                                html5 <- liftEffect <<< HS.render $ HE.createElement' "element" $ HA.style { borderBox : "23", s : "34", borderLeftTopRadius : "20px"}
                                TUA.equal """<element style="border-box:23;s:34;border-left-top-radius:20px"></element>""" html5

                                html6 <- liftEffect <<< HS.render $ HE.createElement' "element" $ HA.class' { borderBox : true, s : false, borderLeftTopRadius : true}
                                TUA.equal """<element class="border-box border-left-top-radius"></element>""" html6

                        test "custom elements" do
                                let html = HE.createElement' "custom-element" "test"
                                html' <- liftEffect $ HS.render html
                                TUA.equal """<custom-element id="test"></custom-element>""" html'

                                let html2 = HE.createElement' "custom-element" "test"
                                html2' <- liftEffect $ HS.render html2
                                TUA.equal """<custom-element id="test"></custom-element>""" html2'

                                let html3 = HE.createElement_ "custom-element" "test"
                                html3' <- liftEffect $ HS.render html3
                                TUA.equal """<custom-element>test</custom-element>""" html3'

                        test "properties" do
                                let html = HE.a [HA.disabled true] [HE.text "TEST"]
                                html' <- liftEffect $ HS.render html
                                TUA.equal """<a disabled="disabled">TEST</a>""" html'

                                let html2 = HE.a [HA.disabled false] [HE.text "TEST"]
                                html2' <- liftEffect $ HS.render html2
                                TUA.equal """<a>TEST</a>""" html2'

                                let html3 = HE.a [HA.createProperty "test-prop" true] [HE.text "TEST"]
                                html3' <- liftEffect $ HS.render html3
                                TUA.equal """<a test-prop="test-prop">TEST</a>""" html3'

                                let html4 = HE.a [HA.createProperty "test-prop" false] [HE.text "TEST"]
                                html4' <- liftEffect $ HS.render html4
                                TUA.equal """<a>TEST</a>""" html4'

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
                                html' <- liftEffect $ HS.render html
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
                                html' <- liftEffect $ HS.render html
                                TUA.equal """<html lang="en"><head><title>title</title></head><body id="content"><main><button style="display:block;width:20px">-</button><br>Test<button my-attribute="myValue">+</button><hr style="border:200px solid blue"><div><div><span><a>here</a></span></div></div></main></body></html>""" html'

                        test "nested elements with properties and attributes" do
                                let html = HE.html [HA.lang "en"] [
                                        HE.head [HA.disabled true] [HE.title "title"],
                                        HE.body "content" [
                                                HE.main_ [
                                                        HE.button (HA.style { display: "block", width: "20px"}) "-",
                                                        HE.br,
                                                        HE.text "Test",
                                                        HE.button (HA.createAttribute "my-attribute" "myValue") "+",
                                                        HE.hr' [HA.autocomplete false, HA.style { border: "200px solid blue"}] ,
                                                        HE.div_ $ HE.div_ [
                                                                HE.span_ [ HE.a [HA.autofocus true] "here" ]
                                                        ]
                                                ]
                                        ]
                                ]
                                html' <- liftEffect $ HS.render html
                                TUA.equal """<html lang="en"><head disabled="disabled"><title>title</title></head><body id="content"><main><button style="display:block;width:20px">-</button><br>Test<button my-attribute="myValue">+</button><hr style="border:200px solid blue"><div><div><span><a autofocus="autofocus">here</a></span></div></div></main></body></html>""" html'

                        test "events" do
                                let html = HE.a [HA.onClick unit, HA.onInput (const unit)] [HE.text "TEST"]
                                html' <- liftEffect $ HS.render html
                                --events are part of virtual dom data and do not show up on the rendered markup
                                TUA.equal """<a>TEST</a>""" html'
                suite "Basic test applications" do
                        test "noeffects" do
                                liftEffect $ do
                                        unsafeCreateEnviroment
                                        TBN.mount
                                childrenLength <- childrenNodeLength
                                --button, span, button
                                TUA.equal 3 childrenLength

                                initial <- textContent "#text-output"
                                TUA.equal "0" initial

                                dispatchEvent clickEvent "#decrement-button"
                                current <- textContent "#text-output"
                                TUA.equal "-1" current

                                dispatchEvent clickEvent "#increment-button"
                                dispatchEvent clickEvent "#increment-button"
                                current2 <- textContent "#text-output"
                                TUA.equal "1" current2
                        test "effectlist" do
                                liftEffect $ do
                                        unsafeCreateEnviroment
                                        TBEL.mount
                                childrenLength <- childrenNodeLength
                                --span, input, input
                                TUA.equal 3 childrenLength

                                let     setInput text = liftEffect $ do
                                                element <- unsafeQuerySelector "#text-input"
                                                WHH.setValue text $ unsafePartial (DM.fromJust $ WHH.fromElement element)
                                initial <- textContent "#text-output"
                                TUA.equal "" initial

                                dispatchEvent clickEvent "#cut-button"
                                current <- textContent "#text-output"
                                TUA.equal "" current

                                setInput "test"
                                dispatchEvent inputEvent "#text-input"
                                dispatchEvent clickEvent "#cut-button"
                                cut <- textContent "#text-output"
                                --always remove at least one character
                                TUA.assert "cut text" $ DS.length cut < 4
                        test "effectful" do
                                liftEffect $ do
                                        unsafeCreateEnviroment
                                        TBE.mount
                                childrenLength <- childrenNodeLength
                                --span, span, span, br, button, button
                                TUA.equal 6 childrenLength

                                currentIncrement <- textContent "#text-output-increment"
                                currentDecrement <- textContent "#text-output-decrement"
                                currentLuckyNumber <- textContent "#text-output-lucky-number"
                                TUA.equal "-1" currentDecrement
                                TUA.equal "0" currentIncrement
                                TUA.equal "2" currentLuckyNumber

                                dispatchEvent clickEvent "#decrement-button"
                                currentIncrement2 <- textContent "#text-output-increment"
                                currentDecrement2 <- textContent "#text-output-decrement"
                                currentLuckyNumber2 <- textContent "#text-output-lucky-number"
                                TUA.equal "-2" currentDecrement2
                                TUA.equal "0" currentIncrement2
                                TUA.equal "2" currentLuckyNumber2

                                dispatchEvent clickEvent "#increment-button"
                                dispatchEvent clickEvent "#increment-button"
                                currentIncrement3 <- textContent "#text-output-increment"
                                currentDecrement3 <- textContent "#text-output-decrement"
                                currentLuckyNumber3 <- textContent "#text-output-lucky-number"
                                TUA.equal "2" currentIncrement3
                                TUA.equal "-2" currentDecrement3
                                TUA.equal "2" currentLuckyNumber3
                suite "World parameter test application" do
                        test "effectful" do
                                liftEffect $ do
                                        unsafeCreateEnviroment
                                        TWE.mount
                                let     ids = ["#times-span", "#previous-messages-span", "#previous-model-span"]
                                        getSpans = unsafePartial \sp@[times, previousMessages, previousModel] -> sp
                                spans <- textContentAll ids
                                equalAll ["1", show [Nothing, Just TWEDecrement], show (Nothing :: Maybe TWEModel)] $ getSpans spans
                                dispatchEvent clickEvent "#increment-button"
                                spans2 <- textContentAll ids
                                equalAll ["2", show [Nothing, Just TWEDecrement, Just TWEDecrement, Just TWEIncrement], show $ Just einit] $ getSpans spans2
                                dispatchEvent clickEvent "#increment-button"
                                spans3 <- textContentAll ids
                                equalAll ["3", show [Nothing, Just TWEDecrement, Just TWEDecrement, Just TWEIncrement, Just TWEIncrement, Just TWEIncrement], show <<< Just $ TWEModel { previousMessages: [Nothing,(Just TWEDecrement)], previousModel: Nothing, times: 1 } ] $ getSpans spans3
                suite "custom events test applications" do
                        test "noeffects" do
                                liftEffect $ do
                                        unsafeCreateEnviroment
                                        TEN.mount
                                output <- textContent "#text-output"
                                TUA.equal "0" output

                                dispatchDocumentEvent clickEvent
                                output2 <- textContent "#text-output"
                                TUA.equal "-1" output2

                                dispatchDocumentEvent keydownEvent
                                dispatchDocumentEvent keydownEvent
                                dispatchDocumentEvent keydownEvent
                                output3 <- textContent "#text-output"
                                TUA.equal "2" output3
                        test "effectlist" do
                                channel <- liftEffect $ do
                                        unsafeCreateEnviroment
                                        TEEL.mount
                                output <- textContent "#text-output"
                                TUA.equal "0" output

                                liftEffect $ SC.send channel [TEELDecrement]
                                output2 <- textContent "#text-output"
                                TUA.equal "-1" output2

                                liftEffect $ SC.send channel [TEELIncrement]
                                output3 <- textContent "#text-output"
                                TUA.equal "0" output3
                        test "effectful" do
                                liftEffect $ do
                                        unsafeCreateEnviroment
                                        TEE.mount
                                output <- textContent "#text-output"
                                TUA.equal "5" output

                                dispatchWindowEvent errorEvent
                                dispatchWindowEvent errorEvent
                                dispatchWindowEvent errorEvent
                                output2 <- textContent "#text-output"
                                TUA.equal "2" output2

                                dispatchWindowEvent offlineEvent
                                output3 <- textContent "#text-output"
                                TUA.equal "3" output3
        where   unsafeQuerySelector selector = unsafePartial (DM.fromJust <$> FD.querySelector selector)

                childrenNodeLength = liftEffect $ do
                        mountPoint <- unsafeQuerySelector "main"
                        children <- WDP.children $ WDE.toParentNode mountPoint
                        WDH.length children

                textContentAll = DF.traverse textContent

                equalAll expected = DF.traverse_ (\(Tuple a b) -> TUA.equal a b) <<< DA.zip expected

                textContent selector = liftEffect $ do
                        element <- unsafeQuerySelector selector
                        WDN.textContent $ WDE.toNode element

                dispatchEvent eventFunction selector = liftEffect $ do
                        element <- unsafeQuerySelector selector
                        event <- eventFunction
                        _ <- WEE.dispatchEvent event $ WDE.toEventTarget element
                        pure unit

                dispatchDocumentEvent eventFunction = liftEffect $ do
                        window <- WH.window
                        document <- WHW.document window
                        event <- eventFunction
                        _ <- WEE.dispatchEvent event $ WDD.toEventTarget document
                        pure unit

                dispatchWindowEvent eventFunction = liftEffect $ do
                        window <- WH.window
                        event <- eventFunction
                        _ <- WEE.dispatchEvent event $ WHW.toEventTarget window
                        pure unit

