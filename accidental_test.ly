\version "2.18.2"
\include "jianpu10a.ly"
\language "english"

test_a={
  cf'8 c'8 cs'8 c'8 df'8 d'8 ds'8 d'8 
  ef'8 e'8 es'8 e'8 ff'8 f'8 fs'8 f'8 
  gf'8 g'8 gs'8 g'8 af'8 a'8 as'8 a'8
  bf'8 b'8 bs'8 b'8 r2 \bar "|"
}

\new JianpuStaff{
  \jianpuMusic{
    \key c \major
    {
      \test_a
    }
   \key df\major{
     \transpose c df { \test_a }
   }
   \key d\major{
     \transpose c d { \test_a }
   }
   \key ds\major{
     \transpose c ds { \test_a }
   }
   \key ef\major{
     \transpose c ef { \test_a }
   }
   \key e\major{
     \transpose c e { \test_a }
   }
   \key es\major{
     \transpose c es { \test_a }
   }
   \key ff\major{
     \transpose c ff { \test_a }
   }
   \key f\major{
     \transpose c f { \test_a }
   }
   \key fs\major{
     \transpose c fs { \test_a }
   }
   \key gf\major{
     \transpose c gf { \test_a }
   }
   \key g\major{
     \transpose c g { \test_a }
   }
   \key gs\major{
     \transpose c gs { \test_a }
   }
   \key af\major{
     \transpose c af { \test_a }
   }
   \key a\major{
     \transpose c a { \test_a }
   }
   \key as\major{
     \transpose c as { \test_a }
   }
   \key bf\major{
     \transpose c bf { \test_a }
   }
   \key b \major{
     \transpose c b { \test_a }
   }
   \key bs\major{
     \transpose c bs { \test_a }
   }
  }
}