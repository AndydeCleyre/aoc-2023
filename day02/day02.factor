#!/usr/bin/env factor

USING: arrays assocs io.encodings.utf8 io.files kernel
math.parser math.vectors prettyprint regexp sequences
sequences.extras splitting ;
IN: aoc-2023.day02

: known-color ( color-phrases regexp -- n )
! "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" R/ \d+ red/ -- 4
  all-matching-subseqs [ 0 ] [
    [ split-words first string>number ] map-supremum
  ] if-empty
;

: line>known-rgb ( str -- game-id known-rgb )
! "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" -- 1 { 4 2 6 }
  ": " split1 [ split-words last string>number ] dip
  R/ \d+ red/ R/ \d+ green/ R/ \d+ blue/
  [ known-color ] tri-curry@ tri 3array
;

: possible? ( known-rgb test-rgb -- ? )
! { 4 2 6 } { 12 13 4 } -- f
  v<= [ ] all?
;

: part1 ( -- )
  "vocab:aoc-2023/day02/input.txt" utf8 file-lines
  [ line>known-rgb 2array ]
  [ last { 12 13 14 } possible? ] map-filter
  [ first ] map-sum .
;

: part2 ( -- )
  "vocab:aoc-2023/day02/input.txt" utf8 file-lines
  [ line>known-rgb nip product ] map-sum .
;

MAIN: [ part1 part2 ]
