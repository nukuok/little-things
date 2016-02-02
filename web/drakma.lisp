(ql:quickload :cffi)
(pushnew "." cffi:*FOREIGN-LIBRARY-DIRECTORIES*)
(ql:quickload :drakma)
(ql:quickload :cl-ppcre)
(ql:quickload :yason)

(setf drakma:*header-stream* *standard-output*)
(setf drakma:*default-http-proxy* '("kws.proxy.nic.fujitsu.com" 8080))
(defvar *fw-auth*)
(setf *fw-auth* '("huang.yangyang@jp.fujitsu.com" "6570787777"))
(drakma:http-request "http://lisp.org/" :proxy-basic-authorization *fw-auth*)

;;;; utf-8
(subseq (drakma:http-request "http://www.cl.cam.ac.uk/~mgk25/ucs/examples/digraphs.txt" :proxy-basic-authorization *fw-auth*) 0 298)

;;;; NG https
;; unable to configure https proxy 
(drakma:http-request "https://www.fortify.net/cgi/ssl_2.pl"
		     :proxy '("kws.proxy.nic.fujitsu.com" 8080)
		     :proxy-basic-authorization *fw-auth*)


;;;; NG seems like explorer type doesn't work
(cl-ppcre:scan-to-strings "<h4>.*" (drakma:http-request "http://whatsmyuseragent.com/" :user-agent :firefox :proxy-basic-authorization *fw-auth*))

;;;; OK cookies
(let ((cookie-jar (make-instance 'drakma:cookie-jar)))
  (drakma:http-request "http://www.phpsecurepages.com/test/test.php"
		       :method :post
		       :parameters '(("entered_login" . "test")
				     ("entered_password" . "test"))
		       :proxy-basic-authorization *fw-auth*
		       :cookie-jar cookie-jar)
  (drakma:http-request "http://www.phpsecurepages.com/test/test2.php"
		       :proxy-basic-authorization *fw-auth*
		       :cookie-jar cookie-jar)
  (drakma:cookie-jar-cookies cookie-jar))

;;;; OK reuse a connection
(let ((stream (nth-value 4 (drakma:http-request "http://www.lispworks.com/"
						:proxy-basic-authorization *fw-auth*
						:close nil))))
  (nth-value 2 (drakma:http-request
		"http://www.lispworks.com/success-stories/index.html"
		:stream stream)))

;;;; basic authorization
omitted

;;;; NG for url of https, reading the response from a stream
(let ((stream (drakma:http-request "https://api.github.com/orgs/edicl/public_members"
				   :proxy-basic-authorization *fw-auth*
				   :want-stream t)))
  (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
  (yason:parse stream :object-as :plist))

;;;; piecemeal assemble of request contents
(let ((temp-file (ensure-directories-exist #p"tmp/quux.txt"))
      (continuation (drakma:http-request "http://localhost:4242/hunchentoot/test/parameter_latin1_post.html"
					 :real-host '("localhost" 4242)
					 :method :post
					 :content :continuation)))
  (funcall continuation "foo=" t)
  (funcall continuation (list (char-code #\z) (char-code #\a)) t)
  (funcall continuation (lambda (stream)
			  (write-char #\p stream)) t)
  (with-open-file (out temp-file
		       :direction :output
		       :if-does-not-exist :create
		       :if-exists :supersede)
    (write-string "p" out))
  (funcall continuation temp-file t)
  (funcall continuation "zerapp"))
;;  (cl-ppcre:scan-to-strings "zappzerapp" (funcall continuation "zerapp")))


