{- This file re-implements the Elm Counter example (1 counter) with elm-mdl
   buttons. Use this as a starting point for using elm-mdl components in your own
   app.
-}


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Material
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Material.Color as Color
import Material.Card as Card
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Elevation as Elevation
import Material.Grid exposing (grid, cell, size, offset, Device(..))
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
    , text =
        """
Markdown Math
============

Tex maht style $$\\frac{n!}{k!(n-k)!} = \\binom{n}{k}$$

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
        , drawer = drawer
        , tabs = ( [], [] )
        , main = [ viewBody model ]
        }


drawer : List (Html Msg)
drawer =
    [ Layout.title [] [ text "Example drawer" ]
    , Layout.navigation
        []
        [ Layout.link
            [ Layout.href "https://github.com/tazzo/elm-markdown-math" ]
            [ text "elm-markdown-math source" ]
        , Layout.link
            [ Layout.href "https://github.com/tazzo/elm-markdown-math-demo" ]
            [ text "demo source" ]
        ]
    ]


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
        [ cell [ size All 6 ] [ tf model ]
        , cell [ size All 6 ] [ renderMessage model ]
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
        , css "max-width" "600px"
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
