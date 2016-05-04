secdir
===

Manage, Mount and Unmount encrypted directories

Requires EncFS or CryFS and Linux (bash and GNU tools). Extensible to other directory encryption tools.

## WARNING

Two known issues, with workarounds.

### EncFS

The EncFS library is mostly suitable for general-case privacy; however you may want to take into account the [Defuse Security](https://defuse.ca/audits/encfs.htm) audit that points out some shortcomings when using encfs in places where third-parties have read-write access to the encrypted store itself.

If you want to ensure better privacy, you can try using CryFS, though that library is not currently deemed stable.

If you want to implement any other crypto library, see the [crypts](crypts) directory and RADME file

### Directories stored in a cloud service

secdir will mount to the current working directory, even if the `home` parameter is set to mount elsewhere, making this unsuitable for directly working directly in a cloud-synchronized directory.

The workaround consists of preventing mounting in one explicity-named non-safe location; this of course is not scalable, and I'm working to fix this, stay tuned.

In the mean time, this is the workaround:

* create a directory in a non-sync'd location

	`mkdir $HOME/Documents/Safe`

* softlink the `secdir.enc` directory

	`ln -s $HOME/DropBox/SecureStorage/secdir.enc $HOME/Documents/Safe/secdir.enc`

* edit the config, set `home=` to the directory where we must **not** mount

	`home=$HOME/DropBox/SecureStorage`

* operate directly there

.

	cd $HOME/Documents/Safe
	secdir list
	secdir mount myfiles
	secdir unmount myfiles


## Usage


	secdir init
	secdir {mount|open} ACCOUNT
	secdir {unmount|close} ACCOUNT

Uses a `secdir.enc` directory in the current working directory to store the encrypted files.

The secure directory is mounted in the current working directory, or the `home=` directory you configure in the config file.

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
	* Other systems being considered are ecryptfs
* You can extend this with any security module you wish -- see the [crypts page on GitHub](https://github.com/taikedz/handy-scripts/tree/master/projects/secure-dir/crypts).

`Mount/load_in_cwd`

* `yes` --> allows mounting directories in current working directory
* (anything else) --> do not allow

`Mount/home`

* This must be a directory
* By default secure directories are mounted here instead of in the current working directory
	* WARNING - found in 1.2, this is not working. See the Workaround above.

