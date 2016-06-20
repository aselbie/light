module Grid exposing (..)

import Types exposing (..)
import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)


type alias ViewTile =
  { x : Int
  , y : Int
  , filled : Bool
  , shifted : Bool
  }

convert : Tile -> ViewTile
convert tile =
  {
    x = tile.x,
    y = tile.y,
    filled = tile.filled,
    shifted = tile.y `rem` 2 == 1
  }


tileInView : (Int, Int) -> Tile -> Bool
tileInView origin tile =
  let
    (x, y) = origin
  in
    tile.x >= x && tile.x < (x + 8) && tile.y >= y && tile.y < (y + 8)


normalizedCoords : (Int, Int) -> ViewTile -> ViewTile
normalizedCoords (x, y) tile =
  { tile |
    x = tile.x - x,
    y = tile.y - y
  }


tilesInView : (Int, Int) -> List Tile -> List ViewTile
tilesInView origin tiles =
  List.map (normalizedCoords origin) (List.map convert (List.filter (tileInView origin) tiles))


hexPoint : Float -> Float -> Float -> Float -> String
hexPoint x y radius num =
  let
    theta = num * pi / 3
    xCoord = toString (x + radius * (sin theta))
    yCoord = toString (y + radius * (cos theta))
  in
    xCoord ++ "," ++ yCoord


hexPoints : Float -> Float -> Float -> String
hexPoints x y radius =
  List.foldr (++) "" (List.intersperse " " (List.map (hexPoint x y radius) [0..5]))


hexView : ViewTile -> Html.Html msg
hexView tile =
  let
    radius = 60
    offset = (sqrt 3) * radius / 2
    x = radius + offset * (toFloat tile.x) * 2 + (if tile.shifted then offset else 0)
    y = radius + offset * (toFloat tile.y) * (sqrt 3)
    fillColor = if tile.filled then "black" else "white"
  in
    polygon [ fill fillColor, stroke "black", strokeWidth "1", points (hexPoints x y radius)] []


grid : Model -> Html.Html Msg
grid model =
  svg [ width "400px", height "400px", viewBox "0 0 800 800" ] (List.map hexView (tilesInView model.gridOrigin model.tiles))