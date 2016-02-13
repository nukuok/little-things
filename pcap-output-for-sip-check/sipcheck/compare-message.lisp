(defun get-message-type (parted-message)
  (let ((first-word (car parted-message)))
    (if (equal first-word "SIP/2.0")
	(cadaar parted-message)
	first-word)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; compact form
(unintern '*compact-pairs*)
(defvar *compact-pairs* '(("i" "Call-ID")("m" "Contact")("e" "Content-Encoding")("l" "Content-Length")("c" "Content-Type")("f" "From")("s" "Subject")("k" "Supported")("t" "To")("v" "Via")))

(defun compact-to-normal (parted-message)
  (labels ((compact-member (x y)
	     (equal x (car y))))
    (loop for sentence in parted-message collect
	 (let ((compact-pair (member (car sentence) *compact-pairs*
				    :test #'compact-member)))
	   (if compact-pair
	       (cons (cadar compact-pair) (cdr sentence))
	       sentence)))))

;;(compact-to-normal '(("i"  a b c) ("m" ads de r)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; for parted message block (a SIP block or a SDP block)
(defun find-all (item sequence &optional (result nil) &key (test #'=))
  (let ((member-result (member item sequence)))
    (cond ((null sequence) result)
	  ((null member-result) result)
	  (t (find-all item (cdr member-result)
		       (cons (car member-result) result) :test test)))))

(defun find-all-position (item sequence &optional (test #'=)
					  (result (list nil (list -1)))) 
  (let ((member-result (member item sequence :test test))
	(position-result (position item sequence :test test)))
    (cond ((null sequence) result)
	  ((null member-result) result)
	  (t 
	     (find-all-position item (cdr member-result) test
				(list (cons (car member-result) (car result))
				      (cons (+ 1 position-result (caadr result))
					    (cadr result))))))))

(defun min-difference (item sequence eva-fun result-fun); result-form: (index distance)
  (let ((differences
	 (loop for x in sequence
	    for index from 0 collect
	      (list index (funcall result-fun (funcall eva-fun item x))))))
    (car (sort differences (lambda (x y) (< (cadr x) (cadr y)))))))

(defun calc-difference (item sequence eva-fun result-fun); result-form: (index distance)
  (let ((differences
	 (loop for x in sequence
	    for index from 0 collect
	      (list index (funcall result-fun (funcall eva-fun item x))))))
    differences))

(defun own-min (result-list)
  (car (sort result-list (lambda (x y) (< (cadr x) (cadr y))))))

;;*fixed-list* '(2 3)
;;(min-difference '(1 2 3) '((1 3 4 5) (2 3 4 5) (3 4 5 6) (2 2 3 6 7)) (car *ps-methods*) (car *ps-q-methods*))
;;(min-difference '(1 2 3) '((1 3 4 5) (2 3 4 5) (3 4 5 6) (2 2 3 6 7)) (cadr *ps-methods*) (cadr *ps-q-methods*))
;;(calc-difference '(1 2 3) '((1 3 4 5) (2 3 4 5) (3 4 5 6) (2 2 3 6 7)) (cadr *ps-methods*) (cadr *ps-q-methods*))

(defun acc-diff-result (diff-result &optional (result nil))
  (cond ((null diff-result) result)
	((null result) (acc-diff-result (cdr diff-result) (car diff-result)))
	(t (print diff-result)
	 (acc-diff-result
	    (cdr diff-result)
	    (loop for x in (car diff-result)
	       for y in result collect
		 (list (car x) (+ (cadr x) (cadr y))))))))

(defun acc-diff-result (diff-result &optional (result nil))
  (mapcar (lambda (x) (list (caar x) (+ (cadar x) (cadadr x)))) diff-result))

(defun matched-indexes-search (eva-mb base-mb)
  (loop for x in base-mb collect
       (let ((all-same-headers
	      (find-all-position x eva-mb
				 (lambda (x y) (equal (car x) (car y))))))
	 (let ((same-header-lines (car all-same-headers))
	       (same-header-indexes (cadr all-same-headers)))
	   (let ((differences
		  (acc-diff-result
		   (loop for a-line in same-header-lines
		      for index in same-header-indexes collect
			(loop for m in *ps-methods*
			   for n in *ps-q-methods* collect
			     (list index (funcall n (funcall m x a-line nil))))))))
	     (car (own-min differences)))))))

;;o(setf *temp2* (ref-shared-data *temp* 384))

(defun diff-output (base-mb matched-lines &optional (outstream t))
  (loop for a-eva-line in matched-lines
     for a-base-line in base-mb collect
       (cdr (assoc "sentence-diff" (compare-message-sentence a-eva-line a-base-line outstream) :test #'equal))))

(defun compare-parted-message-blocks (eva-mb base-mb &optional (outstream t))
  (let ((matched-indexes (matched-indexes-search eva-mb base-mb)))
    (let ((matched-lines (loop for x in matched-indexes
			    append (when x (list (nth x eva-mb))))))
      (let ((diff-evaluated (diff-output base-mb matched-lines outstream)))
	diff-evaluated))))
	     
;;(compare-parted-message-blocks
;; (car (process-a-message (make-string-input-stream *temp2*)))
;; (car (process-a-message (make-string-input-stream *temp3*))) nil)

;;(funcall (cadr *ps-q-methods*) (funcall (cadr *ps-methods*) '("SIP/2.0" "180" "Ringing") '("SIP/2.0" "180" "Ringing")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
(defun mask-sentence (parted-sentence)
  (loop for x in parted-sentence collect
       (if (member x *fixed-list* :test #'equal)
	   x
	   "--masked--")))

(defun compare-message (eva-message base-message &optional (outstream t)) ;;sip sdp block
  (let ((parted-message1 (process-a-message eva-message))
	(parted-message2 (process-a-message base-message)))
    (let ((sip-m1 (compact-to-normal (car parted-message1)))
	  (sip-m2 (compact-to-normal (car parted-message2)))
	  (sdp-m1 (cadr parted-message1))
	  (sdp-m2 (cadr parted-message2)))
      (let ((masked-sip-m1 (loop for x in sip-m1 collect (mask-sentence x)))
	    (masked-sip-m2 (loop for x in sip-m2 collect (mask-sentence x)))
	    (masked-sdp-m1 (loop for x in sip-m1 collect (mask-sentence x)))
	    (masked-sdp-m2 (loop for x in sip-m2 collect (mask-sentence x))))
	(compare-message-sequence sip-m1 sip-m2 outstream)
	(compare-message-sequence sdp-m1 sdp-m2 outstream)
	(print (compare-parted-message-blocks sip-m1 sip-m2 outstream))
	(print (compare-parted-message-blocks sdp-m1 sdp-m2 outstream))))))

;;(setpath *path3* "xl/sharedStrings.xml")
;;(load "data-extract2.lisp")
;;(get-shared-data *path3*)
;;(setf *temp* *)
;;(setf *temp2* (ref-shared-data *temp* 386))

