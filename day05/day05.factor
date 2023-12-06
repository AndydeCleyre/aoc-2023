#!/usr/bin/env factor

USING: grouping io.encodings.utf8 io.files kernel math
math.intervals math.order math.parser prettyprint ranges
sequences sequences.extras splitting ;
IN: aoc-2023.day05

! map-line: { 0 15 37 }
! stage-map: { map-line ... }

: input>data ( -- seeds stage-maps )                             !
  "vocab:aoc-2023/day05/input.txt" utf8 file-lines               ! lines
  unclip ": " split1 nip split-words [ string>number ] map swap  ! seeds rest-lines
  [ ":" subseq-of? ] reject { "" } split harvest                 ! seeds seq-of-seqs-of-map-line-str
  [ [ split-words [ string>number ] map ] map ] map              ! seeds stage-maps
;

: line-hop ( n map-line -- n' )                ! 99 { 50 98 2 }
  [ dup ] dip                                  ! 99 99 { 50 98 2 }
  dup first2 - -rot                            ! 99 -48 99 { 50 98 2 }
  [ second ] [ second ] [ third ] tri + [a,b)  ! 99 -48 99 [98,99]
  interval-contains? [ + ] [ drop ] if         ! 51
;

: stage-hop ( n stage-map -- n' )      ! 53 { { 0 15 37 } { 37 52 2 } { 39 0 15 } }
  [ dup empty? not ] [                 ! 53 { { 0 15 37 } { 37 52 2 } { 39 0 15 } }
    [ dup ] dip unclip swapd line-hop  ! 53 { { 37 52 2 } { 39 0 15 } } 53
    dup reach =                        ! 53 { { 37 52 2 } { 39 0 15 } } 53 t
    [ drop ] [ [ 2drop ] dip f ] if    ! 53 { { 37 52 2 } { 39 0 15 } }
  ] while drop                         ! 38
;

: seed>location ( n stage-maps -- n' )
  [ stage-hop ] each
;

: solve ( seeds stage-maps -- n )
  '[ _ seed>location ] map-infimum
;

: part1 ( -- )
  input>data solve .
;

! --------------------
! -- Part 2, take 1 --
! --------------------

! -- fix-seeds runs out of memory during concat --

! : fix-seeds ( seeds -- seeds' )                               ! { 79 14 55 13 }
!   2 group                                                     ! { { 79 14 } { 55 13 } }
!   [ [ first ] [ first ] [ second ] tri + [a..b) ] map-concat  ! { 79 ... 92 55 ... 67 }
! ;

! : part2 ( -- ) input>data [ seed-ranges ] dip solve . ;

! --------------------
! -- Part 2, take 2 --
! --------------------

! -- solve hangs with huge seed seqs --

! : seed-ranges ( seeds -- ranges )                      ! { 79 14 55 13 }
!   2 group                                              ! { { 79 14 } { 55 13 } }
!   [ [ first ] [ first ] [ second ] tri + [a..b) ] map  ! { [79..92] [55..67] }
! ;

! : part2 ( -- ) input>data [ seed-ranges ] dip '[ _ solve ] map-infimum . ;

! --------------------
! -- Part 2, take 3 --
! --------------------

! -- solve-carefully hangs with the full input --

! : solve-carefully ( seeds-long stage-maps -- n )  ! seeds stage-maps
!   '[ _ seed>location ] [ unclip ] dip             ! eeds s [ stage-maps seed>location ]
!   [ call ] keep swapd                             ! min-loc eeds [ stage-maps seed>location ]
!   '[ @ min ] each                                 ! min-loc'
! ;

! : part2 ( -- )
!   input>data [ seed-ranges ] dip        ! ranges stage-maps
!   '[ _ solve-carefully ] map-infimum .
! ;

! MAIN: [ part1 part2 ]
