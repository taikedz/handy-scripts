# SupEdit - Support Edits Tracking Tool

When support needs to go into a server and edits files, a change repo is rarely ever maintainted, either for the immediate work or for the long term. Creating a localized repo at different levels can also be messy, and working from disparate locations might leave a lot of local repos lying around.

Additionally, on a system where no repos were ever setup, creating a full repo immediately would be overkill, or simply onerous.

This tool has for intention to:

	* Help setup an environment where you can work in a repo over an extended period of time
	* Clean up the repo afterwards as if it were never there
	* Take a snapshot of any files that were edited in a session
	* prevent concurrent support editors from mangling eachothers work
	* Add some accountability

## Dependencies will be

	* fossil
	* GNU tools: bash, vim, grep, sed
	* Linux/BSD
		* We do not consider DOS/NT to be appropriate for servers
		* OS X may be supportable in part (requires relaxing filesystem restriction)

## The intended operations will be:

`supedit start USERNAME`

	* fails if current fs is not ext2/3/4
	* moves us to ~/supedit
	* sets FOSSILNAME="$USERNAME-$(date +%F_%T)"
	* creates a fossil repo with "$FOSSILNAME"
	* creates a directory named "$FOSSILNAME-tmp"
	* opens the fossil repository

`supedit use ~/path/to/directory`

	* checks the filesystem of the directory
		* if this is not ext2/3/4 refuses
		* if this is a mounted filesystem, confirm
	* registers the directorys full path in ~/supedit/.sedirectories as being managed
	* softlinks the directory here
	* registers the softlink in fossil
		* if in use by someone else, generates an info about who is currently doing things in the folder

`supedit vim path/to/file`

	* errors out if someone is already tracking the file
	* registers the files full path in ~/supedit/.sefiles
	* rsyncs a backup file to "~/supedit/$FOSSILNAME-tmp/"
	* registers the full path in "~/supedit/FOSSILNAME-tmp/modified.txt"
	* edits the file in vim
		* on exit, forces a commit of the specifc file

`supedit status`

	* finds commits and lists them

`supedit restore ID`

	* rollback to an edit

`supedit stop USERNAME`

	* prompts for a message for the changelog
	* appends the changelog message to ~/supedit/supportlog with a timestamp
	* de-registers files and folders
	* tar/gz the "$FOSSILNAME-tmp/" to "FOSSILNAME_til_$(date +%F_%T).tgz"
	* closes the fossil repo and deletes it

`supedit switch [-n] ARCHIVE`

	* checks for files being currently edited; errors out if files are being edited
	* creates a temp archive of listed files as they currently are as "RESTORE_$(date +%F_%T)"
	* rsyncs files from ARCHIVE back to their original location
		* "-n" switch prevents a restore file from being created
