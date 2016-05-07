module Search exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
  { input : String
  }


init : Model
init =
  { input = ""
  }


type Msg
  = Input String
  | Search

type Shout = OnSearch String

update : Msg -> Model -> ( Model, List Shout )
update msg model =
  case msg of
    Input str ->
      ( { model | input = str }, [] )
    Search ->
      ( model, [ OnSearch model.input ] )

view : Model -> Html Msg
view model =
  div []
    [ input [ onInput Input, value model.input ] []
    , button [ onClick Search ] [ text "Search" ]
    ]
