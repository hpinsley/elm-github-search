module Pages.SearchingForUserPage exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)

view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            [ h1 []
                [ text ("Searching for " ++ model.searchUserLogin ++ "...")
                ]
            , div
                []
                [ case model.searchUserAvatarUrl of
                    Nothing ->
                        text ""

                    Just imageUrl ->
                        img [src imageUrl, class "mediumAvatar"] []
                ]
            ]
        ]
