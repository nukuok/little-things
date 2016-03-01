(in-package :sbc-tools)

;;;; 
;;;; file-path color-set ip-set
(add-tool "pcap-process")

(defun strong-color (string color)
  (format t "<strong><font color=~a> ~a </font></strong>" color string))

(defun error-set-red (string)
  (when string (concatenate 'string "<font color='red'>" string "</font>")))

(defun error-sentence (num)
  (when num
    (let ((mame (parse-integer num)))
      (cond ((= mame 0) "File not found.")))))

(define-url-fn (pcap-process)
  (standard-page-with-title (:title "Pcap-process")
    (:h1 (:u "Pcap Process Settings"))
    (:hr :size 5 :color "orange")
    (:br)
    (:form :action "/pp-run.htm" :method "post"
	   :onsubmit (ps-inline
		      (when (= ppfilepath.value "")
			(alert "File path empty!")
			(return false)))
	   (:table
	    (:tr (:td :valign "top" "1. File path:")
		 (:td :colspan 2
;;                    won't display path in the region
		      (:input :type "text" :name "ppfilepath"
			      :size 111 :class "txt" :value 
			       (get-filepath)))
;;		      (:textarea :rows 1 :cols 85 :name "ppfilepath"
;;				 :style "overflow:hidden"
;;				 (fmt "~a" (get-filepath))))
		 (:td (let ((mame (parameter "e")))
		   (when mame
		     (fmt "~a" (error-set-red
				(error-sentence (parameter "e"))))))))
	    (:tr (:td :valign "top" "2. IP picking:")
		 (:td :align "right" "Internal IPs &#8656")
		 (:td "&#8658 SBC Internal IPs"))
	    (:tr (:td )
		 (:td  (:textarea :rows 6 :cols 40 :name "ppip1"
				  (fmt "~a" (get-ip-headers 0))))
		 (:td  (:textarea :rows 6 :cols 40 :name "ppip2"
				  (fmt "~a" (get-ip-headers 1))))
		 (:td))
;;		  (:h3 :style "color:purple"
;;			   "&#8656 Internal <br> &#8656 Network 
;;                                   <br> &#8656 IP filters")))
	    (:tr (:td) (:td)
		 (:td :align "right" "SBC External IPs &#8656")
		 (:td "&#8658 External IPs"))
	    (:tr (:td)(:td :align "right")
;;			   (:h3 :style "color:purple" "External &#8658 <br>
;;                                                  Network &#8658 <br>
;;                                                  IP filter &#8658"))
		 (:td  (:textarea :rows 6 :cols 40 :name "ppip3"
				  (fmt "~a" (get-ip-headers 2))))
		 (:td  (:textarea :rows 6 :cols 40 :name "ppip4"
				  (fmt "~a" (get-ip-headers 3)))))
	    (:tr (:td :valign "top" "3. Text color:")
		 (:td :colspan 2
		      (:textarea :rows 12 :cols 83
				 :name "colorsettings" :class "txt"
				 (get-color-rule-settings)))
		 (:td :style "font-size: 10pt; font-family: Courier New;"
		      "Examples for setting color: <br>"
                      "'cpc=[a-zA-Z]*'  'orange'  <br> &gt&gt&gt&gt" 
                      (strong-color "cpc=priority" "orange") " <br>" 
		      "'tag=[a-zA-Z0-9.+]*'  'red'  <br> &gt&gt&gt&gt"
		      (strong-color "tag=zH9c71ced" "red") "<br>"
		      "'@[a-zA-Z.]+'  'blue'  <br> &gt&gt&gt&gt"
		      (strong-color "@fujitsu.co.jp" "blue") "<br>"
		      "'[0-9]+[.][0-9.]+[.][0-9.]+[.][0-9]+'  'green'  <br>
                      &gt&gt&gt&gt"
		      (strong-color "192.168.0.1" "green")))
			     ;;; :name "colorsettings" :class "txt")))
	    (:tr (:td)
		 (:td  (:input :style "width: 80px"
			       :type "submit" :value "Process" :class "btn")
		       (:input :style "width: 80px"
			       :type "reset" :value "Cached" :class "btn")))))))

(define-url-fn (pp-run)
  (let ((filepath (parameter "ppfilepath"))
	(ip1 (parameter "ppip1"))
	(ip2 (parameter "ppip2"))
	(ip3 (parameter "ppip3"))
	(ip4 (parameter "ppip4"))
	(colorset (parameter "colorsettings")))
    ;;;; print debug didn't output anything in slime-repl, use log-message
    ;;(print ip1)
    ;;(debug "pp-run" filepath ip1 ip2 ip3 ip4 colorset)
    (hunchentoot:log-message* 3 "~a~%" (get-filepath))
    ;;(hunchentoot:log-message* 3 "~a~%" (parameter "value")) ;;show nil
    (set-filepath filepath)
    (set-color-rule-settings colorset)
    (set-ip-headers2 ip1 ip2 ip3 ip4)
    (handler-case (standard-page-with-title (:title "pcap analysis")
		    (htm
		     (fmt "~a" (output2html-string filepath))))
      (ccl::simple-file-error () (redirect "/pcap-process.htm?e=0")))))


