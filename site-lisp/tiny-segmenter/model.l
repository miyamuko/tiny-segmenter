; -*- mode: lisp; package: tiny-segmenter -*-

;;; tiny-segmenter/model.l
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

(defparameter *BIAS* -332)

(defparameter *BC1* (let ((h (make-hash-table :test #'equal :size 4))) (setf (gethash "II" h) 2461 (gethash "HH" h) 6 (gethash "OH" h) -1378 (gethash "KH" h) 406) h))
(defparameter *BC2* (let ((h (make-hash-table :test #'equal :size 17))) (setf (gethash "OO" h) -2920 (gethash "KK" h) -8741 (gethash "II" h) -1332 (gethash "HH" h) -4070 (gethash "AA" h) -3267 (gethash "IK" h) 1721 (gethash "IA" h) 1327 (gethash "AN" h) -878 (gethash "MH" h) -3132 (gethash "HM" h) -1711 (gethash "IO" h) 5492 (gethash "HN" h) 4012 (gethash "HO" h) 3761 (gethash "MK" h) 3334 (gethash "KI" h) 3831 (gethash "AI" h) 2744 (gethash "IH" h) -1184) h))
(defparameter *BC3* (let ((h (make-hash-table :test #'equal :size 11))) (setf (gethash "MM" h) 4034 (gethash "KK" h) 2762 (gethash "HH" h) 996 (gethash "HI" h) 626 (gethash "OH" h) 266 (gethash "HK" h) -721 (gethash "HN" h) -1307 (gethash "OA" h) -1652 (gethash "HO" h) -836 (gethash "MK" h) 1079 (gethash "IH" h) -301) h))
(defparameter *BP1* (let ((h (make-hash-table :test #'equal :size 4))) (setf (gethash "OO" h) -125 (gethash "BB" h) 295 (gethash "UB" h) 352 (gethash "OB" h) 304) h))
(defparameter *BP2* (let ((h (make-hash-table :test #'equal :size 2))) (setf (gethash "OO" h) -1762 (gethash "BO" h) 60) h))
(defparameter *BQ1* (let ((h (make-hash-table :test #'equal :size 14))) (setf (gethash "OKH" h) -1020 (gethash "BOO" h) -2597 (gethash "BII" h) -1158 (gethash "BHH" h) 1150 (gethash "OIH" h) -296 (gethash "OOO" h) 2965 (gethash "OKK" h) 904 (gethash "OKA" h) 1851 (gethash "OHI" h) 451 (gethash "BOH" h) -91 (gethash "BNH" h) 449 (gethash "BIM" h) 886 (gethash "BMH" h) 1208 (gethash "BHM" h) 1521) h))
(defparameter *BQ2* (let ((h (make-hash-table :test #'equal :size 10))) (setf (gethash "UHI" h) -1146 (gethash "BIH" h) -919 (gethash "BKK" h) -1720 (gethash "BHH" h) 118 (gethash "OIH" h) 153 (gethash "BHI" h) -1159 (gethash "OHH" h) -1139 (gethash "BKO" h) 864 (gethash "BHM" h) 466 (gethash "OHM" h) -181) h))
(defparameter *BQ3* (let ((h (make-hash-table :test #'equal :size 16))) (setf (gethash "BKI" h) 419 (gethash "OKH" h) 1798 (gethash "OKI" h) -793 (gethash "BNN" h) 998 (gethash "BMM" h) 8335 (gethash "BII" h) -299 (gethash "BHH" h) -792 (gethash "BHI" h) 2664 (gethash "OOO" h) 11699 (gethash "OII" h) 280 (gethash "OHH" h) 2174 (gethash "BOH" h) 775 (gethash "BMH" h) 937 (gethash "OKO" h) -2242 (gethash "OHM" h) 439 (gethash "OMH" h) -2402) h))
(defparameter *BQ4* (let ((h (make-hash-table :test #'equal :size 11))) (setf (gethash "OAH" h) 926 (gethash "BIH" h) 3761 (gethash "BOO" h) -12396 (gethash "BKK" h) -1806 (gethash "BII" h) -4654 (gethash "BHH" h) -3895 (gethash "ONN" h) -973 (gethash "OHH" h) 266 (gethash "BIK" h) 1348 (gethash "OHK" h) -2036 (gethash "BMI" h) -3385) h))
(defparameter *BW1* (let ((h (make-hash-table :test #'equal :size 71))) (setf (gethash "�ڎw" h) -724 (gethash "�Ȃ�" h) 7379 (gethash "����" h) 1104 (gethash "�Ă�" h) 805 (gethash "�A��" h) 660 (gethash "�Ȃ�" h) 5713 (gethash "����" h) 1743 (gethash "�a�P��" h) 542 (gethash "�̈�" h) -501 (gethash "����" h) 2083 (gethash "B1��" h) 1404 (gethash "���s" h) 2558 (gethash "����" h) -1336 (gethash "����" h) -4143 (gethash "�v��" h) 1682 (gethash "���" h) 1497 (gethash "����" h) -790 (gethash "����" h) -2113 (gethash "���" h) -913 (gethash "�Ȃ�" h) -1113 (gethash "�ɑ�" h) -912 (gethash "����" h) 1505 (gethash "�a�P��" h) 1404 (gethash "���" h) -2784 (gethash "���" h) -1947 (gethash ",��" h) 727 (gethash "����" h) -3399 (gethash "�ɂ�" h) 2468 (gethash "�܂�" h) -2155 (gethash "����" h) -2314 (gethash "����" h) -1262 (gethash "����" h) 601 (gethash "��" h) -802 (gethash "�S��" h) -1886 (gethash "�܂�" h) 1711 (gethash "�Ă�" h) 1249 (gethash "�傫" h) -2604 (gethash "�ł�" h) 3445 (gethash "����" h) -2055 (gethash "����" h) 3472 (gethash "����" h) 1977 (gethash "�̒�" h) 741 (gethash "����" h) -4817 (gethash "�A��" h) 727 (gethash "����" h) 2641 (gethash "�Ƃ�" h) -4915 (gethash "�{��" h) -2423 (gethash "����" h) -871 (gethash "�ɂ�" h) 1498 (gethash "�Ȃ�" h) 3015 (gethash "����" h) 1122 (gethash ",��" h) 660 (gethash "�ɂ�" h) 1671 (gethash "����" h) 4573 (gethash "�܂�" h) 2600 (gethash "���{" h) -195 (gethash "�ł�" h) 844 (gethash "����" h) 672 (gethash "���" h) -2565 (gethash "����" h) 1860 (gethash "�܂�" h) 2448 (gethash "����" h) 3463 (gethash "����" h) 731 (gethash "�ǂ�" h) 3887 (gethash "�ł�" h) 1127 (gethash "B1��" h) 542 (gethash "����" h) 665 (gethash "�Ƃ�" h) 1922 (gethash "�ꂽ" h) 2369 (gethash "�v��" h) 1682 (gethash "����" h) 600) h))
(defparameter *BW2* (let ((h (make-hash-table :test #'equal :size 120))) (setf (gethash "�ł�" h) -4761 (gethash "�\�\" h) -5730 (gethash "��" h) 728 (gethash "�茠" h) -1982 (gethash "�Ƃ�" h) 5168 (gethash "�R��" h) -1384 (gethash "���" h) -1375 (gethash "���}" h) 970 (gethash "����" h) -602 (gethash "�č�" h) -4268 (gethash "�ꂽ" h) 4270 (gethash "�Ȃ�" h) 3099 (gethash "����" h) -3198 (gethash "�܂�" h) -6621 (gethash "�{��" h) -2363 (gethash "����" h) 13168 (gethash "�o��" h) 2163 (gethash "�V��" h) -4066 (gethash "�|�|" h) -13175 (gethash "����" h) -662 (gethash "�ɑ�" h) -14943 (gethash "�j��" h) -601 (gethash "����" h) 4589 (gethash "����" h) -3857 (gethash "����" h) -913 (gethash "�͂�" h) 1073 (gethash "���" h) -4115 (gethash "����" h) -990 (gethash "����" h) 4533 (gethash "����" h) -786 (gethash "����" h) -7194 (gethash "�낤" h) 6067 (gethash "�ɏ]" h) -4688 (gethash "���" h) 849 (gethash "����" h) -1350 (gethash "����" h) 5078 (gethash "�Ȃ�" h) -2488 (gethash "����" h) 2230 (gethash "�ł�" h) 2666 (gethash ".." h) -11822 (gethash "�̂�" h) -7059 (gethash "�Ȃ�" h) -6509 (gethash "����" h) 4612 (gethash "����" h) -3977 (gethash "�Ƃ�" h) 1890 (gethash "�Ƃ�" h) -2279 (gethash "�ɂ�" h) 2454 (gethash "�߂�" h) -3153 (gethash "�͂�" h) -1033 (gethash "����" h) -1543 (gethash "���" h) -1897 (gethash "�̂�" h) -6041 (gethash "�{�l" h) -2697 (gethash "����" h) 1647 (gethash "����" h) -1253 (gethash "����" h) 1224 (gethash "�Ă�" h) 6144 (gethash "�Љ�" h) -1276 (gethash "11" h) -669 (gethash "����" h) -7758 (gethash "����" h) 1941 (gethash "����" h) -10713 (gethash "����" h) -2094 (gethash "�Ȃ�" h) 2614 (gethash "����" h) 972 (gethash "���" h) -1612 (gethash "�ψ�" h) -1250 (gethash "�ɂ�" h) -1615 (gethash "�N�x" h) -8669 (gethash "�炩" h) -944 (gethash "�N��" h) -1626 (gethash "�̂�" h) 2093 (gethash "�̂�" h) -6125 (gethash "�Ȃ�" h) -1313 (gethash "����" h) -1819 (gethash "���" h) 4114 (gethash "�ꕔ" h) -1051 (gethash "�Ƃ�" h) 720 (gethash "�ł�" h) -1528 (gethash "���" h) -2471 (gethash "����" h) 939 (gethash "����" h) -1050 (gethash "�P�P" h) -669 (gethash "���" h) -11877 (gethash "�ł�" h) -4203 (gethash "��l" h) 602 (gethash "����" h) -939 (gethash "�Ă�" h) -3110 (gethash "����" h) 853 (gethash "����" h) -1597 (gethash "�܂�" h) -1316 (gethash "����" h) -8392 (gethash "�Ƃ�" h) -3941 (gethash "����" h) -3744 (gethash "���N" h) -2355 (gethash "�Ă�" h) 3640 (gethash "���{" h) -7068 (gethash "����" h) -545 (gethash "�܂�" h) 5409 (gethash "�Ă�" h) -3065 (gethash "���V" h) -722 (gethash "�肵" h) 651 (gethash "�Ă�" h) 2551 (gethash "�Ƃ�" h) -1746 (gethash "�Ɋ�" h) -11388 (gethash "���" h) -1116 (gethash "����" h) -1609 (gethash "����" h) 3372 (gethash "�ɂ�" h) -7236 (gethash "���" h) 1620 (gethash "�オ" h) -4479 (gethash "�͂�" h) -2532 (gethash "�΂�" h) 1813 (gethash "����" h) -4193 (gethash "���" h) 7901 (gethash "���" h) 970 (gethash "�炵" h) -1611 (gethash "�ł�" h) -3828 (gethash "�ɂ�" h) 2748 (gethash "����" h) 2490) h))
(defparameter *BW3* (let ((h (make-hash-table :test #'equal :size 114))) (setf (gethash "�J��" h) 990 (gethash "���A" h) 974 (gethash "�s" h) 965 (gethash "����" h) 1232 (gethash "���" h) 3818 (gethash "�Ȃ�" h) 2135 (gethash "�Ȃ�" h) 1796 (gethash "�Ƃ�" h) 541 (gethash "����" h) 1527 (gethash "����" h) 1449 (gethash "�Ă�" h) 6240 (gethash "����" h) -669 (gethash "����" h) -2064 (gethash "����" h) 1645 (gethash "�V��" h) -5055 (gethash "�Ƃ�" h) -3543 (gethash "����" h) -2194 (gethash "���" h) 2217 (gethash "�ǂ�" h) 4664 (gethash "����" h) -2757 (gethash "����" h) -594 (gethash "����" h) 7397 (gethash "����" h) 1004 (gethash "����" h) 1117 (gethash "��," h) 1816 (gethash "���A" h) 3426 (gethash "����" h) -3714 (gethash "����" h) 2079 (gethash "�Љ�" h) 2024 (gethash "��," h) 854 (gethash "��," h) -724 (gethash "����" h) 1454 (gethash "����" h) 2608 (gethash "���" h) 1091 (gethash "���" h) 1375 (gethash "�܂�" h) -1549 (gethash "����" h) 300 (gethash "���B" h) 2857 (gethash "��." h) 8875 (gethash "���B" h) -1185 (gethash "����" h) 6521 (gethash "����" h) 1200 (gethash "���" h) 6820 (gethash "�ɂ�" h) 1906 (gethash "�ɂ�" h) 1771 (gethash "��," h) 1557 (gethash "����" h) 2056 (gethash "�Ă�" h) 302 (gethash "����" h) 812 (gethash "�Ă�" h) 855 (gethash "����" h) 1542 (gethash "��." h) -1310 (gethash "����" h) 719 (gethash "�炵" h) 1479 (gethash "�܂�" h) -793 (gethash "�܂�" h) 6154 (gethash "����" h) -714 (gethash "����" h) 3846 (gethash "�n��" h) 1681 (gethash "��." h) -1185 (gethash "�ł�" h) -1482 (gethash "����" h) 1374 (gethash "���A" h) 1557 (gethash "���B" h) 8875 (gethash "����" h) -4098 (gethash "����" h) 3029 (gethash "�ł�" h) 1437 (gethash "��" h) 606 (gethash "�܂�" h) 1113 (gethash "����" h) 1883 (gethash "����" h) 6520 (gethash "����" h) 4798 (gethash "����" h) -743 (gethash "���A" h) 1816 (gethash "�Ȃ�" h) -903 (gethash "����" h) -2670 (gethash "����" h) 3562 (gethash "�܂�" h) 6943 (gethash "�́A" h) 1337 (gethash "��," h) 1337 (gethash "�́A" h) -724 (gethash "�ɂ�" h) 2644 (gethash "�ɁA" h) -1021 (gethash "����" h) 976 (gethash "�J��" h) 990 (gethash "�ׂ�" h) 2181 (gethash "�Ƃ�" h) 2266 (gethash "�ł�" h) 2295 (gethash "����" h) -4855 (gethash "��." h) 4098 (gethash "��c" h) 860 (gethash "��A" h) 854 (gethash "��," h) -1021 (gethash "�Ƃ�" h) -1387 (gethash "����" h) 5600 (gethash "��," h) 3426 (gethash "��," h) 974 (gethash "���" h) -3246 (gethash "�̎q" h) -1000 (gethash "����" h) -4748 (gethash "���B" h) 4098 (gethash "��." h) 2857 (gethash "�ꂽ" h) 1850 (gethash "���B" h) -1310 (gethash "����" h) -1183 (gethash "����" h) 841 (gethash "����" h) -913 (gethash "����" h) 428 (gethash "���" h) 798 (gethash "���" h) -605 (gethash "����" h) -4977 (gethash "����" h) -1127 (gethash "����" h) 5308 (gethash "����" h) -853) h))
(defparameter *TC1* (let ((h (make-hash-table :test #'equal :size 12))) (setf (gethash "HOH" h) -390 (gethash "AAA" h) 1093 (gethash "IOH" h) -142 (gethash "HHM" h) 580 (gethash "IOI" h) -1015 (gethash "HOM" h) -331 (gethash "IOM" h) 467 (gethash "MMH" h) 187 (gethash "HII" h) 998 (gethash "HHH" h) 1029 (gethash "OOI" h) -1832 (gethash "IHI" h) 1169) h))
(defparameter *TC2* (let ((h (make-hash-table :test #'equal :size 6))) (setf (gethash "OII" h) -2649 (gethash "HHO" h) 2088 (gethash "KKH" h) 703 (gethash "HMM" h) -1154 (gethash "HII" h) -1023 (gethash "IHI" h) -1965) h))
(defparameter *TC3* (let ((h (make-hash-table :test #'equal :size 23))) (setf (gethash "OHO" h) -3393 (gethash "KHH" h) -1216 (gethash "KKA" h) 491 (gethash "HOH" h) -1486 (gethash "AAA" h) -294 (gethash "MHH" h) -2694 (gethash "IIM" h) -1035 (gethash "IOI" h) -542 (gethash "NNO" h) 662 (gethash "IHO" h) -1935 (gethash "MHM" h) -457 (gethash "KOK" h) -1009 (gethash "NNH" h) -1689 (gethash "MMH" h) -471 (gethash "KKH" h) -1217 (gethash "IIH" h) -825 (gethash "HII" h) -1088 (gethash "HHH" h) 346 (gethash "MHO" h) 123 (gethash "IHH" h) 128 (gethash "HHI" h) -341 (gethash "IHI" h) -3041 (gethash "HIK" h) 731) h))
(defparameter *TC4* (let ((h (make-hash-table :test #'equal :size 23))) (setf (gethash "MOM" h) 841 (gethash "KKK" h) 3065 (gethash "HHK" h) 365 (gethash "KKA" h) 3386 (gethash "HOH" h) 446 (gethash "MMM" h) 661 (gethash "MHH" h) -405 (gethash "HHM" h) -122 (gethash "MHI" h) 201 (gethash "HHN" h) 182 (gethash "IIO" h) 656 (gethash "HHO" h) 669 (gethash "IHO" h) -2324 (gethash "HIH" h) 804 (gethash "MMH" h) -241 (gethash "IIH" h) 321 (gethash "HII" h) 679 (gethash "HHH" h) -203 (gethash "IOO" h) 54 (gethash "III" h) 1497 (gethash "IHH" h) 695 (gethash "HHI" h) 1344 (gethash "KAK" h) 4845) h))
(defparameter *TQ1* (let ((h (make-hash-table :test #'equal :size 13))) (setf (gethash "BNHH" h) -744 (gethash "OHIH" h) 249 (gethash "BOOO" h) -908 (gethash "BOHH" h) 225 (gethash "OIIH" h) -68 (gethash "OHHH" h) 281 (gethash "OIHI" h) 200 (gethash "BHIH" h) -132 (gethash "BHHH" h) -227 (gethash "OAKK" h) 482 (gethash "BIII" h) 1595 (gethash "BIHH" h) 60 (gethash "BHHI" h) 316) h))
(defparameter *TQ2* (let ((h (make-hash-table :test #'equal :size 4))) (setf (gethash "BOOO" h) -5591 (gethash "BIII" h) -1033 (gethash "BIHH" h) -1401 (gethash "BKAK" h) -543) h))
(defparameter *TQ3* (let ((h (make-hash-table :test #'equal :size 20))) (setf (gethash "OKKA" h) 679 (gethash "BHHM" h) -1073 (gethash "BMHI" h) -863 (gethash "OIIH" h) 1344 (gethash "OHII" h) 997 (gethash "OHHH" h) 346 (gethash "OOII" h) -685 (gethash "OOHH" h) 110 (gethash "OIHH" h) 623 (gethash "OHHI" h) 1729 (gethash "BMHM" h) -464 (gethash "BHIH" h) 222 (gethash "BIIH" h) -116 (gethash "BHII" h) -504 (gethash "BHHH" h) 478 (gethash "BIII" h) -105 (gethash "BOMH" h) 620 (gethash "OHMH" h) 481 (gethash "OKHH" h) 587 (gethash "OKAK" h) 2792) h))
(defparameter *TQ4* (let ((h (make-hash-table :test #'equal :size 16))) (setf (gethash "OHHO" h) 480 (gethash "BHHM" h) -3604 (gethash "OHIH" h) -1573 (gethash "OIIH" h) 626 (gethash "OHHH" h) -294 (gethash "OIII" h) -4007 (gethash "OIHH" h) 1935 (gethash "OHHI" h) 2446 (gethash "OIHI" h) -493 (gethash "BIIH" h) -607 (gethash "BHII" h) -966 (gethash "BHHH" h) -721 (gethash "OAKK" h) 180 (gethash "OAAA" h) -2763 (gethash "BIII" h) -2181 (gethash "OKAK" h) -8156) h))
(defparameter *TW1* (let ((h (make-hash-table :test #'equal :size 2))) (setf (gethash "�ɂ�" h) -4681 (gethash "�����s" h) 2026) h))
(defparameter *TW2* (let ((h (make-hash-table :test #'equal :size 16))) (setf (gethash "���߂�" h) -1512 (gethash "��C��" h) -792 (gethash "������" h) -8097 (gethash "�Ƃ���" h) -4517 (gethash "���̌�" h) -4430 (gethash "������" h) -1256 (gethash "�Ƃ���" h) -4657 (gethash "�Ă���" h) 1833 (gethash "���傤" h) 3873 (gethash "���̂�" h) 1882 (gethash "�����" h) -2049 (gethash "�Љ�}" h) -3216 (gethash "�΂���" h) -2721 (gethash "�傫��" h) -1255 (gethash "������" h) -1049 (gethash "���낪" h) -2434) h))
(defparameter *TW3* (let ((h (make-hash-table :test #'equal :size 11))) (setf (gethash "�̂���" h) -600 (gethash "�̂ŁA" h) -727 (gethash "������" h) -1734 (gethash "�ɂƂ�" h) -5989 (gethash "�ɂ�" h) -5483 (gethash "�Ƃ���" h) -4314 (gethash "���Ă�" h) 1314 (gethash "�̂�," h) -727 (gethash "�ɓ���" h) -6247 (gethash "�\��" h) -2287 (gethash "�ꂩ��" h) -3752) h))
(defparameter *TW4* (let ((h (make-hash-table :test #'equal :size 12))) (setf (gethash "�܂���" h) 1097 (gethash "�܂���" h) 5543 (gethash "����." h) 8576 (gethash "�Ă���" h) 1538 (gethash "�����B" h) 8576 (gethash "�悤��" h) -4258 (gethash "�Ƃ���" h) 1349 (gethash "�����A" h) 1516 (gethash "���Ă�" h) 2958 (gethash "����" h) 5865 (gethash "�����" h) -2348 (gethash "����," h) 1516) h))
(defparameter *UC1* (let ((h (make-hash-table :test #'equal :size 4))) (setf (gethash "K" h) 93 (gethash "A" h) 484 (gethash "M" h) 645 (gethash "O" h) -505) h))
(defparameter *UC2* (let ((h (make-hash-table :test #'equal :size 6))) (setf (gethash "A" h) 819 (gethash "M" h) 3987 (gethash "N" h) 5775 (gethash "O" h) 646 (gethash "H" h) 1059 (gethash "I" h) 409) h))
(defparameter *UC3* (let ((h (make-hash-table :test #'equal :size 2))) (setf (gethash "A" h) -1370 (gethash "I" h) 2311) h))
(defparameter *UC4* (let ((h (make-hash-table :test #'equal :size 7))) (setf (gethash "K" h) -3450 (gethash "A" h) -2643 (gethash "M" h) 3565 (gethash "N" h) 3876 (gethash "O" h) 6646 (gethash "H" h) 1809 (gethash "I" h) -1032) h))
(defparameter *UC5* (let ((h (make-hash-table :test #'equal :size 5))) (setf (gethash "K" h) -799 (gethash "M" h) 539 (gethash "O" h) -831 (gethash "H" h) 313 (gethash "I" h) -1238) h))
(defparameter *UC6* (let ((h (make-hash-table :test #'equal :size 5))) (setf (gethash "K" h) 87 (gethash "M" h) 247 (gethash "O" h) -387 (gethash "H" h) -506 (gethash "I" h) -253) h))
(defparameter *UP1* (let ((h (make-hash-table :test #'equal :size 1))) (setf (gethash "O" h) -214) h))
(defparameter *UP2* (let ((h (make-hash-table :test #'equal :size 2))) (setf (gethash "B" h) 69 (gethash "O" h) 935) h))
(defparameter *UP3* (let ((h (make-hash-table :test #'equal :size 1))) (setf (gethash "B" h) 189) h))
(defparameter *UQ1* (let ((h (make-hash-table :test #'equal :size 9))) (setf (gethash "OO" h) -2422 (gethash "BN" h) 142 (gethash "BO" h) -56 (gethash "OH" h) -95 (gethash "OI" h) 477 (gethash "OK" h) 410 (gethash "BH" h) 21 (gethash "BI" h) -12 (gethash "BK" h) -99) h))
(defparameter *UQ2* (let ((h (make-hash-table :test #'equal :size 3))) (setf (gethash "OK" h) 1759 (gethash "BH" h) 216 (gethash "BI" h) 113) h))
(defparameter *UQ3* (let ((h (make-hash-table :test #'equal :size 9))) (setf (gethash "BM" h) 3160 (gethash "BN" h) 6427 (gethash "BO" h) 14761 (gethash "OI" h) -827 (gethash "BH" h) 42 (gethash "BI" h) 1913 (gethash "ON" h) -3212 (gethash "BK" h) -7198 (gethash "BA" h) -479) h))
(defparameter *UW1* (let ((h (make-hash-table :test #'equal :size 38))) (setf (gethash "��" h) -408 (gethash "��" h) 361 (gethash "��" h) 729 (gethash "��" h) -460 (gethash "��" h) -402 (gethash "��" h) 561 (gethash "��" h) -912 (gethash "��" h) -446 (gethash "��" h) -127 (gethash "," h) 156 (gethash "�u" h) -463 (gethash "��" h) -141 (gethash "��" h) -137 (gethash "��" h) 182 (gethash "��" h) -201 (gethash "��" h) -292 (gethash "��" h) -547 (gethash "��" h) 505 (gethash "��" h) 871 (gethash "��" h) -268 (gethash "��" h) 208 (gethash "��" h) -123 (gethash "�E" h) -135 (gethash "��" h) -386 (gethash "��" h) 169 (gethash "��" h) -789 (gethash "�s" h) -718 (gethash "��" h) -466 (gethash "��" h) -553 (gethash "�s" h) -411 (gethash "��" h) 121 (gethash "��" h) -941 (gethash "�u" h) -463 (gethash "�A" h) 156 (gethash "�E" h) -135 (gethash "��" h) -470 (gethash "��" h) -185 (gethash "��" h) -847) h))
(defparameter *UW2* (let ((h (make-hash-table :test #'equal :size 107))) (setf (gethash "�s" h) -813 (gethash "�u" h) -645 (gethash "��" h) 540 (gethash "��" h) -981 (gethash "��" h) -2378 (gethash "��" h) 505 (gethash "�v" h) 3145 (gethash "��" h) 1529 (gethash "��" h) -302 (gethash "��" h) 1273 (gethash "��" h) -861 (gethash "��" h) -1257 (gethash "��" h) -180 (gethash "�{" h) -1650 (gethash "��" h) 1063 (gethash "��" h) 3041 (gethash "��" h) -3874 (gethash "��" h) -675 (gethash "�A" h) -587 (gethash "��" h) -1764 (gethash "��" h) 978 (gethash "��" h) 134 (gethash "��" h) -1353 (gethash "��" h) -665 (gethash "�N" h) -1060 (gethash "��" h) 600 (gethash "��" h) -1355 (gethash "��" h) -968 (gethash "��" h) -1566 (gethash "��" h) -2516 (gethash "��" h) -422 (gethash "��" h) 300 (gethash "��" h) -1843 (gethash "��" h) 130 (gethash "�O" h) -758 (gethash "��" h) 2095 (gethash "�b" h) 831 (gethash "��" h) -242 (gethash "��" h) -1815 (gethash "��" h) 1522 (gethash "��" h) -1519 (gethash "��" h) -409 (gethash "�k" h) -3414 (gethash "��" h) -502 (gethash "��" h) 492 (gethash "��" h) -1011 (gethash "," h) -829 (gethash "��" h) -1165 (gethash "��" h) 752 (gethash "�C" h) -1740 (gethash "�A" h) -829 (gethash "��" h) -1263 (gethash "��" h) 1454 (gethash "�A" h) -587 (gethash "�c" h) 1198 (gethash "��" h) 509 (gethash "��" h) -763 (gethash "��" h) -856 (gethash "��" h) -744 (gethash "��" h) 529 (gethash "�V" h) -1682 (gethash "��" h) -402 (gethash "�s" h) -2150 (gethash "��" h) 188 (gethash "��" h) -1273 (gethash "��" h) -1462 (gethash "��" h) 1837 (gethash "��" h) -1769 (gethash "�q" h) -1519 (gethash "�u" h) -645 (gethash "�J" h) 1758 (gethash "��" h) -412 (gethash "�J" h) 306 (gethash "�v" h) 3145 (gethash "�V" h) -865 (gethash "�J" h) 306 (gethash "��" h) 810 (gethash "��" h) -630 (gethash "�h" h) -1033 (gethash "�L" h) 568 (gethash "��" h) 362 (gethash "��" h) -483 (gethash "�Z" h) 892 (gethash "��" h) 1639 (gethash "�w" h) 760 (gethash "�L" h) 568 (gethash "��" h) -1584 (gethash "��" h) 1067 (gethash "��" h) -949 (gethash "��" h) -3025 (gethash "��" h) 1010 (gethash "�s" h) 838 (gethash "��" h) -931 (gethash "��" h) 548 (gethash "��" h) -579 (gethash "��" h) 1023 (gethash "��" h) 1141 (gethash "��" h) 1261 (gethash "��" h) -694 (gethash "��" h) -291 (gethash "��" h) -538 (gethash "�l" h) -123 (gethash "��" h) -2009 (gethash "�b" h) 831 (gethash "��" h) 571 (gethash "��" h) 878 (gethash "��" h) -268) h))
(defparameter *UW3* (let ((h (make-hash-table :test #'equal :size 217))) (setf (gethash "��" h) 727 (gethash "��" h) 1109 (gethash "�S" h) 1574 (gethash "��" h) 2201 (gethash "��" h) -1136 (gethash "��" h) -488 (gethash "��" h) -3885 (gethash "��" h) 649 (gethash "��" h) -395 (gethash "��" h) -5516 (gethash "�P" h) -800 (gethash "��" h) 792 (gethash "��" h) 5905 (gethash "��" h) 278 (gethash "��" h) -273 (gethash "�w" h) -3973 (gethash "��" h) 2773 (gethash "�O" h) 1319 (gethash "��" h) 3906 (gethash "��" h) 2016 (gethash "�A" h) 4889 (gethash "��" h) 584 (gethash "�w" h) 1620 (gethash "�m" h) -1528 (gethash "��" h) -1008 (gethash "��" h) 457 (gethash "��" h) -3030 (gethash "��" h) -1835 (gethash "�@" h) 1868 (gethash "��" h) 3815 (gethash "��" h) 3685 (gethash "�Z" h) 755 (gethash "��" h) -4384 (gethash "�\" h) -1193 (gethash "��" h) -1504 (gethash "��" h) -4229 (gethash "��" h) 1384 (gethash "��" h) -120 (gethash "��" h) -1207 (gethash "��" h) 421 (gethash "��" h) -733 (gethash "��" h) -805 (gethash "��" h) -661 (gethash "�b" h) -1350 (gethash "�X" h) -2311 (gethash "��" h) -5228 (gethash "��" h) 2163 (gethash "�I" h) -681 (gethash "��" h) -562 (gethash "��" h) 1255 (gethash "�X" h) 2438 (gethash "��" h) 3094 (gethash "��" h) -1619 (gethash "," h) 4889 (gethash "�b" h) -1350 (gethash "�{" h) 1605 (gethash "�B" h) 1155 (gethash "�Z" h) 5827 (gethash "��" h) -1006 (gethash "��" h) -1880 (gethash "��" h) 974 (gethash "��" h) 6620 (gethash "�S" h) 4404 (gethash "��" h) 842 (gethash "��" h) -518 (gethash "�A" h) 551 (gethash "��" h) 2066 (gethash "�J" h) -1432 (gethash "��" h) 364 (gethash "��" h) 642 (gethash "��" h) -1368 (gethash "��" h) 1591 (gethash "�p" h) 914 (gethash "��" h) -521 (gethash "�X" h) 874 (gethash "�g" h) 521 (gethash "��" h) 6293 (gethash "��" h) 360 (gethash "��" h) 811 (gethash "1" h) -800 (gethash "�O" h) -241 (gethash "��" h) 483 (gethash "��" h) 2201 (gethash "�g" h) 521 (gethash "��" h) 1044 (gethash "��" h) -2869 (gethash "��" h) 3222 (gethash "��" h) -513 (gethash "��" h) -1444 (gethash "��" h) 365 (gethash "�d" h) -1045 (gethash "��" h) -1081 (gethash "�~" h) 5807 (gethash "�v" h) 2670 (gethash "�I" h) 7313 (gethash "�j" h) 5156 (gethash "��" h) -2013 (gethash "��" h) -2352 (gethash "��" h) -3102 (gethash "��" h) 1200 (gethash "��" h) -1073 (gethash "��" h) -2696 (gethash "��" h) 6167 (gethash "��" h) 653 (gethash "��" h) -937 (gethash "��" h) -1248 (gethash "�v" h) -1291 (gethash "��" h) 1905 (gethash "��" h) 2318 (gethash "��" h) -2439 (gethash "�\" h) 725 (gethash "��" h) 461 (gethash "�x" h) 1452 (gethash "��" h) -1804 (gethash "��" h) -423 (gethash "��" h) 278 (gethash "��" h) -1759 (gethash "��" h) 1006 (gethash "��" h) 1691 (gethash "��" h) 1302 (gethash "��" h) 3663 (gethash "��" h) 979 (gethash "�L" h) -1030 (gethash "�l" h) 2742 (gethash "��" h) 792 (gethash "��" h) 4265 (gethash "��" h) -899 (gethash "��" h) -1489 (gethash "�N" h) 2416 (gethash "��" h) -949 (gethash "��" h) -3573 (gethash "��" h) 2342 (gethash "��" h) -2788 (gethash "��" h) -960 (gethash "��" h) 4437 (gethash "�}" h) 3593 (gethash "��" h) 2745 (gethash "��" h) 3095 (gethash "�X" h) 874 (gethash "��" h) 401 (gethash "��" h) 1983 (gethash "�O" h) 2286 (gethash "��" h) -4864 (gethash "��" h) 4056 (gethash "��" h) -1872 (gethash "��" h) 1835 (gethash "��" h) 4125 (gethash "��" h) -1163 (gethash "��" h) 4555 (gethash "��" h) 4513 (gethash "�A" h) 551 (gethash "�Y" h) 1026 (gethash "�n" h) 3066 (gethash "�V" h) 1764 (gethash "��" h) -1479 (gethash "�E" h) -3794 (gethash "��" h) 2475 (gethash "��" h) 3271 (gethash "��" h) 1109 (gethash "��" h) 2099 (gethash "��" h) 1822 (gethash "��" h) 1078 (gethash "��" h) -361 (gethash "��" h) -2309 (gethash "�a" h) -837 (gethash "�R" h) 1375 (gethash "�C" h) -495 (gethash "��" h) -2171 (gethash "��" h) 1205 (gethash "��" h) 1219 (gethash "��" h) 7767 (gethash "��" h) 5792 (gethash "�s" h) 3197 (gethash "��" h) 1004 (gethash "��" h) 2323 (gethash "�E" h) 1233 (gethash "�|" h) -1723 (gethash "��" h) 1215 (gethash "�e" h) 3588 (gethash "��" h) -2087 (gethash "�J" h) 2009 (gethash "��" h) 1201 (gethash "��" h) 388 (gethash "��" h) -1798 (gethash "��" h) -788 (gethash "��" h) 1889 (gethash "��" h) -758 (gethash "�O" h) 1319 (gethash "�v" h) 2670 (gethash "��" h) 6457 (gethash "��" h) 1163 (gethash "��" h) 484 (gethash "��" h) 401 (gethash "��" h) 1777 (gethash "��" h) 4231 (gethash "��" h) 2613 (gethash "�j" h) -951 (gethash "��" h) -3552 (gethash "��" h) -783 (gethash "�E" h) -3794 (gethash "��" h) -1282 (gethash "��" h) -3850 (gethash "�w" h) -1356 (gethash "��" h) -3116 (gethash "��" h) 1199 (gethash "��" h) -241 (gethash "��" h) 1327 (gethash "��" h) 4646 (gethash "�^" h) 1389 (gethash "��" h) 1591 (gethash "�p" h) 785 (gethash "��" h) -1694 (gethash "��" h) -1058 (gethash "��" h) -202 (gethash "�k" h) -1038 (gethash "��" h) 1129 (gethash "��" h) 4858) h))
(defparameter *UW4* (let ((h (make-hash-table :test #'equal :size 220))) (setf (gethash "�@" h) -2297 (gethash "�x" h) 856 (gethash "��" h) -2922 (gethash "��" h) -851 (gethash "��" h) 2120 (gethash "��" h) -1984 (gethash "��" h) -9726 (gethash "��" h) -1635 (gethash "��" h) -843 (gethash "��" h) 1464 (gethash "�s" h) 1192 (gethash "��" h) -3485 (gethash "��" h) -14896 (gethash "��" h) -2506 (gethash "��" h) -3637 (gethash "��" h) -1286 (gethash "��" h) -2613 (gethash "�\" h) -4841 (gethash "�A" h) 3930 (gethash "��" h) -731 (gethash "�J" h) -1000 (gethash "�o" h) 1146 (gethash "�B" h) 3508 (gethash "��" h) 601 (gethash "��" h) 1251 (gethash "��" h) -4570 (gethash "��" h) -1100 (gethash "��" h) -939 (gethash "�C" h) -910 (gethash "��" h) 181 (gethash "��" h) 1051 (gethash "�\" h) 782 (gethash "��" h) -2604 (gethash "��" h) -1291 (gethash "��" h) -3370 (gethash "��" h) -1169 (gethash "��" h) -2082 (gethash "��" h) -1783 (gethash "�R" h) 1789 (gethash "��" h) -792 (gethash "��" h) -1659 (gethash "��" h) 357 (gethash "��" h) -867 (gethash "�Y" h) -1101 (gethash "��" h) 456 (gethash "�b" h) -724 (gethash "��" h) 4091 (gethash "��" h) 1749 (gethash "�I" h) 2596 (gethash "��" h) -994 (gethash "��" h) -2667 (gethash "��" h) -809 (gethash "��" h) -2069 (gethash "," h) 3930 (gethash "��" h) -190 (gethash "�b" h) -724 (gethash "�Z" h) 4999 (gethash "��" h) 1013 (gethash "��" h) -1212 (gethash "��" h) 13150 (gethash "��" h) -881 (gethash "�[" h) -11870 (gethash "��" h) 787 (gethash "��" h) 5034 (gethash "." h) 3508 (gethash "��" h) -2352 (gethash "�n" h) 866 (gethash "��" h) -541 (gethash "��" h) 929 (gethash "��" h) 5408 (gethash "��" h) -619 (gethash "��" h) 544 (gethash "��" h) -856 (gethash "��" h) 672 (gethash "��" h) -3654 (gethash "�g" h) -403 (gethash "��" h) 2997 (gethash "�q" h) -4802 (gethash "��" h) 950 (gethash "�g" h) -403 (gethash "��" h) 1910 (gethash "��" h) -5882 (gethash "��" h) -302 (gethash "��" h) 584 (gethash "�Z" h) 1287 (gethash "�u" h) 1895 (gethash "�d" h) -878 (gethash "��" h) -1659 (gethash "�~" h) 788 (gethash "�v" h) 3798 (gethash "�J" h) 2145 (gethash "�I" h) 2586 (gethash "��" h) 2182 (gethash "��" h) 1500 (gethash "�Q" h) 1555 (gethash "��" h) -1200 (gethash "��" h) 730 (gethash "��" h) 1067 (gethash "��" h) 4752 (gethash "��" h) 3994 (gethash "��" h) 2210 (gethash "�K" h) 792 (gethash "��" h) 845 (gethash "��" h) 1829 (gethash "��" h) -4556 (gethash "��" h) 7410 (gethash "��" h) -1768 (gethash "��" h) -1286 (gethash "�\" h) -730 (gethash "��" h) -735 (gethash "��" h) -543 (gethash "��" h) -2056 (gethash "��" h) -3637 (gethash "��" h) -3435 (gethash "��" h) 4547 (gethash "�R" h) 1789 (gethash "��" h) -2344 (gethash "��" h) 2171 (gethash "�l" h) 1036 (gethash "�c" h) -2900 (gethash "��" h) 522 (gethash "�N" h) 374 (gethash "��" h) -740 (gethash "��" h) -5156 (gethash "��" h) -640 (gethash "��" h) 5433 (gethash "�x" h) -1184 (gethash "��" h) -2112 (gethash "��" h) -485 (gethash "��" h) -1328 (gethash "�m" h) -1413 (gethash "��" h) 3879 (gethash "�}" h) -2006 (gethash "��" h) 6499 (gethash "��" h) -2514 (gethash "��" h) 1853 (gethash "�Z" h) 1287 (gethash "�s" h) -792 (gethash "�O" h) 1623 (gethash "��" h) 1413 (gethash "�R" h) -1500 (gethash "��" h) 2405 (gethash "��" h) 7396 (gethash "��" h) -2715 (gethash "��" h) -1481 (gethash "��" h) -9066 (gethash "��" h) 530 (gethash "��" h) 8578 (gethash "��" h) -910 (gethash "�Y" h) -4866 (gethash "�n" h) 786 (gethash "��" h) 704 (gethash "��" h) -2094 (gethash "�E" h) -4371 (gethash "��" h) 1347 (gethash "��" h) 6006 (gethash "��" h) 1940 (gethash "��" h) 1798 (gethash "��" h) 553 (gethash "��" h) 530 (gethash "�a" h) -681 (gethash "��" h) -4482 (gethash "��" h) -882 (gethash "�[" h) -11870 (gethash "��" h) -1635 (gethash "��" h) -2213 (gethash "�R" h) 1158 (gethash "��" h) -852 (gethash "��" h) -1410 (gethash "��" h) -3821 (gethash "��" h) 4249 (gethash "��" h) -5046 (gethash "��" h) 2937 (gethash "�Z" h) -360 (gethash "��" h) -1566 (gethash "�s" h) 2771 (gethash "��" h) -3788 (gethash "��" h) -4134 (gethash "��" h) 4169 (gethash "��" h) 1826 (gethash "��" h) 571 (gethash "��" h) -2666 (gethash "�u" h) 1895 (gethash "�c" h) -244 (gethash "��" h) 788 (gethash "��" h) -442 (gethash "��" h) -4376 (gethash "��" h) 1345 (gethash "��" h) 2795 (gethash "�v" h) 3798 (gethash "��" h) 2145 (gethash "��" h) 940 (gethash "��" h) -1267 (gethash "��" h) -1043 (gethash "��" h) -4734 (gethash "��" h) -881 (gethash "��" h) 5388 (gethash "��" h) 2255 (gethash "��" h) 4292 (gethash "��" h) -541 (gethash "�E" h) -4371 (gethash "��" h) -1433 (gethash "��" h) 922 (gethash "��" h) 916 (gethash "�w" h) -1397 (gethash "��" h) 1979 (gethash "��" h) 6665 (gethash "��" h) -1544 (gethash "�J" h) 2145 (gethash "��" h) -1834 (gethash "��" h) 776 (gethash "��" h) 4517 (gethash "��" h) -856 (gethash "��" h) 749 (gethash "��" h) -2716 (gethash "��" h) -856 (gethash "��" h) -1057 (gethash "��" h) 2864 (gethash "��" h) -744 (gethash "��" h) 3351) h))
(defparameter *UW5* (let ((h (make-hash-table :test #'equal :size 99))) (setf (gethash "��" h) -1347 (gethash "�u" h) 363 (gethash "�s" h) -2991 (gethash "]" h) -2762 (gethash "��" h) -127 (gethash "��" h) 3519 (gethash "��" h) 848 (gethash "��" h) -1073 (gethash "��" h) -813 (gethash "�I" h) -3149 (gethash "��" h) 331 (gethash "��" h) -1371 (gethash "��" h) 1682 (gethash "��" h) 1191 (gethash "��" h) 419 (gethash "�v" h) 872 (gethash "��" h) -787 (gethash "��" h) 451 (gethash "��" h) -3912 (gethash "��" h) -4353 (gethash "��" h) -852 (gethash "��" h) -1224 (gethash "��" h) -1153 (gethash "��" h) 722 (gethash "��" h) -503 (gethash "�I" h) -1018 (gethash "�}" h) -654 (gethash "�N" h) 1763 (gethash "��" h) 2104 (gethash "�P" h) -514 (gethash "��" h) 1955 (gethash "�C" h) 241 (gethash "��" h) -871 (gethash "��" h) 502 (gethash "��" h) 1199 (gethash "E2" h) -32768 (gethash "��" h) -1264 (gethash "��" h) -901 (gethash "��" h) -635 (gethash "��" h) 921 (gethash "��" h) 327 (gethash "�\" h) 663 (gethash "��" h) 1319 (gethash "��" h) 932 (gethash "��" h) 218 (gethash "��" h) -578 (gethash "��" h) 865 (gethash "��" h) 527 (gethash "��" h) -1304 (gethash "," h) 465 (gethash "��" h) -4003 (gethash "�A" h) 465 (gethash "��" h) 647 (gethash "�c" h) 1219 (gethash "�B" h) -299 (gethash "��" h) 3350 (gethash "��" h) -421 (gethash "." h) -299 (gethash "�C" h) 241 (gethash "�@" h) -1508 (gethash "�V" h) -1682 (gethash "��" h) 1624 (gethash "��" h) -343 (gethash "��" h) 1618 (gethash "��" h) 786 (gethash "��" h) 1785 (gethash "��" h) 1971 (gethash "��" h) -1186 (gethash "��" h) -1296 (gethash "��" h) 451 (gethash "�u" h) 363 (gethash "�c" h) 240 (gethash "��" h) 312 (gethash "��" h) 1093 (gethash "1" h) -514 (gethash "�d�Q" h) -32768 (gethash "��" h) 854 (gethash "��" h) -997 (gethash "��" h) 52 (gethash "�w" h) -548 (gethash "��" h) -814 (gethash "��" h) 921 (gethash "��" h) -983 (gethash "��" h) -343 (gethash "��" h) -689 (gethash "�Y" h) -368 (gethash "��" h) -1052 (gethash "��" h) -208 (gethash "��" h) 2368 (gethash "��" h) -2233 (gethash "�i" h) 1356 (gethash "��" h) 1001 (gethash "��" h) 429 (gethash "��" h) -18 (gethash "��" h) -278 (gethash "��" h) 1655 (gethash "��" h) 504 (gethash "��" h) -1537 (gethash "��" h) -850) h))
(defparameter *UW6* (let ((h (make-hash-table :test #'equal :size 53))) (setf (gethash "��" h) 798 (gethash "��" h) 535 (gethash "�w" h) -960 (gethash "��" h) -1212 (gethash "��" h) 1792 (gethash "��" h) -496 (gethash "��" h) 195 (gethash "��" h) -1014 (gethash "��" h) 189 (gethash "E1" h) 306 (gethash "," h) 227 (gethash "�Y" h) 1082 (gethash "�O" h) 302 (gethash "��" h) -800 (gethash "��" h) 101 (gethash "��" h) -673 (gethash "��" h) -105 (gethash "��" h) -200 (gethash "." h) 808 (gethash "��" h) -673 (gethash "��" h) 187 (gethash "�d�P" h) 306 (gethash "�A" h) 463 (gethash "��" h) -507 (gethash "��" h) -277 (gethash "��" h) -135 (gethash "��" h) -253 (gethash "��" h) -428 (gethash "��" h) 1811 (gethash "��" h) -822 (gethash "��" h) 624 (gethash "��" h) -149 (gethash "��" h) 241 (gethash "1" h) -270 (gethash "��" h) -496 (gethash "��" h) -697 (gethash "�L" h) -695 (gethash "��" h) 201 (gethash "��" h) -206 (gethash "��" h) -73 (gethash "�P" h) -270 (gethash "��" h) 753 (gethash "�s" h) 887 (gethash "��" h) 1782 (gethash "��" h) -307 (gethash "�A" h) 227 (gethash "��" h) 974 (gethash "��" h) -417 (gethash "��" h) 573 (gethash "��" h) 383 (gethash "�B" h) 808 (gethash "��" h) -236 (gethash "��" h) -121) h))


(provide "tiny-segmenter/model")

;;; End