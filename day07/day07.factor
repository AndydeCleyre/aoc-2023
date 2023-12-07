#!/usr/bin/env factor

USING: arrays assocs combinators.short-circuit.smart
io.encodings.utf8 io.files kernel math math.order math.parser
math.statistics prettyprint sequences sets sorting splitting ;
IN: aoc-2023.day07

! hand: "A23A4"
! card: 'Q'
! hand-bid: { "A23A4" 220 }

: card-key ( ch -- n ) "23456789TJQKA" index ;

: five-kind?  ( hand -- ? ) cardinality 1 = ;
: four-kind?  ( hand -- ? ) sorted-histogram last last 4 = ;
: full-house? ( hand -- ? ) sorted-histogram { [ last last 3 = ] [ length 2 = ] } && ;
: three-kind? ( hand -- ? ) sorted-histogram { [ last last 3 = ] [ length 3 = ] } && ;
: two-pair?   ( hand -- ? ) sorted-histogram { [ last last 2 = ] [ length 3 = ] } && ;
: one-pair?   ( hand -- ? ) sorted-histogram { [ last last 2 = ] [ length 4 = ] } && ;
: high-card?  ( hand -- ? ) cardinality 5 = ;

: type-key ( hand -- n )
  [ 0 ] dip                          ! n hand
  { [ high-card? ] [ one-pair? ] [ two-pair? ] [ three-kind? ] [ full-house? ] [ four-kind? ] [ five-kind? ] }
  [ dup empty? ] [                   ! n hand checks
    unclip pick swap call( h -- ? )  ! n hand checks t/f
    [ drop f ] [ [ 1 + ] 2dip ] if   ! n hand checks/f
  ] until 2drop                      ! n
;

: hand-compare ( hand1 hand2 -- <=> )             ! "77888" "77788"
  2dup [ type-key ] compare                       ! hand1 hand2 +gt+/+eq+/+lt+
  dup +eq+ = [                                    ! hand1 hand2 +eq+
    drop zip [ first2 [ card-key ] compare ] map  ! { +eq+ +eq+ +gt+ +eq+ +eq+ }
    { +eq+ } without ?first                       ! +gt+/f
    dup [ drop +eq+ ] unless                      ! +eq+
  ] [ [ 2drop ] dip ] if                          ! +gt+/+eq+/+lt+
;

: input>hand-bids ( -- hand-bids )
  "vocab:aoc-2023/day07/input.txt" utf8 file-lines
  [ " " split1 string>number 2array ] map
;

: part1 ( -- )
  input>hand-bids [ [ first ] bi@ hand-compare ] sort-with  ! hand-bids
  [ 1 + swap last * ] map-index sum .
;

! : part2 ( -- )
! ;

! MAIN: [ part1 part2 ]
