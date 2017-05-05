{- This file re-implements the Elm Counter example (1 counter) with elm-mdl
   buttons. Use this as a starting point for using elm-mdl components in your own
   app.
-}


module Main exposing (..)

import Html exposing (..)
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
        """## Markdown-Math rendering
    Tex maht style $$\\frac{n!}{k!(n-k)!} = \\binom{n}{k}$$

An h1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

  * this one
  * that one
  * the other one

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.

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
        , drawer = []
        , tabs = ( [], [] )
        , main = [ viewBody model ]
        }


header : Model -> List (Html Msg)
header model =
    [ Layout.row
        [ css "transition" "height 333ms ease-in-out 0s"
        ]
        [ Layout.title [] [ text "Markdown Math Demo" ]
        ]
    ]


viewBody : Model -> Html Msg
viewBody model =
    grid [ Color.background (Color.color Color.Grey Color.S100) ]
        [ cell [ size All 8 ] [ tf model ]
        , cell [ size All 8 ] [ renderMessage model ]
        ]


tf : Model -> Html Msg
tf model =
    Textfield.render Mdl
        [ 0, 9 ]
        model.mdl
        [ Textfield.label "Multiline with 6 rows"
        , Textfield.floatingLabel
        , Textfield.textarea
        , Textfield.rows 6
        , Textfield.value model.text
        , Options.onInput InputChange
        , Color.background Color.white
        , Elevation.e4
        ]
        []


renderMessage : Model -> Html Msg
renderMessage model =
    Card.view
        [ css "width" "100%"
        , css "max-width" "600px"
        , Elevation.e16

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
