port module Main exposing (..)

import View

import Html.App

main =
  Html.App.program
    { init = ( View.init, Cmd.none )
    , update = View.update
    , view = View.view
    , subscriptions = (\_ -> Sub.none )
    }
