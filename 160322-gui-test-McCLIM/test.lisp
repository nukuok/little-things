(ql:quickload :MCCLIM)
(ql:quickload :MCCLIM-freetype)


;;NOTE:
;;* McCLIM was unable to configure itself automatically using
;;  fontconfig. Therefore you must configure it manually.
;;  Remember to set mcclim-freetype:*freetype-font-path* to the
;;  location of the Bitstream Vera family of fonts on disk. If you
;;  don't have them, get them from http://www.gnome.org/fonts/
;;   [Condition of type SIMPLE-ERROR]

(setf mcclim-freetype:*FREETYPE-FONT-PATH* "C:\Users\Administrator\Desktop\program\little-things\160322-gui-test-McCLIM\ttf-bitstream-vera-1.10")

(defpackage "APP"
  (:use :clim :clim-lisp :cl-user)
  (:export "APP-MAIN"))

(in-package :app)

(define-application-frame superapp ()
  ()
  (:panes
   (int :interactor :height 400 :width 600))
  (:layouts
   (default int)))

(defun app-main ()
  (run-frame-top-level (make-application-frame 'superapp)))
