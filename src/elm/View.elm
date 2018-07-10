module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Types exposing (..)
import Pages.SearchPage exposing (view)
import Pages.SearchingPage exposing (view)
import Pages.ResultsPage exposing (view)

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "left" )] ]
    [
      displayPage model
    ]

displayPage: Model -> Html Msg
displayPage model =
  case model.page of
    SearchPage ->
      Pages.SearchPage.view model
    SearchingPage ->
      Pages.SearchingPage.view model
    ResultsPage ->
      Pages.ResultsPage.view model