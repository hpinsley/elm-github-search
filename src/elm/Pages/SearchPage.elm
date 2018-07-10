module Pages.SearchPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Types exposing (..)

view: Model -> Html Msg
view model =
    div [ class "row" ][
      div [ class "col-xs-12" ][
        h1 [] [
          text "GitHub Search"
          , h2 []
            [
              text <| model.errorMessage
            ]

          , Html.div []  [
                getSearchTerm model
              , getButtons model
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
