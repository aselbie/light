import Html.App
import WebSocket
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
  (Model "" [], Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      (Model newInput model.tiles, Cmd.none)

    Send ->
      (Model "" model.tiles, WebSocket.send echoServer model.input)

    IncomingMessage str ->
      handleMessage str model


echoServer : String
echoServer =
  "ws://localhost:3000"


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer IncomingMessage
