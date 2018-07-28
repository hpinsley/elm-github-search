module Services exposing (..)

import Http
import Json.Decode
import Dict
import Types exposing (..)
import GithubTypes exposing (..)
import Decoders exposing (..)
import Utils exposing (..)
import Base64

import Secrets exposing (username, password)

searchRepos : String -> Int -> String -> Cmd Msg
searchRepos searchTerm items_per_page language =
    let
        qTerm = case language of
                "" -> searchTerm
                lang -> searchTerm ++ "+language:" ++ lang

        url = "https://api.github.com/search/repositories?q=" ++ qTerm ++
                    "&per_page=" ++ (toString items_per_page)
    in
        searchViaUrl url

searchViaUrl : String -> Cmd Msg
searchViaUrl url =
    let
        userPlusPwd = username ++ ":" ++ password
        encoded = Base64.encode userPlusPwd

        request =
            Http.request <|
                Debug.log "request"
                    { method = "GET"
                    , url = url
                    , body = Http.emptyBody
                    , headers =
                        [
                                Http.header "Accept" "application/json"
                              , authHeader
                        ]
                    --, expect = Http.expectJson repoSearchResultDecoder
                    , expect = Http.expectStringResponse responseToRepoQueryResult
                    , timeout = Nothing
                    , withCredentials = False
                    }
    in
        Http.send (Result.mapError Utils.httpErrorMessage >> ProcessRepoSearchResult) request

authHeader: Http.Header
authHeader =
        let
            userPlusPwd = username ++ ":" ++ password
            encoded = Base64.encode userPlusPwd
        in
            Http.header "Authorization" ("Basic " ++ encoded)

responseToRepoQueryResult: Http.Response String -> Result String RepoQueryResult
responseToRepoQueryResult response =

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

responseToUserRepoQueryResult: Http.Response String -> Result String UserReposQueryResult
responseToUserRepoQueryResult response =

    case response.status.code of
        200 ->
            let
                repoListResponse = Json.Decode.decodeString repoListDecoder response.body
            in
                case repoListResponse of
                    Ok repoList ->
                        Ok <| UserReposQueryResult repoList (extractLinks response)
                    Err msg ->
                        Err msg

        _ ->
            -- The error string ends up embedded in a HttpError.BadPayload
            Err response.status.message

extractLinks: Http.Response String -> Maybe String
extractLinks response =
    Dict.get "link" response.headers

searchUser: String -> Cmd Msg
searchUser user =
    let
        url = "https://api.github.com/users/" ++ user
        request =
            Http.request <|
                    { method = "GET"
                    , url = url
                    , body = Http.emptyBody
                    , headers =
                        [
                                Http.header "Accept" "application/json"
                              , authHeader
                        ]
                    , expect = Http.expectJson userDecoder
                    , timeout = Nothing
                    , withCredentials = False
                    }
    in
        Http.send ProcessUserSearchResult request

searchUserRepos: String -> Cmd Msg
searchUserRepos url =
    let
        adjustedUrl = url
        request =
            Http.request <|
                    { method = "GET"
                    , url = adjustedUrl
                    , body = Http.emptyBody
                    , headers =
                        [
                                Http.header "Accept" "application/json"
                              , authHeader
                        ]
                    --, expect = Http.expectJson repoSearchResultDecoder
                    , expect = Http.expectStringResponse responseToUserRepoQueryResult
                    , timeout = Nothing
                    , withCredentials = False
                    }
    in
        Http.send ProcessUserReposResult request