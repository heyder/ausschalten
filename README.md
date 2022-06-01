# Ausschalten

Network Denial-of-Service simulation tools collection and executor

## [Application](aus-app)

Agent orchestration

## [Engine](aus-engine)
Techiniques implementations


### Examples

#### Interative mode

```powershell
PS C:\aus-engine> docker run --rm -it aus
Loading techniques from /root/ausschalten/techniques...
Loading Technique, dns_flood.
, icmp_flood.
, udp_flood, all_tcp_flags_flood, fin_flood, rst_flood, push_ack_flood, ack_flood, urg_flood, syn_flood, tcp_flood, empty_connection_flood.
Enter the name of the technique that you would like to execute (eg. icmp_flood).  Type 'exit' to quit.
> icmp_flood
executors [{'name': 'ICMP Flood', 'description': '', 'reference': 'https://security.radware.com/ddos-knowledge-center/ddospedia/icmp-flood/', 'supported_platforms': ['linux'], 'input_arguments': {'target_ip': {'description': 'Target IP', 'type': 'String', 'default': '127.0.0.1'}, 'interface': {'description': 'interface to use', 'type': 'String', 'default': 'eth0'}, 'extra_args': {'description': 'extra arguments', 'type': 'String', 'default': '-V -d 120 --flood -c 10'}}, 'executor': {'command': 'hping3 --icmp -n -I #{interface} #{extra_args} #{target_ip}\n', 'cleanup_command': '', 'name': 'command_prompt'}}]

===========================================================
ICMP Flood Attack - icmp_flood

-----------------------------------------------------------
Name: ICMP Flood
Description: 
Platforms: linux

Arguments:
target_ip: Target IP (default: 127.0.0.1)
interface: interface to use (default: eth0)
extra_args: extra arguments (default: -V -d 120 --flood -c 10)

Launcher: command_prompt
Command: hping3 --icmp -n -I #{interface} #{extra_args} #{target_ip}


Do you want to run this?  (Y/n): 
Do you want to check dependencies?  (Y/n): 
Do you want to run the cleanup after the executor completes?  (Y/n):
Please provide a parameter for 'target_ip' (blank for default): 127.0.0.1
Please provide a parameter for 'interface' (blank for default): eth0
Please provide a parameter for 'extra_args' (blank for default): -V -d 2 -c 4               
No 'dependency_executor_name' or 'dependencies' section found in the yaml file. Skipping dependencies check.
In order to run this non-interactively:
    Python:
    techniques = runner.Runner()
    techniques.execute("icmp_flood", position=0, parameters={'target_ip': '127.0.0.1', 'interface': 'eth0', 'extra_args': '-V -d 2 -c 4'}, dependencies=True, cleanup=True)
    Shell Script:
    python3 runner.py run icmp_flood 0 --args '{"target_ip": "127.0.0.1", "interface": "eth0", "extra_args": "-V -d 2 -c 4"}' --dependencies --cleanup


------------------------------------------------
Output: 
--- 127.0.0.1 hping statistic ---
4 packets tramitted, 0 packets received, 100% packet loss
round-trip min/avg/max = 0.0/0.0/0.0 ms
using eth0, addr: 172.17.0.2, MTU: 1500
HPING 127.0.0.1 (eth0 127.0.0.1): icmp mode set, 28 headers + 2 data bytes


------------------------------------------------
> exit
PS C:\aus-engine>
```

#### In-line mode

```powershell
PS C:\aus-engine> docker run --rm -it aus run icmp_flood 0 --args '{\"target_ip\": \"127.0.0.1\", \"interface\": \"eth0\"}'  
Loading Technique, dns_flood.
, icmp_flood.
, udp_flood, all_tcp_flags_flood, fin_flood, rst_flood, push_ack_flood, ack_flood, urg_flood, syn_flood, tcp_flood, empty_connection_flood.
args Namespace(args='{"target_ip": "127.0.0.1", "interface": "eth0", "extra_args": "-V -d 2 -c 4"}', cleanup=True, dependencies=True, func=<function run at 0x7f1e6873cb00>, position=0, technique='icmp_flood')
args {"target_ip": "127.0.0.1", "interface": "eth0", "extra_args": "-V -d 2 -c 4"}
================================================
Checking dependencies icmp_flood/0

No 'dependency_executor_name' or 'dependencies' section found in the yaml file. Skipping dependencies check.
Executing icmp_flood/0

File did not exist.  Created a new empty Hash DB.
Technique section 'icmp_flood' did not exist.  Creating.
Hash was not in DB.  Adding.

------------------------------------------------
Output:
--- 127.0.0.1 hping statistic ---
4 packets tramitted, 0 packets received, 100% packet loss
round-trip min/avg/max = 0.0/0.0/0.0 ms
using eth0, addr: 172.17.0.2, MTU: 1500
HPING 127.0.0.1 (eth0 127.0.0.1): icmp mode set, 28 headers + 2 data bytes

Running cleanup commands.

------------------------------------------------
PS C:\aus-engine>
```