# gdiff - a helpful git wrapper

`gdiff` is a helpful wrapper for working with git.

It started out as a simple shortcut for adding and committing at the same time without having to re-write commands between diffs and commit instructions, but recently has grown to be a minor molly-guard to some bad beginners' habits.

## Useful features

Running `gdiff` without arguments will cause a `git fetch` to happen (unless you specify argument `-nf`) and then display the `git status` - for example

	gdiff

Running `gdiff` simply with a list of changed files will bring up a colorized `git diff` in `less`, once for each, allowing you to easily view and navigate the changes before committing.

Example:

	gdiff fileA fileB

You can then add

	gdiff fileA fileB -a

and even commit

	gdiff fileA fileB -m "Commit message"

### `master` warnings

Notably, it will warn you every time you are on master.

If you have made changes, it will also offer to help you move these to a different branch.

This also kicks in prior to staging and committing.

Don't develop on master!

### branch switch recommendations

For now, `gdiff` simply displays a recommendation based on whether you are on master or not, but analyzing the state of merges would be nice.

## Building `gdiff`

I am using my [`bash-builder`](https://github.com/taikedz/bash-builder) to maintain `gdiff`. At some point I'll split out sub-functionality, but still be able to ship single executables.
