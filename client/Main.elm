import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
-- import Html.Events exposing (..)
import WebSocket
import Json.Decode exposing (Decoder, decodeString, string, int, bool, list, (:=), object4)


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
  , tiles : List Tile
  }


type Msg
  = Input String
  | Send
  | NewMessage String


type alias Tile =
  { id : String
  , x : Int
  , y : Int
  , filled : Bool
  }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


-- UPDATE

tileDecoder : Decoder Tile
tileDecoder =
  object4 Tile
    ("id" := string)
    ("x" := int)
    ("y" := int)
    ("filled" := bool)

tilesDecoder : Decoder (List Tile)
tilesDecoder =
  Json.Decode.list tileDecoder

nullTile : Tile
nullTile =
  { id = "0.0", x = 0, y = 0, filled = False }

decodeTiles : String -> List Tile
decodeTiles str =
  case decodeString tilesDecoder str of
    Ok val -> val
    Err message -> [nullTile]

update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, tiles} =
  case msg of
    Input newInput ->
      (Model newInput tiles, Cmd.none)

    Send ->
      (Model "" tiles, WebSocket.send echoServer input)

    NewMessage str ->
      (Model input (decodeTiles(str)), Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewMessage


-- VIEW
yIs : Int -> Tile -> Bool
yIs y tile = 
  tile.y == y

compareX : Tile -> Tile -> Order
compareX a b =
  compare a.x b.x

getRow : List Tile -> Int -> List Tile
getRow tiles rowNum =
  List.sortWith compareX (List.filter (yIs rowNum) tiles)

getRows : List Tile -> List (List Tile)
getRows tiles =
  List.map (getRow tiles) [0..9]

view : Model -> Html Msg
view model =
  table [] (List.map viewRow (getRows model.tiles))

viewRow : List Tile -> Html msg
viewRow row =
  tr [] (List.map viewTile row)

tileStyle : Attribute msg
tileStyle =
  style
    [ ("padding", "4px")
    ]

viewTile : Tile -> Html msg
viewTile tile =
  td [tileStyle] [ text tile.id ]
