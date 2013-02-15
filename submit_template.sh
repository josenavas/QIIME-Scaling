#!/bin/bash

# Template script for submit benchmark scripts on compy

time_wrapper="/Users/jona1883/QIIME-Scaling-master/timing_wrapper.sh"
cmd="QIIME_cmd.py"
params_in="-i "
params_out="-o "
base_outfp="time_file"
files=`ls /path/to/test_files`
job_name="bench_CMD"

# Run each experiment 10 times, so we can average the results
for i in `seq 1 10`
do
	for f in $files
	do
		# Get the basename of the file (without the file extension)
		basename=`basename $f | cut -d. -f1`
		echo "cd `pwd`; $time_wrapper ${base_outfp}_${i}_${basename}.txt $cmd $params_in$f $params_out${basename}_$i" | qsub -k oe -N ${job_name}_${i}_${basename} -l pvmem=512gb -q memroute
	done
done
