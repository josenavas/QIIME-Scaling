#!/bin/bash

# Template script for submit scripts on compy
# It submits each test case 10 times in order to be
# able to successfully benchmark the script
# 10 times for timing average

# Path to timing_wrapper.sh script
time_wrapper="/Users/jona1883/QIIME-Scaling-master/timing_wrapper.sh"
# QIIME script to execute
cmd="QIIME_cmd.py"
# In each test we usually change only one input file, put all the needed
# parameters before the one we change here
params_in="-i "
# We also modify the output folder/file, put the ouput parameter here
# (and all the remaining parameters, but the output should be the last one)
params_out="-o "
# Base name for the output timing file
base_outfp="time_file"
# Files to use as input
files=`ls /path/to/test_files`
# Base name for the job
job_name="bench_"

# Run each experiment 10 times, so we can average the results
for i in `seq 1 10`
do
	for f in $files
	do
		# Get the basename of the file (without the file extension)
		basename=`basename $f | cut -d. -f1`
		# Submit the job
		echo "cd `pwd`; $time_wrapper ${base_outfp}_${i}_${basename}.txt $cmd $params_in$f $params_out${basename}_$i" | qsub -k oe -N ${job_name}_${i}_${basename} -l pvmem=512gb -q memroute
	done
done
