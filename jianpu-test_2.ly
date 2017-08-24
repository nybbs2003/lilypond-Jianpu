\version "2.18.2"
\language "english"

global = {
  \key f\major
  \time 4/4
}
\include "jianpu10a.ly"

notes = { 
  c'1 f'2( g') g'2~g'2~g'2. r4  bf'1~bf'2 c''2 |\break
  d'8~d'8 e'8.~e'16 \tuplet 3/2{f'8~ f'8~ f'8} \tuplet 3/2{g'16 r16 g'16} r8 r1  |\break
  f'4~f'2 r4 f'2~f'4 g'4 a'4 a'4~ a'4 \tuplet 3/2{bf'8 a'8 g'8} 
}
  
<< 
  \new JianpuStaff \jianpuMusic { \global \notes }
  \new Staff { \global \notes }
>> 



