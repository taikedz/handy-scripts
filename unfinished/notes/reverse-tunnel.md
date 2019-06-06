# How to setup a remote tunnel to a Linux box

There are three machines involved in this setup:

1. target - the Linux box we want to ultimately SSH to, which is behind a NAT/firewall
	* the user on this host is target-user
2. anchor - the machine with a public IP address
	* no specific user is needed on this machine
3. commander - any PC somewhere out there

## Setup target

On the target PC, edit /etc/ssh/sshd_config. You need to add this line, or activate it:

	GatewayPorts yes

Restart sshd

Finally, open the tunnel:

	ssh -fN -R 5500:localhost:22 anchor &

...where 'anchor' is the domain name or IP of the anchor machine. We use `&` to leave this process running after the shell terminates.

## Setup the anchor

The anchor's firewall needs to allow port 5500 through, or whichever port you choose.

That's it.

## Use the commander

From the commander machine, you can now start whatever client you were trying to use by pointing it at the anchor address.

For simple ssh, this is:

	ssh -p 5500 target-user@anchor

Port 5500 is used for Gitso, and if you do not have the ability to port forward on the router, this method is what you'll need to employto allow users elsewhere to connect to you.

Users of Gitso soliciting your help will then need to use the anchor's address to connect to you.

### Clean up

On the target, once the access requirement is ended, take down the reverse tunnel. First find the PID:

	ps aux | grep 'ssh -fN -R'

Get the PID (often the first number after your username) and issue a `kill` command on that PID.
