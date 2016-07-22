(in-package :kafka-demo)

(defun to-pairs (a-list &optional (result nil))
  (if (null a-list)
      result
      (to-pairs (cddr a-list) (append result (list (list (car a-list)
							 (cadr a-list)))))))
