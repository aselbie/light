module Grid exposing (..)

import Types exposing (..)
import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)


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


hexView : Tile -> Html.Html msg
hexView tile =
  let
    radius = 40
    offset = ((sqrt 3) * radius / 2)
    shift = (rem tile.y 2) == 1
    x = radius + offset * (toFloat tile.x) * 2 + (if shift then offset else 0)
    y = radius + offset * (toFloat tile.y) * (sqrt 3)
    fillColor = if tile.filled then "black" else "white"
  in
    polygon [ fill fillColor, stroke "black", strokeWidth "1", points (hexPoints x y radius)] []


grid : Model -> Html.Html Msg
grid model =
  svg [ width "800px", height "800px", viewBox "0 0 800 800" ] (List.map hexView model.tiles)