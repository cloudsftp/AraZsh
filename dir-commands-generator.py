import sys
import re

class ProjCommandsGenerator:
    def __init__(self, cfg_file_name, complete_path) -> None:
        super().__init__()

        self.cfg = dict()
        self.cfg_file_name = cfg_file_name
        self.complete_path = complete_path

        self.tgt_file_name = f"{complete_path}/dir-commands.zsh"

    def read_cfg(self):
        with open(self.cfg_file_name, 'r') as cfg_file:
            for line in cfg_file:
                if not re.match(r'^$', line):
                    command, dir = re.match(r'(\S+)\s+(\S+)', line).groups()
                    self.cfg[command] = dir

    def write_tgt(self):
        with open(self.tgt_file_name, 'w') as tgt_file:
            for command, dir in self.cfg.items():
                tgt_file.write(
f'''
# config for {command} (dir {dir})
{command}() {{
    dir_general {dir} $1
}}
export {command}d="{dir}"
''')

    def write_autocomplete(self):
        for command, dir in self.cfg.items():
            with open(f'{self.complete_path}/_{command}', 'w') as autocomplete_file:
                autocomplete_file.write(
f'''#compdef {command}

_path_files -W "{dir}" "$@"
''')


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("2 arguments expected\n")
        exit(2)

    generator = ProjCommandsGenerator(sys.argv[1], sys.argv[2])
    generator.read_cfg()
    generator.write_tgt()
    generator.write_autocomplete()
