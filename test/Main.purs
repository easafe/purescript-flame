module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Flame.Html.Element as HH
import Flame.Html.Attribute as HA
import Flame.Html.Property as HA
import Flame.Renderer.String as HS
import Test.Unit (suite, test)
import Test.Unit.Assert as TUA
import Test.Unit.Main (runTest)

--might need https://bitbucket.org/chromiumembedded/cef/wiki/GeneralUsage as headless browser

main :: Effect Unit
main = runTest do
        suite "VNode creation" do
                test "ToHtml instances" do
                        let html = HH.a [HA.id "test"] [HH.text "TEST"]
                        html' <- liftEffect $ HS.render html
                        TUA.equal """<a id="test">TEST</a>""" html'

                        let html2 = HH.a (HA.id "test") [HH.text "TEST"]
                        html2' <- liftEffect $ HS.render html2
                        TUA.equal """<a id="test">TEST</a>""" html2'

                        let html3 = HH.a "test" [HH.text "TEST"]
                        html3' <- liftEffect $ HS.render html3
                        TUA.equal """<a id="test">TEST</a>""" html3'

                        let html4 = HH.a "test" $ HH.text "TEST"
                        html4' <- liftEffect $ HS.render html4
                        TUA.equal """<a id="test">TEST</a>""" html4'

                        let html5 = HH.a "test" "TEST"
                        html5' <- liftEffect $ HS.render html5
                        TUA.equal """<a id="test">TEST</a>""" html5'

                test "ToClassList instances" do
                        let html = HH.a [HA.class' "test"] [HH.text "TEST"]
                        html' <- liftEffect $ HS.render html
                        TUA.equal """<a class="test">TEST</a>""" html'

                        let html2 = HH.a [HA.class' { "test": false, "test2": true, "test3": true }] [HH.text "TEST"]
                        html2' <- liftEffect $ HS.render html2
                        TUA.equal """<a class="test2 test3">TEST</a>""" html2'

                test "Inline style" do
                        let html = HH.a (HA.style { mystyle: "test" }) [HH.text "TEST"]
                        html' <- liftEffect $ HS.render html
                        TUA.equal """<a style="mystyle:test">TEST</a>""" html'

                        let html2 = HH.a [HA.style { width: "23px", display: "none" }] [HH.text "TEST"]
                        html2' <- liftEffect $ HS.render html2
                        TUA.equal """<a style="width:23px;display:none">TEST</a>""" html2'

                test "style/class name case" do
                        html <- liftEffect <<< HS.render $ HH.createElement' "element" $ HA.class' "superClass"
                        TUA.equal """<element class="super-class"></element>""" html

                        html2 <- liftEffect <<< HS.render $ HH.createElement' "element" $ HA.class' "SuperClass"
                        TUA.equal """<element class="super-class"></element>""" html2

                        html3 <- liftEffect <<< HS.render $ HH.createElement' "element" $ HA.class' "MySuperClass my-other-class"
                        TUA.equal """<element class="my-super-class my-other-class"></element>""" html3

                        html4 <- liftEffect <<< HS.render $ HH.createElement' "element" $ HA.class' "SUPERCLASS"
                        TUA.equal """<element class="superclass"></element>""" html4

                        html5 <- liftEffect <<< HS.render $ HH.createElement' "element" $ HA.style { borderBox : "23", s : "34", borderLeftTopRadius : "20px"}
                        TUA.equal """<element style="border-box:23;s:34;border-left-top-radius:20px"></element>""" html5

                        html6 <- liftEffect <<< HS.render $ HH.createElement' "element" $ HA.class' { borderBox : true, s : false, borderLeftTopRadius : true}
                        TUA.equal """<element class="border-box border-left-top-radius"></element>""" html6

                test "custom elements" do
                        let html = HH.createElement' "custom-element" "test"
                        html' <- liftEffect $ HS.render html
                        TUA.equal """<custom-element id="test"></custom-element>""" html'

                        let html2 = HH.createElement' "custom-element" "test"
                        html2' <- liftEffect $ HS.render html2
                        TUA.equal """<custom-element id="test"></custom-element>""" html2'

                        let html3 = HH.createElement_ "custom-element" "test"
                        html3' <- liftEffect $ HS.render html3
                        TUA.equal """<custom-element>test</custom-element>""" html3'

                test "properties" do
                        let html = HH.a [HA.disabled true] [HH.text "TEST"]
                        html' <- liftEffect $ HS.render html
                        TUA.equal """<a disabled="disabled">TEST</a>""" html'

                        let html2 = HH.a [HA.disabled false] [HH.text "TEST"]
                        html2' <- liftEffect $ HS.render html2
                        TUA.equal """<a>TEST</a>""" html2'

                        let html3 = HH.a [HA.createProperty "test-prop" true] [HH.text "TEST"]
                        html3' <- liftEffect $ HS.render html3
                        TUA.equal """<a test-prop="test-prop">TEST</a>""" html3'

                        let html4 = HH.a [HA.createProperty "test-prop" false] [HH.text "TEST"]
                        html4' <- liftEffect $ HS.render html4
                        TUA.equal """<a>TEST</a>""" html4'

                test "nested elements" do
                        let html = HH.html_ [
                                HH.head_ [HH.title_ "title"],
                                HH.body_ [
                                        HH.main_ [
                                	        HH.button_ "-",
                                                HH.br,
                                	        HH.text "Test",
                                	        HH.button_ "+",
                                                HH.hr,
                                                HH.div_ $ HH.div_ [
                                                        HH.span_ [ HH.a_ "here" ]
                                                ]
                                        ]
                                ]
                	]
                        html' <- liftEffect $ HS.render html
                        TUA.equal """<html><head><title>title</title></head><body><main><button>-</button><br>Test<button>+</button><hr><div><div><span><a>here</a></span></div></div></main></body></html>""" html'

                test "nested elements with attributes" do
                        let html = HH.html [HA.lang "en"] [
                                HH.head_ [HH.title_ "title"],
                                HH.body "content" [
                                        HH.main_ [
                                	        HH.button (HA.style { display: "block", width: "20px"}) "-",
                                                HH.br,
                                	        HH.text "Test",
                                	        HH.button (HA.createAttribute "my-attribute" "myValue") "+",
                                                HH.hr' [HA.style { border: "200px solid blue"}] ,
                                                HH.div_ $ HH.div_ [
                                                        HH.span_ [ HH.a_ "here" ]
                                                ]
                                        ]
                                ]
                	]
                        html' <- liftEffect $ HS.render html
                        TUA.equal """<html lang="en"><head><title>title</title></head><body id="content"><main><button style="display:block;width:20px">-</button><br>Test<button my-attribute="myValue">+</button><hr style="border:200px solid blue"><div><div><span><a>here</a></span></div></div></main></body></html>""" html'

                -- test "nested elements with properties" do

                -- test "nested elements with properties and attributes" do