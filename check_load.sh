#!/bin/bash

# Author:	Jay
# Date:		30/11/2019
# Description:	Reboot system if load & memory is above Threshold. 
# Requires:	[bc, awk, cat, free, shutdown]

# User variables
n_load_threshold=10.0
n_mem_threshold=10000
s_reboot_message='Reboot triggered via script.'
s_action='None'
n_timeout=1

# Flags
b_reboot=0
b_high_load=0
b_high_mem=0

# Get Load averages
s_load=`cat /proc/loadavg`
n_load_1=` echo $s_load | awk '{print $1}'`
n_load_5=` echo $s_load | awk '{print $2}'`
n_load_15=`echo $s_load | awk '{print $3}'`

# Get Free memory
s_free=`free | cut -d$'\n' -f2`
n_mem=`     echo $s_free | awk '{print $2}'`
n_mem_free=`echo $s_free | awk '{print $4}'`

# Set flags if values above thresholds
b_high_mem=` echo "$n_mem_free < $n_mem_threshold" | bc`
b_high_load=`echo "$n_load_15 > $n_load_threshold" | bc`

# Check if flags are set, if so... Set Reboot flag
if [ "$b_high_mem" -eq "1" -a "$b_high_load" -eq "1" ]; then
	s_action="Reboot"
	b_reboot=1
fi

echo "========================"
echo "Load: 		$n_load_15"
echo "Threshold:	$n_load_threshold"
echo "------------------------"
echo "Free Memory:	$n_mem_free"
echo "Threshold:	$n_mem_threshold"
echo "------------------------"
echo "Mem Alarm:	$b_high_mem"
echo "Load Alarm:	$b_high_load"
echo "------------------------"
echo "Action:		$s_action"
echo "========================"

# Reboot system if flag set
if [ "$b_reboot" -eq "1" ]; then
        `shutdown --reboot $n_timeout '$s_reboot_message'`
fi
