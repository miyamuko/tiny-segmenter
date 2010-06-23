; -*- mode: lisp; package: tiny-segmenter -*-

;;; tiny-segmenter/buffer.l
;;
;; Copyright (c) 2010 MIYAMUKO Katsuyuki <miyamuko@gmail.com>.
;;
;; tiny-segmenter is freely distributable under the terms of a new BSD licence.
;; For details, see http://chasen.org/~taku/software/TinySegmenter/LICENCE.txt
;;

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "tiny-segmenter/package")
  (require "tiny-segmenter/segmenter")
  )

(in-package :tiny-segmenter)

(export '(following-segment
          preceding-segment
          segment-before
          segment-after
          ))

(defun following-segment ()
  (segment-after (point) :buffe (selected-buffer)))

(defun preceding-segment ()
  (segment-before (point) :buffe (selected-buffer)))

(defun segment-before (&optional (point (point)) &key (buffer (selected-buffer)))
  (segment-at point :before t :buffer buffer))

(defun segment-after (&optional (point (point)) &key (buffer (selected-buffer)))
  (segment-at point :before nil :buffer buffer))

(defun segment-at (point &key before buffer)
  (save-excursion
    (goto-char point)
    (let ((segment-w/-points (let ((end (bol-point)))
                               (mapcar #'(lambda (seg)
                                           (let ((begin end))
                                             (incf end (length seg))
                                             (list seg begin end)))
                                       (segment (buffer-line-at buffer point))))))
      (let ((segment (find-if #'(lambda (seg/beg/end)
                                  (multiple-value-bind (_ beg end)
                                      (values-list seg/beg/end)
                                    (if before
                                        (and (< beg point) (<= point end))
                                      (and (<= beg point) (< point end)))))
                              segment-w/-points)))
        (when segment
          (values-list segment))))))


(provide "tiny-segmenter/buffer")

;;; End
