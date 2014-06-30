##
# Functions for file reading and writing
# 
# Dan Kolbman 2014
##

module DataIO

# Appends output to a logfile
# Params
#   str - the string to write
#   conf - the configuration Dict
function log(str,conf)
  path = string(conf["path"],"log.txt")
  f = open(path,"a")
  t = TmStruct(time())
  str = string("[",t.hour,":",t.min,":",t.sec,"]: ",str,"\n")
  write(f,str)
  if(conf["verbose"] == 1) print(str) end
  close(f)
end
# Read a configuration file and returns a new configuration dict
# Params:
#   filen - the path for the configuration file
# Returns:
#   A Dict with param, value pairs
function readConf(filen)
  params = Dict{String, Any}()
  readConf(filen, conf)
  return params

end

# Read a configuration file and assigns values to conf dict.
# Modifies the conf in place. Existing parameters may be overwritten
# Params:
#   filen - the path for the configuration file
#   conf - a configuration dict
function readConf(filen, conf)
  # Reads data into an array separated by ' '
  data = readdlm(filen,' ',comments=true)
  # Each element in the array corresponds to a parameter
  for line in 1:size(data,1)
    # The first element is the parameter name
    key = data[line,1]
    vals = Array(Any,0)
    # Strip all empty entries
    for elem in 2:size(data,2)
      if (data[line,elem] != "")
        push!(vals,data[line,elem])
      end
    end
    # If only one value, assign it to the key
    if(size(vals,1) == 1)
      conf[key] = vals[1]
    # If more than one value, assign the array as the value
    elseif(size(vals,1) > 1)
      conf[key] = vals
    end
  end
end

# Write a configuration file
# Params
#   filen - the path to write the configuration file to
#   conf - a Dict of parameters
function writeConf(filen, conf)
  f = open("$filen.cnf", "w")
  for key in keys(conf)
    line = key
    # If the parameter has multiple values..
    if(typeof(conf[key]) == Array{Any,1})
      # Write each value
      for val in conf[key]
        line = string(line, " ", val)
      end
    else
      # Or just write the single value
      line = string(line, " ", conf[key])
    end
    write(f, string(line,"\n"))
  end
  close(f)
end

# Reads particle data for all species from files begining with filen
# Params
#   filen - the path to write the file
# Returns
#   a species array
function readParts(filen)
  #TODO implement this. Not needed until we want to start simulations from
  # old states.
end

# Reads a single species from a data file
# Params
#   filen - the file name of the species
# Returns
#   An array of particle data for the species
function readSpecies(filen)
  parts = readdlm(filen,' ')
  return parts
end

# Write particle data to a file.
# If no species is defined, write all species to different data files
# Params
#   filen - the file to write to
#   parts - particle species array
#   spec - which species to write
function writeParts(filen, parts, spec=0)
  if(spec != 0)
    writedlm("$filen.dat", parts[spec],' ')
  else
    # Write all species to different files
    for sp in 1:length(parts)
      f = open("$(filen)SP$sp.dat","a+")
      writedlm(f, parts[sp], ' ')
      close(f)
      #writedlm("$(filen)SP$sp.dat", parts[sp], ' ')
    end
  end
end

# Test functions
function test()
  #Configuration files
  #conf1 = readConf("defaults.cnf")
  #writeConf("newconf.cnf", conf1)
  #conf2 = readConf("newconf.cnf")
  #println(conf2)

  # Make some species
  parts = Array(Any,2)
  for sp in 1:2
    # Make some particles for the species
    spn = Array(Float64,6,8)
    for p in 1:5
      spn[p,:] = [ rand(1,6) 2*pi*rand() 0 ]
    end
    parts[sp] = spn
  end

  # Write positions
  writeParts("parts", parts)
  print(parts)
end

end
