#=
    File:       general_test .jl
    Author:     Roland Sanford (ras9841@rit.edu)
    Version:    Julia 0.5
    Description:
        Main experimental testing file. All experimental parameters 
        are entered here. Results are saved to "data/$(name)/", 
        relative to the run path.

        To run the test, execute this shell script:
        "$ sh general_test.jl"
=#

# Include the BCIM definitioins.
include("../src/julia/BCIM.jl")

# Set the base simulation seed in range 0 to 100. 
base_seed = round(Int, rand(1)[1]*100)

# Define the system's physical constants.
# Note: sp1 denotes species 1, and sp2 denotes species 2.
pc = BCIM.PhysicalConst(
        # Time step (s)  
        1e-6,          
        # Packing fraction
        0.60,
        # Eta
        0.01,
        # Temperature (K)
        298.0,
        # Boltzmann constant (cgs)
        1.38e-16,
        # Propulsisions [ sp1, sp2 ] (dynes) 
        [0.0, 1.0e3],
        # Repulsions [ sp1, sp2 ] (dynes)
        [1.5e4, 1.5e3],
        # Adhesions  [sp1-sp1, sp2-sp2, sp1-sp2 ] (dynes)
        [1.5e3, 0.0, 0.0],
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
name = "general_test"

exp = BCIM.Experiment("data/$(name)", 1, pc, true)
# Run exp with the conditions a:b:c where
# - equilibriate every a steps
# - collect data every b steps
# - run rxp for c steps
print("Starting experiment with seed $base_seed.\n")
BCIM.run(exp, 10000:10000:1000000)
