(in-package :sbc-tools)


(setf *temp* '(setf *tt* (1 2 (3 4) (5 6))))
(defun save-db (filename)
  (with-open-file (out filename
		       :direction :output
		       :if-exists :supersede)
    (with-standard-io-syntax (print *temp* out))))

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))
