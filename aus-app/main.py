#!/usr/bin/env python3

import os
import sys
from collections import namedtuple

from ansible.parsing.dataloader import DataLoader
from ansible.vars.manager import VariableManager
# from ansible.inventory.manager import Inventory
from ansible.executor.playbook_executor import PlaybookExecutor

# loader = DataLoader()

# inventory = Inventory(loader=loader, sources='/home/slotlocker/hosts2')
# variable_manager = VariableManager(loader=loader, inventory=inventory)
# playbook_path = '/home/slotlocker/ls.yml'

# if not os.path.exists(playbook_path):
#     print '[INFO] The playbook does not exist'
#     sys.exit()

# Options = namedtuple('Options', ['listtags', 'listtasks', 'listhosts', 'syntax', 'connection','module_path', 'forks', 'remote_user', 'private_key_file', 'ssh_common_args', 'ssh_extra_args', 'sftp_extra_args', 'scp_extra_args', 'become', 'become_method', 'become_user', 'verbosity', 'check','diff'])
# options = Options(listtags=False, listtasks=False, listhosts=False, syntax=False, connection='ssh', module_path=None, forks=100, remote_user='slotlocker', private_key_file=None, ssh_common_args=None, ssh_extra_args=None, sftp_extra_args=None, scp_extra_args=None, become=True, become_method='sudo', become_user='root', verbosity=None, check=False, diff=False)

# variable_manager.extra_vars = {'hosts': 'mywebserver'} # This can accomodate various other command line arguments.`

# passwords = {}

# pbex = PlaybookExecutor(playbooks=[playbook_path], inventory=inventory, variable_manager=variable_manager, loader=loader, options=options, passwords=passwords)

# results = pbex.run()