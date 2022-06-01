source "hpingstdlib.htcl"

if {$argc < 1} {
    puts {usage: hping3 exec ipscan.htcl hostname}
    exit 1
}

set target [lindex $argv 0]
set targetip [hping resolve $target]

set outifaddr [hping outifa $targetip]
set outifname [outifname $targetip]

set ip_proto 1;

hping setfilter $outifname "icmp and host $targetip"

proc send_probe {} {
    after 100 send_probe
    global outifaddr targetip ip_proto
    if {$ip_proto > 255} exit
    append probe "ip(saddr=$outifaddr,daddr=$targetip,proto=$ip_proto,ttl=255)"
    hping send $probe
    incr ip_proto
}

proc recv_probe {} {
    global outifname outifaddr targetip
    set packets [hping recv $outifname 0 1000]
    foreach p $packets {
               if {[GetIpSaddr $p] != $targetip} continue
               if {[GetIpDaddr $p] != $outifaddr} continue
           puts "Response TYPE: [GetIcmpType $p]] CODE: [GetIcmpCode $p] ID: [GetIcmpId $p]"

    }
    after 10 recv_probe
}

puts "Scanning $target ($targetip)"

hping recv $outifname 0
after 10 send_probe
after idle recv_probe
vwait forver