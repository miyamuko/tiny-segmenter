; -*- mode: lisp; package: tiny-segmenter -*-

;;; tiny-segmenter/util.l
;;
;; Copyright (c) 2008,2010 MIYAMUKO Katsuyuki.
;;
;; tiny-segmenter is released under an MIT license.
;; See tiny-segmenter/docs/MIT-LICENSE for full license.
;;

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "tiny-segmenter/package")
  )

(in-package :tiny-segmenter)

(defmacro with-selected-buffer (buffer &body body)
  (let ((org (gensym)))
    `(if (eq ,buffer (selected-buffer))
         (progn ,@body)
       (let ((,org (selected-buffer)))
         (unwind-protect
             (with-set-buffer
               (set-buffer ,buffer)
               (progn ,@body))
           (set-buffer ,org))))))
#+xyzzy
(setf (get 'with-selected-buffer 'ed::lisp-indent-hook) 'with-selected-window)

(defun buffer-content (buffer)
  (with-selected-buffer buffer
    (buffer-substring (point-min) (point-max))))

(defun buffer-line-at (buffer point)
  (with-selected-buffer buffer
    (goto-char point)
    (buffer-substring (bol-point) (eol-point))))

(defun bol-point ()
  (goto-bol)
  (point))

(defun eol-point ()
  (goto-eol)
  (point))

(defun stream-content (stream)
  (let ((s (make-vector 4096 :element-type 'character :fill-pointer 0)))
    (with-output-to-string (out)
      (while (read-into s stream nil)
        (princ s out)))))


(provide "tiny-segmenter/util")

;;; End
