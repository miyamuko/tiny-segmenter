; -*- mode: lisp; package: user -*-

;;; tiny-segmenter/package.l
;;
;; Copyright (c) 2008 Taku Kudo <taku@chasen.org>
;; Copyright (c) 2008 MIYAMUKO Katsuyuki <miyamuko@gmail.com>.
;;
;; tiny-segmenter is freely distributable under the terms of a new BSD licence.
;; For details, see http://chasen.org/~taku/software/TinySegmenter/LICENCE.txt
;;

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :tiny-segmenter)
    (defpackage :tiny-segmenter
      (:nicknames :ts)
      (:use
       :lisp
       :editor
       ))))


(provide "tiny-segmenter/package")

;;; End
