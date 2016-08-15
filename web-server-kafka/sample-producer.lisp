(in-package :kafka-demo)

;; {
;;     "app": "tabelog-dtlside",
;;     "hostname": "d-so-tr11.coreprice.com",
;;     "hits": "10",
;;     "timestamp": "2014-12-03 11:28:17",
;;     "res_time": "12",
;;     "status": "0" 
;; }


(defun current-date ()
  (multiple-value-bind
	(second minute hour date month year) ;;  day-of-week dst-p tz)
      (get-decoded-time)
    (format nil "~4,'0d-~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d" 
	      year month date hour minute second)))


;; (stream-result-to-string #'generate-data)
(defun stream-result-to-string (func)
  (let ((out-to (make-string-output-stream)))
     (funcall func out-to)
     (let ((result (get-output-stream-string out-to)))
       result)))

(defun generate-data (&optional (out-stream nil))
  (yason:encode
   (alexandria:plist-hash-table (list "app" "kafka-example"
			"hostname" "localhost"
			"hits" (write-to-string (random 5))
			"timestamp" (current-date)
			"res_time" (write-to-string (random 200))
			"status" "0"))
   out-stream))

(defun run-interval (interval &optional (start-point 0))
    (loop
       (let ((current-point (mod (get-universal-time) interval)))
	 (when (> current-point start-point)
	   (print current-point)
	   (setf start-point current-point)
	   (post-to-topic-raw "WordsWithCountsTopic" (stream-result-to-string #'generate-data))))))

			
(defun generate-data2 ()
  (let ((data '("PageA-0hit" "PageB-0hit" "PageC-0hit" "PageD-0hit")))
    (post-to-topic-raw "UserClicks" (nth (random 3) data))))

(defun run-interval2 (times-per-second)
  (loop 
    (loop for x below times-per-second do
	 (generate-data2))
     (sleep 1)))

(defun integer-to-long (num)
  (concatenate 'string (format nil "~64,'0b" num) "00000000"))

(defun generate-review-comments ()
  (with-open-file (instream "~/Downloads/reviewcomment.txt" :direction :input)
    (read-line instream)
    (as:start-event-loop
     (lambda ()
       (as:interval
	(lambda ()
	  (post-to-topic-raw
	   "streams-file-input"
	  ;; (print
	   (sequence-to-string (flexi-streams:string-to-octets
				(cadr (string-split (read-line instream) #\tab))
				:external-format :utf-8))))
	:time 5)))))

