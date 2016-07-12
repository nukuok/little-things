(define-url-fn (pcap-process)
  (standard-page-with-title (:title "pcap process")
    (:h1 "pcap process settings")
    (:form :action "/pp-run.htm" :method "post"
	   :onsubmit (ps-inline
		      (when (= pp-filepath.value "")
			(alert "File path empty!")
			(return false)))
	   (:table
	    (:tr
	     (:td "File path:")
	     (:td :colspan 3
		  (:p (:input :type "text" :name "pp-filepath"
			      :size 111 :cols 60 :class "txt"))))
	    (:tr
	     (:td "IP picking:")
	     (:td "Internal IPs 1")
	     (:td "SBC Internal IPs"))
	    (:tr
	     (:td)
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip1")))
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip2")))
	     (:td ))
	    (:tr
	     (:td) (:td)
	     (:td "SBC External IPs")
	     (:td "External IPs"))
	    (:tr
	     (:td)(:td)
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip3")))
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip4"))))
	    (:tr
	     (:td "Text color:")
	     (:td :colspan 2
		  (:p (:textarea :rows 15 :cols 60
				 :name "color-settings" :class "txt"))))
	    (:tr
	     (:td)
	     (:td (:p (:input :type "reset" :value "Reset" :class "btn")))
	     (:td (:p (:input :type "submit" :value "Process" :class "btn"))))))))



;;; yason
;; (yason:encode
;;           (list (alexandria:plist-hash-table
;;                  '("foo" 1 "bar" (7 8 9))
;;                  :test #'equal)
;;                 2 3 4
;;                 '(5 6 7)
;;                 t nil)
;;           *standard-output*)

;; (defmacro raw-data-package-old (contents)
;;   `(yason:encode
;;     (alexandria:plist-hash-table
;;      (list "records"
;; 	   (alexandria:plist-hash-table
;; 	    (list "value" ,contents)
;; 	    :test #'equal))
;;      :test #'equal)
;;     *standard-output*))

;;; curl -X POST -H "Content-Type: application/vnd.kafka.binary.v1+json" \
;;;      --data '{"records":[{"value":"S2Fma2E="}]}' "http://localhost:8082/topics/binarytest"

	;; (print packaged-contents)
	;; (common-request (*kafka-rest-ip* ":8082/topics/" topic-name) :post
	;; 		:content packaged-contents
	;; 		:content-type "application/vnd.kafka.binary.v1+json"
	;; 		:accept "application/vnd.kafka.v1+json, application/vnd.kafka+json, application/json"))))

;; CL-USER> (defvar *json-string* "[{\"foo\":1,\"bar\":[7,8,9]},2,3,4,[5,6,7],true,null]")
;; *JSON-STRING*
;; CL-USER> (let* ((result (yason:parse *json-string*)))
;;            (print result)
;;            (alexandria:hash-table-plist (first result)))

;; (#<HASH-TABLE :TEST EQUAL :COUNT 2 {5A4420F1}> 2 3 4 (5 6 7) T NIL)
;; ("bar" (7 8 9) "foo" 1)
;; CL-USER> (defun maybe-convert-to-keyword (js-name)
;;            (or (find-symbol (string-upcase js-name) :keyword)
;;                js-name))
;; MAYBE-CONVERT-TO-KEYWORD
;; CL-USER> :FOO ; intern the :FOO keyword
;; :FOO
;; CL-USER> (let* ((yason:*parse-json-arrays-as-vectors* t)
;;                 (yason:*parse-json-booleans-as-symbols* t)
;;                 (yason:*parse-object-key-fn* #'maybe-convert-to-keyword)
;;                 (result (yason:parse *json-string*)))
;;            (print result)
;;            (alexandria:hash-table-plist (aref result 0)))

;; #(#<HASH-TABLE :TEST EQUAL :COUNT 2 {59B4EAD1}> 2 3 4 #(5 6 7) YASON:TRUE NIL)
;; ("bar" #(7 8 9) :FOO 1)


