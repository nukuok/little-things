*package*

(list-all-packages)

(make-package 'test)
(in-package 'test)
*package*

(defvar *hello* "Hello, PP!")
(defvar *hello-mame* "Hello, mame!")

(in-package cl-user)
*hello*

(in-package 'test)
(export '*hello*)
(export '*hello-mame*)

(in-package cl-user)
(unintern '*hello*)
*hello*    ;; found 
*hello-mame*  ;; not found

test::*hello*   ;; found
test::*hello-mame*   ;; found
test:*hello* ;;found
test:*hello-mame*   ;; not found
;;;;Reader error: No external symbol named "*HELLO-MAME*" in package #<Package "TEST"> .

;;;;
(provide 'mylib)

(defpackage mylib
  (:use common-lisp)
  (:export hello))

(in-package mylib)

(defvar *hold-on* "mame")
(defun mame1 () (print "mamemame"))
(export 'mame1)

(unintern 'mame1)
(unintern 'hello)
(require 'mylib)

