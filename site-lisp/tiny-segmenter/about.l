; -*- mode: lisp; package: tiny-segmenter -*-

;;; tiny-segmenter/about.l
;;
;; Copyright (c) 2008 Taku Kudo <taku@chasen.org>
;; Copyright (c) 2008 MIYAMUKO Katsuyuki <miyamuko@gmail.com>.
;;
;; tiny-segmenter is freely distributable under the terms of a new BSD licence.
;; For details, see http://chasen.org/~taku/software/TinySegmenter/LICENCE.txt
;;

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "tiny-segmenter/package")
  )

(in-package :tiny-segmenter)

(export '(tiny-segmenter-version
          ))

(defconstant +tiny-segmenter-version+ "1.1.0")

(defun tiny-segmenter-version ()
  +tiny-segmenter-version+)


(provide "tiny-segmenter/about")

;;; End
