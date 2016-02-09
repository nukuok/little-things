(ql:quickload :cxml)


(defmacro setpath (symbol path)
  (let
      ((default-path "c:/Users/Administrator/Desktop/program/little-things/sip-check/xlsx/"))
    `(progn
       (defvar ,symbol)
       (setf ,symbol ,(concatenate 'string default-path path)))))


;;;; workbook.xml
(setpath *path1* "xl/workbook.xml")

(setf *temp0* (cxml:parse-file *path1* (cxml-dom:make-dom-builder)))
(setf *temp1* (dom:document-element *temp0*))
(setf *temp2* (dom:get-elements-by-tag-name *temp1* "sheets"))
(setf *temp3* (dom:get-elements-by-tag-name (aref *temp2* 0) "sheet"))
;;(setf *temp4* (dom:get-elements-by-tag-name (aref *temp3* 0) "sheet"))

(dom:get-attribute (aref *temp3* 0) "name")
(dom:get-attribute (aref *temp3* 0) "sheetId")
(dom:get-attribute (aref *temp3* 0) "r:id")

(loop for x in (coerce *temp3* 'list) do
     (let ((name (dom:get-attribute x "name"))
	   (sheetId (dom:get-attribute x "sheetId"))
	   (rid (dom:get-attribute x "r:id")))
       (format t"~A ~A ~A~%" name sheetId rid)))

(defun get-sheet-names (filepath)
  (let* ((temp0 (cxml:parse-file filepath (cxml-dom:make-dom-builder)))
	 (temp1 (dom:document-element temp0))
	 (temp2 (dom:get-elements-by-tag-name temp1 "sheets"))
	 (temp3 (dom:get-elements-by-tag-name (aref temp2 0) "sheet")))
    (loop for x in (coerce temp3 'list) collect
	 (let ((name (dom:get-attribute x "name"))
	       (sheetId (dom:get-attribute x "sheetId"))
	       (rid (dom:get-attribute x "r:id")))
	   (list name sheetId rid)))))

;;(dom:get-elements-by-tag-name *temp2* "sheet")

;;(setf *temp* (cxml:parse-file *path1* (cxml-xmls:make-xmls-builder)))

;;;; sheet1.xml

(defun insert-newline-to-xml (in out)
  (with-open-file (instream in :direction :input)
    (with-open-file (outstream out :direction :output
			       :if-exists :supersede
			       :if-does-not-exist :create)
      (loop
	 (let ((current-char (read-char instream nil "eofeofeof")))
	   (cond ((equal current-char "eofeofeof") (return))
		 ((equal current-char #\<) (format outstream "~%<"))
		 (t (format outstream "~A" current-char))))))))

(insert-newline-to-xml "sheet1.xml" "sheet1m.xml")

(setpath *path2* "xl/worksheets/sheet2.xml")

(defun get-sheet-item (filepath)
  (let* ((temp0 (cxml:parse-file filepath (cxml-dom:make-dom-builder)))
	 (temp1 (dom:document-element temp0))
	 (temp2 (dom:get-elements-by-tag-name temp1 "row")))
    temp2))

(defun filter-sheet-items (sheet-items-tag-c)
  (loop for x in (coerce sheet-items-tag-c 'list) append
       (let ((v (dom:get-elements-by-tag-name x "v"))
	     (r (dom:get-attribute x "r")))
	 (when (and (> (length v) 0)
		    (or (search "D" r) (search "G" r)))
	   (list (list r (dom:node-value (aref (dom:child-nodes (aref v 0)) 0))))))))

;;;; 

(insert-newline-to-xml "sharedStrings.xml" "sharedStringsm.xml")

(setpath *path3* "xl/sharedStrings.xml")

(defun get-shared-data (filepath)
  (let* ((temp0 (cxml:parse-file filepath (cxml-dom:make-dom-builder)))
	 (temp1 (dom:document-element temp0))
	 (temp2 (dom:get-elements-by-tag-name temp1 "si")))
    temp2))

;;;; old find rPr rPh tag
(defun ref-shared-data (data-vector index) 
  (let ((temp0 (dom:get-elements-by-tag-name (aref data-vector index) "t")))
    (format nil "~{~A~}"
     (loop for x in (coerce temp0 'list) collect
	;;	 (print (dom:node-value x)))))
       ;;	 (print (type-of x))))) ;; RUNE-DOM::ELEMENT
	  (princ (dom:node-value (aref (dom:child-nodes x) 0)))))))

(defun ref-shared-data (data-vector index) 
  (let ((temp0 (dom:child-nodes (aref data-vector index))))
    (format nil "~{~A~}"
	    (loop for x in (coerce temp0 'list) append
		 (if (equal "t" (dom:tag-name x))
		     (list (dom:node-value (aref (dom:child-nodes x) 0)))
		     (if (equal "r" (dom:tag-name x))
			 (list (dom:node-value
				(aref (dom:child-nodes
				       (aref (dom:get-elements-by-tag-name x "t")
					     0)) 0)))))))))



;;(loop for y in (coerce (dom:child-nodes x) 'list) do
;;	      (dom:node-value y))))))

(setf *temp* (get-shared-data *path3*))
(setf *temp-ref* (ref-shared-data *temp* 188))

(dotimes (x 500)
	(let ((ref-data (ref-shared-data *temp* x)))
	  (when (search "sip" ref-data)
	    (print "")
	    ref-data)))


;;;; sip message process
;;(defclass SIPmessage ()
;;  ((sip :accessor m-SIP :initial-form '(SIP))
;;   (sdp :accessor m-SDP :initial-form '(SDP))))

(defun process-a-message (instream &optional (result nil))
  (let ((currentline (read-line instream nil "eofeofeof")))
    (cond ((equal currentline "eofeofeof")
	   (reverse (cons (reverse (car result)) (cdr result))));;all over
	  ((equal currentline "")
	   (process-a-message instream
			      (list nil (reverse (car result)))));;sip part over
	  (t
	   (process-a-message instream
			      (cons (cons (process-a-line currentline)
					  (car result))
				    (cdr result)))))))

(defun process-a-line (line &optional charlist (result nil))
  (if (= (length line) 0)
      (reverse (cons (coerce (reverse charlist) 'string) result))
      (let ((currentchar (aref line 0)))
	(cond ((char-equal currentchar #\ )
	       (process-a-line (subseq line 1) nil
			       (cons (coerce (reverse charlist) 'string) result)))
	      ((or (char-equal currentchar #\@) (char-equal currentchar  #\:)
		   (char-equal currentchar  #\;) (char-equal currentchar #\=))
	       (process-a-line (subseq line 1) nil
			       (cons currentchar
				     (cons (coerce (reverse charlist) 'string)
					   result))))
	      (t (process-a-line (subseq line 1) (cons currentchar charlist)
		 result))))))


;;;; xlsx process
(defmacro setpath (symbol path)
  (let
      ((default-path "c:/Users/Administrator/Desktop/program/little-things/sip-check/xlsx/"))
    `(progn
       (defvar ,symbol)
       (setf ,symbol ,(concatenate 'string default-path path)))))


(defun process-xlsx-folder (path)
  (let ((default-

	 
