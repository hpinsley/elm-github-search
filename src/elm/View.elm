module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Types exposing (..)
-- Component import example
import Components.Hello exposing ( hello )

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][    -- inline CSS (literal)
    div [ class "row" ][
      div [ class "col-xs-12" ][
        h1 [] [
          text ("GitHub Search for " ++ model.name)

          , h2 []
            [
              text <| if (model.searching) then "Searching" else "Not searching"
            ]

          , Html.form []  [
              div [class "form-group"] [
                button [class "btn btn-primary btn-lg"] [text "Search"]
              ]
              , div [class "form-group"] [
                button [class "btn btn-primary btn-lg"] [text "Cancel"]
              ]
            ]
          ]
        ]
      ]
    ]


-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }