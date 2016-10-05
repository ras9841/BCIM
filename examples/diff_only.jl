#=
    File:       diff_only.jl
    Author:     Roland Sanford (ras9841@rit.edu)
    Version:    Julia 0.4
    Description:
        Experimental configuration file for the diffusion-only base 
        case. Here, only diffusion governs the motion of the particles.
        Results are savec to "data/$(name)/", relative to the run path.
=#

# Include the BCIM definitioins.
include("../src/julia/BCIM.jl")

# Set the base simulation seed in range 0 to 100. 
base_seed = round(Int, rand(1)[1]*100)

# Define the system's physical constants.
# Note: sp1 denotes species 1, and sp2 denotes species 2.
pc = BCIM.PhysicalConst(# Time step (s)  
                        1e-7,          
                        # Packing fraction
                        0.50,
                        # Eta
                        1.00,
                        # Temperature (K)
                        310.15,
                        # Boltzmann constant (cgs)
                        1.38e-16,
                        # Propulsisions [ sp1, sp2 ] (dynes) 
                        [0.0, 0.0],
                        # Repulsions [ sp1, sp2 ] (dynes)
                        [0.0, 1.0e-12],
                        # Adhesions  [sp1-sp1, sp2-sp2, sp1-sp2 ] (dynes)
                        [0.0, 0.0, 0.0],
                        # Cell division time ( 0 = no division ) (s) 
                        [0.0, 0.0],
                        # Efective adhesive contact distance (*D) (cm)
                        0.01, #prefactor
                        # Cell diameter (cm)
                        15.0e-4,
                        # Number of particles [ sp1, sp2 ]
                        [128, 128],
                        # Seed for RNGs
                        base_seed
                       )

##### 256 particles total
pc.npart = [128, 128]

# Base directory for results
name = "testing"

exp = BCIM.Experiment("data/$(name)", 1, pc, true)
# Run exp with the conditions a:b:c where
# - equilibriate every a steps
# - collect data every b steps
# - run rxp for c steps
print("Starting experiment with seed $base_seed.\n")
BCIM.run(exp, 10000:10000:1000000)
