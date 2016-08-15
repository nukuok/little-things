(in-package :kafka-demo)

(defvar *topic-offsets*)
(setf *topic-offsets* nil)

(defun update-local-topic-offset (topic offset)
  (let* ((topic-symbol (intern topic))
	 (topic-offset (assoc topic-symbol *topic-offsets*)))
    (if topic-offset
	(setf (cadr topic-offset) (max 0 (- offset 20)))
	(setf *topic-offsets*
	      (append *topic-offsets*
		      (list (list topic-symbol offset)))))))

(defun get-local-topic-offset (topic)
  (let ((record (assoc (intern topic) *topic-offsets*)))
    (if record
	(cadr record)
	0)))

