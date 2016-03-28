(ql:quickload :cffi)
(pushnew "." cffi:*FOREIGN-LIBRARY-DIRECTORIES*)
(ql:quickload :drakma)
(setf drakma:*header-stream* nil)

;;(ql:quickload :cl-who)
;;(ql:quickload :parenscript)
;;(ql:quickload :hunchentoot)

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
      (read-line-until-head-is  stream str))))

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

(with-open-file (in "temp.txt" :direction :input)
  (with-open-file (out "temp-m1.txt" :direction :output
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

(with-open-file (in "temp-m1.txt" :direction :input)
  (with-open-file (out "temp-m2.txt" :direction :output
		       :if-does-not-exist :create :if-exists :supersede)
    (labels ((rec (stream acc)
	       (let ((current-line (read-line stream nil "owadayo")))
		 (if (equal current-line "owadayo")
		     acc
		     (rec in (cons current-line acc))))))
      (format out "~{~A~%~}"
	      (remove-if-not (lambda (x) (> (length x) 2))
			     (remove-duplicates (rec in nil) :test #'equal))))))

(with-open-file (in "temp-m2.txt" :direction :input)
  (with-open-file (out "temp-m3.txt" :direction :output
		       :if-does-not-exist :create :if-exists :supersede)
    (labels ((rec (stream-in stream-out)
	       (let ((current-line (read-line stream-in nil "owadayo")))
		 (unless (equal current-line "owadayo")
		   (print current-line)
		   (sleep 0.5)
		   (lookup-a-word current-line stream-out)
		   (rec stream-in stream-out)))))
      (rec in out))))
