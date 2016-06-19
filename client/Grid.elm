module Grid exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

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


grid : Model -> Html Msg
grid model =
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