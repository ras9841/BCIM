## Runs a experiments for diffrent numbers of particles
# Each experiment consists of three trials
# Saves data to data/numparts/ relative to run path

include("../src/julia/BCIM.jl")
#using BCIM

# Hack to allow asynchronous experiment runs
sleep(rand()*10)

# Our physical constants
# sp1:= species 1, sp2 = species 2
pc = BCIM.PhysicalConst(  1e-7,           # dt
                          # Packing fraction
                          0.50,
                          # so unit length cube dia/root(0.8)
                          # Eta
                          1.00,
                          # Temperature (K)
                          310.15,
                          # Boltzmann constant
                          1.38e-16,
                          # Propulsisions [ sp1, sp2 ]
                          [0.0, 0.0],
                          # Repulsions [ sp1, sp2 ]
                          [0.0, 1.0e-12],
                          # Adhesions  [sp1, sp2, sp1-sp2 ]
                          # Adehsion force = pi gamma dia 
                          # 3.14 *45 dyne/cm * 15* 10-4 cm
                          [0.0, 0.0, 0.0],
                          # Cell division time ( 0 = no division)
                          [ 0.0, 0.0 ],
                          # Efective adhesive contact distance (D)
                          0.01,
                          # Cell diameter
                          15.0e-4,
                          # Number of particles [ sp1, sp2 ]
                          [128,128])

##### 256 particles total
pc.npart = [128, 128]
#pc.npart = [2, 2]

##### Set number of experiments to run.
nexps = 5;
for test in 1:nexps
    #srand(3435)
    exp = BCIM.Experiment("data/test_long$(test)", 1, pc, true)
    # Run the experiment
    # Equilibriate for 1000 steps
    # Collect every 1000 steps
    # Run for 100000 steps
    BCIM.run(exp, 10000:10000:1000000)
end
##### Run again for 512 particles total
#pc.npart = [256, 256]
#exp = BCIM.Experiment("data/ex/512", 1, pc, false)
#BCIM.run(exp, 1000:1000:10000)

##### 1024 particles total
#pc.npart = [512, 512]
#exp = BCIM.Experiment("data/ex/1024", 1, pc, false)
#BCIM.run(exp, 1000:1000:10000)
