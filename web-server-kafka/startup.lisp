(in-package :kafka-demo)

(defvar parenscript::suppress-values? nil)

;;; start & stop
(defparameter *server*
  (make-instance 'easy-acceptor :port 8000))

(setf (acceptor-document-root *server*) "./")

(setq *dispatch-table* (list 'dispatch-easy-handlers
			     (create-ajax-dispatcher *ajax-processor-kafka*)))

;;; add router
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
    (standard-page-with-title (:title "A Kafka demo")
      (:h1 "A Kafka Demo")
      (htm (fmt "Some contents"))))

      ;; (:table
      ;;  (loop for x in *tools*
      ;; 	  for index from 1 do 
      ;; 	    (htm
      ;; 	     (:tr
      ;; 	      (:td (:h2 (fmt "~d. ~a" index (tool-name x))))
      ;; 	      (:td (:h2 "&nbsp&nbsp>&nbsp&nbsp"))
      ;; 	      (:td (:h2 (:a :href (format nil "~a" (tool-link x))
      ;; 			    (fmt "link"))))))))))

