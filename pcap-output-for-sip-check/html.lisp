(ql:quickload :cl-who)
(ql:quickload :parenscript)
(ql:quickload :cffi)
(pushnew "." cffi:*FOREIGN-LIBRARY-DIRECTORIES*)
;;(ql:quickload :hunchentoot)

(defmacro standard-page ((&key title) &body body)
  `(cl-who:with-html-output-to-string (s nil :prologue t :indent t)
     (:html :xmlns "http://www.w3.org/1999/xhtml"  :xml\:lang "en" :lang "en"
	    (:head 
	     (:meta :http-equiv "Content-Type" :content "text/html;charset=utf-8")
	     (:style :type "text/css"
		     "<!--
		     table {
		     #width: 100%;
		     border-collapse: collapse;
		     font-size: 8pt;
		     font-family: Tahoma;
		     }
		     
		     th {
		     font-weight: normal;
		     background-color: #F0F0F0;
		     border:1px solid #BFBFBF;
		     text-align: center;
		     #padding: 12px;
		     }
		     
		     tr {
		     #width: 10%;
		     background-color: #FFFFFF;
		     border:1px solid #BFBFBF;
		     text-align: left;
		     #padding: 12px;
		     }
		     
		     td {
		     #width: 10%;
		     background-color: #FFFFFF;
		     border:1px solid #BFBFBF;
		     #padding: 12px;
		     }
		     //-->")
	     (:title ,title))
	    (:body 
	     ,@body))))



