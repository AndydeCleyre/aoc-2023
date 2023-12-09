#!/usr/bin/env factor

USING: arrays assocs io.encodings.utf8 io.files kernel math
prettyprint sequences splitting ;
IN: aoc-2023.day08

! instructions: "LLR"
! direction: 'L'/'R'
! branch: { "AAA" { "BBB" "ZZZ" } }
! from/dest: "AAA"

: input>data ( -- instructions branches )
  "vocab:aoc-2023/day08/input.txt" utf8 file-lines
  unclip swap harvest
  [
    ")( ,=" split harvest
    unclip swap 2array
  ] map
;

: step ( from direction branches -- dest )
  swapd at swap CHAR: L = [ first ] [ last ] if
;

: next-direction ( n instructions -- direction )
  dup length '[ _ mod ] dip nth
;

: part1 ( -- )
  0 input>data                    ! n-steps instructions branches
  [ 2dup next-direction ] dip     ! n-steps instructions direction branches
  "AAA" [ dup "ZZZ" = ] [         ! n-steps instructions direction branches current
    2over                         ! n-steps instructions direction branches current direction branches
    step [ drop ] 2dip            ! n-steps instructions branches dest
    [ 1 + ] 3dip                  ! n-steps instructions branches dest
    [ 2dup next-direction ] 2dip  ! n-steps instructions direction branches dest
  ] until 4drop .
;

! : part2 ( -- ) ;

! MAIN: [ part1 part2 ]
