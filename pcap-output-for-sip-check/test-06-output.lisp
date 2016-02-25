(ql:quickload :cl-who)
;;(load "processpcap/module.lisp")
;;(load "sipcheck/module.lisp")

(load "sipcheck/data-extract2.lisp")
(load "sipcheck/check.lisp")
(load "sipcheck/compare-message.lisp")
(load "sipcheck/data.lisp")

(load "processpcap/tools.lisp")
(load "processpcap/test-05-udp.lisp")
(load "processpcap/output-to-var.lisp")
(load "processpcap/rtp.lisp")

(load "ip-header.lisp")
(load "tools.lisp")
(load "html.lisp")

(defvar *ip-list* nil)

(defun push-to-ip-list (number ip)
  (unless (member ip (assoc number *ip-list*) :test #'equal)
    (nconc (assoc number *ip-list*) (list ip))))

(defun determine-column-and-array (ip)
  (let* ((iplist (coerce ip 'list))
	 (result    
	  (apply #'min (loop for x in *ip-header-list*
			  collect (- 5 (length
					  (member iplist x :test #'equal)))))))
    (push-to-ip-list result iplist)
    result))

(defun get-messages-from-ppcap (p-pcap-result)
  (let (left-messages right-messages)
    (loop for x in (remove-duplicates p-pcap-result) do
	 (let ((source (determine-column-and-array (car x))))
	       (cond
		 ((or (= source 1) (= source 2))
		  (push (seq-to-string
			 (remove 13 (caddr x))) left-messages)) ;; remove #\return
		 ((or (= source 3) (= source 4))
		  (push (seq-to-string
			 (remove 13 (caddr x))) right-messages))
		 (t nil))))
    (list (reverse left-messages) (reverse right-messages))))

;;(cl-who:with-html-output-to-string (*standard-output*) (:font :color "red" "def"))

;;(defmacro set-color (a b)
;;  `(progn (print ,a) (print ,b)
;;	  (cl-who:with-html-output-to-string (s) (:font :color ,b ,a))))

(defun set-color (x)
  (format nil "<font color='~A'>~A</font>" (cadr x) (car x)))

(defun convert-ppcap-to-html (filename)
  (let ((text-result (get-messages-from-ppcap (pcap-process filename))))
    (output-2html (car text-result) (cadr text-result))))

(defun set-color-list (mame)
  (progn
    (print mame)
    (mapcar (lambda (x)
	      (if (consp x)
		  (set-color x)
		  x)) mame)))

(defun set-nil-to-red (a-list)
  (substitute-if  (set-color '("NIL" "red")) #'null a-list))



(defun _totail (num)
  (cond ((not (integerp num)) num)
	((> num 99) (format nil "~d__" num))
	((> num 9) (format nil "~d___" num))
	(t (format nil "~d____" num))))

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
				    (:td "<>")
				    (:td "========================================")))
		   (loop for x from 0 do
			(let 
			    ((tr1 (nth x (html-escape temp1-result)))
			     (z (nth x matched-index-eva))
			     (y (nth x matched-index-base))
			     (tr2 (nth x (html-escape temp2-result))))
			  (unless (or tr1 z y tr2) (return))
			  (debug "output-2html-2" tr1 z y tr2)
			  (cl-who:htm
			   (:tr
			    (:td (cl-who:fmt
				  (format nil "~{~a~}" (set-color-list tr1))))
			    (:td (cl-who:fmt ;;(format nil "~2,'_d" z)))
				  (cond ((not (null z))
					 (format nil "~a" (_totail z)))
					((null tr1) "N/A")
					(t (set-color '("NIL" "red"))))))
			    (:td (cl-who:fmt ;;(format nil "~2,'_d" y)))
				  (cond ((not (null y)) (format nil "~5,'_d" y))
					((null tr2) "N/A")
					(t (set-color '("NIL" "red"))))))
			    (:td (cl-who:fmt
				  (format nil "~{~a~}" (set-color-list tr2))))
			    ))))))))))

(defun output-message-2html (eva-message base-message)
  (standard-page (:title "test")
    (:div :id "\"contents\""
	  (:table
	   (multiple-value-bind (temp1-result
				 temp2-result
				 matched-index-base matched-index-eva)
	       (compare-message (make-string-input-stream eva-message)
				(make-string-input-stream base-message))
	     (loop for x from 0 do
		  (let 
		      ((tr1 (nth x (html-escape temp1-result)))
		       (z (nth x matched-index-eva))
		       (y (nth x matched-index-base))
		       (tr2 (nth x (html-escape temp2-result))))
		    (unless (or tr1 z y tr2) (return))
		    (debug "output-2html-2" tr1 z y tr2)
		    (cl-who:htm
		     (:tr
		      (:td (cl-who:fmt
			    (format nil "~{~a~}" (set-color-list tr1))))
		      (:td (cl-who:fmt ;;(format nil "~2,'_d" z)))
			    (cond ((not (null z))
				   (format nil "~a" (_totail z)))
				  ((null tr1) "N/A")
				  (t (set-color '("NIL" "red"))))))
		      (:td (cl-who:fmt ;;(format nil "~2,'_d" y)))
			    (cond ((not (null y)) (format nil "~5,'_d" y))
				  ((null tr2) "N/A")
				  (t (set-color '("NIL" "red"))))))
		      (:td (cl-who:fmt
			    (format nil "~{~a~}" (set-color-list tr2))))
		      )))))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; html escape

(defun html-escape (tree)
  (process-tree (lambda (x) (if (stringp x)
				(substitute-for-html-string x)
				x)) tree))

(defmacro substitute-char-for-html-string (special-char special-string the-line)
  `(loop
      (let ((position-special-char (position ,special-char ,the-line)))
	(if position-special-char
	    (setf ,the-line (concatenate
			   'string
			   (subseq ,the-line 0 position-special-char)
			   ,special-string
			   (subseq ,the-line (+ 1 position-special-char))))
	    (return)))))
  
(defun substitute-for-html-string (line)
  (let ((result line))
    (substitute-char-for-html-string #\< "&lt;" result)
    (substitute-char-for-html-string #\> "&gt;" result)
    (substitute-char-for-html-string #\" "&quot;" result)
    result))

;; (get-messages (processpcap::pcap-process "123.pcapng"))
;; (get-messages-from-ppcap (pcap-process "123.pcapng"))
;; (setf *temp* *)
;; (process-a-message (make-string-input-stream (car (car *temp*))))


;;(setf *temp2* (get-messages-from-ppcap (pcap-process "123.pcapng")))
;;(setf *tt1* (nth 8 (car *temp2*)))
;;(setf *tt2* (nth 11 (cadr *temp2*)))
;;(compare-message (make-string-input-stream *tt2*) (make-string-input-stream *tt1*))

