module Utils exposing (..)

import Http exposing (..)

initialCap: String -> String
initialCap input =
    (++)
        (input|> String.left 1 |> String.toUpper)
        (String.dropLeft 1 input)

httpErrorMessage : Http.Error -> String
httpErrorMessage error =
    case error of
        Http.BadUrl url ->
            "Bad Url " ++ url

        Http.Timeout ->
             "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus _ ->
            "Bad Status"

        Http.BadPayload errmsg _ ->
            "Bad Payload: " ++ errmsg