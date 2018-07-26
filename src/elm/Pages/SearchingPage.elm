module Pages.SearchingPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Utils exposing (getSearchTerm)


view : Model -> Html Msg
view model =
    div [ class "banner" ]
        [ div [class "bannerText"] [ text ("Searching for " ++ getSearchTerm model.searchType) ]
        ]
