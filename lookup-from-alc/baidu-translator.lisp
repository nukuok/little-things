;;;;APP ID:  20160125000009295 
;;;;key:  gWn0IuBS5C5LS7ivV6eB
;;;;http://api.fanyi.baidu.com/api/trans/vip/translate?

(setf drakma:*header-stream* nil)

(defclass request ()
  ((q :accessor request-q :initform "goodbye")
   (from :accessor request-from :initform "en")
   (to :accessor request-to :initform "jp")
   (salt :accessor request-salt :initform "123456789")
   (appid :accessor request-appid :initform "20160125000009295")
   (key :accessor request-key :initform "gWn0IuBS5C5LS7ivV6eB")))

(defun request-line (req)
  (let ((url "http://api.fanyi.baidu.com/api/trans/vip/translate?")
	(q (request-q req))
	(from (request-from req))
	(to (request-to req))
	(appid (request-appid req))
	(key (request-key req))
	(salt (request-salt req)))
    (concatenate 'string
		 url
		 "q=" q "&"
		 "from=" from "&"
		 "to=" to "&"
		 "appid=" appid "&"
		 "salt=" salt "&"
		 "sign=" (sign appid q salt key))))


(defmacro sign (&rest args)
  `(string-downcase
    (format nil "~{~2,'0x~}"
	    (coerce (md5:md5sum-string
		     (concatenate 'string ,@args)) 'list))))

(let ((http-line (request-line (make-instance 'request))))
      (drakma:http-request http-line :proxy-basic-authorization *fw-auth*))


(let* ((http-line (request-line (make-instance 'request)))
       (stream (drakma:http-request http-line :proxy-basic-authorization *fw-auth*
				    :want-stream t)))
  (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
  (maphash (lambda (x y)
	     (if (equal x "trans_result")
		 (maphash (lambda (u v) (format t "~A : ~B ~%" u v)) (car y))
		 (format t "~A : ~B ~%" x y))) (yason:parse stream)))

(drakma:url-encode "abc" :UTF-8)

(defun result (req)
  (let* ((http-line (request-line req))
	 (stream (drakma:http-request http-line :proxy-basic-authorization *fw-auth*
				      :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (type-of (yason:parse stream))))


;;;; alc‚ð—˜—p
(ql:quickload 'closure-html)

(let* ((url "http://eow.alc.co.jp/search?q=application"))
       (drakma:http-request url :proxy-basic-authorization *fw-auth*))


(let* ((url "http://eow.alc.co.jp/search?q=application&ref=sa")
       (stream (drakma:http-request url :proxy-basic-authorization *fw-auth*
				    :want-stream t)))
  (read-line-until-head-is stream "<body>")
  (chtml:parse (read-line-until-contains stream "wordclass") (chtml:make-lhtml-builder)))

(defun read-line-until-head-is (stream str)
  (let ((current-line (read-line stream))
	(str-len (length str)))
    (unless
	(and (> (length current-line) str-len)
	     (equal (subseq current-line 0 str-len) str))
      (read-line-until stream str))))

;;(read-line-until-contains (make-string-input-stream "abc") "ccd")
(defun read-line-until-contains (stream str)
  (let ((current-line (read-line stream nil "owadayo"))
	(str-len (length str)))
    (cond ((equal current-line "owadayo") nil)
	  ((and (> (length current-line) str-len)
		(ppcre:all-matches str current-line))
	   current-line)
	   (t (read-line-until-contains stream str)))))

(defun prune (test tree)
 (labels ((rec (tree acc)
           (cond
            ((null tree) (nreverse acc))
            ((consp (car tree))
             (rec (cdr tree)
                  (cons (rec (car tree) nil) acc)))
            (t (rec (cdr tree)
                    (if (funcall test (car tree))
                     acc
                     (cons (car tree) acc)))))))
   (rec tree nil)))

(defun extract-li (tree)
  (labels ((rec (tree acc)
	     (cond
	       ((null tree) acc);(reverse acc))
	       ((consp (car tree))
		(if (equal (caar tree) :li)
		    (rec (cdr tree)
			 (cons (car tree) acc))
		    (rec (cdr tree)
			 (append (rec (car tree) nil) acc))))
	       (t (rec (cdr tree) acc)))))
    (rec tree nil)))

;;;;
(defun extract-li (tree)
  (labels ((rec (tree acc)
	     (cond
	       ((null tree) (reverse acc))
	       ((consp (car tree))
		(if (equal (caar tree) :li)
		    (rec (cdr tree)
			 (cons (car tree) acc))
		    (rec (cdr tree)
			 (append (rec (car tree) nil) acc))))
	       (t (rec (cdr tree) acc)))))
    (rec tree nil)))

(defun remove-kana (li-list)
  (loop for x in li-list collect
       (remove-if #'consp x)))

(defun mean-list (li-list)
  (loop for x in (reverse li-list) collect
       (apply #'concatenate (cons 'string (cddr x)))))

(defun output-list (string-list stream &optional (index 1))
  (unless (null string-list)
    (format stream "~A ~A~%" index (car string-list))
    (output-list (cdr string-list) stream (+ index 1))))

(defun lookup-a-word (word &optional (st t))
  (let* ((url (concatenate 'string "http://eow.alc.co.jp/search?q=" word "&ref=sa"))
	 (stream (drakma:http-request url :proxy-basic-authorization *fw-auth*
				      :want-stream t)))
    (read-line-until-head-is stream "<body>")
    (format st "~%<<<------~A------>>>~%" word)
    (let ((line-contains-wordclass (read-line-until-contains stream "wordclass")))
      (if (null line-contains-wordclass)
	  "Word not found."
	  (let ((tree (chtml:parse line-contains-wordclass
				   (chtml:make-lhtml-builder))))
	    (output-list (mean-list (remove-kana (extract-li tree))) st))))))
    
(loop for x in '("ball" "cat" "tree" "dead" "elephant" "around") do (lookup-a-word x))

(with-open-file (in "surf-license-origin.txt" :direction :input)
  (with-open-file (out "surf-license.txt" :direction :output
		      :if-does-not-exist :create :if-exists :supersede)
    (loop
	 (let ((current-line (read-line in nil "owadayo")))
	   (if (equal current-line "owadayo")
	       (return)
	       (let* ((only-words
		       (remove-if-not (lambda (x)
					(or (and (char<= #\A x) (char<= x #\Z))
					    (and (char<= #\a x) (char<= x #\z))
					    (equal x #\-)
					    (equal x #\ ))) current-line))
		      (all-down-case (string-downcase only-words))
		      (one-word-per-line (substitute #\newline #\  all-down-case)))
		 (format out "~A~%" one-word-per-line)))))))

(with-open-file (in "surf-license.txt" :direction :input)
  (with-open-file (out "surf-license1.txt" :direction :output
		       :if-does-not-exist :create :if-exists :supersede)
    (labels ((rec (stream acc)
	       (let ((current-line (read-line stream nil "owadayo")))
		 (if (equal current-line "owadayo")
		     acc
		     (rec in (cons current-line acc))))))
      (format out "~{~A~%~}"
	      (remove-if-not (lambda (x) (> (length x) 2))
			     (remove-duplicates (rec in nil) :test #'equal))))))

(with-open-file (in "surf-license1.txt" :direction :input)
  (with-open-file (out "surf-license2.txt" :direction :output
		       :if-does-not-exist :create :if-exists :supersede)
    (labels ((rec (stream-in stream-out)
	       (let ((current-line (read-line stream-in nil "owadayo")))
		 (unless (equal current-line "owadayo")
		   (print current-line)
		   (sleep 0.5)
		   (lookup-a-word current-line stream-out)
		   (rec stream-in stream-out)))))
      (rec in out))))




    
