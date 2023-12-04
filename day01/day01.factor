#!/usr/bin/env factor

USING: arrays assocs assocs.extras io.encodings.utf8 io.files
kernel make math math.parser prettyprint sequences sorting
unicode ;
IN: aoc-2023.day01

: part1 ( -- )
  "vocab:aoc-2023/day01/input.txt" utf8 file-lines
  [
    [ [ digit? ] find nip ]
    [ [ digit? ] find-last nip ] bi
    2array string>number
  ] map-sum .
;

CONSTANT: digit-words H{
  { "one" CHAR: 1 } { "two" CHAR: 2 } { "three" CHAR: 3 }
  { "four" CHAR: 4 } { "five" CHAR: 5 } { "six" CHAR: 6 }
  { "seven" CHAR: 7 } { "eight" CHAR: 8 } { "nine" CHAR: 9 }
}

: first-digit-char ( str -- num-char/f i/f )
  [ digit? ] find swap
;

: last-digit-char ( str -- num-char/f i/f )
  [ digit? ] find-last swap
;

: first-digit-word ( str -- num-char/f )  ! "abcone"
  [
    digit-words keys [                    ! "abcone" "one"
      2dup subseq-index                   ! "abcone" "one" 3
      dup [                               ! "abcone" "one" 3
        [ digit-words at ] dip            ! "abcone" '1' 3
        ,,                                ! "abcone"
      ] [ 2drop ] if                      ! "abcone"
    ] each drop                           !
  ] H{ } make                             ! H{ { 3 '1' } { 7 '3' } }
  [ f ] [
    sort-keys first last
  ] if-assoc-empty
;

: last-digit-word ( str -- num-char/f )   ! "threexyz"
  reverse                                 ! "zyxeerht"
  [
    digit-words keys [                    ! "zyxeerht" "three"
      reverse                             ! "zyxeerht" "eerht"
      2dup subseq-index                   ! "zyxeerht" "eerht" 3
      dup [                               ! "zyxeerht" "eerht" 3
        [ reverse digit-words at ] dip    ! "zyxeerht" '3' 3
        ,,                                ! "zyxeerht"
      ] [ 2drop ] if                      ! "zyxeerht"
    ] each drop                           !
  ] H{ } make
  [ f ] [
    sort-keys first last
  ] if-assoc-empty
;

: first-digit ( str -- num-char )  ! "abcone2threexyz"
  dup first-digit-char dup [       ! "abcone2threexyz" '2' 6
    pick 2dup swap head nip        ! "abcone2threexyz" '2' 6 "abcone"
    first-digit-word dup [         ! "abcone2threexyz" '2' 6 '1'
      [ 2drop ] dip                ! "abcone2threexyz" '1'
    ] [ 2drop ] if                 ! "abcone2threexyz" '2'
    nip
  ] [                              ! "abcone2threexyz" f f
    2drop first-digit-word
  ] if
;

: last-digit ( str -- num-char )   ! "abcone2threexyz"
  dup last-digit-char dup [        ! "abcone2threexyz" '2' 6
    pick 2dup swap 1 + tail nip    ! "abcone2threexyz" '2' 6 "threexyz"
    last-digit-word dup [          ! "abcone2threexyz" '2' 6 '7'
      [ 2drop ] dip                ! "abcone2threexyz" '7'
    ] [ 2drop ] if                 ! "abcone2threexyz" '2'
    nip
  ] [                              ! "abcone2threexyz" f f
    2drop last-digit-word
  ] if
;

: part2 ( -- )
  "vocab:aoc-2023/day01/input.txt" utf8 file-lines
  [ [ first-digit ] [ last-digit ] bi 2array string>number ] map-sum .
;

MAIN: [ part1 part2 ]
