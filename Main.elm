module Main exposing (..)

import Html exposing (..)
import Material
import Material.Layout as Layout
import Material.Color as Color
import Material.Card as Card
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Options as Options exposing (css)
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Grid exposing (stretch, grid, cell, size, order, offset, Device(..))
import MarkdownMath exposing (toHtml)


type alias Model =
    { mdl :
        Material.Model
    , text : String
    }


initModel : Model
initModel =
    { mdl =
        Material.model
    , text = example1
    }


type Msg
    = Mdl (Material.Msg Msg)
    | InputChange String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model

        InputChange str ->
            ( { model | text = str }, Cmd.none )


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.fixedDrawer
        ]
        { header = header model
        , drawer = drawer model
        , tabs = ( [], [] )
        , main = [ viewBody model ]
        }


drawer : Model -> List (Html Msg)
drawer model =
    [ Layout.navigation
        []
        (examplesList model)
    , Layout.navigation
        []
        [ Layout.title [] [ text "Github" ]
        , Layout.link
            [ Layout.href "https://github.com/tazzo/elm-markdown-math" ]
            [ text "elm-markdown-math" ]
        , Layout.link
            [ Layout.href "https://github.com/tazzo/elm-markdown-math-demo" ]
            [ text "demo" ]
        ]
    ]


examplesList model =
    [ Layout.title [] [ text "Examples" ]
    , button1 model
    , button2 model
    , button3 model
    ]


button1 model =
    Button.render Mdl
        [ 2, 1 ]
        model.mdl
        [ Button.ripple
        , Options.onClick <| InputChange example1
        ]
        [ text "Markdown Math" ]


button2 model =
    Button.render Mdl
        [ 2, 2 ]
        model.mdl
        [ Button.ripple
        , Options.onClick <| InputChange example2
        ]
        [ text "Matrix" ]


button3 model =
    Button.render Mdl
        [ 2, 3 ]
        model.mdl
        [ Button.ripple
        , Options.onClick <| InputChange example3
        ]
        [ text "Math" ]


header : Model -> List (Html Msg)
header model =
    [ Layout.row
        [ css "transition" "height 333ms ease-in-out 0s"
        ]
        [ Layout.title [] [ text "Elm Markdown Math - Demo" ]
        ]
    ]


viewBody : Model -> Html Msg
viewBody model =
    grid [ Color.background (Color.color Color.Grey Color.S100) ]
        [ cell
            [ size All 8
            , size Desktop 6
            , stretch
            ]
            [ renderMessage model ]
        , cell
            [ size All 8
            , size Desktop 6
            , stretch
            ]
            [ tf model ]
        ]


tf : Model -> Html Msg
tf model =
    Textfield.render Mdl
        [ 0, 9 ]
        model.mdl
        [ css "width" "100%"
        , css "padding-left" "10px"
        , css "padding-right" "10px"
        , Textfield.label "Enter Markdown and Math here"
        , Textfield.floatingLabel
        , Textfield.textarea
        , Textfield.rows 20
        , Textfield.value model.text
        , Options.onInput InputChange
        , Color.background Color.white
        , Elevation.e8
        ]
        []


renderMessage : Model -> Html Msg
renderMessage model =
    Card.view
        [ css "width" "100%"
        , Elevation.e8

        -- ,Color.background (Color.color Color.Amber Color.S600)
        ]
        [ Card.text [] [ toHtml [] model.text ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Layout.subs Mdl model.mdl
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Layout.sub0 Mdl )
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


example1 =
    """
### Markdown Math

Tex math **scriptscriptstyle** $$\\scriptscriptstyle \\int_{0}^{\\infty} e^{-x} dx$$

Tex math **scriptstyle** $$\\scriptstyle \\int_{0}^{\\infty} e^{-x} dx$$

Tex math **textstyle (default)** $$ \\int_{0}^{\\infty} e^{-x} dx$$

Tex math **textstyle** $$\\textstyle \\int_{0}^{\\infty} e^{-x} dx$$

Tex math **displaystyle** $$\\displaystyle \\int_{0}^{\\infty} e^{-x} dx$$

#### limit
$$
\\displaystyle\\lim_{x \\to \\infty} e^{-x} = 0
 $$

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

  * this one
  * that one
  * the other one

> Block quotes are
> written like so.

Unicode is supported. ☺



An h2 header
------------

Here's a numbered list:

 1. first item
 2. second item
 3. third item

```python
import time
# Quick, count to ten!
for i in range(10):
    # (but not *too* quick)
    time.sleep(0.5)
    print i
```



### An h3 header

Now a nested list:

 1. First, get these ingredients:

      * carrots
      * celery
      * lentils

 2. Boil some water.

 3. Dump everything in the pot and follow
    this algorithm:


Here's a link to [a website](http://foo.bar), to a [local
doc](local-doc.html), and to a [section heading in the current
doc](#an-h2-header).

![example image](logo-elm.png "An exemplary image")

Math equations go in like so: $$\\omega = d\\phi / dt$$.

"""


example2 =
    """
#### Simple matrix

$$
\\begin{matrix}
  a & b & c \\\\
  d & e & f \\\\
  g & h & i
 \\end{matrix}
$$

#### Matrix with dots


$$

  A_{m,n} =
 \\begin{pmatrix}
  a_{1,1} & a_{1,2} & \\cdots & a_{1,n} \\\\
    a_{2,1} & a_{2,2} & \\cdots & a_{2,n} \\\\
  \\vdots  & \\vdots  & \\ddots & \\vdots  \\\\
    a_{m,1} & a_{m,2} & \\cdots & a_{m,n}
 \\end{pmatrix}

 $$

#### Matrix with square brakets

$$
M = \\begin{bmatrix}
       \\frac{5}{6} & \\frac{1}{6} & 0           \\\\[0.3em]
       \\frac{5}{6} & 0           & \\frac{1}{6} \\\\[0.3em]
       0           & \\frac{5}{6} & \\frac{1}{6}
     \\end{bmatrix}
 $$

"""


example3 =
    """
#### Simple function

$$f(n) = n^5 + 4n^2 + 2 |_{n=17}$$

#### Case function


$$
 f(n) =
  \\begin{cases}
    n/2       & \\quad \\text{if } n \\text{ is even}\\\\
    -(n+1)/2  & \\quad \\text{if } n \\text{ is odd}
 \\end{cases}

 $$

#### Integral
$$
\\int_0^\\infty \\mathrm{e}^{-x}\\,\\mathrm{d}x
$$

"""
