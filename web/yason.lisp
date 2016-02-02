(defvar *json-string* "[{\"foo\":1,\"bar\":[7,8,9]},2,3,4,[5,6,7],true,null]")

(let* ((result (yason:parse *json-string*)))
           (print result)
           (print (alexandria:hash-table-plist (first result))))

(defun maybe-convert-to-keyword (js-name)
           (or (find-symbol (string-upcase js-name) :keyword)
               js-name))

(let* ((yason:*parse-json-arrays-as-vectors* t)
       (yason:*parse-json-booleans-as-symbols* t)
       (yason:*parse-object-key-fn* #'maybe-convert-to-keyword)
       (result (yason:parse *json-string*)))
  (print result)
  (print (alexandria:hash-table-plist (aref result 0))))
