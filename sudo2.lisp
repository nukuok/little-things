(defpackage :sudoku
  (:use :cl))

(in-package :sudoku)

;;;; tool
(defun to-list (x)
  (if (atom x)
      (list x)
      x))

(defun index-of-nth-row (number)
  (loop for x below 9 collect
       (+ x (* number 9))))

(defun index-of-nth-col (number)
  (loop for x below 9 collect
       (+ number (* x 9))))

(defun index-of-nth-block (number)
  (multiple-value-bind (x y) (truncate number 3)
    (let ((first-number-index (+ (* 27 x) (* 3 y))))
      (loop for x below 9 collect
	   (multiple-value-bind (p q) (truncate x 3)
	     (+ first-number-index (+ (* 9 p) q)))))))

(defun get-numbers (index board)
  (loop for x in index collect
       (nth x board)))

(defun relation-find (current)
  (let ((position-belong-to (nth current *position-number*)))
    (remove-duplicates
     (remove current (append (nth (nth 1 position-belong-to)
				  *index-of-rows*)
			     (nth (nth 2 position-belong-to)
				  *index-of-cols*)
			     (nth (nth 3 position-belong-to)
				  *index-of-blocks*))))))

(defun related-position (current)
  (nth current *relation-list*))
  
;;;; variable
(defvar *board*
  (loop for x below 81 collect 0))

(defvar *probability-board*
  (loop for x below 81 collect
       (loop for x from 1 to 9 collect x)))

(defvar *index-of-rows*
  (loop for x below 9 collect
       (index-of-nth-row x)))

(defvar *index-of-cols*
  (loop for x below 9 collect
       (index-of-nth-col x)))

(defvar *index-of-blocks*
  (loop for x below 9 collect
       (index-of-nth-block x)))

(defvar *index-of-all*
  (append *index-of-rows* *index-of-cols* *index-of-blocks*))

(defvar *position-number*
  (loop for current below 81 collect 
       (multiple-value-bind (row-number col-number) (truncate current 9)
	 (let ((block-number (+ (* 3 (truncate row-number 3))
				(truncate col-number 3))))
	   (list current row-number col-number block-number)))))

(defvar *relation-list*
  (loop for x below 81 collect
       (relation-find x)))

;;;; 
(defun update-board (indexes numbers board)
  (loop for x below 81 collect
	 (if (member x (to-list indexes))
	     (nth (position x (to-list indexes)) (to-list numbers))
	     (nth x board))))

(defun update-p-board (indexes remove-items pboard)
  (loop for x below 81 collect
	 (if (member x (to-list indexes))
	     (remove-if (lambda (x) (member x (to-list remove-items)))
			(nth x pboard))
	     (nth x pboard))))

(defun update-p-board-according-to-board-a (pboard board)
  (loop for x below 81 collect
       (let ((the-number (nth x board)))
	 (if (> the-number 0)
	     (list the-number)
	     (nth x pboard)))))

(defun update-p-board-according-to-board-b (pboard board &optional (current 0))
  (cond ((= current 81) pboard)
	((= (nth current board) 0)
	 (update-p-board-according-to-board-b pboard board (+ current 1)))
	(t (update-p-board-according-to-board-b
	    (update-p-board (related-position current)
			    (nth current board)
			    pboard)
	    board (+ current 1)))))

