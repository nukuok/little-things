(ql:quickload :cffi)
(pushnew "." cffi:*FOREIGN-LIBRARY-DIRECTORIES*)
(ql:quickload :hunchentoot)
(ql:quickload :hunchentoot-test)

(defvar *a-acceptor* (make-instance 'hunchentoot:easy-acceptor :port 4242))
(hunchentoot:start *a-acceptor*)
(hunchentoot:stop *a-acceptor*)

(ql:quickload :parenscript)
(ql:quickload :cl-who)


