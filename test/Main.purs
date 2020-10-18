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
import Flame.Application.DOM as FAD
import Flame.Application.Effectful as FAE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Renderer.String as FRS
import Partial.Unsafe (unsafePartial)
import Partial.Unsafe as PU
import Signal.Channel as SC
import Test.Basic.ContentEditable as TBC
import Test.Basic.EffectList as TBEL
import Test.Basic.Effectful as TBE
import Test.Basic.NoEffects as TBN
import Test.Basic.PresentialAttributes as TBPA
import Test.Effectful.SlowEffects as TES
import Test.External.EffectList (TEELMessage(..))
import Test.External.EffectList as TEEL
import Test.External.Effectful as TEE
import Test.External.NoEffects as TEN
import Test.SVG.NoEffects as TSN
import Test.ServerSideRendering.Effectful as TSE
import Test.TextContent.NoEffects as TTN
import Test.Unit (suite, test)
import Test.Unit.Assert as TUA
import Test.Unit.Main (runTest)
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

main :: Effect Unit
main =
        runTest do
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

                                let html2 = HE.a [HA.class' { "test": false, "test2": true, "test3": true }] [HE.text "TEST"]
                                html2' <- liftEffect $ FRS.render html2
                                TUA.equal """<a class="test2 test3">TEST</a>""" html2'

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

                        test "key data property is not part of the dom" do
                                let html = HE.div (HA.key "23") "oi"
                                html' <- liftEffect $ FRS.render html
                                TUA.equal """<div>oi</div>""" html'

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
                                                HE.main_ [
                                                        HE.button (HA.style { display: "block", width: "20px"}) "-",
                                                        HE.br,
                                                        HE.text "Test",
                                                        HE.button (HA.createAttribute "my-attribute" "myValue") "+",
                                                        HE.hr' [HA.autocomplete "off", HA.style { border: "200px solid blue"}] ,
                                                        HE.div_ $ HE.div_ [
                                                                HE.span_ [ HE.a [HA.autofocus true] "here" ]
                                                        ]
                                                ]
                                        ]
                                ]
                                html' <- liftEffect $ FRS.render html
                                TUA.equal """<html lang="en"><head disabled="true"><title>title</title></head><body id="content"><main><button style="display: block; width: 20px">-</button><br>Test<button my-attribute="myValue">+</button><hr autocomplete="off" style="border: 200px solid blue"><div><div><span><a autofocus="true">here</a></span></div></div></main></body></html>""" html'

                        test "events" do
                                let html = HE.a [HA.onClick unit, HA.onInput (const unit)] [HE.text "TEST"]
                                html' <- liftEffect $ FRS.render html
                                --events are part of virtual dom data and do not show up on the rendered markup
                                TUA.equal """<a>TEST</a>""" html'
                suite "show" do
                        test "simple element" do
                                let html = HE.div [HA.id "1"] [HE.text "T"]
                                TUA.equal """(Node div [(Property id 1)] [(Text T)])""" $ show $ html
                        test "events do not matter" do
                                let html = HE.div [HA.id "1", HA.onClick "Test"] [HE.text "T"]
                                TUA.equal """(Node div [(Property id 1)] [(Text T)])""" $ show $ html
                        test "element with childs" do
                                let html = HE.div_ [HE.div_ [HE.br]]
                                TUA.equal """(Node div [] [(Node div [] [(Node br [] [])])])""" $ show $ html
                suite "eq" do
                        test "simple element" do
                                TUA.equal' "equal html" (HE.div [HA.id "1"] [HE.text "T"]) (HE.div [HA.id "1"] [HE.text "T"])
                                TUA.assert "diffent property" $ (HE.div [HA.id "1"] [HE.text "T"]) /= (HE.div [HA.id "2"] [HE.text "T"])
                        test "events do not matter" do
                                TUA.equal' "equal html" (HE.div [HA.id "1", HA.onClick unit] [HE.text "T"]) (HE.div [HA.id "1"] [HE.text "T"])
                        test "property order does not matter" do
                                TUA.assert "should equal" $
                                        (HE.div [HA.class' "test", HA.id "1"] [HE.text "T"]) == (HE.div [HA.id "1", HA.class' "test"] [HE.text "T"])
                        test "child order does matter" do
                                TUA.assert "should not equal" $
                                        (HE.div_ [HE.text "T", HE.br]) /= (HE.div_ [HE.br, HE.text "T"])

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

                suite "Basic test applications" do
                        test "noeffects" do
                                liftEffect do
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
                                liftEffect do
                                        unsafeCreateEnviroment
                                        TBEL.mount
                                childrenLength <- childrenNodeLength
                                --span, input, input
                                TUA.equal 3 childrenLength

                                let     setInput text = liftEffect do
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
                                TUA.assert "cut text" $ DSC.length cut < 4

                                dispatchEvent inputEvent "#text-input"
                                dispatchEvent enterPressedEvent "#text-input"
                                submitted <- textContent "#text-output"
                                TUA.equal "thanks" submitted

                        test "effectful" do
                                liftEffect do
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

                        test "presential attributes" do
                                liftEffect do
                                        unsafeCreateEnviroment
                                        TBPA.mount
                                childrenLength <- childrenNodeLength
                                --button, input, button
                                TUA.equal 3 childrenLength

                                initialChecked <- isChecked "#checkbox"
                                initialDisabled <- isDisabled "#checkbox"
                                TUA.equal true initialChecked
                                TUA.equal false initialDisabled

                                dispatchEvent clickEvent "#increment-button"
                                currentChecked <- isChecked "#checkbox"
                                currentDisabled <- isDisabled "#checkbox"
                                TUA.equal false currentChecked
                                TUA.equal true currentDisabled

                                dispatchEvent clickEvent "#increment-button"
                                currentNewChecked <- isChecked "#checkbox"
                                currentNewDisabled <- isDisabled "#checkbox"
                                TUA.equal false currentNewChecked
                                TUA.equal false currentNewDisabled

                        test "contentEditable" do
                                --contentEditable is not supported by jsdom
                                liftEffect do
                                        unsafeCreateEnviroment
                                        TBC.mount
                                childrenLength <- childrenNodeLength
                                TUA.equal 3 childrenLength

                                initialOutput <- textContent "#text-output"
                                TUA.equal "start" initialOutput

                                dispatchEvent inputEvent "#content-div"
                                currentOutput <- textContent "#text-output"
                                TUA.equal "" currentOutput

                                dispatchEvent inputEvent "#content-select"
                                currentOutput2 <- textContent "#text-output"
                                TUA.equal "2" currentOutput2

                suite "Effectful specific" do
                        test "slower effects" do
                                liftEffect do
                                        unsafeCreateEnviroment
                                        TES.mount
                                outputCurrent <- textContent "#text-output-current"
                                outputNumbers <- textContent "#text-output-numbers"
                                TUA.equal "0" outputCurrent
                                TUA.equal "[]" outputNumbers

                                --the event for snoc has a delay, make sure it doesnt overwrite unrelated fields when updating
                                dispatchEvent clickEvent "#snoc-button"
                                dispatchEvent clickEvent "#bump-button"
                                outputCurrent2 <- textContent "#text-output-current"
                                outputNumbers2 <- textContent "#text-output-numbers"
                                TUA.equal "1" outputCurrent2
                                TUA.equal "[]" outputNumbers2

                                AF.delay $ Milliseconds 4000.0
                                outputCurrent3 <- textContent "#text-output-current"
                                outputNumbers3 <- textContent "#text-output-numbers"
                                TUA.equal "2" outputCurrent3
                                TUA.equal "[0]" outputNumbers3

                suite "Custom events test applications" do
                        test "noeffects" do
                                liftEffect do
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
                                channel <- liftEffect do
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
                                liftEffect do
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

                suite "Text content views" do
                        test "no effects" do
                                liftEffect do
                                        unsafeCreateEnviroment
                                        TTN.mount
                                childrenLength <- childrenNodeLengthOf "#mount-point"
                                TUA.equal 0 childrenLength

                                dispatchDocumentEvent clickEvent
                                childrenLength2 <- childrenNodeLength
                                TUA.equal 3 childrenLength2

                                dispatchWindowEvent offlineEvent
                                childrenLength3 <- childrenNodeLength
                                TUA.equal 0 childrenLength3

                suite "Server side rendering" do
                        test "effectful" do
                                liftEffect do
                                        unsafeCreateEnviroment
                                        TSE.preMount
                                childrenLength <- childrenNodeLengthOf "#mount-point"
                                TUA.equal 1 childrenLength

                                childrenLength2 <- childrenNodeLength
                                initial <- textContent "#text-output"
                                TUA.equal 4 childrenLength2
                                TUA.equal "2" initial

                                liftEffect TSE.mount
                                childrenLength3 <- childrenNodeLength
                                initial2 <- textContent "#text-output"
                                TUA.equal 4 childrenLength3
                                TUA.equal "2" initial2

                                dispatchEvent clickEvent "#increment-button"
                                current <- textContent "#text-output"
                                TUA.equal "3" current

                suite "SVG" do
                        test "noeffects" do
                                liftEffect do
                                        unsafeCreateEnviroment
                                        TSN.mount
                                dispatchEvent clickEvent "#decrement-button"
                                dispatchEvent clickEvent "#increment-button"
                                dispatchEvent clickEvent "#increment-button"
                                --we are only interested that updating a svg attr (e.g. viewBox) doesn't fail
                                liftEffect <<< void $ unsafeQuerySelector """svg circle[cx="1"]"""

        where   unsafeQuerySelector selector = unsafePartial (DM.fromJust <$> FAD.querySelector selector)

                childrenNodeLength = childrenNodeLengthOf "main"

                childrenNodeLengthOf selector = liftEffect do
                        mountPoint <- unsafeQuerySelector selector
                        children <- WDP.children $ WDE.toParentNode mountPoint
                        WDH.length children

                textContent selector = liftEffect do
                        element <- unsafeQuerySelector selector
                        WDN.textContent $ WDE.toNode element

                isChecked selector = liftEffect do
                        element <- unsafeQuerySelector selector
                        WHH.checked $ PU.unsafePartial $ DM.fromJust $ WHH.fromElement element

                isDisabled selector = liftEffect do
                        element <- unsafeQuerySelector selector
                        WHH.disabled $ PU.unsafePartial $ DM.fromJust $ WHH.fromElement element

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

newtype TestNewtype = TestNewtype { a :: Int, b :: String, c :: Boolean }

derive instance genericTestNewtype :: Generic TestNewtype _
derive instance newtypeTestNewtype :: Newtype TestNewtype _
derive instance eqTestNewtype :: Eq TestNewtype
instance showTestNewtype :: Show TestNewtype where
        show = DGRS.genericShow