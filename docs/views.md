---
layout: default
title: Defining views
permalink: /views
---

## Defining views

In the application record

```haskell
type Application model message = {
      model :: model
      view :: model -> Html message,
      update :: Update model message,
      subscribe :: Array (Subscription message)
}
```

`view` maps the current state to markup. Whenever the model is updated, Flame patches the DOM by calling the `view` function with the new state.

A custom DSL, defined by the type `Html`, is used to write markup. Alternatively, [breeze](https://github.com/easafe/haskell-breeze) can generate Flame views from HTML.

You will likely need to qualify imports, e.g., prefix HE for HTML elements and HA for HTML attributes and events

```haskell
import Flame.Html.Element as HE
import Flame.Html.Attribute as HA
```

### Attributes and events

The module `Flame.Html.Attribute` exports

* Regular name=value attributes such as `id` or `type'`

* Helpers like `class'` or `style` that accept records

* Presential attributes, such as `disabled` or `checked`, expecting boolean parameters

* Events, e.g., `onClick` or `onInput`, expecting a `message` data constructor

* A special attribute, `key` used to enable ["keyed" rendering](https://www.stefankrause.net/wp/?p=342)

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of attributes. In the case you need to define your own attributes/events, Flame provides the combinators

```haskell
HA.createAttibute
HA.createProperty --for DOM properties
HA.createEvent
HA.createRawEvent
```

### Elements

The module `Flame.Html.Element` exports HTML elements, such as `div`, `body`, etc, following the convention

* Functions named `element` expects attributes and children elements

```haskell
HE.div [HA.id "my-div"] [HE.text "text content"] -- renders <div id="my-div">text content</div>
```

* Functions named `element_` (trailing underscore) expects children elements but no attributes

```haskell
HE.div_ [HE.text "text content"] -- renders <div>text content</div>
```

* Functions named `element'` (trailing quote) expects attributes but no children elements

```haskell
HE.div' [HA.id "my-div"] -- renders <div id="my-div"></div>
```

(a few elements that usually have no children like br or input have `element` behave as `element'`)

Attributes and children elements are passed as arrays

```haskell
HE.div [HA.id "my-div", HA.disabled False, HA.title "div title"] [
      HE.span' [HA.id "special-span"],
      HE.br,
      HE.span_ [HE.text "I am regular"],
]
{- renders
<div id="my-div" title="div title">
      <span id="special-span"></span>
      <br>
      <span>I am regular</span>
</div>
-}
```

But for some common cases, the markup DSL also defines convenience type classes so we can write

* `HE.element "my-element" _` instead of `HE.element [HA.id "my-element"] _` to declare an element with only id as attribute

* `HE.element _ "text content"` instead of `HE.element _ [HE.text "text content"]` to declare elements with only text as children

* `HE.element (HA.attribute _) _` instead of `HE.element [HA.attribute _] _` to declare elements with a single attribute

* `HE.element _ $ HE.element _ _` instead of `HE.element _ [HE.Element _ _]` to declare elements with a single child element

Flame also offers a few special elements for cases where finer control is necessary

* Managed elements

`HE.managed` takes user supplied functions to manipulate an element's DOM node

```haskell
type NodeRenderer arg = {
      createNode :: arg -> Effect Node,
      updateNode :: Node -> arg -> arg -> Effect Node
}

managed :: forall arg nd message. ToNode nd message NodeData => NodeRenderer arg -> nd -> arg -> Html message
```

On rendering, Flame calls `createNode` only once and from then on `updateNode`. These functions can check on their local state `arg` to decide whether/how to change a DOM node. For easy of use, the elements attributes and events are still automatically patched -- otherwise, `HE.managed_` should be used

```haskell
managed_ :: forall arg message. NodeRenderer arg -> arg -> Html message
```

* Lazy elements

Lazy elements are only re-rendered if their local state `arg` changes

```haskell
lazy :: forall arg message. Maybe Key -> (arg -> Html message) -> arg -> Html message
```

This is useful to avoid recomputing potentially expensive views such as large lists.

* Fragments

Fragments are wrappers

```haskell
fragment :: forall children message. ToNode children message Html => children -> Html message
```

meaning that only their children elements will be rendered to the DOM. Fragments are useful in cases where having an extra parent element is unnecessary, or wherever [`DocumentFragment`](https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment) could be used.

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of elements. In the case you need to define your own elements, Flame provides a few combinators as well

```haskell
HE.createElement
HE.createElement_
HE.createElement'
HE.createEmptyElement
```

### Combining attributes and events

For most attributes, later declarations overwrite previous ones

```haskell
HE.div' [HA.title "title", HA.title "title 2"]
{- renders
<div title="title 2">
</div>
-}
```

```haskell
HE.input [HA.type' "input", HA.value "test", HA.value "not a test!"]
{- renders
<input type="text">
with value set to "not a test!"
-}
```

However, classes, inline styles and events behave differently:

* Classes and styles

All uses of `HE.class'` on a single element are merged

```haskell
HE.div' [HA.class' "a b", HA.class' { c: true }]
{- renders
<div class="a b c">
</div>
-}
```

So is `HE.style`

```haskell
HE.div' [HA.style { display: "flex", color: "red" }, HA.style { order: "1" }]
{- renders
<div style="display: flex; color: red; order:1">
</div>
-}
```

* Events

Different messages for the same event on a single element are raised in the order they were declared. For example, clicking on a `div` similar to

```haskell
HE.div' [HA.onClick Message1, HA.onClick Message2]
```

will result on the `update` function being called with `Message1` and after once again with `Message2`.

### View logic

A `view` is just a regular PureScript function: we can compose it or pass it around as any other value. For example, we can use the model in attributes

```haskell
type Model = {
      done :: Int,
      enabled :: Boolean
}

data Message = Do

view :: Model -> Html Message
view model = HE.div [HA.class' { usefulClass: model.enabled }] $ HE.input [HA.type' "button", HA.value "Do thing number " <> show $ model.done, HA.onClick Do]
```

or to selective alter the markup

```haskell
type Name = String

type Model = Maybe Name

data Message = Update Name | Greet

view :: Model -> Html Message
view = case _ of
      Nothing -> HE.div_ [
            HE.input [HA.type' "text", HA.onInput Update],
            HE.input [HA.type' "button", HA.value "Greet!", HA.onClick Greet]
      ]
      Just name -> "Greetings, " <> name <> "!"
```

as well create "partial views" without the need for any special syntax

```haskell
header :: forall model message. model -> Html message
header = ...

footer :: forall model message. model -> Html message
footer = ...

view :: Model -> Html Message
view model = HE.content' [
      header,
      ...
      footer
]
```

`Html` is also a `Functor` so mapping `message`s works as expected. For instance, the [counters example](https://github.com/easafe/purescript-flame/tree/master/examples/Counters) markup is a list of counters

```haskell
view :: Model -> Html Message
view model = HE.main [HA.id "main"] [
      HE.button [HA.onClick Add] "Add",
      HE.div_ $ DA.mapWithIndex viewCounter model
]
      where viewCounter index model' = HE.div [HA.style { display: "flex" }] [
                  CounterMessage index <$> ECM.view model',
                  HE.button [HA.onClick $ Remove index] "Remove"
            ]
```

<a href="/concepts" class="direction previous">Previous: Main concepts</a>
<a href="/events" class="direction">Next: Handling events</a>
