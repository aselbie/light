import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Json.Decode exposing (Decoder, decodeString, string, (:=), object1)


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


echoServer : String
echoServer =
  "ws://localhost:3000"


-- MODEL
type alias Model =
  { input : String
  , messages : List Person
  }


type Msg
  = Input String
  | Send
  | NewMessage String


type alias Person =
    { name : String
    -- , age : Int
    -- , profession : Maybe String
    }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


-- UPDATE

person : Decoder Person
person =
    object1 Person
      ("name" := string)

nullPerson : Person
nullPerson =
  { name = "I have no nome" }

decode : String -> Person
decode str =
  case decodeString person str of
    Ok val -> val
    Err message -> nullPerson

update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
      (Model "" messages, WebSocket.send echoServer input)

    NewMessage str ->
      (Model input (decode(str) :: messages), Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewMessage



-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    , div [] (List.map viewMessage (List.reverse model.messages))
    ]


viewMessage : Person -> Html msg
viewMessage msg =
  div [] [ text msg.name ]
