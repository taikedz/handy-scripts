#!/bin/bash

# Shell arguments extractor
#
# Copyright 2015 Tai Kedzierski
#
# Released under the GPL v3.0 - see http://gnu.org for full details
#
# In brief:
# This software is Free Software - you are free to use, modify,
# share and otherwise disseminate this program and its code as
# well you please, provided that this copyright notice is retained and:
#
#	A/ You provide the source code with any binary/non-source version you may compile
#	B/ You provide the source code of any code you integrate this code into
#	C/ You transfer the same rights to any who use your version.
#
# You accept that this code is provided "as-is"
# wihout any warranty of merchantability or fitness for a particular purpose
# etc.
#
# For full license details, please refer to the GNU General Public License v 3.0

# ---------------------------------------------------------------------------

# Include this script at the head of your main script to perform argument extraction
# before beginning working
#

# </premable> ==============================================================================

# Read an argument and try to extract its value according to the rules as provided
# Argument 1 is the argument being passed
# Argument 2 is the label - this is a string, followed by a "=" followed by thestring expected as value
# Argument 3 is the pattern to match the value against. For the general case, use ".+"
#
# Returns the value of the argument if present, or an empty string if no match
#
# Example:
#	getarg "$argument" "--some-number" "[0-9]+"
#
# This extracts the value of "--some-number=42" , which is "42"
function getarg {
	# $1 - arg
	# $2 - label
	# $3 - pattern
	local a_arg=$1
	shift

	local a_label=$1
	shift

	local a_match=$1
	shift

	echo "$a_arg" | grep -E "^$a_label=$a_match$" | sed -e "s/$a_label=//"
}

# Match an argument against a comma-separated list of values
#
# Argument 1 is the argument received
# Argument 2 is a list of comma-separated literals
#
# Example: 
#	matcharg "$argument" "START,STOP,STATUS"
#
# This matches the argument against a determined list of START, STOP or STATUS. Whitespace is relevant.
function matcharg {
	# $1 - argument
	# $2 - values
	local a_arg=$1
	shift

	local a_match=$( echo "$@" | tr ',' '\n' )

	echo -e "$a_match" | grep "^$a_arg$"
}

# Extract a specific piece of text out of an argument, by way of a series of patterns
#
# Argument 1 - the argument to process
# Argument 2+ - the patterns through which to successively pass the argument
#
# The patterns apply whole, and only the first capturing group should come out the other end.
#
# Example:
#	argextract "sir francis SUPER bacon" "[a-z]+ (.+)" "(.+) bacon"
#
# returns "francis SUPER"
function argextract {
	#$1 - argument
	#$2 - series of capturing patterns captured sequentially
	# This is a bit kludgy and needs refining

	local a_arg=$1
	shift

	#echo "Arg $a_arg"

	local var
	for var in "$@"; do
		#echo "Pat $var"
		a_arg=$(echo $a_arg | sed -r "s|^$var$|\1|")
	done
	echo $a_arg
}

function getargs() {
	# Main function to extract all arguments
	for var in "$@"; do
		if [[ $( matcharg "$var" "--help,-h,/h" ) != "" ]]; then
		cat <<EOHELP
USER HELP SECTION - replace this
EOHELP
	# Write in this loop what arguments you want to extract
	# use 'local' to make variables that will not be used outside of this function
	# all other variables have scope globally

		fi
		
#		#if you need to pass aguments to a subshell, remember to export
#
#		# Example - extract an action string from (anywhere)
#		t_action=$( matcharg "$var" "START,STOP,STATUS"  )
#		if [[ -n "$t_action" ]]; then continue;
#		else export t_action; fi
#
#		# Extract two numerical values from the same argument: --ports=rport-lport
#		local l_ports=$( getarg "$var" "--ports" "[1-9][0-9]*-[1-9][0-9]*" )
#		if [[ -n "$l_ports" ]]; then
#			export t_rport=$( argextract "$l_ports" ".*-([1-9][0-9]+)" ) # use '.*' at the start to discard the start of string
#			export t_lport=$( argextract "$l_ports" "([1-9][0-9]+)-.*" ) # and at the end to omit rest of string
#			continue;
#		fi

	done
}
# Calls the arguments processing we just defined
getargs "$@"

# -----------
#
#
#	End of boilerplate argument extraction
#	You can now add your own code
#
#
# =========== Your actual script here =============
#

#if [[ -n $t_action ]]; then echo "t_action is $t_action";        fi
#if [[ -n $t_lport  ]]; then echo "l = $t_lport ; r = $t_rport"; fi
#echo "Done."
