USING: io.encodings.utf8 io.files kernel math.parser sequences ;
IN: aoc-2023

: input-path ( daynum -- txtpath )         ! 1
  number>string 2 CHAR: 0 pad-head         ! "01"
  "day" swap append                        ! "day01"
  "vocab:aoc-2023/" "/input.txt" surround  ! "vocab:aoc-2023/day01/input.txt"
;

: day-lines ( daynum -- lineseq )
  input-path utf8 file-lines
;

: day-text ( daynum -- contentstr )
  input-path utf8 file-contents
;
