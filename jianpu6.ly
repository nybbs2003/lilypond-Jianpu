\version "2.18.2"
% also works with 2.19.x and later

#(define (get-keysig-alt-count alt-alist)
   "Return number of sharps/flats in key sig, (+) for sharps, (-) for flats."
   (if (null? alt-alist)
       0
       (* (length alt-alist) 2 (cdr (car alt-alist)))))

#(define (get-major-tonic alt-count)
   "Return number of the tonic note 0-6, as if the key sig were major."
   ;; (alt-count major-tonic)
   ;; (-7 0) (-5 1) (-3 2) (-1 3) (1 4) (3 5) (5 6) (7 0)
   ;; (-6 4) (-4 5) (-2 6) (0 0) (2 1) (4 2) (6 3)
   (if (odd? alt-count)
       (modulo (- (/ (+ alt-count 1) 2) 4) 7)
       (modulo (/ alt-count 2) 7)))

#(define (add-dash-right stencil)
   "For half notes and whole notes, adds a dash to the right of the stencil."
   (ly:stencil-combine-at-edge stencil X RIGHT
     (ly:stencil-translate
      (make-connected-path-stencil
       '((1 0))
       0.3 1 1 #f #f)
      (cons 0 1))
     1))

#(define (add-dot direction stencil)
   "For adding octave dots above and below notes."
   (ly:stencil-combine-at-edge stencil Y direction
     (ly:stencil-translate
      (make-circle-stencil 0.3 0 #t)
      (cons 0.5 0))
     1))

#(define (add-flag-dash stencil)
   "For adding dashes below 8th notes and shorter notes."
   (ly:stencil-combine-at-edge stencil Y DOWN
     (ly:stencil-translate
      (make-connected-path-stencil
       '((1 0))
       0.3 1 1 #f #f)
      (cons 0 0))
     0.5))

#(define (get-key-alts context)
   "Needed because LilyPond 2.19 and 2.20 has 'keyAlterations
    and 2.18 has 'keySignature for the same context property.
    No way to test for existence of context property..."
   (define key-alts (ly:context-property context 'keyAlterations '()))
   (if (equal? key-alts '())
       (ly:context-property context 'keySignature '())
       key-alts))


