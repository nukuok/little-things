(setf *temp2* "INVITE sip:+81322222222;npdi@[NTTドメイン名];user=phone SIP/2.0
Via: SIP/2.0/TCP [SBCのNTT側CプレーンIPアドレス]:5060;branch=z9hG4bKxxx1b
From: <sip:+819011111111@[A社ドメイン名];user=phone>;tag=xxxxxxbcd
To: <sip:+81322222222@[NTTドメイン名];user=phone>
Contact: <sip:[SBCのNTT側CプレーンIPアドレス]:5060;transport=tcp>
Call-ID: xxxxxxxxxx234@[SBCのNTT側CプレーンIPアドレス]
CSeq: 1 INVITE
Max-Forwards: xx
Allow: INVITE,ACK,PRACK,BYE,CANCEL,UPDATE
Supported: 100rel,timer
Session-Expires: 300;refresher=uac
Min-SE: 300
Content-Type: application/sdp
Content-Length: xx
P-Asserted-Identity: <tel:+819011111111;cpc=ordinary>,<sip:+819011111111@[A社ドメイン名];user=phone;cpc=ordinary>
Privacy: none

o=- x2x0 x2x0 IN IPx [SBCのNTT側UプレーンIPアドレス]
c=IN IPx [SBCのNTT側UプレーンIPアドレス]
t=0 0
s=-
m=audio [SBCのポート番号] RTP/AVP 0 96 97 98 101
a=sendrecv
a=rtpmap:0 PCMU/8000
a=rtpmap:96 AMR-WB/16000/1
a=fmtp:96 mode-set=2
a=rtpmap:99 AMR/8000/1
a=fmtp:99 mode-set=7
a=rtpmap:98 telephone-event/16000
a=fmtp:98 0-15
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15")

(setf *temp3* "INVITE sip:+81322222222;npdi@[NTTドメイン名];user=phone SIP/2.0
Via: SIP/2.0/TCP [SBCのNTT側CプレーンIPアドレス]:5060;branch=z9hG4bKxxx1b
From: <sip:+819011111111@[A社ドメイン名];user=phone>;tag=xxxxxxbcd
To: <sip:+81322222222@[NTTドメイン名];user=phone>
Contact: <sip:[SBCのNTT側CプレーンIPアドレス]:5060;transport=tcp>
Call-ID: xxxxxxxxxx234@[SBCのNTT側CプレーンIPアドレス]
CSeq: 1 INVITE
Max-Forwards: xx
Allow: INVITE,ACK,PRACK,BYE,CANCEL,UPDATE
Supported: 100rel,timer
Session-Expires: 300;refresher=uac
Min-SE: 300
Content-Type: application/sdp
Content-Length: xx
P-Asserted-Identity: <tel:+819011111111;cpc=ordinary>,<sip:+819011111111@[A社ドメイン名];user=phone;cpc=ordinary>
Privacy: none

v=0
o=- x2x0 x2x0 IN IPx [SBCのNTT側UプレーンIPアドレス]
s=-
c=IN IPx [SBCのNTT側UプレーンIPアドレス]
t=0 0
m=audio [SBCのポート番号] RTP/AVP 0 96 97 98 99
a=sendrecv
a=rtpmap:0 PCMU/8000
a=rtpmap:96 AMR-WB/16000/1
a=fmtp:96 mode-set=2
a=rtpmap:97 AMR/8000/1
a=fmtp:97 mode-set=7
a=rtpmap:98 telephone-event/16000
a=fmtp:98 0-15
a=rtpmap:99 telephone-event/8000
a=fmtp:99 0-15")
