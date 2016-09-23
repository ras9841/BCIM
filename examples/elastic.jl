## Runs a experiments for diffrent numbers of particles
# Each experiment consists of three trials
# Saves data to data/numparts/ relative to run path

include("../src/julia/BCIM.jl")
#using BCIM

# Hack to allow asynchronous experiment runs
sleep(rand()*10)

# Our physical constants
# sp1:= species 1, sp2 = species 2
pc = BCIM.PhysicalConst(  1.0e-3,           # dt
                          # Packing fraction
                          0.90,
                          # so unit length cube dia/root(0.8)
                          # Eta
                          1.00,
                          # Temperature (K)
                          310.15,
                          # Boltzmann constant
                          1.38e-16,
                          # Propulsisions [ sp1, sp2 ]
                          [1e-2, 1e-2],
                          # Repulsions [ sp1, sp2 ]
                          [1.5e4, 1.5e2],
                          # Adhesions [ sp1, sp2, sp1-sp2 ]
                          # Adehsion force = pi gamma dia 
                          # 3.14 *45 dyne/cm * 15* 10-4 cm
                          [0e0, 0e0, 0e0],
                          # Cell division time ( 0 = no division)
                          [ 0.0, 0.0 ],
                          # Efective adhesive contact distance
                          0.01,
                          # Cell diameter
                          15.0e-4,
                          # Number of particles [ sp1, sp2 ]
                          [128,128])

##### 256 particles total
pc.npart = [128, 128]
# Initialize experiment with 3 trials in given directory with desired constants
exp = BCIM.Experiment("../data/elastic", 5, pc, false)

# Run the experiment
# Equilibriate for 1000 steps
# Collect every 1000 steps
# Run for 100000 steps
#BCIM.run(exp, 10000:5000:700000)
BCIM.run(exp, 10000:5000:700000)

##### Run again for 512 particles total
#pc.npart = [256, 256]
#exp = BCIM.Experiment("data/ex/512", 1, pc, false)
#BCIM.run(exp, 1000:1000:10000)

##### 1024 particles total
#pc.npart = [512, 512]
#exp = BCIM.Experiment("data/ex/1024", 1, pc, false)
#BCIM.run(exp, 1000:1000:10000)