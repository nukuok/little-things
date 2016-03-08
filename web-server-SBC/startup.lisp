;;;;
(ql:quickload :cl-who)
(ql:quickload :parenscript)
(ql:quickload :cffi)
(pushnew "." cffi:*FOREIGN-LIBRARY-DIRECTORIES*)
(ql:quickload :hunchentoot)
(ql:quickload :smackjack)

;;;;
(ql:quickload :processpcap) ;; heyhey

(defpackage :sbc-tools
  (:use :cl :cl-who :hunchentoot :parenscript :processpcap))
(in-package :sbc-tools)

(defvar parenscript::suppress-values? nil)

;;;; tools
(defvar *tools*)
(setf *tools* nil)

(defclass tool ()
  ((name :accessor tool-name :initarg :name)
   (link :accessor tool-link :initarg :link)))

(defun tool-from-name (name)
  (find name *tools* :test #'string-equal
	:key #'tool-name))

(defun tool-stored? (name)
  (tool-from-name name))

(defun add-tool (name)
  (unless (tool-stored? name)
    (push (make-instance 'tool :name name :link
			 (format nil "~a.htm" name)) *tools*)))

;;;; start & stop
(defun start-server (&optional (port 4241))
  (setf *acceptor* (make-instance 'easy-acceptor :port port))  
;;  (setf (acceptor-document-root *acceptor*)
;;	"c:/Users/Administrator/Desktop/program/gui-test/www/")
  (start *acceptor*))
(defun stop-server ()
  (stop *acceptor*))


;;;; insert-tool
(defmacro define-url-fn ((name) &body body)
  `(progn
     (defun ,name ()
       ,@body)
     (push (create-prefix-dispatcher ,(format nil "/~(~a~).htm" name) ',name) *dispatch-table*)))

(defmacro standard-page-with-title ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html :xmlns "http://www.w3.org/1999/xhtml"  :xml\:lang "en" :lang "en"
	    (:head 
	     (:meta :http-equiv "Content-Type" :content "text/html;charset=utf-8")
	     (:title ,title))
	    ;;(:link :type "text/css" :rel "stylesheet" :href "/retro.css"))
	    (:body 
	     (:div :id "header")
	     ,@body))))

(define-url-fn (index)
    (standard-page-with-title (:title "index page")
      (:h1 "tools list")
      (:table
       (loop for x in *tools*
	  for index from 1 do 
	    (htm
	     (:tr
	      (:td (:h2 (fmt "~d. ~a" index (tool-name x))))
	      (:td (:h2 "&nbsp&nbsp>&nbsp&nbsp"))
	      (:td (:h2 (:a :href (format nil "~a" (tool-link x))
			    (fmt "link"))))))))))



