; -*- mode: lisp; package: tiny-segmenter -*-

;;; tiny-segmenter/util.l
;;
;; Copyright (c) 2008 MIYAMUKO Katsuyuki.
;;
;; tiny-segmenter is released under an MIT license.
;; See tiny-segmenter/docs/MIT-LICENSE for full license.
;;

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "tiny-segmenter/package")
  )

(in-package :tiny-segmenter)

(defun buffer-content (buffer)
  (let ((org (selected-buffer)))
    (unwind-protect
        (progn
          (set-buffer buffer)
          (buffer-substring (point-min) (point-max)))
      (set-buffer org))))

(defun stream-content (stream)
  (let ((s (make-vector 4096 :element-type 'character :fill-pointer 0)))
    (with-output-to-string (out)
      (while (read-into s stream nil)
        (princ s out)))))


(provide "tiny-segmenter/util")

;;; End
