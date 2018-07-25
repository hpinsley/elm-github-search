module Pages.SearchingPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Utils exposing (getSearchTerm)

view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            [ h1 []
                [ text ("Searching for " ++ getSearchTerm model.searchType)
                ]
            ]
        ]
