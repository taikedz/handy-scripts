#!/usr/bin/env python3

import argparse
import subprocess
import shlex
import sys
import re


def main():
    try:
        args = parse_args()
        prune_remote(args.remote)
        all_branches, _ = run("git branch --all")
        local_branches, remote_branches = sortout_branches(all_branches)
        prune_locals(local_branches, remote_branches)

    except KeyboardInterrupt:
        print("")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--remote", help="The remote to prune.", default="origin")
    return parser.parse_args()


def prune_remote(remote):
    run(f"git remote prune {remote}", echo=True)


def user_said_yes(message):
    res = input(f"{message} y/N> ").lower()
    return (res in ['y','yes'])


def run(command, shell=False, echo=False):
    if echo:
        print(f"+ {command}", file=sys.stderr)

    if isinstance(command, str):
        command = shlex.split(command)

    res = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=shell)
    outs = {"stdout": res.stdout.readlines(), "stderr": res.stderr.readlines()}

    for k,lines in outs.items():
        outs[k] = [L.decode().strip() for L in lines]

    return outs["stdout"], outs["stderr"]


def sortout_branches(all_branches):
    local_branches = []
    remote_branches = []

    for branch in all_branches:
        if branch.startswith("* ") or "/HEAD ->" in branch:
            continue

        if branch.startswith("remotes/"):
            remote_branches.append(re.sub(r'remotes/[^/]+/' ,'' , branch))
        else:
            local_branches.append(branch)
    
    return local_branches, remote_branches


def prune_locals(local_branches, remote_branches):
    for branch in local_branches:
        if branch not in remote_branches:
            if user_said_yes(f"Remove local {branch} ?"):
                print(run(f"git branch -D {branch}"))

if __name__ == "__main__":
    main()
