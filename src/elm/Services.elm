module Services exposing (..)

import Http

import Types exposing (..)
import Decoders exposing (..)

searchRepos : String -> Cmd Msg
searchRepos searchString =
    let
        url = "https://api.github.com/search/repositories?q=" ++ searchString
        -- url = "http://localhost:8080/static/test.json"

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
                    , expect = Http.expectJson repoSearchResultDecoder
                    , timeout = Nothing
                    , withCredentials = True
                    }
    in
        Http.send ProcessRepoSearchResult request