#(define Jianpu_rest_engraver
   (make-engraver
    (acknowledgers
     ((rest-interface engraver grob source-engraver)
      ;; make sure \omit is not in effect (stencil is not #f)
      (if (ly:grob-property-data grob 'stencil)
          (let* ((stencil-a
                  (grob-interpret-markup grob (markup #:musicglyph "zero")))

                 ;; add duration dashes to the rest, to the right or below
                 (dur-log (ly:grob-property grob 'duration-log))
                 (stencil-b (case dur-log
                              ((0) (add-dash-right (add-dash-right (add-dash-right stencil-a))))
                              ((1) (add-dash-right stencil-a))
                              ((2) stencil-a)
                              ((3) (add-flag-dash stencil-a))
                              ((4) (add-flag-dash (add-flag-dash stencil-a)))
                              ((5) (add-flag-dash (add-flag-dash (add-flag-dash stencil-a))))
                              ((6) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash stencil-a)))))
                              ((7) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash (add-flag-dash stencil-a))))))
                              (else stencil-a))) )

            ;; (display dur-log) (newline)

            (ly:grob-set-property! grob 'stencil stencil-b)
            (ly:grob-set-property! grob 'X-extent
              (ly:stencil-extent (ly:grob-property grob 'stencil) X))
            (ly:grob-set-property! grob 'Y-extent
              (ly:stencil-extent (ly:grob-property grob 'stencil) Y))
            ))))))

#(define Jianpu.style  "solfege")
#(define Jianpu_note_head_engraver
   (make-engraver
    (acknowledgers
     ((note-head-interface engraver grob source-engraver)
      ;; make sure \omit is not in effect (stencil is not #f)
      (if (ly:grob-property-data grob 'stencil)
          (let* ((staff-context (ly:translator-context engraver))
                 ;; (tonic-pitch (ly:context-property staff-context 'tonic))
                 ;; (tonic-number (ly:pitch-notename tonic-pitch))
                 (stem-grob (ly:grob-object grob 'stem))
                 (flag-grob (ly:grob-object stem-grob 'flag))

                 ;; start with a number stencil based on the scale degree of the note
                 (key-alts (get-key-alts staff-context))
                 (keysig-alt-count (get-keysig-alt-count key-alts))
                 (major-tonic-number (get-major-tonic keysig-alt-count))
                 (grob-pitch (ly:event-property (event-cause grob) 'pitch))
                 (note-number (ly:pitch-notename grob-pitch))
                 (key-relative-note-number (modulo (- note-number major-tonic-number) 7))
                 (jianpu-number (+ 1 key-relative-note-number))
                  (solfege-string (case jianpu-number
                                 ((1) "do")
                                 ((2) "re")
                                 ((3) "mi")
                                 ((4) "fa")
                                 ((5) "so")
                                 ((6) "la")
                                 ((7) "to")
                                 (else "0")))
                 (glyph-string (case jianpu-number
                                 ((1) "one")
                                 ((2) "two")
                                 ((3) "three")
                                 ((4) "four")
                                 ((5) "five")
                                 ((6) "six")
                                 ((7) "seven")
                                 (else "zero")))
                 (stencil-a (grob-interpret-markup grob
                              (if (string= Jianpu.style "numbered")
                              (markup #:musicglyph glyph-string)
                              (if (string= Jianpu.style "solfege")
                              (markup solfege-string) 
                              ()))))

                 ;; TODO: handle dotted notes
                 ;; but how to access dots grob from note head grob?
                 ;; (note-column-grob (ly:grob-parent stem-grob Y))
                 ;; (note-column-grob (ly:grob-parent stem-grob X))
                 ;; these don't work:
                 ;; (vert-axis-group-grob (ly:grob-object note-column-grob 'vertical-axis-group))
                 ;; (vert-axis-group-grob (ly:grob-parent note-column-grob X))
                 ;; (paper-column-grob (ly:grob-object note-column-grob 'paper-column))

                 ;; TODO: use some kind of looping, iteration, recursion, fold function, etc.
                 ;; instead of hard-coding the repetitions of stencil-modifying functions

                 ;; add duration dashes to right of half note and whole note
                 (dur-log (ly:grob-property grob 'duration-log))
                 (stencil-b (case dur-log
                              ((0) (add-dash-right (add-dash-right (add-dash-right stencil-a))))
                              ((1) (add-dash-right stencil-a))
                              ((2) stencil-a)
                              (else stencil-a)))

                 ;; add duration dashes below 8th notes and shorter
                 (flag-glyph-name
                  (if (ly:grob? flag-grob)
                      (ly:grob-property flag-grob 'glyph-name)
                      ""))
                 (flag-num (cond
                            ((string= flag-glyph-name "flags.u3") 1)
                            ((string= flag-glyph-name "flags.u4") 2)
                            ((string= flag-glyph-name "flags.u5") 3)
                            ((string= flag-glyph-name "flags.u6") 4)
                            ((string= flag-glyph-name "flags.u7") 5)
                            (else 0)))
                 (stencil-c (case flag-num
                              ((0) stencil-b)
                              ((1) (add-flag-dash stencil-b))
                              ((2) (add-flag-dash (add-flag-dash stencil-b)))
                              ((3) (add-flag-dash (add-flag-dash (add-flag-dash stencil-b))))
                              ((4) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash stencil-b)))))
                              ((5) (add-flag-dash (add-flag-dash (add-flag-dash
                                                                  (add-flag-dash (add-flag-dash stencil-b))))))
                              (else stencil-b)))

                 ;; add octave dots above or below the stencil.
                 ;; Not the absolute octave but the key-relative octave,
                 ;; Jianpu octave goes up between 7 and 1, not between b and c.
                 ;; Take current grob-pitch and transpose it down to the tonic pitch of the current
                 ;; key (as if it were major), which gives the correct octave for the octave dots.
                 (octave
                  (ly:pitch-octave
                   (ly:pitch-transpose grob-pitch
                     (ly:make-pitch 0 (* -1 key-relative-note-number) 0)
                     )))
                 (stencil-d (case octave
                              ((3) (add-dot UP (add-dot UP (add-dot UP stencil-c))))
                              ((2) (add-dot UP (add-dot UP stencil-c)))
                              ((1) (add-dot UP stencil-c))
                              ((0) stencil-c)
                              ((-1) (add-dot DOWN stencil-c))
                              ((-2) (add-dot DOWN (add-dot DOWN stencil-c)))
                              ((-3) (add-dot DOWN (add-dot DOWN (add-dot DOWN stencil-c))))
                              (else stencil-c))) )
            ;; (display octave)(newline)
            ;; set the stencil for the note head grob
            (ly:grob-set-property! grob 'stencil stencil-d)
            ))))))


#(define Jianpu_accidental_engraver
   (make-engraver
    (acknowledgers
     ((accidental-interface engraver grob source-engraver)
      (let*
       ((context (ly:translator-context engraver))
        (key-alts (get-key-alts context))
        (alt (accidental-interface::calc-alteration grob))
        (note-head-grob (ly:grob-parent grob Y))
        (pitch (ly:event-property
                (ly:grob-property note-head-grob 'cause)
                'pitch))
        (note-number (ly:pitch-notename pitch))
        ;; default alteration of this note, in the key, as if there were no accidental sign
        (default (or (assoc-ref key-alts note-number) 0))
        (new-alt
         (cond

          ;; natural sign: convert to sharp or flat (the opposite of the sharps
          ;; or flats in the key signature) if natural is not in the key
          ((and (= alt 0) (not (= alt default)))
           (* -1 (cdr (car key-alts))))

          ;; single sharp sign: convert to natural if sharp is in key
          ((and (= alt 1/2) (= 1/2 default)) 0)

          ;; single flat sign: convert to natural if flat is in key
          ((and (= alt -1/2) (= -1/2 default)) 0)

          ;; single sharp sign: convert to double sharp if natural (and sharp) is not in key
          ((and (= alt 1/2) (not (= 0 default))) 1)

          ;; single flat sign: convert to double flat if natural (and flat) is not in key
          ((and (= alt -1/2) (not (= 0 default))) -1)

          ;; double sharp sign: convert to single if single sharp is in the key
          ((and (= alt 1) (= 1/2 default)) 1/2)

          ;; double flat sign: convert to single if single flat is in the key
          ((and (= alt -1) (= -1/2 default)) -1/2)

          ;; there are no triple sharp or triple flat glyphs,
          ;; so these are needed but don't work:
          ;; double sharp sign: convert to triple sharp if single flat is in the key
          ;; ((and (= alt 1) (= -1/2 default))
          ;; (ly:grob-set-property! grob 'alteration 3/2))
          ;; double flat sign: convert to triple flat if single sharp is in the key
          ;; ((and (= alt -1) (= -1/2 default))
          ;; (ly:grob-set-property! grob 'alteration -3/2))

          (else #f))))
       ;; (display default)(newline)
       (if new-alt (ly:grob-set-property! grob 'alteration new-alt))
       )))))


% Custom "JianpuStaff" Context

\layout {
  \context {
    % \Staff lets us start with all standard staff settings
    \Staff
    % \name gives the custom staff context its name
    \name JianpuStaff
    % \alias Staff tells LilyPond that commands that work on a standard
    % Staff context should also work with this custom context
    \alias Staff
    % customizations
    \consists \Jianpu_note_head_engraver
    \consists \Jianpu_rest_engraver
    \consists \Jianpu_accidental_engraver
    \override KeySignature.transparent = ##t 
    \override KeyCancellation.transparent = ##t 
    \override Clef.stencil = ##f
    \override StaffSymbol.line-count = #0
    \override BarLine.bar-extent = #'(-2 . 2)
    \override TimeSignature.style = #'numbered
    \override Stem.transparent = ##t
    \override Stem.length = #0
    \override Rest.Y-offset = #-1
    \override NoteHead.Y-offset = #-1
    \override Beam.transparent = ##t
    \override Stem.direction = #DOWN
    \override Beam.beam-thickness = #0
    \override Beam.length-fraction = #0
    \override Tie.staff-position = #2.5
    \override TupletBracket.bracket-visibility = ##t
    \slurUp
    \tupletUp
    \hide Stem
    \hide Beam
  }
  % define the "parent" contexts that will accept the custom context
  \context { \Score \accepts JianpuStaff }
  \context { \ChoirStaff \accepts JianpuStaff }
  \context { \GrandStaff \accepts JianpuStaff }
  \context { \PianoStaff \accepts JianpuStaff }
  \context { \StaffGroup \accepts JianpuStaff }
}

% Define Custom Staff for MIDI
% to avoid warnings it has to be defined for each type of output desired
\midi {
  \context {
    \Staff
    \name JianpuStaff
    \alias Staff
  }
  % since the customizations are for visual output only,
  % there is no need to include them for midi
  \context { \Score      \accepts JianpuStaff }
  \context { \ChoirStaff \accepts JianpuStaff }
  \context { \GrandStaff \accepts JianpuStaff }
  \context { \PianoStaff \accepts JianpuStaff }
  \context { \StaffGroup \accepts JianpuStaff }
}


