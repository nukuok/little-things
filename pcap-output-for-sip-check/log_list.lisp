;;(loop for x in '(28 29) do (compare-2pcap (nth x eva-a-list) (nth x base-a-list) (nth x result-list)))


(setf eva-a-list
      '(
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-1-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-1-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-1-3.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-1-4.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-2-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-2-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-3-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-3-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-4-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-4-2.pcap"
;;"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-6-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-6a-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-1-6a-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-1-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-1-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-2-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-2-2_NA.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-3-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-3-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-4-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-4-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-5-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-1-2-6-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-2-1-2-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-2-1-2-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-2-1-3-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-2-1-3-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-2-1-4-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-2-1-5-1.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-2-1-5-2.pcap"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-3-1-2a-1.pcap"
;;"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/A_log/A-3-1-2a-2.pcap"
))
(setf base-a-list '(
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-1-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-1-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-1-3_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-1-4_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-2-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-2-2_20160223.pcapng"
;;"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-2-3_20160223.pcapng"
;;"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-2-4_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-3-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-3-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-4-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-4-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-6A-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-1-6A-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-1-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-1-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-2-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-2-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-3-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-3-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-4-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-4-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-5-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/1-2-6-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/2-1-2-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/2-1-2-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/2-1-3-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/2-1-3-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/2-1-4-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/2-1-5-1_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/2-1-5-2_20160223.pcapng"
"c:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_A/3-1-2A-1_20160223.pcapng"
))
(setf result-list '(
"1-1-1-1.html"
"1-1-1-2.html"
"1-1-1-3.html"
"1-1-1-4.html"
"1-1-2-1.html"
"1-1-2-2.html"
;;"1-1-2-3.html"
;;"1-1-2-4.html"
"1-1-3-1.html"
"1-1-3-2.html"
"1-1-4-1.html"
"1-1-4-2.html"
"1-1-6A-1.html"
"1-1-6A-2.html"
"1-2-1-1.html"
"1-2-1-2.html"
"1-2-2-1.html"
"1-2-2-2.html"
"1-2-3-1.html"
"1-2-3-2.html"
"1-2-4-1.html"
"1-2-4-2.html"
"1-2-5-1.html"
"1-2-6-1.html"
"2-1-2-1.html"
"2-1-2-2.html"
"2-1-3-1.html"
"2-1-3-2.html"
"2-1-4-1.html"
"2-1-5-1.html"
"2-1-5-2.html"
"3-1-2A-1.html"
))

(setf eva-b-list '(
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-1-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-1-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-1-3.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-1-4.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-2-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-2-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-2-3.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-2-4.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-2-5.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-2-6.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-3-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-3-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-4-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-4-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-5-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-5-3.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-5-4.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-5a-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-1-5a-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/rev02/B-1-2-1-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-2-1-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/rev02/B-1-2-2-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/rev02/B-1-2-2-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-2-3-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-2-3-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-2-4-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-2-4-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-2-5-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-1-2-6-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-1-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-1-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-2-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-2-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-3-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-3-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-4-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-2-1-4-2.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-3-1-2a-1.pcap"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/B_log/merge/B-3-1-2a-2.pcap"
		   ))


(setf base-b-list '(
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-1-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-1-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-1-3-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-1-4-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-2-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-2-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-2-3-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-2-4-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-2-5-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-2-6-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-3-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-3-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-4-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-4-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-5-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-5-3-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-5-4-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-5a-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-1-5a-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-1-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-1-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-2-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-2-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-3-1-BN.pcapng"
;;"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-3-2-NB-sbc_timeout.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-3-2-NB_isc_timeout.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-4-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-4-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-5-1-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/1-2-6-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-1-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-1-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-2-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-2-2.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-3-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-3-2-NB.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-4-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/2-1-4-2-NB.pcapng"
;;"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/3-1-2-1_BN_20151026_100830.pcapng"
;;"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/3-1-2-2_NB_20151026_094908.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/3-1-2a-1-BN.pcapng"
"C:/Users/Administrator/Desktop/Perimeta3.9-upgrade/regression/log/base_B/3-1-2a-2-NB.pcapng"
))

(setf result-b-list '(
"B-1-1-1-1.html"
"B-1-1-1-2.html"
"B-1-1-1-3.html"
"B-1-1-1-4.html"
"B-1-1-2-1.html"
"B-1-1-2-2.html"
"B-1-1-2-3.html"
"B-1-1-2-4.html"
"B-1-1-2-5.html"
"B-1-1-2-6.html"
"B-1-1-3-1.html"
"B-1-1-3-2.html"
"B-1-1-4-1.html"
"B-1-1-4-2.html"
"B-1-1-5-2.html"
"B-1-1-5-3.html"
"B-1-1-5-4.html"
"B-1-1-5a-1.html"
"B-1-1-5a-2.html"
"B-1-2-1-1.html"
"B-1-2-1-2.html"
"B-1-2-2-1.html"
"B-1-2-2-2.html"
"B-1-2-3-1.html"
"B-1-2-3-2.html"
"B-1-2-4-1.html"
"B-1-2-4-2.html"
"B-1-2-5-1.html"
"B-1-2-6-1.html"
"B-2-1-1-1.html"
"B-2-1-1-2.html"
"B-2-1-2-1.html"
"B-2-1-2-2.html"
"B-2-1-3-1.html"
"B-2-1-3-2.html"
"B-2-1-4-1.html"
"B-2-1-4-2.html"
"B-3-1-2a-1.html"
"B-3-1-2a-2.html"
))
