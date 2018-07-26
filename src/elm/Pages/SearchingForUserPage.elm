module Pages.SearchingForUserPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)

view : Model -> Html Msg
view model =
    case model.searchType of
        UserLookup userLogin m_avatarUrl ->
            let
                avatar_url = Maybe.withDefault "" m_avatarUrl
            in
                div [ class "row" ]
                    [ div [ class "col-xs-12" ]
                        [ h1 []
                            [ text ("Searching for " ++ userLogin)
                            ]
                        , div
                            []
                            [
                                img [src avatar_url, class "mediumAvatar"] []
                            ]
                        ]
                    ]
        _ ->
            text ""
