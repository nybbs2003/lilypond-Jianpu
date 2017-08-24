\version "2.18.2"
\language "english"
\include "jianpu10a.ly"
global = {
  \key bf \major
  \time 4/4
  \partial 4.
  \tempo 4=100
}
SS➉   = { d'8 ef'8 e'8 |}  
SS➀   = { f'2~f'8 bf'8 c''8 bf'8 |}
SS➁   = { bf'4 c'4. df'8 ef'8 f'8 |}  
soprano = {
  \global
  \SS➉ \SS➀ \SS➁
}

\score {
  <<
    \new JianpuStaff \jianpuMusic   { \soprano }

    \new Staff \soprano
  >>
  \layout { } 
  %\midi { }
}

