#!/bin/python

import sys
import re


class ProjCommandsGenerator:
    def __init__(self, cfg_file_name, tgt_file_name):
        super().__init__()

        self.cfg = dict()
        self.cfg_file_name = cfg_file_name
        self.tgt_file_name = tgt_file_name

    def read_cfg(self):
        with open(self.cfg_file_name, 'r') as cfg_file:
            for line in cfg_file:
                if len(line) > 0:
                    command, dir = re.match(r'(\S+)\s+(\S+)', line).groups()
                    self.cfg[command] = dir

    def write_tgt(self,):
        with open(self.tgt_file_name, 'w') as tgt_file:
            for command, dir in self.cfg.items():
                tgt_file.write(
f'''
# config for {command} (dir {dir})
alias {command}="dir_general {dir}"



export {command}d="{dir}"

''')


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("2 arguments expected\n")
        exit(2)

    generator = ProjCommandsGenerator(sys.argv[1], sys.argv[2])
    generator.read_cfg()
    generator.write_tgt()
