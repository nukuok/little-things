;;;;
(ql:quickload :cl-who)
(ql:quickload :parenscript)
(ql:quickload :cffi)
(pushnew "." cffi:*FOREIGN-LIBRARY-DIRECTORIES*)
(ql:quickload :hunchentoot)

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

;;;; file-path color-set ip-set
(add-tool "pcap-process")

(define-url-fn (pcap-process)
  (standard-page-with-title (:title "Pcap-process")
    (:h1 (:u "Pcap Process Settings"))
    (:hr :size 5 :color "orange")
    (:br)
    (:form :action "/pp-run.htm" :method "post"
	   :onsubmit (ps-inline
		      (when (= ppfilepath.value "")
			(alert "File path empty!")
			(return false)))
	   (:table
	    (:tr
	     (:td :valign "top" "1. File path:")
	     (:td :colspan 3
		  (:input :type "text" :name "ppfilepath"
			  :size 111 :class "txt")))
	    (:tr
	     (:td :valign "top" "2. IP picking:")
	     (:td :align "right" "Internal IPs &#8656")
	     (:td "&#8658 SBC Internal IPs"))
	    (:tr
	     (:td)
	     (:td  (:textarea :rows 4 :cols 40 :name "ppip1"))
	     (:td  (:textarea :rows 4 :cols 40 :name "ppip2"))
	     (:td ))
	    (:tr
	     (:td) (:td)
	     (:td :align "right" "SBC External IPs &#8656")
	     (:td "&#8658 External IPs"))
	    (:tr
	     (:td)(:td)
	     (:td  (:textarea :rows 4 :cols 40 :name "ppip3"))
	     (:td  (:textarea :rows 4 :cols 40 :name "ppip4")))
	    (:tr
	     (:td :valign "top" "3. Text color:")
	     (:td :colspan 2
		  (:textarea :rows 15 :cols 60
			     :name "colorsettings" :class "txt")))
	    (:tr
	     (:td)
	     (:td  (:input :type "reset" :value "Reset" :class "btn"))
	     (:td  (:input :type "submit" :value "Process" :class "btn")))))))

(define-url-fn (pp-run)
  (let ((filepath (parameter "ppfilepath"))
	(ip1 (parameter "ppip1"))
	(ip2 (parameter "ppip2"))
	(ip3 (parameter "ppip3"))
	(ip4 (parameter "ppip4"))
	(colorset (parameter "colorsettings")))
    ;;;; print debug didn't output anything in slime-repl, use log-message
    ;;(print ip1)
    ;;(debug "pp-run" filepath ip1 ip2 ip3 ip4 colorset)
    (hunchentoot:log-message* 3 "~a~%" filepath)
    (standard-page-with-title (:title "pcap analysis")
      (htm
	(fmt "~a" (output2html-string filepath))))))


;;(output2html-string "c:/Users/Administrator/Desktop/program/little-things/pcap-output-for-sip-check/123.pcapng")
