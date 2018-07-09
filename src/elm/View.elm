module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Types exposing (..)

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

          , h2 []
            [
              text <| "Result count " ++ (toString model.result_count)
            ]

          , Html.div []  [
                getSearchTerm model
              , getButtons model
            ]
          ]
        ]
      ]
    ]

getButtons: Model -> Html Msg
getButtons model =
        div [class "form-group"] [
            button [
                      class "btn btn-primary btn-lg"
                    , onClick StartSearch
            ] [text "Search"]
          , button [class "btn btn-warning btn-lg"] [text "Cancel"]
        ]

getSearchTerm: Model -> Html Msg
getSearchTerm model =
        div [class "form-group"] [
            label [] [text "Search term:"]
          , input [
                type_ "text"
              , class "form-control"
              , value model.searchTerm
              , onInput OnSearchTermChange
              ] []
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