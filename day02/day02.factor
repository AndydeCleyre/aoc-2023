#!/usr/bin/env factor

USING: aoc-2023 arrays assocs kernel math math.parser
prettyprint regexp sequences splitting ;
IN: aoc-2023.day02

: known-color ( color-phrases regexp -- n )
! "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" R/ \d+ red/ -- 4
  all-matching-subseqs [ 0 ] [
    [ split-words first string>number ] map supremum
  ] if-empty
;

: line>known-rgb ( str -- game-id known-rgb )
! "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" -- 1 { 4 2 6 }
  ": " split1 [ split-words last string>number ] dip
  R/ \d+ red/ over R/ \d+ green/ over R/ \d+ blue/ [ known-color ] 2tri@ 3array
;

: possible? ( known-rgb test-rgb -- ? )
! { 4 2 6 } { 12 13 4 } -- f
  zip [ first2 <= ] map first3 and and
;

: part1 ( -- )
  2 day-lines
  [ line>known-rgb 2array ] map
  [ last { 12 13 14 } possible? ] filter
  [ first ] map-sum .
;

: part2 ( -- )
  2 day-lines
  [ line>known-rgb nip first3 * * ] map-sum .
;

MAIN: [ part1 part2 ]
