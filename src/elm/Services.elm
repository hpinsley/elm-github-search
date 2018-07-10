module Services exposing (..)

import Http

import Types exposing (..)
import Decoders exposing (..)

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
                    , expect = Http.expectJson repoSearchResultDecoder
                    , timeout = Nothing
                    , withCredentials = False
                    }
    in
        Http.send ProcessRepoSearchResult request
