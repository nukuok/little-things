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

(defun process-tree (process tree)
 (labels ((rec (tree acc)
           (cond
            ((null tree) (nreverse acc))
            ((consp (car tree))
             (rec (cdr tree)
                  (cons (rec (car tree) nil) acc)))
            (t (rec (cdr tree)
		    (cons (funcall process (car tree)) acc))))))
   (rec tree nil)))


