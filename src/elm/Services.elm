module Services exposing (..)

import Http
import Json.Decode
import Dict
import Types exposing (..)
import GithubTypes exposing (..)
import Decoders exposing (..)
import Utils exposing (..)

searchRepos : SearchRequest -> Cmd Msg
searchRepos searchRequest =
    let
        url = "https://api.github.com/search/repositories?q=" ++ searchRequest.searchTerm ++
                    "&per_page=" ++ (toString searchRequest.items_per_page)

        x = Debug.log url

        request =
            Http.request <|
                Debug.log "request"
                    { method = "GET"
                    , url = url
                    , body = Http.emptyBody
                    , headers =
                        [
                              Http.header "Accept" "application/json"
                        ]
                    --, expect = Http.expectJson repoSearchResultDecoder
                    , expect = Http.expectStringResponse responseToResult
                    , timeout = Nothing
                    , withCredentials = False
                    }
    in
        Http.send (Result.mapError Utils.httpErrorMessage >> ProcessRepoSearchResult) request

responseToResult: Http.Response String -> Result String RepoQueryResult
responseToResult response =

    case response.status.code of
        200 ->
            let
                decodedResponse = Json.Decode.decodeString repoSearchResultDecoder response.body
            in
                    case decodedResponse of
                        Ok goodResponse ->
                            let withLinks = {
                                goodResponse
                                    | linkHeader = extractLinks response}
                            in
                                Ok withLinks
                        Err msg ->
                                Err msg

        _ ->
            -- The error string ends up embedded in a HttpError.BadPayload
            Err response.status.message

extractLinks: Http.Response String -> Maybe String
extractLinks response =
    Dict.get "link" response.headers
