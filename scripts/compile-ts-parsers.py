#!/usr/bin/env python3

import os
import sys
import stat
import shutil
import signal
import glob
import tempfile
import wget
import json
import subprocess
from termcolor import cprint


ZIG_TARGETS = [
    "x86_64-windows",
    "x86_64-linux",
    "aarch64-linux",
    "x86_64-macos",
    "aarch64-macos",
]

WANTED_TS_PARSERS = [
    "astro",
    "bash",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "diff",
    "dot",
    "dockerfile",
    "fish",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "graphql",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "gowork",
    "graphql",
    "help",
    "html",
    "ini",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "kotlin",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "regex",
    "rst",
    "rust",
    "scss",
    "sql",
    "svelte",
    "swift",
    "todotxt",
    "toml",
    "vim",
    "yaml",
    "zig",
]

TEMP_DIR = tempfile.gettempdir()


def onerror(func, path, exc_info):
    if not os.access(path, os.W_OK):
        os.chmod(path, stat.S_IWUSR)
        func(path)
    else:
        raise


def fs_rm(path):
    if os.path.exists(path) is False:
        return
    if os.path.isdir(path):
        shutil.rmtree(path, onerror=onerror)
    else:
        os.remove(path)


def cleanup(full=False):
    fs_rm("parsers.json")
    fs_rm("lockfile.json")

    parser_dirs = glob.glob(os.path.join(TEMP_DIR, "tree-sitter-") + "*")
    for dir in parser_dirs:
        fs_rm(dir)

    if full == False:
        return

    target_dirs = glob.glob(os.path.join(TEMP_DIR, "treesitter-") + "*")
    for dir in target_dirs:
        fs_rm(dir)


def run_command(command):
    proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    out, err = proc.communicate()

    if proc.returncode != 0:
        raise subprocess.CalledProcessError(
            returncode=proc.returncode, cmd=proc.args, stderr=err
        )
    return out.decode("utf-8")


def read_json(path):
    with open(path) as file_json:
        content = json.load(file_json)
        return content


def download_lockfile(commit_hash):
    wget.download(
        "https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/"
        + commit_hash
        + "/lockfile.json",
        "lockfile.json",
    )


def create_target_dirs(target):
    dir = os.path.join(TEMP_DIR, "treesitter-" + target)
    os.mkdir(dir)
    os.mkdir(os.path.join(dir, "parser"))
    os.mkdir(os.path.join(dir, "parser-info"))


def ouput_files(target, parser):
    output = os.path.join(
        TEMP_DIR,
        "treesitter-" + target,
        "parser",
        parser["language"] + ".so",
    )
    revision = os.path.join(
        TEMP_DIR,
        "treesitter-" + target,
        "parser-info",
        parser["language"] + ".revision",
    )
    return output, revision


def compile_parser(parser, target, treesitter_lock, index):
    try:
        cwd = os.path.join(TEMP_DIR, "tree-sitter-" + parser["language"])
        os.mkdir(cwd)
        os.chdir(cwd)

        cprint("\n\n  " + str(index) + ". " + parser["language"], "light_blue")

        # commit can't checked out unless full repo is cloned
        # for https://github.com/DerekStride/tree-sitter-sql
        clone_depth = ["--depth", "10"]
        if parser["language"] == "sql":
            clone_depth = []

        run_command(
            [
                "git",
                "clone",
                *clone_depth,
                parser["url"],
                cwd,
            ],
        )

        run_command(
            ["git", "checkout", treesitter_lock[parser["language"]]["revision"]]
        )

        try:
            run_command(["pnpm", "install"])
            run_command(["tree-sitter", "generate"])
        except:
            pass

        # a simple workaround as both parsers are in the same repo
        # https://github.com/MDeiml/tree-sitter-markdown
        if parser["language"] == "markdown" or parser["language"] == "markdown_inline":
            os.chdir(os.path.join(cwd, "tree-sitter-" + parser["language"].replace("_", "-")))

        output, revision = ouput_files(target, parser)
        run_command(
            [
                "zig",
                "c++",
                "-o",
                "out.so",
                *parser["files"],
                "-lc",
                "-Isrc",
                "-shared",
                "-Os",
                "-target",
                target,
            ]
        )
        shutil.move("out.so", output)
        f = open(revision, "w")
        f.write(treesitter_lock[parser["language"]]["revision"])
        f.close()

        cprint("  SUCCESS: " + parser["language"], "light_green")
    except:
        cprint("  FAILED: " + parser["language"], "light_red")
        return parser


def handler(signum, frame):
    res = input("Ctrl-c was pressed. Do you really want to exit? y/n ")
    if res == "y":
        cleanup()
        os.kill(os.getpid(), signal.SIGINT)
        exit(1)


def validate_argv():
    error = False
    if len(sys.argv) != 2:
        cprint("ERROR: no compile target provided", "light_red")
        error = True

    if error == False and sys.argv[1] not in ZIG_TARGETS:
        cprint("ERROR: invalid compile target provided", "light_red")
        error = True

    if error:
        cprint("HINT: allowed targets...", "yellow")
        cprint(str(ZIG_TARGETS), "yellow")
        exit(1)
    return sys.argv[1]


def main():
    target = validate_argv()
    cleanup(True)
    subprocess.run(
        [
            "nvim",
            "--headless",
            "-c",
            "lua require('utils.fn').get_treesitter_parsers()",
            "-c",
            "q",
        ],
        shell=True,
        capture_output=True,
    )

    # load parsers and lazy-lock
    parsers = sorted(read_json("parsers.json"), key=lambda x: x["language"])
    lazy_lock = read_json("lazy-lock.personal.json")
    download_lockfile(lazy_lock["nvim-treesitter"]["commit"])
    treesitter_lock = read_json("lockfile.json")

    create_target_dirs(target)

    retry_list = []

    for parser in parsers:
        if parser["language"] in WANTED_TS_PARSERS:
            p = compile_parser(
                parser,
                target,
                treesitter_lock,
                WANTED_TS_PARSERS.index(parser["language"]) + 1,
            )

            if p != None:
                retry_list.append(p)

    if len(retry_list) == 0:
        return

    cprint("\nRetrying failed builds...", "light_blue")
    for parser in retry_list:
        fs_rm(os.path.join(TEMP_DIR, "tree-sitter-" + parser["language"]))
        output, revision = ouput_files(target, parser)
        fs_rm(output)
        fs_rm(revision)

        p = compile_parser(
            parser,
            target,
            treesitter_lock,
            WANTED_TS_PARSERS.index(parser["language"]) + 1,
        )
        if p != None:
            cprint("  RETRY FAILED", "light_red")

    cleanup()


signal.signal(signal.SIGINT, handler)
main()