(defun remove-item-analysis (indexes pboard)
  (let* ((probability-line (mapcar (lambda (x) (list (nth x pboard) x)) indexes))
	 (duplicate-item-count (duplicate-item-occurence
				(mapcar #'car probability-line))))
    (remove-duplicates 
     (loop for y in probability-line
	for z in duplicate-item-count append
	  (when (= z (length (car y)))
	    (list
	     (list (mapcar #'cadr
			   (remove-if (lambda (x) (equal (car x) (car y)))
				      probability-line))
		   (car y)))))
     :test #'equal)))

(defun remove-item-analysis-all (pboard)
  (loop for x in 
       *index-of-all* append
       (remove-item-analysis x pboard)))
;;(update-board '(1 2 3 4 5) '(13 13 13 13 13) *board*)

(defun total-probability-sum (pboard)
  (apply #'+ (mapcar #'length pboard)))

;;;;
(defun duplicate-item-occurence (probability-line)
  (mapcar (lambda (x) (count x probability-line :test #'equal)) probability-line))

(defun update-p-board-according-to-analysis (pboard &optional (indexes-groups))
  (if (null indexes-groups)
      pboard
      (update-p-board-according-to-analysis
       (update-p-board (caar indexes-groups) (cadar indexes-groups) pboard)
       (cdr indexes-groups))))

(defun update-board-according-to-p-board (board pboard)
  (loop for x below 81 collect
       (let ((the-item (nth x pboard)))
	 (if (= (length the-item) 1)
	     (car the-item)
	     (nth x board)))))

(defun solve (board &optional (pboard *probability-board*)
		      (total-probability 729)
		      (pattern 1))
  (cond
    ((= total-probability 81) board)
    ((= pattern 1)
     (solve board (update-p-board-according-to-board-a pboard board)
	    total-probability 2))
    ((= pattern 2)
     (solve board (update-p-board-according-to-board-b pboard board)
	    total-probability 3))
    ((= pattern 3)
     (solve board (update-p-board-according-to-analysis
		   pboard (remove-item-analysis-all pboard))
	    total-probability 4))
    ((= pattern 4)
     (let ((new-t-p (total-probability-sum pboard)))
       (if (= new-t-p total-probability) board
	   (solve (update-board-according-to-p-board board pboard)
		  pboard new-t-p 1))))))
	
(defun find-first-more-than-one (pboard &optional (current 0))
  (if (> (length (nth current pboard)) 1)
      current
      (find-first-more-than-one pboard (+ current 1))))


(defun if-no-solution (pboard)
  (member 0 (mapcar #'length pboard)))


(defun solve-guess (board &optional (pboard *probability-board*)
			    (total-probability 729)
			    (pattern 1))
  (cond
    ((= total-probability 81) (output-board board))
    ((= pattern 1)
     (solve-guess board (update-p-board-according-to-board-a pboard board)
	    total-probability 2))
    ((= pattern 2)
     (solve-guess board (update-p-board-according-to-board-b pboard board)
	    total-probability 3))
    ((= pattern 3)
     (solve-guess board (update-p-board-according-to-analysis
		   pboard (remove-item-analysis-all pboard))
	    total-probability 4))
    ((if-no-solution pboard));; (format t "no-solution-guess: ~A~%" total-probability))
    ((= pattern 4)
     (let ((new-t-p (total-probability-sum pboard))
	   (new-board (update-board-according-to-p-board board pboard)))
       (if (= new-t-p total-probability)
	   (let ((guess-index (find-first-more-than-one pboard)))
	     (loop for x in (nth guess-index pboard) do
		  (solve-guess (update-board guess-index x board)
			       pboard new-t-p 1)))
	   (solve-guess new-board pboard new-t-p 1))))))

(defun output-board (board);; &optional (width 3))
  (format t "~{~3A~3A~3A~3A~3A~3A~3A~3A~3A~%~}" board))

(defvar *sample1*
  '(0 6 1 0 0 7 0 0 3
    0 9 2 0 0 3 0 0 0
    0 0 0 0 0 0 0 0 0
    0 0 8 5 3 0 0 0 0
    0 0 0 0 0 0 5 0 4
    5 0 0 0 0 8 0 0 0
    0 4 0 0 0 0 0 0 1
    0 0 0 1 6 0 8 0 0
    6 0 0 0 0 0 0 0 0))

(defvar *sample2*
  '(8 5 0 0 2 0 0 7 6
    0 0 7 0 0 0 4 0 0
    0 4 9 0 3 0 1 8 0
    3 0 0 0 0 0 0 0 5
    4 0 0 1 0 8 0 0 9
    9 0 0 0 0 0 0 0 8
    0 9 6 0 8 0 2 3 0
    0 0 8 0 0 0 5 0 0
    5 3 0 0 6 0 0 9 1))

