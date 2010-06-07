= tiny-segmenter - xyzzy Lisp �����Ŏ������ꂽ�R���p�N�g�ȕ����������\�t�g�E�F�A

  * Author: �݂�ނ� ���䂫 ((<URL:mailto:miyamuko@gmail.com>))
  * Home URL: ((<URL:http://miyamuko.s56.xrea.com/xyzzy/tiny-segmenter/intro.htm>))
  * Version: 1.1.0


== SYNOPSIS

  (require "tiny-segmenter")

  (ts:segment "���̖��O�͒���ł��B")
  ;;=> ("��" "��" "���O" "��" "����" "�ł�" "�B")

  (setf *str* "tiny-segmenter ��
  �uTinySegmenter: Javascript �����Ŏ������ꂽ�R���p�N�g�ȕ����������\�t�g�E�F�A�v��
  xyzzy lisp �ɈڐA�������̂ł��B")

  (setf *segmenter* (ts:make-segmenter *str*))

  (ts:segmenter-segment-next *segmenter*)
  ;;=> "tiny"

  (ts:segmenter-segment-next *segmenter*)
  ;;=> "-segmenter"

  (ts:segmenter-segment-partial *segmenter* 3)
  ;;=> (" " "��" "
  ;;   �u")

  (ts:segmenter-segment-partial *segmenter* 5)
  ;;=> ("TinySegmenter" ": " "Javascript" " " "����")

  (ts:segmenter-segment-partial *segmenter* 10)
  ;;=> ("��" "����" "��" "��" "��" "�R���p�N�g" "��" "������" "����" "�\�t�g�E�F�A")

  (ts:segmenter-segment-all *segmenter*)
  ;;=> ("�v" "��" "
  ;;   xyzzy" " lisp" " " "��" "�ڐA��" "��" "����" "�ł�" "�B")


== DESCRIPTION

tiny-segmenter ��
((<"TinySegmenter: Javascript �����Ŏ������ꂽ�R���p�N�g�ȕ����������\�t�g�E�F�A"|URL:http://chasen.org/~taku/software/TinySegmenter/>))
�� xyzzy lisp �ɈڐA�������̂ł��B

��L URL �ɂ��Έȉ��̂悤�ȓ���������܂��B

  * ���{��̐V���L���ł���Ε����P�ʂ� 95% ���x�̐��x�ŕ������������s����
  * �����������̒P�ʂ� MeCab + ipadic �ƌ݊�
  * �������g���Ă��܂��� (�@�B�w�K�̂�)�B
    xyzzy lisp �݂̂ŕ������������s���܂��B


== INSTALL

tiny-segmenter �̓��C�u�����ł��B

=== NetInstaller �ŃC���X�g�[��

(1) ((<NetInstaller|URL:http://www7a.biglobe.ne.jp/~hat/xyzzy/ni.html>))
    �� tiny-segmenter ���C���X�g�[�����܂��B

=== NetInstaller ���g�킸�ɃC���X�g�[��

(1) �A�[�J�C�u���_�E�����[�h���܂��B

    ((<URL:http://miyamuko.s56.xrea.com/xyzzy/archives/tiny-segmenter.zip>))

(2) �A�[�J�C�u��W�J���āA$XYZZY/site-lisp �z���Ƀt�@�C�����R�s�[���܂��B


== MODULE

=== DEPENDS

�ˑ����W���[���͂���܂���B


=== PACKAGE

tiny-segmenter �͈ȉ��̃p�b�P�[�W�𗘗p���Ă��܂��B

  * tiny-segmenter

    nickname �� ts �ł��B


=== EXPORT

tiny-segmenter �͈ȉ��̃V���{���� export ���Ă��܂��B

  * tiny-segmenter:segment
  * tiny-segmenter:make-segmenter
  * tiny-segmenter:segmenter-segment-all
  * tiny-segmenter:segmenter-segment-partial
  * tiny-segmenter:segmenter-segment-next


=== CONDITION

�Ȃ��B

=== VARIABLE

�Ȃ��B

=== COMMAND

�Ȃ��B

=== FUNCTION

--- tiny-segmenter:segment INPUT

    INPUT �Ŏw�肳�ꂽ�I�u�W�F�N�g�𕪂����������ă��X�g�ŕԂ��܂��B

      ; string
      (ts:segment "xyzzy �̓ǂݕ���������܂���B")
      ;;=> ("xyzzy" " " "��" "�ǂݕ�" "��" "������" "�܂�" "��" "�B")

      ; stream
      (with-input-from-string (s "xyzzy �̓ǂݕ���������܂���B")
        (ts:segment s))

      ; buffer
      (ts:segment (find-buffer "*scratch*"))

    * INPUT �ɂ͈ȉ��̃I�u�W�F�N�g���w��ł��܂��B
      * ������
      * �X�g���[��
      * �o�b�t�@
    * nil �܂��͋󕶎�����w�肵���ꍇ�� nil ��Ԃ��܂��B

--- tiny-segmenter:make-segmenter INPUT

    INPUT �Ŏw�肳�ꂽ�I�u�W�F�N�g�𕪂����������� SEGMENTER �I�u�W�F�N�g��Ԃ��܂��B

    SEGMENTER �I�u�W�F�N�g�� INPUT ��ێ����A�ȉ��̊֐����Ă΂�邽�т�
    ����������������i�߂܂��B

    * ((<segmenter-segment-next|tiny-segmenter:segmenter-segment-next SEGMENTER>))
    * ((<segmenter-segment-partial|tiny-segmenter:segmenter-segment-partial SEGMENTER N>))
    * ((<segmenter-segment-all|tiny-segmenter:segmenter-segment-all SEGMENTER>))

    ���ׂĂ� INPUT ������������́A�����̊֐��� nil ��Ԃ��܂��B

    * INPUT �ɂ͈ȉ��̃I�u�W�F�N�g���w��ł��܂��B
      * ������
      * �X�g���[��
      * �o�b�t�@
    * nil �܂��͋󕶎�����w�肵���ꍇ�� nil ��Ԃ��܂��B

    �����Ӂ�

    ���݂̃o�[�W�����ł� SEGMENTER �I�u�W�F�N�g�̓N���[�W���Ƃ��Ď�������Ă��܂����A
    �����̃o�[�W�����ŕύX����\��������܂��B
    ���� funcall ����͔̂����Ă��������B

--- tiny-segmenter:segmenter-segment-next SEGMENTER

    SEGMENTER �I�u�W�F�N�g���ێ�����c��� INPUT �𕪂�����������
    ���̒P����擾���܂��B

      (setf *segmenter* (ts:make-segmenter "xyzzy �̓ǂݕ���������܂���B"))

      (ts:segmenter-segment-next *segmenter*)
      ;;=> "xyzzy"

      (ts:segmenter-segment-next *segmenter*)
      ;;=> " "

      (ts:segmenter-segment-next *segmenter*)
      ;;=> "��"

--- tiny-segmenter:segmenter-segment-partial SEGMENTER N

    SEGMENTER �I�u�W�F�N�g���ێ�����c��� INPUT �𕪂�����������
    N �̒P��̃��X�g���擾���܂��B

      (setf *segmenter* (ts:make-segmenter "xyzzy �̓ǂݕ���������܂���B"))
      
      (ts:segmenter-segment-partial *segmenter* 7)
      ;;=> ("xyzzy" " " "��" "�ǂݕ�" "��" "������" "�܂�")
      
      (ts:segmenter-segment-partial *segmenter* 7)
      ;;=> ("��" "�B")
      
      (ts:segmenter-segment-partial *segmenter* 7)
      ;;=> nil

--- tiny-segmenter:segmenter-segment-all SEGMENTER

    SEGMENTER �I�u�W�F�N�g���ێ�����c��� INPUT ���ׂĕ�������������
    �P��̃��X�g���擾���܂��B

      (setf *segmenter* (ts:make-segmenter "xyzzy �̓ǂݕ���������܂���B"))

      (ts:segmenter-segment-next *segmenter*)
      ;;=> "xyzzy"

      (ts:segmenter-segment-all *segmenter*)
      ;;=> (" " "��" "�ǂݕ�" "��" "������" "�܂�" "��" "�B")

--- tiny-segmenter:tiny-segmenter-version

    �{���C�u�����̃o�[�W������Ԃ��܂��B
    �o�[�W������ major.minor.teeny �Ƃ����`���ł��B

    ���ꂼ��̔ԍ��͕K�� 1 ���ɂ���̂ŁA�ȉ��̂悤�ɔ�r���邱�Ƃ��ł��܂�

        (if (string<= "1.1.0" (tiny-segmenter:tiny-segmenter-version))
            '(1.1.0 �ȍ~�ŗL���ȏ���)
          '(1.1.0 ���O�̃o�[�W�����ł̏���))


== TODO

* make-segmenter
  * �ŏ��̏�����������x��
  * stream ����ǂݍ��݂Ȃ��番����������i�߂�


== KNOWN BUGS

�Ȃ��B


== SEE ALSO

  : TinySegmenter: Javascript �����Ŏ������ꂽ�R���p�N�g�ȕ����������\�t�g�E�F�A
      ((<URL:http://chasen.org/~taku/software/TinySegmenter/>))

  : Text::TinySegmenter - Super compact Japanese tokenizer - search.cpan.org
      ((<URL:http://search.cpan.org/dist/Text-TinySegmenter/>))

  : TinySegmenter��Ruby�ɈڐA���Ă݂�[Ruby] - d.hatena.zeg.la
      ((<URL:http://d.hatena.ne.jp/zegenvs/20080212/p1>))

  : TinySegmenter��Ruby�ɈڐA - llamerada�̓��L
      ((<URL:http://d.hatena.ne.jp/llamerada/20080224/1203818061>))


== COPYRIGHT

tiny-segmenter �͍H���񎁂ɂ���ĊJ�����ꂽ JavaScript �ł� TinySegmenter ��
xyzzy lisp �ɈڐA�������̂ł��B

tiny-segmenter �͏C�� BSD ���C�Z���X�ɏ]���Ė{�\�t�g�E�F�A���g�p�A�Ĕz�z���邱�Ƃ��ł��܂��B

  tiny-segmenter -- Super compact Japanese tokenizer
  
  (c) 2008 Taku Kudo <taku@chasen.org>
  (c) 2008 MIYAMUKO Katsuyuki  <miyamuko@gmail.com>
  
  tiny-segmenter is freely distributable under the terms of a new BSD licence.
  For details, see http://chasen.org/~taku/software/TinySegmenter/LICENCE.txt


== NEWS

<<<NEWS.rd
