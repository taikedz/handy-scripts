secdir
===

Manage, Mount and Unmount EncFS encrypted directory

Requires EncFS and Linux (bash and GNU tools)

You can view this help in any HTML viewer by running:

	secdir --help | markdown > /tmp/secdirhelp && $htmlviewer /tmp/secdirhelp 

Or see the latest release documentation at [the secdir main page](https://github.com/taikedz/handy-scripts/tree/master/projects/secure-dir)

## Usage

	secdir init
	secdir {mount|open} ACCOUNT
	secdir {unmount|close} ACCOUNT

Uses a `secdir.enc` directory in the current working directory to store the encrypted files.

The secure directory is mounted in the current working directory, or the "home=" directory you configure in the config file.

You need to be in the parent directory of the `secdir.enc` directory to open the secure directories it contains.

You can be anywhere when closing the mounted directory.

## OPTIONS

`list`

* List local secure directories, and the current active security utility

`init`

* set current working directory up as a location to store secure directories' encrypted data

`{mount|open} ACCOUNT`

* mount the secure directory. If it does not exist, offers to create it.
* Will fail if you cannot write to the mountpoint
* If you have configured against mounting in the current working directory, you MUST point the `home=` option to a different location. This allows secure directories to be distributed on a network whilst reducing the risk of a user __indavertently__ mounting in a publicly shared directory (and thus propagating the plaintext files over the network).
	* **This is a molly-guard, NOT a security lock !!** Modifying the `secdir.enc/config` file can override this.

`{unmount|close}`

* unmount a mounted secure directory.

## CONFIGURATION

A configuration file is stored in `secdir.enc/config`. It is an INI-style key-value store

`Crypt/utility`

* defines which security module to use
* these are stored in `secdir.enc/crypts`
* by default this is `encfs`
	* encfs is available in standard repositories
	* However a [secuirty audit](https://defuse.ca/audits/encfs.htm) revealed it to be potentially weak when the secured store is itself public and can be monitored for changes
* A module to take advantage of `cryfs` is available, but you will need to [install cryfs](https://www.cryfs.org/tutorial) first
	* I'm currently working on a way to integrate cryfs straight into secdir. Stay tuned.
* You can extend this with any security module you wish -- see the [crypts page on GitHub](https://github.com/taikedz/handy-scripts/tree/master/projects/secure-dir/crypts).

`Mount/load_in_cwd`

* `yes` --> allows mounting directories in current working directory
* (anything else) --> do not allow

`Mount/home`

* This must be a directory
* By default secure directories are mounted here instead of in the current working directory

