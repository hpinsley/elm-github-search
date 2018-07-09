module Types exposing (..)

import Http exposing (..)
import GithubTypes exposing (..)

init : ( Model, Cmd Msg )
init =
    (
        {
            name = "Howard"
            , searchTerm = ""
            , searching = False
            , errorMessage = ""
            , result_count = 0
        }
        ,  Cmd.none
    )

-- MODEL
type alias Model =
    {
          name: String
        , searchTerm: String
        , searching: Bool
        , errorMessage: String
        , result_count: Int
    }

-- Messages
type Msg
    = NoOp
    | OnSearchTermChange String
    | StartSearch
    | ProcessRepoSearchResult (Result Http.Error RepoQueryResult)
