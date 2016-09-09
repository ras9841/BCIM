echo "(${USER}@${HOSTNAME}) Simulation set started."
julia examples/diff_only.jl
echo "(${USER}@${HOSTNAME}) Simulation set completed."
notify-send "Job Done" "BCIM Simulation Completed!"
