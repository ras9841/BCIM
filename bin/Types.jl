##
# Type for particle representation
#
# Dan Kolbman
##

import Base.show

type Part
  sp::Int8
  pos::Array{Float64}
  vel::Array{Float64}
  ang::Array{Float64}
  # The total square distance, used for msd
  sqd::Float64
  # The starting coordinate
  org::Array{Float64}

  Part(sp, pos, vel, ang, sqd) = new(sp, pos, vel, ang, sqd, pos)
  Part(sp, pos, vel, ang) = new(sp, pos, vel, ang, 0.0, pos)
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
end

function print_arr(io, X::AbstractArray)
    for i=1:size(X,1)
      print(io, "$(X[i]) ")
    end
end

function show(io::IO, part::Array{Part})
  for p in part
    show(io, p)
    print(io, "\n")
  end
end
