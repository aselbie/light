import Html.App
import WebSocket
import Keyboard
import Types exposing (..)
import Grid exposing(grid)
import Connection exposing(handleMessage)

main : Program Never
main =
  Html.App.program
    { init = init
    , view = grid
    , update = update
    , subscriptions = subscriptions
    }


init : (Model, Cmd Msg)
init =
  (Model "" [] (0, 0), Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      ({ model | input = newInput }, Cmd.none)

    Send ->
      ({ model | input = "" }, WebSocket.send echoServer model.input)

    IncomingMessage str ->
      handleMessage str model

    KeyDown code ->
      let
        (x, y) = model.gridOrigin
        newOrigin =
          if code == 37 then
            (x - 1, y)

          else if code == 38 then
            (x, y - 1)

          else if code == 39 then
            (x + 1, y)

          else if code == 40 then
            (x, y + 1)

          else
            (x, y)
      in
        ({ model | gridOrigin = newOrigin }, Cmd.none)


echoServer : String
echoServer =
  "ws://localhost:3000"


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [
    WebSocket.listen echoServer IncomingMessage
  , Keyboard.downs KeyDown
  ]
