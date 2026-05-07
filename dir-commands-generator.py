import sys
import re
import textwrap
from pathlib import Path


class ProjectCommandsGenerator:
    configuration: dict[str, str]

    target_directory: Path
    commands_file_name: Path
    completion_directory: Path

    def __init__(
        self,
        cfg_file_name: Path,
        target_directory: Path,
    ) -> None:
        self.configuration = dict()
        with open(cfg_file_name, "r") as cfg_file:
            for line in cfg_file:
                if len(line) == 0:
                    continue

                matches = re.match(r"(\S+)\s+(\S+)", line)
                if not matches:
                    continue

                command, directory = matches.groups()
                self.configuration[command] = directory

        self.target_directory = target_directory

        self.commands_file_name = target_directory.joinpath("dir-commands.zsh")
        self.completion_directory = target_directory.joinpath("completions")

    def write_commands(self) -> None:
        self.target_directory.mkdir(exist_ok=True)

        with open(self.commands_file_name, "w") as commands_file:
            for command, dir in self.configuration.items():
                commands_file.write(textwrap.dedent(f"""\
                    # config for {command} (dir {dir})
                    {command}() {{
                        dir_general {dir} $1
                    }}
                    export {command}d="{dir}"

                """))

    def write_completions(self) -> None:
        self.completion_directory.mkdir(exist_ok=True)

        for command, directory in self.configuration.items():
            with open(
                self.completion_directory.joinpath(f"_{command}"),
                "w",
            ) as completion_file:
                completion_file.write(textwrap.dedent(f"""\
                    #compdef {command}

                    _path_files -W "{directory}" "$@"
                """))


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("2 arguments expected\n")
        exit(2)

    generator = ProjectCommandsGenerator(
        Path(sys.argv[1]),
        Path(sys.argv[2]),
    )

    generator.write_commands()
    generator.write_completions()
