port module Main exposing (..)

import View

import Html.App

main =
  Html.App.beginnerProgram
    { model = View.init
    , update = View.update
    , view = View.view
    }
