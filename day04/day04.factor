#!/usr/bin/env factor

USING: io.encodings.utf8 io.files kernel math math.parser
prettyprint ranges sequences sets splitting ;
IN: aoc-2023.day04

: line>cards ( line -- winning-nums player-nums )  ! "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
  ":|" split rest                                  ! { "41 48 83 86 17 " " 83 86  6 31 17  9 48 53" }
  [                                                ! "41 48 83 86 17 "
    [ CHAR: space = ] trim                         ! "41 48 83 86 17"
    split-words harvest [ string>number ] map      ! { 41 48 83 86 17 }
  ] map first2                                     ! { 41 48 83 86 17 } { 83 86 6 31 17 9 48 53 }
;

: points ( winning-nums player-nums -- n )  ! { 41 48 83 86 17 } { 83 86 6 31 17 9 48 53 }
  intersect length                          ! 4
  dup 0 > [ 1 - 2^ ] when                   ! 8
;

: part1 ( -- )
  "vocab:aoc-2023/day04/input.txt" utf8 file-lines
  [ line>cards points ] map-sum .
;

: follow-card ( i commons -- n )  ! 0 { 2 1 0 }
  [ 1 ] 2dip                      ! 1 0 { 2 1 0 }
  2dup nth swapd                  ! 1 { 2 1 0 } 0 2
  over + (a..b]                   ! 1 { 2 1 0 } [1..2]
  [ over follow-card ] map-sum    ! 1 { 2 1 0 } 3
  nip +                           ! 4
;

: part2 ( -- )
  "vocab:aoc-2023/day04/input.txt" utf8 file-lines  ! lines
  [ line>cards intersect length ] map               ! { 2 1 0 }
  dup length <iota> swap '[ _ follow-card ]         ! [0..2] [ { 2 1 0 } follow-card ]
  map-sum .                                         ! 7
;

MAIN: [ part1 part2 ]
