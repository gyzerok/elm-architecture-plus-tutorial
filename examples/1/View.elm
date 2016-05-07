module View exposing (..)

import Html exposing (..)
import Html.App

import Search


type alias Model =
  { search : Search.Model
  , query : String
  }

init : Model
init =
  { search = Search.init
  , query = ""
  }

type Msg = MsgFromSearch Search.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    MsgFromSearch childMsg ->
      let
        ( childModel, shouts ) = Search.update childMsg model.search
      in
        List.foldl
          handleSearchShout
          { model | search = childModel }
          shouts

handleSearchShout : Search.Shout -> Model -> Model
handleSearchShout shout model =
  case shout of
    Search.OnSearch query ->
      { model | query = query }

view : Model -> Html Msg
view model =
  div []
    [ Search.view model.search |> Html.App.map MsgFromSearch
    , span [] [ text model.query ]
    ]
