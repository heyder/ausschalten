
## Techniques

* Reflection Amplification
    * DNS
    * NTP
    * UDP/11211 open – used by the Memcached service
    * UDP/3283 Apple Remote Management Service
    * WS-Discovery
* Floods
    * ICMP - ok
    * SYN - ok
    * PSH+ACK - ok
    * URG - ok
    * ACK - ok
    * UDP - ok
    * TCP - ok
    * RST - ok
    * FIN - ok
    * ALL TCP Flags - ok
    * Empty connection - ok
    * IP Fragmented (4)
    * UDP Garbage Flood (2)
* ICMP dst Unnreachable
* HTTP(S)
    * Flooder
    * Brobot
    * Browser emulation
* SlowLoris (2)
* THC SSL Attack
* SSL Renegotiation (2)

# Features

* set outgoing bandwith limit
* log outgoing traffic
* distributed orchastration 

While throughput, or packets-per-second (pps), is often the most significant metric in direct-flooding DDoS attacks such as SYN-floods, 
bandwidth, or bits-per-second (bps), is the primary metric for most (not all) reflection/amplification attacks.

# Tools
 - Hping - A free CLI-based packet generator for IP/TCP/UDP/ICMP protocols.
 - Mausezahn - A free Linux-based versatile packet generator, written in C, with the ability to customize L2, L3 and L4 packet headers. 
 - HULK - (HTTP Unbearable Load King) – A DoS tool and HTTP traffic stress generator
 - BoNeSi – A DDoS Botnet Simulator tool that generates ICMP, UDP and TCP (HTTP) flooding from a Botnet of a defined size