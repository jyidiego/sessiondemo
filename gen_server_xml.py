#!/usr/bin/python

from __future__ import print_function
from string import Template

import netifaces
import sys



def get_ip4_addr(interface):
    if interface in netifaces.interfaces():
        net_if_config = netifaces.ifaddresses(interface)
        if netifaces.AF_INET in net_if_config:
            return net_if_config[netifaces.AF_INET][0]['addr']
        else:
            print("No IPv4 Address")
    else:
        print("interface {} doesn't exist.".format(interface))
        sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print('{} <network interface>'.format(sys.argv[0]))
        sys.exit(1)
    print(get_ip4_addr(sys.argv[1]))

if __name__ == '__main__':
    main() 
