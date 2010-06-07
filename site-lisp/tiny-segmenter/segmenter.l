; -*- mode: lisp; package: tiny-segmenter -*-

;;; tiny-segmenter/segmenter.l
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
  (require "tiny-segmenter/model")
  (require "tiny-segmenter/util")
  )

(in-package :tiny-segmenter)

(export '(segment
          segmenter-segment-all
          segmenter-segment-next
          segmenter-segment-partial
          make-segmenter
          ))

(defparameter *patterns*
  (mapcar #'(lambda (pair)
              (cons (compile-regexp (car pair)) (cdr pair)))
          '(("[ˆê“ñOlŒÜ˜Zµ”ª‹ã\•Sç–œ‰­’›]" . "M")
            ("[ˆê-êXYƒ•ƒ–]" . "H")
            ("[‚Ÿ-‚ñ]" . "I")
            ("[ƒ@-ƒ”[±-İŞ°]" . "K")
            ("[a-zA-Z‚-‚š‚`-‚y]" . "A")
            ("[0-9‚O-‚X]" . "N")
            )))

(defun ctype (str)
  (or (cdr (find-if #'(lambda (pattern)
                        (string-match (car pattern) str))
                    *patterns*))
      "O"))

(defmacro ts (v)
  `(or ,v 0))

(defmacro setl ((&rest binds) lst)
  `(multiple-value-setq (,@binds)
     (values-list ,lst)))



(defun segment (input)
  (segmenter-segment-all (make-segmenter input)))


(defun segmenter-segment-next (segmenter)
  (funcall segmenter))

(defun segmenter-segment-all (segmenter)
  (let (w result)
    (while (setf w (funcall segmenter))
      (push w result))
    (nreverse result)))

(defun segmenter-segment-partial (segmenter n)
  (let (w result)
    (dotimes (i n)
      (when (setf w (funcall segmenter))
        (push w result)))
    (nreverse result)))


(defun make-segmenter (input)
  (cond ((bufferp input) (make-buffer-segmenter input))
        ((streamp input) (make-stream-segmenter input))
        ((stringp input) (make-string-segmenter input))
        ((null input) nil)
        (t
         (error 'type-error
                :datum input
                :expected-type '(or buffer stream string)))))

(defun make-buffer-segmenter (input)
  (make-string-segmenter (buffer-content input)))

(defun make-stream-segmenter (input)
  (make-string-segmenter (stream-content input)))

(defun make-string-segmenter (input)
  (if (and input (string/= input ""))
      (make-segmenter0 input)
    #'(lambda () nil)))

(defun make-segmenter0 (str)
  (let (seg ctype)
    (dotimes (i (length str))
      (let ((c (string (char str i))))
        (push c seg)
        (push (ctype c) ctype)))
    (setf seg (append '("B3" "B2" "B1") (nreverse seg) '("E1" "E2" "E3")))
    (setf ctype (append '("O" "O" "O") (nreverse ctype) '("O" "O" "O")))
    (let ((word (nth 3 seg))
          (p1 "U") (p2 "U") (p3 "U")
          (i 4) result)
      #'(lambda ()
          (loop
            (if (not (< i (- (length seg) 3)))
                (let ((w word))
                  (setf word nil)
                  (return w))
              (let ((score *BIAS*)
                    w1 w2 w3 w4 w5 w6
                    c1 c2 c3 c4 c5 c6)
                (setl (w1 w2 w3 w4 w5 w6) (subseq seg (- i 3) (+ i 3)))
                (setl (c1 c2 c3 c4 c5 c6) (subseq ctype (- i 3) (+ i 3)))

                (incf score (ts (gethash p1 *UP1*)))
                (incf score (ts (gethash p2 *UP2*)))
                (incf score (ts (gethash p3 *UP3*)))
                (incf score (ts (gethash (concat p1 p2) *BP1*)))
                (incf score (ts (gethash (concat p2 p3) *BP2*)))
                (incf score (ts (gethash w1 *UW1*)))
                (incf score (ts (gethash w2 *UW2*)))
                (incf score (ts (gethash w3 *UW3*)))
                (incf score (ts (gethash w4 *UW4*)))
                (incf score (ts (gethash w5 *UW5*)))
                (incf score (ts (gethash w6 *UW6*)))
                (incf score (ts (gethash (concat w2 w3) *BW1*)))
                (incf score (ts (gethash (concat w3 w4) *BW2*)))
                (incf score (ts (gethash (concat w4 w5) *BW3*)))
                (incf score (ts (gethash (concat w1 w2 w3) *TW1*)))
                (incf score (ts (gethash (concat w2 w3 w4) *TW2*)))
                (incf score (ts (gethash (concat w3 w4 w5) *TW3*)))
                (incf score (ts (gethash (concat w4 w5 w6) *TW4*)))
                (incf score (ts (gethash c1 *UC1*)))
                (incf score (ts (gethash c2 *UC2*)))
                (incf score (ts (gethash c3 *UC3*)))
                (incf score (ts (gethash c4 *UC4*)))
                (incf score (ts (gethash c5 *UC5*)))
                (incf score (ts (gethash c6 *UC6*)))
                (incf score (ts (gethash (concat c2 c3) *BC1*)))
                (incf score (ts (gethash (concat c3 c4) *BC2*)))
                (incf score (ts (gethash (concat c4 c5) *BC3*)))
                (incf score (ts (gethash (concat c1 c2 c3) *TC1*)))
                (incf score (ts (gethash (concat c2 c3 c4) *TC2*)))
                (incf score (ts (gethash (concat c3 c4 c5) *TC3*)))
                (incf score (ts (gethash (concat c4 c5 c6) *TC4*)))
                ;(incf score (ts (gethash (concat c4 c5 c6) *TC5*)))
                (incf score (ts (gethash (concat p1 c1) *UQ1*)))
                (incf score (ts (gethash (concat p2 c2) *UQ2*)))
                (incf score (ts (gethash (concat p3 c3) *UQ1*)))
                (incf score (ts (gethash (concat p2 c2 c3) *BQ1*)))
                (incf score (ts (gethash (concat p2 c3 c4) *BQ2*)))
                (incf score (ts (gethash (concat p3 c2 c3) *BQ3*)))
                (incf score (ts (gethash (concat p3 c3 c4) *BQ4*)))
                (incf score (ts (gethash (concat p2 c1 c2 c3) *TQ1*)))
                (incf score (ts (gethash (concat p2 c2 c3 c4) *TQ2*)))
                (incf score (ts (gethash (concat p3 c1 c2 c3) *TQ3*)))
                (incf score (ts (gethash (concat p3 c2 c3 c4) *TQ4*)))

                (let ((p "O")
                      w)
                  (when (> score 0)
                    (setf w word)
                    (setf word ""
                          p "B"))
                  (setf p1 p2 p2 p3 p3 p)
                  (setf word (concat word (nth i seg)))
                  (incf i)
                  (when w
                    (return w))))))))))

(provide "tiny-segmenter/segmenter")


;;; End
