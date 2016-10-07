"""
Sets up the simulation:
- Run the system for k steps then take data.
"""

type Simulation
  path::String
  s::System
  dimConst::DimensionlessConst
  l::Log
  Simulation(dir, s, dimConst, l) = new(nextPath(dir), s, dimConst, l)
end

# Initialize a simulation with given parameters and log file
function Simulation(dir::String, dc::DimensionlessConst, l::Log)
  return Simulation(dir, Sphere(dc), dc, l)
end

# Uses default folder names of 'trial{id}' inside the given dir
# Finds the next available id in the given dir and makes a path for it
function nextPath(dir::String)
  id = 1
  # Find next available id
  while ispath(joinpath(dir, "trial$id"))
    id += 1
  end
  path = joinpath(dir, "trial$id")
  println(path)
  mkdir(path)
  return path
end

# Runs the simulation for the desired time
function run(sim::Simulation, r::Range{Int})
  nequil = first(r)-1
  freq = r.step
  nsteps = last(r)

  ndata = round(Int64, nsteps/freq)
  avgmsd = zeros(Float64, ndata, size(sim.dimConst.npart, 1)+1)

  tic()
  # Equilibriate
  for neq in 1:nequil
    # Update cells
    if(neq%10 == 1)
        assignParts(sim.s)

    end
    # Step
    step(sim.s)
  end


  # Reset particles' origins after equilibriating
  for p in sim.s.parts
    p.org = p.pos
    p.sqd = 0.0
  end
  
  # Run each step
  for s in 1:nsteps
  
    # Update cells
    if(s%10 == 1)
      assignParts(sim.s)
    end
    # Step
    step(sim.s)
    
    # Collect data
    if(s%freq == 0)
      print("[")
      print("#"^round(Int64, s/nsteps*70))
      print("-"^(70-round(Int64, s/nsteps*70)))
      print("] $(round(Int64, s/nsteps*100))%\r")
      #print"\r\t"^(myid()*3))
      #print"$(myid()): $(round(Int64, s/conf["nsteps"]*100))%   ")

      t = s*sim.dimConst.dt
      writeParts(joinpath(sim.path, "parts"), sim.s.parts, t)

      avgmsd[round(Int64, s/freq), 1] = t
      avgmsd[round(Int64, s/freq), 2:end] = avgMSD(sim.dimConst, sim.s.parts)

    end
  end
  
  # Put time and space dimesions back into msd
  msd[:,1] = msd[:,1]*sim.dimConst*utime
  msd[:,2:3] = msd[:,2:3]*sim.dimConst*ulength^2
  writeMSD(joinpath(sim.path,"msd"), avgmsd)
  log(sim.l, "Finished trial in $(toq()) seconds")

end
