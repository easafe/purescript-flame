module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Renderer.String as HS
import Test.Unit (suite, test)
import Test.Unit.Assert as TUA
import Test.Unit.Main (runTest)

--might need https://bitbucket.org/chromiumembedded/cef/wiki/GeneralUsage as headless browser

main :: Effect Unit
main = runTest do
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

                test "Inline style" do
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
                                HE.head_ [HE.title_ "title"],
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
                                HE.head_ [HE.title_ "title"],
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
                                HE.head [HA.disabled true] [HE.title_ "title"],
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
        --suite "test noeffect application" do
        --suite "test effectlist application" do
        --suite "test effectful application" do
