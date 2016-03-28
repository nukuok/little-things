(in-package :sbc-tools)

(add-tool "sip-check-page")

(define-url-fn (sip-check-page)
    (standard-page-with-title (:title "SIP-check")
    (:h1 (:u "SIP check Settings"))
    (:hr :size 5 :color "orange")
    (:br)
    (:form
     :action "/sip-check.html" :method "post"
     (:table
      (:tr (:td "1. File to evaluate")
	   (:td (:input :type "text" :name "file-to-eva" :size 111 :class "txt" (get-eva-filepath))))
      (:tr (:td "2. Base File")
	   (:td (:input :type "text" :name "base-file" :size 111 :class "txt" (get-base-filepath))))
      (:tr (:td "3. Compact forms")
	   (:td  (:textarea :rows 10 :cols 80 :name "compact-forms")))
      (:tr (:td "4. fixed words")
	   (:td  (:textarea :rows 10 :cols 80 :name "fixed-words")))
      (:tr (:td)
	   (:td  (:input :style "width: 80px"
			 :type "submit" :value "Process" :class "btn")
		 (:input :style "width: 80px"
			 :type "reset" :value "Cached" :class "btn")))))))



