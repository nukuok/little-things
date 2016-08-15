(in-package :kafka-demo)

;;(scenario-run (scenario-read "scenario/nakahara_2_login.scenario") nil)
;;(scenario-run (scenario-read "scenario/nakahara_2_logout.scenario") nil)

(setf *js-string-delimiter* #\")

(defclass easy-handler-html ()
  ((head :accessor handler-html-head :initform nil)
   (body :accessor handler-html-body :initform nil)))

(defmacro push-to-handler-html-head (handler sentence)
  `(push (with-html-output-to-string (s nil :indent t) ,sentence)
	 (handler-html-head ,handler)))

(defmacro push-to-handler-html-body (handler sentence)
  `(push (with-html-output-to-string (s nil :indent t) ,sentence)
	(handler-html-body ,handler)))

(defvar *kafka* nil)
(setf *kafka* (make-instance 'easy-handler-html))

(define-easy-handler (kafka :uri "/kafka") ()
  (with-html-output-to-string (s nil :indent t)
    (:html
     (:head
      (str (apply
       #'concatenate
       (cons 'string (loop for x in
			  (reverse (handler-html-head *kafka*)) collect x)))))
     (:body
      (str (apply
       #'concatenate
       (cons 'string (loop for x in
			  (reverse (handler-html-body *kafka*)) collect x))))))))

(push-to-handler-html-head
 *kafka*
 (:title "A Kafka Demo"))

(push-to-handler-html-head
 *kafka*
 (str (generate-prologue *ajax-processor-kafka*)))

(defvar *area1* nil)
(setf *area1*
      (with-html-output-to-string (s nil :indent 1)
	(:td :style "width:600px" (:div :id "input"))))

(defvar *area2* nil)
(setf *area2*
      (with-html-output-to-string (s nil :indent 1)
	(:td :style "width:200px" (:div :id "output"))))

(push-to-handler-html-body
 *kafka*
 (:table
  (:tr
   (:td (str *area1*))
   (:td (str *area2*)))))


(push-to-handler-html-head
 *kafka* 
 (:script :type "text/javascript"
	  (str (ps
		 (defun callback-get-input (response)
		   ;;(alert response)
		   (setf (chain document
				(get-element-by-id "input")
				inner-h-t-m-l) response))
		 (defun front-get-input ()
		   (progn
		     ;; (alert "front-get-input")
		     (chain smackjack (ajax-get-records
				       ;; (chain document
					      ;; (get-element-by-id "topicname")
				       "streams-file-input"
					      ;; value)
				       callback-get-input))))
		 (defun callback-get-output (response)
		   ;;(alert response)
		   (setf (chain document
				(get-element-by-id "output")
				inner-h-t-m-l) response))
		 (defun front-get-output ()
		   (progn
		     ;; (alert "front-get-output")
		     (chain smackjack (ajax-get-records
				       ;; (chain document
					      ;; (get-element-by-id "topicname")
				       "streams-wordcount-output"
					      ;; value)
				       callback-get-output))))

		 (defvar timer-i-d-input)
		 (defun set-timer-input ()
		   (progn
		     ;;(alert "set-timer")
		     (chain (clear-interval timer-i-d-input))
		     (setf timer-i-d-input
			   (chain (set-interval
				   front-get-input 1000)))))
		 (set-timer-input)

		 (defvar timer-i-d-output)
		 (defun set-timer-output ()
		   (progn
		     ;;(alert "set-timer")
		     (chain (clear-interval timer-i-d-output))
		     (setf timer-i-d-output
			   (chain (set-interval
				   front-get-output 1000)))))
		 (set-timeout (set-timer-output) 1000)))))


