module View exposing (..)

import Html exposing (..)
import Html.App
import Json.Decode as Decode exposing (Decoder, (:=))
import Http
import Task

import Search


type alias Model =
  { search : Search.Model
  , isFetching : Bool
  , results : List String
  }

init : Model
init =
  { search = Search.init
  , isFetching = False
  , results = []
  }

decoder : Decoder (List String)
decoder =
  Decode.at ["items"] (Decode.list (Decode.at ["name"] Decode.string))

searchWiki : String -> Cmd Msg
searchWiki query =
  let
    url = "https://api.github.com/search/repositories?q=" ++ query
  in
    Http.get decoder url
      |> Task.perform (always FetchFail) FetchOk

type Msg
  = MsgFromSearch Search.Msg
  | FetchOk (List String)
  | FetchFail

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    MsgFromSearch childMsg ->
      let
        ( childModel, shouts ) = Search.update childMsg model.search
      in
        List.foldl
          handleSearchShout
          ( { model | search = childModel }, Cmd.none )
          shouts

    FetchOk results ->
      ( { model | results = results, isFetching = False }
      , Cmd.none
      )

    FetchFail ->
      ( { model | isFetching = False }, Cmd.none )

handleSearchShout : Search.Shout -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
handleSearchShout shout ( model, _ ) =
  case shout of
    Search.OnSearch query ->
      ( { model | isFetching = True }
      , searchWiki query
      )

view : Model -> Html Msg
view model =
  div []
    [ Search.view model.search |> Html.App.map MsgFromSearch
    , if model.isFetching then
        text "Loading..."
      else
        ul [] (List.map resultView model.results)
    ]

resultView : String -> Html msg
resultView result =
  li [] [ text result ]
