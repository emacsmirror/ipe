;;; ipe-test-other.el --- Insert Pair Edit - Other Tests -*- lexical-binding: t; -*-
;; Copyright (C) 2024 Brian Kavanagh

;; Author: Brian Kavanagh <brians.emacs@gmail.com>
;; Maintainer: Brian Kavanagh <brians.emacs@gmail.com>
;; Created: 28 June, 2020
;; Version: 1.1
;; Package: ipe
;; Keywords: internal local
;; Homepage: https://github.com/BriansEmacs/insert-pair-edit.el

;; -------------------------------------------------------------------
;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this programe.  If not, see
;; <https://www.gnu.org/licenses/>.

;; -------------------------------------------------------------------
;;; Commentary:
;;
;; This file defines a set of `ert' (Emacs Regression Test)s for the
;; `ipe' (Insert Pair Edit) package.
;;
;; These tests are all defined using the `ipe-test-def-kbd' macro
;; (See `ipe-test.el'), which is used to test the interactive
;; functions within `ipe-edit-mode' by executing a set of keystrokes
;; against a buffer containing text, and comparing the result (both
;; output text, and cursor positions) with an 'expected' output.
;;
;; The tests within this file are used to test miscellaneous 'Insert
;; Pair Edit' processing not performed specifically in the other
;; 'categorised' ERT test files.

;; -------------------------------------------------------------------
;;; Code:

(require 'ert)
(require 'ipe-test)

(defvar ipe-test-other-options
  '((ipe-move-point-on-insert   nil)
    (ipe-prefix-moves-close-p   t)
    (ipe-edit--movement-keysets '(modifiers))
    (ipe-update-forward-first-p nil)
    (ipe-delete-action          'delete)
    (ipe-pairs
     '(("(" "(" ")")
       ("<" "<" ">")
       ("`" "`" "'"     (:movement char))
       ("{" "{" "}"     (:movement word))
       ("[" "[" "]"     (:movement line))
       ("/" "/**" " */" (:movement line :infix " * "))))
    (ipe-mode-pairs nil))
  "Options used by `ipe-test-def-kbd' for `ipe-test-other'.")

(ipe-test-def-kbd other-replace-1 ()
  "Test `ipe-insert-pair-edit-replace'.

Using a 'word PAIR -> 'word PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown <|fox> jumps over the lazy dog."
  "M-( ( ( < RET")

(ipe-test-def-kbd other-replace-2 ()
  "Test `ipe-insert-pair-edit-replace' changing movement unit.

Using a 'char PAIR -> 'word PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown {|fox} jumps over the lazy dog."
  "M-( ` ( { RET")

(ipe-test-def-kbd other-replace-3 ()
  "Test `ipe-insert-pair-edit-replace' changing movement unit.

Using a 'char PAIR -> 'line PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "[The quick brown |fox jumps over the lazy dog.]"
  "M-( { ( [ RET")

