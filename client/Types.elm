module Types exposing (..)


type alias Model =
  { input : String
  , tiles : List Tile
  }


type Msg
  = Input String
  | Send
  | IncomingMessage String


type alias Tile =
  { id : String
  , x : Int
  , y : Int
  , filled : Bool
  }