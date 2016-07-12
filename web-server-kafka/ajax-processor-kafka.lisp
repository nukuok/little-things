(in-package :kafka-demo)

(defparameter *ajax-processor-kafka*
  (make-instance 'ajax-processor :server-uri "/kafka-api"))

(defun-ajax ajax-get-records (topicname)
    (*ajax-processor-kafka* :callback-data :response-text)
  ;; (log-message* 3 "heyhey ~A" topicname)
  (all-records-to-table (last-items (get-all-records topicname 0))))

  

;; (in-package sbc-tools)

;; (defparameter *ajax-processor-plink-conversation*
;;   (make-instance 'ajax-processor :server-uri "/plink-conversation-api"))

;; (defvar *plink* (make-instance 'plink))
;; ;(setf *plink* (new-plink-connection '("-pw" "telecom" "telecom@10.22.98.203")))

