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
	(:td (:div :id "allrecords"))))


(push-to-handler-html-body
 *kafka*
 (:table
  (:tr
   (:td (:textarea :rows 3 :cols 76
		   :id "topicname" :class "txt" "UserClicks")))
  (:tr
   (str *area1*))))


(push-to-handler-html-head
 *kafka* 
 (:script :type "text/javascript"
	  (str (ps
		 (defun callback-get-all-records (response)
		   ;;(alert response)
		   (setf (chain document
				(get-element-by-id "allrecords")
				inner-h-t-m-l) response))
		 (defun front-get-all-records ()
		   (progn
		     ;;(alert "front-get-all-records")
		     (chain smackjack (ajax-get-records
				       (chain document
					      (get-element-by-id "topicname")
					      value)
				       callback-get-all-records))))
		 (defvar timer-i-d)
		 (defun set-timer ()
		   (progn
		     ;;(alert "set-timer")
		     (chain (clear-interval timer-i-d))
		     (setf timer-i-d
			   (chain (set-interval
				   front-get-all-records 500)))))
		 (set-timer)))))


