##
# Types for particle and cell representation
#
# Dan Kolbman
##

import Base.show

# Holds dimensional physical parameters
type PhysicalConst
  dt::Float64
  phi::Float64
  eta::Float64
  temp::Float64
  boltz::Float64

  prop::Array{Float64,1}
  rep::Array{Float64,1}
  adh::Array{Float64,1}
  div::Array{Float64,1}
  contact::Float64
  dia::Float64
  npart::Array{Int64,1}
  
  rotdiffus::Float64
  diffus::Float64
  bseed::Int64
end

function PhysicalConst(
            dt::Float64,
            phi::Float64, #packing fraction
            eta::Float64,
            temp::Float64,
            boltz::Float64,
            prop::Array{Float64,1},
            rep::Array{Float64,1},
            adh::Array{Float64,1},
            div::Array{Float64,1},
            contact::Float64,
            dia::Float64,
            npart::Array{Int64,1},
            bseed::Int64)
  diff = 2e-8/60
  rotdiff = 31.6*boltz*temp/(pi*eta*dia^3)
  return PhysicalConst(
            dt,
            phi,
            eta,
            temp,
            boltz,
            prop,
            rep,
            adh,
            div,
            contact,
            dia,
            npart,
            diff,
            rotdiff,
            bseed
            )
end
# Holds dimensionless parameters
type DimensionlessConst
  dt::Float64
  phi::Float64
  eta::Float64
  temp::Float64
  boltz::Float64

  prop::Array{Float64,1}
  rep::Array{Float64,1}
  adh::Array{Float64,1}
  div::Array{Float64,1}
  contact::Float64
  dia::Float64
  npart::Array{Int64,1}
  size::Float64

  utime::Float64
  ulength::Float64
  uenergy::Float64

  rotdiffus::Float64
  diffus::Float64
  pretrad::Float64
  prerotd::Float64

  bseed::Int64
end

# Converts physical parameters to dimensionless parameters
function DimensionlessConst(pc::PhysicalConst)
  contact = pc.contact
  utime = pc.dia*pc.dia/pc.diffus
  ulength = pc.dia
  uenergy = pc.boltz*pc.temp
  diffus = pc.diffus*utime/(ulength^2)
  rotdiffus = 3*diffus
  dia = pc.dia./ulength
  size = cbrt(sum(pc.npart))*(dia/2) # radius of bounding sphere
  dt = pc.dt/utime #nondimensionalize dt
  rep = pc.rep
  contact = contact
  adh = pc.adh
  pretrad = sqrt(2.0*diffus/dt)     ### SET TO 0 FOR SPP CHECK ###
  prerotd = sqrt(2.0*rotdiffus*dt)  ### SET TO 0 FOR SPP CHECK ###
  div = pc.div/utime

  return DimensionlessConst(
    dt,
    pc.phi,
    pc.eta,
    pc.temp,
    pc.boltz,
    pc.prop,
    rep,
    adh,
    div,
    contact,
    dia,
    pc.npart,
    size,
    utime,
    ulength,
    uenergy,
    rotdiffus,
    diffus,
    pretrad,
    prerotd,
    pc.bseed)
  end

type Part
  id::Int
  sp::Int8
  pos::Array{Float64}
  vel::Array{Float64}
  ang::Array{Float64}
  # Division counter (counts number of steps since last division)
  div::Float64
  # The total square distance, used for msd
  sqd::Float64
  # The starting coordinate
  org::Array{Float64}
  # Force contributions
  brn::Array{Float64}
  prp::Array{Float64}
  adh::Array{Float64}
  rep::Array{Float64}
  # Constructors
  Part(id, sp, pos, vel, ang, div, sqd) = new(id, sp, pos, vel, ang, div, sqd, pos,
       [0.0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0])
  Part(id, sp, pos, vel, ang, div) = new(id, sp, pos, vel, ang, div, 0.0, pos,
       [0.0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0])
end

type Cell
  id::Int
  parts::Array{Part}
  neighbors::Array{Cell}
end

function show(io::IO, c::Cell)
  print(io, "$(c.id)")
end

# The following formats the output of particle data
# TODO this could be cleaned up some
function show(io::IO, p::Part)
  #println("$(p.sp) $(p.vel) $(p.ang) $(p.msd)")
  print(io, "$(p.sp) ")
  print_arr(io, p.pos)
  print_arr(io, p.vel)
  print_arr(io, p.ang)
  print(io, "$(p.sqd)")
  if io == STDOUT
    forces(p)
  end
end

# Print the force contributions for the particle
function forces(p::Part)
  print("FORCES FOR PARTICLE $(p.id)\n")
  print("BRN: $(norm(p.brn))\n")
  print("PRP: $(norm(p.prp))\n")
  print("ADH: $(norm(p.adh))\n")
  print("REP: $(norm(p.rep))\n")
end

function print_arr(io, X::AbstractArray)
    for i=1:size(X,1)
      print(io, "$(X[i])\t")
    end
end

function show(io::IO, part::Array{Part})
  for p in part
    show(io, p)
    print(io, "\n")
  end
end
