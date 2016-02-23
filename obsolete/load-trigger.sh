#!/bin/bash

SERVERNAME='your server'
EMAILS='me@home.net myself@work.com'

# This is a simple script to detect issues early
# It is not an IDS by any measure, but should help catch performance problems.

L_TRIGGER=90
CPU_COUNT=$(cat /proc/cpuinfo | grep "model name" | wc -l)


OVERALL_LOAD=$(python -c 'import sys; m=float(sys.argv[1]); n=float(sys.argv[2]); print int(100*(n+m)/('$CPU_COUNT'*2))' $(uptime | sed -r -e 's/^.+load average: //' -e 's/, / /g' | cut -d ' ' -f 2,1))

#echo CPU "$OVERALL_LOAD (max $L_TRIGGER)"


# ===========================================================================================
CPU_LOAD=$(echo $(uptime | sed -r -e 's/^.+load average: //' -e 's/, / /g' | cut -d ' ' -f 1)"/1" | bc)
if [[ $CPU_LOAD -gt $CPU_COUNT ]] && [[ $OVERALL_LOAD -gt $L_TRIGGER ]]; then
mail -s "Warning - high Load average on $SERVERNAME" $EMAILS <<EOMAIL

High Load average detected ($CPU_COUNT cores)

High load average occurs when processes are waiting for the CPU. This could be a CPU-intensive task, or
when the disk is busy (typically writing/reading lots)

The load average report consists of 3 numbers, the load for the last minute, 5 minutes, and 15 minutes.

Your max ideal CPU load threshold is $CPU_COUNT
A load average above this number, consistent for all three slots, needs attention.


$(uptime)

==================

Memory stats: (MB)

$(free -m)


=================

CONFIDENTIAL

Top set of CPU-using processes


$(top -b -n 1 | head -n 20)


$(ps aux | grep -E $(echo $(top -b -n 1 | head -n 30 | grep -E '^ *[0-9]' | cut -d ' ' -f 1) | sed -r -e 's/ /|/g' -e 's/^/^/' -e 's/$/$/'))


EOMAIL
fi

