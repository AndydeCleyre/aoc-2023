#!/usr/bin/env factor

USING: assocs io.encodings.utf8 io.files kernel math math.parser
prettyprint ranges sequences sequences.extras splitting ;
IN: aoc-2023.day06

! race: { time record-distance }

: input>data ( -- races )
  "vocab:aoc-2023/day06/input.txt" utf8 file-lines       ! { "Time:      7  15   30" "Distance:  9  40  200" }
  [ ": " split harvest rest [ string>number ] map ] map  ! { { 7 15 30 } { 9 40 200 } }
  first2 zip                                             ! { { 7 9 } { 15 40 } { 30 200 } }
;

: go ( press-ms total-time -- distance )  ! 3 7 -- 12
  over - *
;

: beats-record? ( press-ms race -- ? )
  [ first go ] keep last >
;

: ways-to-beat ( race -- n )  ! { 7 9 }
  dup first [1..b)            ! { 7 9 } [1..6]
  [                           ! { 7 9 } 1
    over beats-record?        ! { 7 9 } f
  ] map [ ] count nip         ! 4
;

: part1 ( -- )
  input>data [ ways-to-beat ] map-product .
;

: input>big-race ( -- race )
  "vocab:aoc-2023/day06/input.txt" utf8 file-lines               ! { "Time:      7  15   30" "Distance:  9  40  200" }
  [ ":" split1 nip [ CHAR: space = ] reject string>number ] map  ! { 71530 940200 }
;

: part2 ( -- )
  input>big-race ways-to-beat .
;

MAIN: [ part1 part2 ]
