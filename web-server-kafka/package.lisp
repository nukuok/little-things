(load "/Users/ko_yoyo/quicklisp/setup.lisp")

;;;;
(ql:quickload :cl-who)
(ql:quickload :cl-async)
(ql:quickload :parenscript)
(ql:quickload :cffi)
(pushnew "." cffi:*FOREIGN-LIBRARY-DIRECTORIES*)
(ql:quickload :hunchentoot)
(ql:quickload :smackjack)
(ql:quickload :drakma)
(ql:quickload :yason)
(ql:quickload :cl-base64)
(ql:quickload :smackjack)
(ql:quickload :cl-ppcre)


;;;;
(ql:quickload :custom-tools) 

(defpackage :kafka-demo
  (:use :cl :cl-who :hunchentoot :parenscript :custom-tools :cl-user :cl-base64 :smackjack :cl-ppcre))

(in-package :kafka-demo)

(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/config.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/html-formats.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/sample-producer.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/tools.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/interface-to-kafka-rest.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/ajax-processor-kafka.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/handler-kafka.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/startup.lisp")
(load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/topic-offsets.lisp")

;; (load "/Users/ko_yoyo/Desktop/program/cl/little-things/web-server-kafka/
