#!/bin/bash

# Can be killed with kill -9 <pid>
trap -- '' SIGINT SIGTERM SIGTSTP

echo "(${USER}@${HOSTNAME}) Simulation set started."
time julia examples/diff_only.jl
echo "(${USER}@${HOSTNAME}) Simulation set completed."
notify-send "Job Done" "BCIM Simulation Completed!"
