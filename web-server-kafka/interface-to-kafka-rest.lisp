(in-package :kafka-demo)


;;; The REST proxy uses content types for both requests and responses to indicate 3 properties of the data:
;;; the serialization format (e.g. json),
;;; the version of the API (e.g. v1),
;;; and the embedded format (e.g. binary or avro).
;;; Currently, the only serialization format supported is json and the only version of the API is v1.

;;; application/vnd.kafka[.embedded_format].[api_version]+[serialization_format]
;;; Accept: application/vnd.kafka.v1+json; q=0.9, application/json; q=0.5

;; (let* ((url "http://eow.alc.co.jp/search?q=application"))
;;        (drakma:http-request url :proxy-basic-authorization *fw-auth*))

;;; GET /topics HTTP/1.1
;;; Host: kafkaproxy.example.com
;;; Accept: application/vnd.kafka.v1+json, application/vnd.kafka+json, application/json

;;; common part 
(defmacro to-scheme (list)
  `(concatenate 'string "http://" ,@list))

(defmacro common-request (for-to-scheme method &key (accept "application/vnd.kafka.v1+json")
						 (content "")
						 (content-type "application/vnd.kafka.v1+json"))
  `(drakma:http-request (to-scheme ,for-to-scheme)
		       :method ,method
		       :accept ,accept
		       :content-type ,content-type
		       :content ,content))

;;; interface 
(defmacro raw-data-package (contents output-stream)
  `(yason:encode
    (a-pht "records" (list (a-pht "value" ,contents)))
    ,output-stream))


(defun extract-value-in-record (record)
  (base64-string-to-string (json-assoc "value" (nth 0 (yason:parse record)))))

(defmacro get-topics ()
  `(common-request (*kafka-rest-ip* ":8082/topics") :get))

(defmacro get-topic-info (topic-name)
  `(common-request (*kafka-rest-ip* ":8082/topics/" ,topic-name) :get))



(defmacro post-to-topic (topic-name contents)
    `(common-request (*kafka-rest-ip* ":8082/topics/" ,topic-name) :post
		     :content ,contents
		     :content-type "application/vnd.kafka.binary.v1+json"
		     :accept "application/vnd.kafka.v1+json, application/vnd.kafka+json, application/json"))

(defun post-to-topic-raw (topic-name contents)
    (let ((out-to (make-string-output-stream)))
      (raw-data-package (string-to-base64-string contents) out-to)
      (let ((packaged-contents (get-output-stream-string out-to)))
	(post-to-topic topic-name packaged-contents))))

;;; curl "http://localhost:8082/topics/finetopic/partitions/0/messages?offset=9"
(defmacro get-record (topic-name offset &optional (partition 0))
  `(common-request (*kafka-rest-ip* ":8082/topics/" ,topic-name
				    "/partitions/" (write-to-string ,partition)
				    "/messages?offset=" (write-to-string ,offset)) :get))

(defmacro get-all-records (topic-name from-offset)
  `(labels ((iter (result offset)
	     (let ((record (sequence-to-string (get-record ,topic-name offset))))
	       (if (equal record "[]")
		   result
		   (iter (append result
				 (list (list offset (extract-value-in-record record)))) (+ 1 offset))))))
    (iter nil ,from-offset)))


