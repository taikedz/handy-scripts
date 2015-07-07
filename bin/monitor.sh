#!/bin/bash

# (C) Tai Kedzierski 2015
# Released under GNU GPLv3
#
# You are free to distribute, modify, and distribute your changes
# provided you retain this copyright notice and include the source
# with any binary you distribute.
#
# Full details can be found at:
# http://www.gnu.org/licenses/gpl-3.0.en.html

# This is a simple script to detect issues early
# It is not an IDS by any measure, but should help catch performance problems.

# ----------------------------------------¬
# Configure your settings

SERVERNAME='your server'
EMAILS='admin@domain.net support@helpers.com'

# Configure at what percentage to trigger

# Memory pressure (0 - 100%)
M_TRIGGER=90

# Overall load average (0 - 100%)
L_TRIGGER=90

# This is (load_avg_5min + load_avg_1min)/(2*core_count)
# So as to allow for temporary spikes

# /Configuration -------------------------/
# You shouldn't need to modify anything below

# ==========================================================================================

CPU_COUNT=$(cat /proc/cpuinfo | grep "model name" | wc -l)

# FIXME use the bc calculator instead
MEMORY_LOAD=$(python -c 'import sys; print int(100*(float(sys.argv[3])-float(sys.argv[6]))/float(sys.argv[3]))' $(free | sed -r 's/ +/\t/g'|cut -f 2,4) )
OVERALL_LOAD=$(python -c 'import sys; m=float(sys.argv[1]); n=float(sys.argv[2]); print int(100*(n+m)/(2*'"$CPU_COUNT"'))' $(uptime | sed -r -e 's/^.+load average: //' -e 's/, / /g' | cut -d ' ' -f 2,1))

echo Memory "$MEMORY_LOAD (max $M_TRIGGER)"
echo CPU "$OVERALL_LOAD (max $L_TRIGGER)"

# ===========================================================================================
if [[ $MEMORY_LOAD -gt $M_TRIGGER ]]; then

mail "Warning - $MEMORY_LOAD % memory usage on $SERVERNAME" $EMAILS <<EOMAIL

High Memory usage $MEMORY_LOAD % has been detected on $SERVERNAME

$(free -m)

=================

Uptime stats ($CPU_COUNT cores)

$(uptime)

=================

CONFIDENTIAL - 'top' output:

$(top -b -n 1 | head)

EOMAIL
fi

# ===========================================================================================
CPU_LOAD=$(echo $(uptime | sed -r -e 's/^.+load average: //' -e 's/, / /g' | cut -d ' ' -f 1)"/1" | bc)
if [[ $CPU_LOAD -gt $CPU_COUNT ]] && [[ $OVERALL_LOAD -gt $L_TRIGGER ]]; then
mail "Warning - high CPU load on $SERVERNAME" $EMAILS <<EOMAIL

High Load average detected ($CPU_COUNT cores) on $SERVERNAME

$(uptime)

==================

Memory stats: (MB)

$(free -m)


=================

CONFIDENTIAL - 'top' output:

$(top -b -n 1 | head)

EOMAIL
fi
