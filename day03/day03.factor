#!/usr/bin/env factor

USING: arrays io.encodings.utf8 io.files kernel make math
math.intervals math.parser prettyprint sequences
sequences.extras splitting unicode ;
IN: aoc-2023.day03

: symbol-indices ( line -- seq )                        ! "*..$.*..7."
  [ ".0123456789" member? not ] find-all [ first ] map  ! { 0 3 5 }
;

: num-spans ( line -- seq )                                ! ".664.598.."
  >array [ over digit? [ nip ] [ 2drop f ] if ] map-index  ! { f 1 2 3 f 5 7 }
  { f } split harvest                                      ! { { 1 2 3 } { 5 7 } }
  [ [ first ] [ last ] bi 2array ] map                     ! { { 1 3 } { 5 7 } }
;

: adjacent? ( num-span symbol-indices -- ? )  ! { 1 3 } { 3 5 7 }
  swap [ first 1 - ] [ last 1 + ] bi [a,b]    ! { 3 5 7 } [0,4]
  '[ _ interval-contains? ] any?              ! t
;

: part-numbers ( line nearby-symbol-indices -- seq )  ! ".664.598.." { 0 5 6 }
  [ dup num-spans ] dip                               ! ".664.598.." { { 1 3 } { 5 7 } } { 0 5 6 }
  '[ _ adjacent? ] filter                             ! ".664.598.." { { 1 3 } { 5 7 } }
  swap '[ first2 1 + _ subseq string>number ] map     ! { 664 598 }
;

: part1 ( -- )
  "vocab:aoc-2023/day03/input.txt" utf8 file-lines             ! lines
  [ [ symbol-indices ] map ] keep                              ! lines-symbol-idxs lines
  [                                                            ! lines-symbol-idxs line line#
    pick swap [ 1 - ?nth-of ] [ nth-of ] [ 1 + ?nth-of ] 2tri  ! lines-symbol-idxs line prev-sym-idxs cur-sym-idxs next-sym-idxs
    3append part-numbers sum                                   ! lines-symbol-idxs line-parts-sum
  ] map-index sum nip .                                        ! total .
;

: star-indices ( line -- seq )          ! ".*.$.*...*"
  [ CHAR: * = ] find-all [ first ] map  ! { 1 5 9 }
;

: gears ( line prev-line next-line -- seq-of-pairs )        ! ".*.$*.*..." ".........." ".664.598..455"
  pick star-indices                                         ! ".*.$*.*..." ".........." ".664.598..455" { 1 4 6 }
  [ 1array '[ _ part-numbers ] [ 3dup ] dip tri@ 3append ]  ! ".*.$*.*..." ".........." ".664.598..455" { { 664 } { 664 598 } { 598 } }
  [ length 2 = ] map-filter [ 3drop ] dip                   ! { { 664 598 } }
;

: part2 ( -- )
  "vocab:aoc-2023/day03/input.txt" utf8 file-lines  ! lines
  dup [                                             ! lines line i
    pick swap [ 1 - ?nth-of ] [ 1 + ?nth-of ] 2bi   ! lines line prev next
    gears [ product ] map-sum                       ! lines line-ratio-sum
  ] map-index sum nip .                             ! total .
;

MAIN: [ part1 part2 ]
