module Main exposing (..)

import Html exposing (..)

import Types exposing (..)
import View exposing (..)
import Update exposing (..)

-- APP
main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
