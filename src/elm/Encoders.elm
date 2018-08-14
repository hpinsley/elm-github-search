module Encoders exposing (..)

import Json.Encode exposing (..)
import Types exposing (..)

encodeMonthValueList: List MonthValue -> Value
encodeMonthValueList months =
    months
        |> List.map encodeMonth
        |> list

encodeMonth: MonthValue -> Value
encodeMonth monthValue =
    object
    [
            ("month", string monthValue.month)
        , ("val", int monthValue.val)
    ]
