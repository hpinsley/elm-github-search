module Pages.SearchingPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)

view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            [ h1 []
                [ text ("Searching for " ++ model.searchTerm ++ "...")
                ]
            ]
        ]
