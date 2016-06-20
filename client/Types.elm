module Types exposing (..)

import Keyboard


type alias Model =
  { input : String
  , tiles : List Tile
  , gridOrigin: (Int, Int)
  }


type Msg
  = Input String
  | Send
  | IncomingMessage String
  | KeyDown Keyboard.KeyCode


type alias Tile =
  { id : String
  , x : Int
  , y : Int
  , filled : Bool
  }