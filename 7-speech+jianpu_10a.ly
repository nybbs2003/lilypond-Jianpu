
\version "2.18.2"
\language "english"


\include "jianpu10a.ly"

\header {
  title = "十架七言"
  subtitle = "7 speech"
  % Remove default LilyPond tagline
  tagline = ##f
}

\paper {
  #(set-paper-size "letter")
}

\layout {
  \context {
    \Voice
    \consists "Melody_engraver"
    \override Stem #'neutral-direction = #'()
  }
}

globald = {
  \key d \major
  \numericTimeSignature
  \time 3/4
  \tempo 4=100
}


\include "include_lyndon-specific.ly"

melodyd =   {  
   
  fs'2. | %m01
  e'2 a'8. g'16 |%m002
  fs'4 fs'2 |%m03
  d'4 d''4 cs''8.( b'16) %m04
  a'2 b'8. g'16 |\break %m05
  fs'2 e'8 fs'8 |%m06
  e'8 b8 d'2 |%m07
  a'4 fs'2 |%m08
  e'4 fs'4  a'8( g'8) |%m09
  fs'2 d''4 | \break %m10
  cs''8( d''8) e''8( d''8) cs''8( b'8) |%m11
  a'2. |%m12
  d'4 d''2 |%m13
  d''4 cs''4 b'8 a'8 |%m14
  fs'2. |\break %m15
  d'4 b'2 |%m16
  b'4 a'4 g'8 fs'8 |%m17
  e'2 a'8( g'8) |%m18
  fs'2 fs'8( e'8) |%m19
  d'2 d''8( cs''8) |\break %m20
  b'2 b'8( a'8) |%m21
  g'2 fs'4 |%m22
  e'8 d' cs'( e') cs'( d') |%m23
  b2. |%m24
  b2 cs'8( e'16 d'16) | \break %m25
  b2 \tuplet 3/2{g'8( b'  g')} |%m26
  fs'2 r4 |%m27
  fs'8 fs'4~8 r4 |%m28
  b'4 a'8( g'8) fs'4 |%m29
  e'8 d' cs' e' d' cs' |  %m30
  b2. \bar"|."
  
}




verse = \lyricmode {
  父 啊! 赦 免 他 們, 因 為 他 們 所 作 的, 他 們 不 曉 得. 
  %{我 實 在 告 訴 你, %} 今 日 你 要 同 我 在 樂 園 裡 了. 
  母 親 看 你 的 兒 子, (門 徒) 看 你 的 母 親. 
  我 的 神 哪! 我 的 神 哪! 為 甚 麽 離 棄 我!
  我 渴 了!
  成 了!
  父 啊! 我 將 我 靈 魂 交 在 祢 手 裡.
  
}
sk = \tag "SK" {\skip1}
verseSK = \lyricmode {
  父 \sk \sk 啊! \sk 赦 免 他 們, \sk  因 為 他 們 \sk  所 作 的, \sk  他 們 不 曉 得. \sk  
  %{我 實 在 告 訴 你, %} 今 日 \sk  你 要 同 我 \sk  在 樂 園 裡 了. \sk  \sk  
  母 親 \sk  看 你 的 兒 子, \sk  \sk  (門 徒) \sk  看 你 的 母 親. \sk    
  我 的 \sk  神 哪! \sk  我 的 \sk  神 哪! \sk  為 甚 麽 離 棄 我! \sk  \sk 
  我 \sk  渴 了! \sk 
  成 了! \sk  \sk 
  父 啊! \sk  我 將 我 靈 魂 交 在 祢 手 裡.
}
verseSolfege = \lyricmode {
  父2 啊!2 赦8. 免16 他4 們,2 因4 為4 他8.~16 們2 所8. 作16 的,2 他8 們8 不8 曉8 得.2 
  %{我 實 在 告 訴 你, %} 今4 日2 你4 要4 同8~8 我2 在4 樂8~8 園8~8 裡8~8 了.2. 
  母4 親2 看4 你4 的8 兒8 子.2. (門4 徒)2 看4 你4 的8 母8 親.2 
  我8~8 的2 神8~8 哪!2 我8~8 的2 神8~8 哪!2 為4 甚8 麽8~8 離8~8 棄8~8  我2.
  我2  渴8~16~16 了!2
  成\tuplet3/2{8( 8 8)} 了2 s4
  父8 啊!4~8 s4 我4 將8~8 我4 靈8 魂8 交8 在8 祢8 手8 裡2.
}
verseJ = \lyricmode {
  父 \skip1 \skip1 啊! \skip1 赦 免 他 們, \skip1  因 為 他 們 \skip1  所 作 的, \skip1  他 們 不 曉 得. \skip1  
  %{我 實 在 告 訴 你, %} 今 日 \skip1  你 要 同 我 \skip1  在 樂 園 裡 了. \skip1  \skip1  
  母 親 \skip1  看 你 的 兒 子, \skip1  \skip1  (門 徒) \skip1  看 你 的 母 親. \skip1    
  我 的 \skip1  神 哪! \skip1  我 的 \skip1  神 哪! \skip1  為 甚 麽 離 棄 我! \skip1  \skip1 
  我 \skip1  渴 了! \skip1 
  成 了! \skip1  \skip1 
  父 啊! \skip1  我 將 我 靈 魂 交 在 祢 手 裡.
  
}


\score { 
  <<  
  
  \new JianpuStaff \jianpuMusic \new Voice = solfege { \globald \melodyd }
  \new Lyrics \keepWithTag "SK" \lyricsto solfege {     \verseSK    }
  \new Staff  \new Voice = number    { \globald \melodyd }
  \new Lyrics \removeWithTag "SK" \lyricsto number {  \verseSK } 
  >>
  \layout { }
  %\midi { }
}

\book {
  \bookOutputSuffix "midi"
 \score { 
  <<  
    %\jianpuVoice
    %\new JianpuStaff \jianpuMusic         {  \globald \melodyd }
      
    %\new ChordNames \chordNames
    \new Staff     { \globald \melodyd }
    %\addlyrics { \verse }
  >>
  %\layout { }
  \midi { }
 }
}

