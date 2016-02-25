(define-url-fn (pcap-process)
  (standard-page-with-title (:title "pcap process")
    (:h1 "pcap process settings")
    (:form :action "/pp-run.htm" :method "post"
	   :onsubmit (ps-inline
		      (when (= pp-filepath.value "")
			(alert "File path empty!")
			(return false)))
	   (:table
	    (:tr
	     (:td "File path:")
	     (:td :colspan 3
		  (:p (:input :type "text" :name "pp-filepath"
			      :size 111 :cols 60 :class "txt"))))
	    (:tr
	     (:td "IP picking:")
	     (:td "Internal IPs 1")
	     (:td "SBC Internal IPs"))
	    (:tr
	     (:td)
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip1")))
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip2")))
	     (:td ))
	    (:tr
	     (:td) (:td)
	     (:td "SBC External IPs")
	     (:td "External IPs"))
	    (:tr
	     (:td)(:td)
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip3")))
	     (:td (:p (:textarea :rows 4 :cols 40 :name "pp-ip4"))))
	    (:tr
	     (:td "Text color:")
	     (:td :colspan 2
		  (:p (:textarea :rows 15 :cols 60
				 :name "color-settings" :class "txt"))))
	    (:tr
	     (:td)
	     (:td (:p (:input :type "reset" :value "Reset" :class "btn")))
	     (:td (:p (:input :type "submit" :value "Process" :class "btn"))))))))
