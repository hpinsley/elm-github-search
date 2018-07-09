module Utils exposing (..)

import Http exposing (..)

httpErrorMessage : Http.Error -> String
httpErrorMessage error =
    case error of
        Http.BadUrl url ->
            "Bad Url"

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus _ ->
            "Bad Status"

        Http.BadPayload _ _ ->
            "Bad Payload"
