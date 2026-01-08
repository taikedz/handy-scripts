#!/usr/bin/env bash

# Create a helpful python script stub

cat <<'EOTEMP'
#!/usr/bin/env python3

import os
import pathlib
import argparse

THIS = pathlib.Path(os.path.realpath(__file__))
HEREDIR = pathlib.Path(os.path.dirname(THIS))


def cli_args():
    # further quick examples at https://dev.to/taikedz/ive-parked-my-side-projects-3o62
    parser = argparse.ArgumentParser()

    #parser.add_argument("terms", help="Positional terms (one or more)", nargs="+") # for zero or more, use 'nargs="*"'
    #parser.add_argument("--option", "-o", help="An option with a string value")
    #parser.add_argument("--option", "-o", action="store_true", help="An option with a boolean value, default false") # use store_false for opposite default
    #parser.add_argument("--number", "-n", type=int, default=0, help="An option with a numeric value") # type can be any function returning a value

    args = parser.parse_args()

    # optionally validate now
    assert args.number < 5, "Maximum of 4"

    return args


def main():
    args = cli_args()

    # do the rest here


# Generic launch and catch assertions
if __name__ == "__main__":
    try:
        main()

    except Exception as e:
        # Catches all exceptions, but not KeyboardInterrupt

        # Normally silence tracebacks. Run with PY_TRACEBACK=true to show them
        if os.getenv("PY_TRACEBACK") == "true":
            raise
        else:
            print(e)
            exit(1)
EOTEMP

