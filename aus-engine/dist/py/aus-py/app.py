#!/usr/bin/env python3
try:
    import sys
    import json
    import argparse
    from modules.dns import DnsFlood as dns_flood
    import constants
except ImportError as err:
    print("ImportError: {0}".format(err))
    exit(1)
    # raise err
# from os.path import dirname, basename, isfile, join
# import glob
# modules = glob.glob(join('./modules/', "*.py"))
# __all__ = [ basename(f)[:-3] for f in modules if isfile(f) and not f.endswith('__init__.py')]
sys.dont_write_bytecode = True

def main():
    parser = argparse.ArgumentParser(description="Allows the automation of tests in the Red Team repository.")
    
    parser.add_argument('technique', type=str, help="Technique to run.")
    parser.add_argument('--args', type=str, default="{}", help="JSON string representing a dictionary of arguments (eg. '{ \"arg1\": \"val1\", \"arg2\": \"val2\" }' )")
    
    try:
        args = parser.parse_args()
        if args.technique in ['dns_flood']:
            try:
                parameters = json.loads(args.args) or {}
                tech = globals()[args.technique](**parameters)
                tech.execute()
                # print(tech)
            except:
                print("Unexpected error: {0}".format(sys.exc_info()[0]))
                exit(1)
        else:
            print("Technique not found")
            exit(1)

    except AttributeError:
        parser.print_help()

if __name__ == "__main__":
    main()