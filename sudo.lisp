(defpackage :sudoku
  (:use :cl))

(in-package :sudoku)

(defun to-list (x)
  (if (atom x)
      (list x)
      x))

(defvar *board*
  (loop for x below 81 collect 0))

(defvar *probability-board*
  (loop for x below 81 collect
       (loop for x from 1 to 9 collect x)))

(defun index-of-nth-row (number)
  (loop for x below 9 collect
       (+ x (* number 9))))

(defvar *index-of-rows*
  (loop for x below 9 collect
       (index-of-nth-row x)))

(defun index-of-nth-col (number)
  (loop for x below 9 collect
       (+ number (* x 9))))

(defvar *index-of-cols*
  (loop for x below 9 collect
       (index-of-nth-col x)))

(defun index-of-nth-block (number)
  (multiple-value-bind (x y) (truncate number 3)
    (let ((first-number-index (+ (* 27 x) (* 3 y))))
      (loop for x below 9 collect
	   (multiple-value-bind (p q) (truncate x 3)
	     (+ first-number-index (+ (* 9 p) q)))))))

(defvar *index-of-blocks*
  (loop for x below 9 collect
       (index-of-nth-block x)))

(defvar *position-number*
  (loop for current below 81 collect 
       (multiple-value-bind (row-number col-number) (truncate current 9)
	 (let ((block-number (+ (* 3 (truncate row-number 3))
				(truncate col-number 3))))
	   (list current row-number col-number block-number)))))

(defun get-numbers (index board)
  (loop for x in index collect
       (nth x board)))

(defun update-board (indexes numbers board)
  (loop for x below 81 collect
	 (if (member x indexes)
	     (nth (position x indexes) numbers)
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

(defun related-position (current)
  (let ((position-belong-to (nth current *position-number*)))
    (remove-duplicates
     (remove current (append (nth (nth 1 position-belong-to)
				  *index-of-rows*)
			     (nth (nth 2 position-belong-to)
				  *index-of-cols*)
			     (nth (nth 3 position-belong-to)
				  *index-of-blocks*))))))
			 
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
    
;;(update-board '(1 2 3 4 5) '(13 13 13 13 13) *board*)

(defun total-prbability (pboard)
  (apply #'+ (mapcar #'length pboard)))

;;;;
(defun duplicate-item-occurence (probability-line)
  (labels ((equal-item (x y)
	     (if (equal x y) 1 0)))
    (mapcar
     (lambda (item)
       (apply #'+ (mapcar
		   (lambda (x)
		     (equal-item item x))
		   probability-line)))
     probability-line)))

(defun duplicate-item-occurence (probability-line)
  (mapcar (lambda (x) (count x probability-line :test #'equal)) probability-line))

(defun update-p-board-according-to-analysis (pboard &optional (indexes-groups))
  (if (null indexes-groups)
      pboard
      (update-p-board-according-to-analysis (update-p-board 
					    (caar indexes-groups)
					    (cadar indexes-groups)
					    pboard)
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
    ((= total-probability 81) pboard)
    ((= pattern 1) (solve board (update-p-board-according-to-board-a
				 pboard board) total-probability 2))
    ((= pattern 2) (solve board (update-p-board-according-to-board-a
				 pboard board) total-probability 3))
    ((= pattern 3) (solve board (update-p-board-according-to-analysis
				 pboard 
				  (loop for x in 
				       (append *index-of-rows*
					       *index-of-cols*
					       *index-of-blocks*) append
				       (remove-item-analysis x pboard)))
				  total-probability 4))
    ((= pattern 4)
     (let ((new-t-p (apply #'+ (mapcar #'length pboard))))
       (if (= new-t-p total-probability)
	   pboard
	   (solve (update-board-according-to-p-board board pboard)
		  pboard
		  new-t-p
		  1))))))
	

(defvar *sample*
  '(0 6 1 0 0 7 0 0 3
    0 9 2 0 0 3 0 0 0
    0 0 0 0 0 0 0 0 0
    0 0 8 5 3 0 0 0 0
    0 0 0 0 0 0 5 0 4
    5 0 0 0 0 8 0 0 0
    0 4 0 0 0 0 0 0 1
    0 0 0 1 6 0 8 0 0
    6 0 0 0 0 0 0 0 0))
