module Grid exposing (..)

import Types exposing (..)
import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)

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



xPoint x radius theta =
  toString (round (x + radius * (sin (theta * pi / 3))))

yPoint y radius theta =
  toString (round (y + radius * (cos (theta * pi / 3))))

point x y radius theta =
  (xPoint x radius theta) ++ "," ++ (yPoint y radius theta)

hexPoints x y radius =
  List.foldr (++) "" (List.intersperse " " (List.map (point x y radius) [0..5]))

hex radius y x =
  polygon [ fill "white", stroke "black", strokeWidth "1", points (hexPoints x y radius)] []

offset radius =
  (sqrt 3) * radius / 2

hexStart offset shift col =
  40 + offset * col * 2 + (if shift then offset else 0)

hexStarts width radius shift =
  List.map (hexStart (offset radius) shift) [0..(width - 1)]

rowY offset row=
  40 + offset * row * (sqrt 3)

hexRow radius row =
  List.map (hex radius (rowY (offset radius) row)) (hexStarts 10 radius ((rem (round row) 2) == 0))

hexRows radius =
  List.foldr List.append [] (List.map (hexRow radius) [0..9])

grid : Model -> Html.Html Msg
grid model =
  svg [ width "100%", height "100%", viewBox "0 0 1200 1200" ] (hexRows 40)