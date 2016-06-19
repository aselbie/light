module Connection exposing (..)

import Types exposing (..)
import Json.Decode exposing (..)


tileDecoder : Decoder Tile
tileDecoder =
  object4 Tile
    ("id" := string)
    ("x" := int)
    ("y" := int)
    ("filled" := bool)


tilesDecoder : Decoder (List Tile)
tilesDecoder =
  list tileDecoder


nullTile : Tile
nullTile =
  { id = "0.0", x = 0, y = 0, filled = False }


decodeTiles : String -> List Tile
decodeTiles str =
  case decodeString tilesDecoder str of
    Ok val -> val
    Err message -> [nullTile]


handleMessage : String -> Model -> (Model, Cmd Msg)
handleMessage str {input, tiles} =
  (Model input (decodeTiles(str)), Cmd.none)