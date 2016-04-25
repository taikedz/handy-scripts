secdir
===

Manage, Mount and Unmount EncFS encrypted directory

Requires EncFS and Linux (bash and GNU tools)

## Usage

	secdir {list|init}
	secdir {mount|open} ACCOUNT [-to MOUNTPOINT] [LINK ...]
	secdir {unmount|close} ACCOUNT

Uses a `.enc` directory in the current working directory to store the encrypted files.

The secure directory is mounted in the current working directory.

If you do not specify a `MOUNTPOINT`, creates a directory in the current working directory and mounts there, if allowed.


## OPTIONS

`list`

* list secure directories by account name configured at current working directory

`init`

* set current working directory up as a location to store secure directories' encrypted data

`{mount|open} [-to MOUNTPOINT] [LINKS ...]`

* mount the secure directory. If it does not exist, offers to create it.
* You can specify `-to MOUNTPOINT` to explicitly mount the directory at that location.
* You can specify any number of softlinks to create pointing to the mounted directory.
* Will fail if you cannot write to the mountpoint
* If you have configured against mounting in the current working directory, you MUST point the `-to MOUNTPOINT` to a different location. This allows secure directories to be distributed on a network whilst reducing the risk of a user indavertently mounting in a publicly shared directory.
	*  This is a Molly-guard, NOT a security lock.

`{unmount|close}`

* unmount a mounted secure directory.
* Any soft links created during mount will be removed.

## CONFIGURATION

A configuration file is stored in .enc/config. It is an INI-style key-value store

`Mount/load_in_cwd`

* `yes` --> allows mounting directories in current working directory
* `*` --> do not allow

`Mount/home`

* This must be a directory
* By default secure directories are mounted here instead of in the current working directory

