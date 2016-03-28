(in-package :sbc-tools)

;(setf *temp* '(setf *tt* (1 2 (3 4) (5 6))))
(defun save-db (filename db)
  (with-open-file (out (concatenate 'string "db/" filename)
		       :direction :output
		       :if-exists :supersede)
    (with-standard-io-syntax (print db out))))

(defmacro load-db (filename db)
  `(with-open-file (in ,(concatenate 'string "db/" filename))
     (with-standard-io-syntax
       (setf ,db (read in)))))

