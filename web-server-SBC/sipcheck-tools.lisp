(in-package :sbc-tools)

(defvar *eva-filepath* nil)
(setf *filepath* "C:/Users/Administrator/Desktop/")

(defvar *base-filepath* nil)
(setf *filepath* "C:/Users/Administrator/Desktop/")

(defun get-eva-filepath ()
  (format nil "~a" *eva-filepath*))

(defun get-base-filepath ()
  (format nil "~a" *base-filepath*))

(defun set-eva-filepath (string)
  (setf *eva-filepath* (string-trim #(#\space #\return) string)))

(defun set-base-filepath (string)
  (setf *base-filepath* (string-trim #(#\space #\return) string)))

(defun get-compact-forms (&optional listname)
  (if listname
      (get-compact-forms listname)
      *compact-forms*))

(defun get-fixed-list (&optional listname)
  (if listname
      (get-fixed-list listname)
      *fixed-list*))

;;(defun set-compact-forms (listname compact-forms)
;;  (set-compact-forms listname compact-forms))

;;(defun set-fixed-list (listname fixed-list)
;;  (set-fixed-list listname fixed-list))

(defvar *sipcheck-db*)
(setf *sipcheck-db* nil)

(defun compact-forms-to-db-form (mame)
  (let ((mame-splitted (string-split  (string-rm-return (string-rm-newline mame)) #\;)))
    (loop for x in mame-splitted collect
	 (let ((x-splitted (remove "" (string-split x #\space) :test #'equal)))
	   (list (car x-splitted) (or (cadr x-splitted) (car x-splitted)))))))

(defun db-form-to-compact-forms (mame)
  (format nil "~{~{~a ~};~}" (loop for x in mame collect (list (car x) (cadr x)))))

(defun remove-db-duplicates (db)
  (remove-duplicates db :test (lambda (x y) (equal (car x) (car y)))))

(defun save-to-sipcheck-db (listname compact-forms-string fixed-list-string)
  (progn
    (setf *sipcheck-db*
	  (remove-db-duplicates
	   (append *sipcheck-db*
		   (list
		    (list
		     (compact-forms-to-db-form compact-forms-string)
		     (fixed-list-to-db-form fixed-list-string) )))))
    (save-db "db/sipcheck.db" *sipcheck-db*)))



