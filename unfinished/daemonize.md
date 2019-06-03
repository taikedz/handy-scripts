Header for SysV Init scripts to allow them to define system daemons

First add the INIT INFO section to the top of the script

Adjust the requirements at will.

	### BEGIN INIT INFO
	# Provides:          daemon-name
	# Required-Start:    \$remote_fs \$syslog \$all
	# Required-Stop:
	# Default-Start:     2 3 4 5
	# Default-Stop:      0 1 6
	# Short-Description: Describe what this service is for
	### END INIT INFO

Then write the script to /etc/init.d/daemon-name

Finally activate by running

	update-rc.d daemon-name defaults

To remove the script:

	update-rc.d -f daemon-name remove
