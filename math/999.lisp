(defvar *origin-list*)
(defvar *fomula*)
(defvar *temp*)
(defvar *result*)

(setf *origin-list* '(1 2 3 4 5 6 7 8 9))
(setf *fomula* (lambda (a b c d e f g h i)
		 (= 999 (+ (* 100 (+ a d g))
			   (* 10 (+ b e h))
			   (+ c f i)))))

;;(funcall *fomula* 1 2 5 3 9 6 4 7 8)

;;;; too long to calculate
(defun all-arrange (item-list)
  (let ((list-length (length item-list)))
    (cond ((< list-length 0) "no-result")
	  ((= list-length 1) (list item-list))
	  (t (loop for x in item-list append
		  (mapcar (lambda (mame) (cons x mame))
			  (all-arrange (remove x item-list))))))))

(defun filter (item-list fomula)
  (loop for x in item-list append
       (if (apply fomula x)
	   (list x)
	   nil)))

(setf *temp* (all-arrange '(1 2 3 4 5 6 7 8 9)))
(setf *result*  (filter *temp* *fomula*))

(print (remove-duplicates
	(loop for x in *result* collect
	     (sort (apply
		    (lambda (a b c d e f g h i)
		      (list (+ (* 100 a) (* 10 b) c)
			    (+ (* 100 d) (* 10 e) f)
			    (+ (* 100 g) (* 10 h) i)))
		    x) #'<))
       :test #'equal))

(print (remove-duplicates  
	(loop for x in *result* collect
	     (apply 
	      (lambda (a b c d e f g h i)
		(list (sort (list a d g) #'<)
		      (sort (list b e h) #'<)
		      (sort (list c f i) #'<))) x))
       :test #'equal))


;;;;
(defun fact (n)
  (labels ((iter (n result)
	     (cond ((= n 0) 1)
		   ((= n 1) result)
		   (t (iter (- n 1) (* n result))))))
    (iter n 1)))

(setf *temp* (make-array (fact 9)))

(defun list-left-shift (list)
  (append (cdr list) (list (car list))))

;;;; 1~9 1~9 array 0 9
(defun all-arrange-iter (item-list position-list result start-position line-length)
  (let ((item-number (length item-list)))
    (dotimes (ii (fact (- item-number 1)))
      (setf (aref result (+ start-position
			    (car position-list)
			    (* ii line-length))) (car item-list)))
    (when (> item-number 1)
      (all-arrange-iter (cdr item-list) (cdr position-list) result
			start-position line-length))
    (unless (= (car position-list) (apply #'max position-list))
    ;;(unless (= (+ start-position (fact (- item-number 1)))
    ;;(fact item-number))
      (all-arrange-iter item-list (list-left-shift position-list) result
			(+ start-position (* line-length (fact (- item-number 1))))
			line-length))))
     
(defun all-arrange (list)
  (let ((result (make-array (* (length list) (fact (length list))))))
    (all-arrange-iter list
		      (loop for x from 0 to (- (length list) 1) collect x)
		      result
		      0
		      (length list))
    result))

(all-arrange '(1 2 3))
;;;;#(1 2 3 1 3 2 3 1 2 0 1 0 2 3 1 3 2 1)
;;;; problem in "unless" line, terminate the recursion too early

