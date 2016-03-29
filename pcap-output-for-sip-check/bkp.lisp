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
		   (char-equal currentchar  #\,)
		   (char-equal currentchar  #\;) (char-equal currentchar #\=))
	       (process-a-line (subseq line 1) nil
			       (cons currentchar
				     (cons (coerce (reverse charlist) 'string)
					   result))))
	      (t (process-a-line (subseq line 1) (cons currentchar charlist)
		 result))))))

(defun output-2html (left-messages right-messages)
  (let ((temp1 (car left-messages))
	(temp2 (car right-messages)))
    (multiple-value-bind (temp1-result temp2-result index-pairs)
	(compare-message (make-string-input-stream temp1)
			 (make-string-input-stream temp2))
      (standard-page (:title "test")
	(:div :id "\"contents\""
	      (:table
	       (loop
		  for tr1 in (html-escape temp1-result)
		  for z in index-pairs
		  for tr2 in (html-escape temp2-result) do
		    (cl-who:htm
		     (:tr
		      (:td (cl-who:fmt
			    (format nil "~{~a~}" (set-color-list tr1))))
		      (:td (cl-who:fmt (format nil "~2,' d" z)))
		      (:td (cl-who:fmt
			    (format nil "~{~a~}" (set-color-list tr2))))
		      )))))))))

(defun compare-parted-message-blocks (eva-mb base-mb &optional (outstream t))
  (let ((matched-indexes (matched-indexes-search eva-mb base-mb)))
    ;;(print matched-indexes)
    (let ((matched-lines (loop for x in matched-indexes collect
			    (when x (nth x eva-mb)))))
      (print "abcdefg")
      (print matched-indexes)
      (print matched-lines)
      (let ((diff-evaluated (diff-output base-mb matched-lines matched-indexes outstream)))
	(append (diff-output-complete eva-mb base-mb matched-indexes diff-evaluated) (list matched-indexes))))))

(defun diff-output-complete (eva-mb base-mb matched-indexes diff-evaluated)
  (let (eva-result base-result)
    (loop for x in matched-indexes for ii from 0 do
	 (let ((matched (nth ii matched-indexes))
	       (evaluated-item (nth ii diff-evaluated))
	       (ii-position (position ii matched-indexes)))
	   (if matched
	       (push (cadr evaluated-item) base-result)
	       (push (nth ii base-mb) base-result))
	   (if ii-position
	       (push (car (nth ii-position diff-evaluated)) eva-result)
	       (push (nth ii eva-mb) eva-result))))
    (list (reverse eva-result) (reverse base-result))))

(defun diff-output (base-mb matched-lines matched-indexes &optional (outstream t))
  (let ((base-matched (filter-matched base-mb matched-indexes)))
    (loop for a-eva-line in matched-lines
       for a-base-line in base-matched collect
	 (cdr (assoc "sentence-diff" (compare-message-sentence a-eva-line a-base-line outstream) :test #'equal)))))


(defun output-2html (left-messages right-messages)
  (let ((temp1 (car left-messages))
	(temp2 (car right-messages)))
    (multiple-value-bind (temp1-result
			  temp2-result matched-index-base matched-index-eva)
	(compare-message (make-string-input-stream temp1)
			 (make-string-input-stream temp2))
      (standard-page (:title "test")
	(:div :id "\"contents\""
	      (:table
	       (loop
		  for tr1 in (html-escape temp1-result)
		  for y in matched-index-base
		  for z in matched-index-eva
		  for tr2 in (html-escape temp2-result) do
		    (debug "output-2html" tr1 y z tr2)
		    (cl-who:htm
		     (:tr
		      (:td (cl-who:fmt
			    (format nil "~{~a~}" (set-color-list tr1))))
		      (:td (cl-who:fmt ;;(format nil "~2,'_d" z)))
			    (cond ((not (null z)) (format nil "~2,'_d" z))
				  ((null tr2) "N/A")
				  (t (set-color '("nil" "red"))))))
		      (:td (cl-who:fmt ;;(format nil "~2,'_d" y)))
			    (cond ((not (null y)) (format nil "~2,'_d" y))
				  ((null tr1) "N/A")
				  (t (set-color '("nil" "red"))))))
		      (:td (cl-who:fmt
			    (format nil "~{~a~}" (set-color-list tr2))))
		      )))))))))


(defun output-messages-2html (eva-messages base-messages)
  (standard-page (:title "test")
    (:div :id "\"contents\""
	  (:table
	    (loop
	       for temp1 in eva-messages
	       for temp2 in base-messages do
		 (multiple-value-bind (temp1-result
				       temp2-result
				       matched-index-base matched-index-eva)
		     (compare-message (make-string-input-stream temp1)
				      (make-string-input-stream temp2))
		   (cl-who:htm (:tr (:td "========================================")
				    (:td "<>")
				    (:td " ")
				    (:td "<>")
				    (:td "========================================")))
		   (loop			
		      for tr1 in (html-escape temp1-result)
		      for z in matched-index-eva
		      for y in matched-index-base
		      for tr2 in (html-escape temp2-result) do
			(debug "output-2html-2" tr1 z y tr2)
			(cl-who:htm
			 (:tr
			  (:td (cl-who:fmt
				(format nil "~{~a~}" (set-color-list tr1))))
			  (:td (cl-who:fmt ;;(format nil "~2,'_d" z)))
				(cond ((not (null z)) (format nil "~2,'_d" z))
				      ((null tr1) "N/A")
				      (t (set-color '("NIL" "red"))))))
			  (:td (cl-who:fmt ;;(format nil "~2,'_d" y)))
				(cond ((not (null y)) (format nil "~2,'_d" y))
				      ((null tr2) "N/A")
				      (t (set-color '("NIL" "red"))))))
			  (:td (cl-who:fmt
				(format nil "~{~a~}" (set-color-list tr2))))
			  )))))))))
