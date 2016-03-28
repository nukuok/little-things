(in-package :sbc-tools)

(defvar *processpcap-data*)
(setf *processpcap-data* "saved_data/processpcap/db.lisp")

;;test
;;(setf *temp* '(setf *tt* (1 2 (3 4) (5 6))))
;;(defun save-db (filename)
;;  (with-open-file (out filename
;;		       :direction :output
;;		       :if-exists :supersede)
;;    (with-standard-io-syntax (print *temp* out))))
;;
;;(defun load-db (filename)
;;  (with-open-file (in filename)
;;    (with-standard-io-syntax
;;      (setf *db* (read in)))))

(defun new-data (dataname)
  (push (list dataname *filepath* *ip-header-list* *color-rule*)
	      *processpcap-data*))

(defun remove-data (dataname)
  (remove dataname *processpcap-data* :test (lambda (x) (equal dataname (car x)))))

(defun get-data-list ()
  (mapcar #'car *processpcap-data*))

(defun load-data (dataname)
  (let ((mame (assoc dataname *processpcap-data*)))
    (setf *filepath* (cadr mame)
	  *ip-header-list* (caddr mame)
	  *color-rule* (cadddr mame))))