(ipe-test-def-kbd other-replace-4 ()
  "Test `ipe-insert-pair-edit-replace' changing movement unit.

Using a 'word PAIR -> 'char PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown `|fox' jumps over the lazy dog."
  "M-( { ( ` RET")

(ipe-test-def-kbd other-replace-5 ()
  "Test `ipe-insert-pair-edit-replace' changing movement unit.

Using a 'line PAIR -> 'word PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "{The quick brown |fox jumps over the lazy dog}."
  "M-( [ ( { RET")

(ipe-test-def-kbd other-replace-6 ()
  "Test `ipe-insert-pair-edit-replace' changing movement unit.

Using a 'line PAIR -> 'char PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "`The quick brown |fox jumps over the lazy dog.'"
  "M-( [ ( ` RET")

(ipe-test-def-kbd other-replace-7 ()
  "Test `ipe-insert-pair-edit-replace'."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown [|fox] jumps over the lazy dog."
  "M-( ( RET C-u C-u C-u M-( ( [ RET")

(ipe-test-def-kbd other-replace-8 ()
  "Test `ipe-insert-pair-edit-replace'."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown `|fox' jumps over the lazy dog."
  "M-( ( RET C-u C-u C-u M-( ( ` RET")

(ipe-test-def-kbd other-double-insert-1 ()
  "Test `ipe-insert-pair-edit' inserting two pairs.

Using a 'word PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown ((|fox)) jumps over the lazy dog."
  "M-( ( RET M-( ( RET")

(ipe-test-def-kbd other-double-insert-2 ()
  "Test `ipe-insert-pair-edit' inserting two different pairs.

Using a 'word PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown (<|fox>) jumps over the lazy dog."
  "M-( ( RET M-( < RET")

(ipe-test-def-kbd other-triple-insert ()
  "Test `ipe-insert-pair-edit' inserting three pairs.

Using a 'word PAIR."
  ipe-test-other-options
  nil
  "The quick brown |fox jumps over the lazy dog."
  "The quick brown (<(|fox)>) jumps over the lazy dog."
  "M-( ( RET M-( < RET M-( ( RET")

(ipe-test-def-kbd other-infix-update ()
  "Test `ipe-insert-pair-edit' updating an :infix PAIR.

Using a 'line PAIR."
  ipe-test-other-options
  nil
  '("|The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog.")
  '("|The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog.")
  "M-( / C-n C-n RET C-u M-( / C-d")

(ipe-test-def-kbd other-infix-replace ()
  "Test `ipe-insert-pair-edit' replacing an :infix PAIR.

Using a 'line PAIR and a 'word PAIR."
  ipe-test-other-options
  nil
  '("|The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog.")
  '("(|The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog."
    "The quick brown fox jumps over the lazy dog.)")
  "M-( / C-n C-n RET C-u C-u C-u M-( / ( RET")

(ipe-test-def-kbd other-change-movement-prefix-1 ()
  "Test changing to `ipe-edit--movement-by-char'.

From a 'line PAIR with a prefix / postfix string."
  ipe-test-other-options
  nil
  '("    ["
    "        |The quick brown fox jumps over the lazy dog."
    "    ]")
  '("|The quick brown fox jumps over the lazy dog.")
  "C-u M-( [ m c C-d")

(ipe-test-def-kbd other-change-movement-prefix-2 ()
  "Test changing to `ipe-edit--movement-by-word'.

From a 'line PAIR with a prefix / postfix string."
  ipe-test-other-options
  nil
  '("    ["
    "        |The quick brown fox jumps over the lazy dog."
    "    ]")
  '("|The quick brown fox jumps over the lazy dog.")
  "C-u M-( [ m w C-d")

(ipe-test-def-kbd other-change-movement-prefix-3 ()
  "Test changing to `ipe-edit--movement-by-line'.

From a 'word PAIR."
  ipe-test-other-options
  nil
  "|The quick brown fox {jumps} over the lazy dog."
  "|{The quick brown fox jumps over the lazy dog.}"
  "C-u M-( { m l RET")

(ipe-test-def-kbd other-change-movement-prefix-4 ()
  "Test changing to `ipe-edit--movement-by-line'.

From a 'char PAIR."
  ipe-test-other-options
  nil
  "|The quick brown `'fox jumps over the lazy dog."
  "|`The quick brown fox jumps over the lazy dog.'"
  "C-u M-( ` m l RET")

(when (>= emacs-major-version 26)
  (ipe-test-def-kbd other-undo-1 ()
    "Test `ipe-insert-pair-edit' undo.

Using multiple:

- C-s (`ipe-edit--next-pair')
- C-r (`ipe-edit--previous-pair')

calls."
    ipe-test-other-options
    nil
    '("|The quick brown fox (jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog.")
    '("The quick brown fox |(jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog.")
    "C-u M-( ( C-s C-s C-r C-r RET C-/")

  (ipe-test-def-kbd other-undo-2 ()
    "Test `ipe-insert-pair-edit' undo.

Using:

- M-u (`ipe-edit--contents-upcase')
- M-c (`ipe-edit--contents-capitalize')
- %   (`ipe-edit--contents-replace')

calls."
    ipe-test-other-options
    nil
    '("|The quick brown fox (jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog.")
    '("The quick brown fox |(jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog."
      "The quick brown fox (jumps) over the lazy dog.")
    "C-u M-( ( M-u C-s M-c C-s % x C-a C-k test RET RET C-/"))

(provide 'ipe-test-other)

;;; ipe-test-other.el ends here
