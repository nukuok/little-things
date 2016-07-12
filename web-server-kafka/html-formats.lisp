(in-package :kafka-demo)

(defun all-records-to-table (result-list)
  (with-html-output-to-string (s nil :indent 1)
    (htm (:table
	  (loop for item in result-list collect
	       (htm (:tr
		     (htm (:td (str (car item))))
		     (htm (:td (str (cadr item)))))))))))


(defun last-items (result-list &optional (needed-len 20))
  (labels ((iter (tail-list list-len)
	     (if (<= list-len needed-len)
		 tail-list
		 (iter (cdr tail-list) (- list-len 1)))))
    (iter result-list (length result-list))))

