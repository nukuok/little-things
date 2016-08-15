(in-package :kafka-demo)

(defparameter *ajax-processor-kafka*
  (make-instance 'ajax-processor :server-uri "/kafka-api"))

(defun last-items-number-to-show (ajax-topicname)
  (cond ((string-equal ajax-topicname "streams-file-input") 5)
	((string-equal ajax-topicname "streams-wordcount-output") 20)))

(defun function-for-ajax-get-records (ajax-topicname)
  (let ((results (last-items (get-all-records ajax-topicname (get-local-topic-offset ajax-topicname))
			     (last-items-number-to-show ajax-topicname))))
    ;; (log-message* 3 "heyhey-in-function ~A" ajax-topicname)
    (update-local-topic-offset ajax-topicname (caar (last results)))
    (all-records-to-table results)))

(defun-ajax ajax-get-records (ajax-topicname)
    (*ajax-processor-kafka* :callback-data :response-text)
  (log-message* 3 "heyhey ~A" ajax-topicname)
  (function-for-ajax-get-records ajax-topicname))

  

;; (in-package sbc-tools)

;; (defparameter *ajax-processor-plink-conversation*
;;   (make-instance 'ajax-processor :server-uri "/plink-conversation-api"))

;; (defvar *plink* (make-instance 'plink))
;; ;(setf *plink* (new-plink-connection '("-pw" "telecom" "telecom@10.22.98.203")))

