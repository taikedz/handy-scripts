# SupEdit - Support Edits Tracking Tool

When support needs to go into a server and edits files, a change repo is rarely ever maintainted, either for the immediate work or for the long term. Creating a localized repo at different levels can also be messy, and working from disparate locations might leave a lot of local repos lying around.

Additionally, on a system where no repos were ever setup, creating a full repo immediately would be overkill, or simply onerous.

This tool has for intention to:

	* Help setup an environment where you can work in a repo over an extended period of time
	* Take a snapshot of any files that were edited in a session
	* Prevent concurrent support editors from mangling eachothers work
	* Add some accountability
	* Clean up the repo afterwards as if it were never there

Note that this is not true revision control as such, but a tool for iterating tests on a subset of files before committing them. An overall repository is desirable for the long term, and a commit to the overall repository can happen at any point in time independent of supedit.

## Dependencies will be

	* fossil
	* GNU tools: bash, vim, grep, sed, rsync
	* Linux/BSD/OS X
		* We do not consider DOS/NT to fit in this workflow - a separate tool would be needed

## The intended operations will be:

`supedit start PROJECT`

	* tests to check for existing project name
		* if existing project is found, prompts for resume or start
	* sets an environment variable to register session
	* test for symlinking
		* exits with failure if symlinking is not possible
	* moves us to ~/supedit
	* sets FOSSILNAME="$PROJECT-$(date +%F_%T)"
	* creates a fossil repo with "$FOSSILNAME"
	* creates a directory named "$FOSSILNAME-tmp"
	* opens the fossil repository

The PROJECT name is the anme of the modification session. It could be the name of a modification, a change request code, a username... anything

`supedit resume PROJECT`

	* checks for open projects with the project name
		* if none exists, prompts for start
	* moves us to ~/supedit
	* loads "$FOSSILNAME" from existing project

`supedit use path/to/directory`

	* checks the filesystem of the directory
		* if this is not ext2/3/4 refuses
		* if this is a mounted filesystem, confirm
	* registers the directorys full path in ~/supedit/.sedirectories as being managed
	* softlinks the directory here
	* registers the softlink in fossil
		* if in use by someone else, generates an info about who is currently doing things in the folder

`supedit vim path/to/file`

	* errors out if someone is already tracking the file
	* if the file is not already being edited in current supedit session
		* registers the files full path in ~/supedit/.sefiles
		* rsyncs a backup file to "~/supedit/$FOSSILNAME-tmp/"
		* registers the full path in "~/supedit/FOSSILNAME-tmp/modified.txt"
	* edits the file in vim
		* on exit, forces a commit of the specifc file

`supedit status`

	* finds commits and lists them

`supedit restore ID`

	* rollback to an edit in the current session

`supedit conclude PROJECT`

	* prompts for a message for the changelog
	* appends the changelog message to ~/supedit/supportlog with a timestamp
	* de-registers files and folders
	* tar/gz the "$FOSSILNAME-tmp/" to "$(date +%F_%T)_PROJECT.tgz"
	* closes the fossil repo and deletes it

`supedit switch [-n] ARCHIVE`

	* checks for files being currently edited; errors out if files are being edited
	* creates a temp archive of listed files as they currently are as "RESTORE_$(date +%F_%T)"
	* rsyncs files from ARCHIVE back to their original location
		* "-n" switch prevents a restore file from being created

WARNING - this operation does not test against 
