##
# A brownian colloid (s)imulator
#
# Dan Kolbman
##

import DataIO
import Experiment
using ArgParse

# Initialize the file system by creating needed directories and files
# Params:
#   conf - the configuration Dict
function initFS(conf)
  path = conf["path"]
  if(!isdir(path))
    mkpath(path)
  # Check for existing data
  elseif(isfile(string(path,"log.txt")))
    println("WARNING: Data exists in the path. Overwrite? (y/n)")
    input = chomp(readline())
    if(input != "y")
      exit()
    end
  end
end

# Parse arguements from the command line
# Returns
#   A dict with the agruement flags and their values
function parseArgs()
  s = ArgParseSettings()
  s.prog = "bcim"

  @add_arg_table s begin
    "config"
      help = "The configuration file"
      required = true
      arg_type = String
    "-o", "--outdir"
        help = "The directory path to save output to"
        arg_type = String
    "run"
      help = "Run an experiment"
      action = :command
  end
  return parse_args(s)
end

# Creates a default configuration
# Returns
#   A configuration dict with nondimensional units
function defaultConf()
  conf = Dict{String, Any}()
  # Program params
  conf["path"] = "data/test/"
  conf["verbose"] = 1
  conf["ntrials"] = 1
  conf["nsteps"] = 1000
  conf["freq"] = 100

  # Simulation params
  conf["npart"] = 400
  conf["phi"] = 0.40      # Packing frac
  conf["dt"] = 1.0e-6     # s
  conf["temp"] = 298.0    # K
  conf["boltz"] = 1.38e16 # erg / K
  conf["dia"] = 1.07e-4   # g / (cm s)

  conf["diffus"] = 2.15e-10
  conf["rotdiffus"] = 2.845e7

  # Coefficients
  conf["rep"] = 0.001     # energy / length
  conf["prop"] = 100.0    # length / difftime
  conf["contact"] = 0.1   # length
  conf["adh"] = 0.1       # energy / length

  return conf
end

# Dedimensionalize all constants in configuration
# Params
#   conf - the configuration dict
# Returns
#   A configuration dict with nondimensional units
function dedimension(conf)
  # Dimensionless units
  ulength = conf["dia"]
  utime = conf["dia"]^2/conf["diffus"]
  uenergy = conf["boltz"]*conf["temp"]
  
  conf["rotdiffus"] = conf["rotdiffus"]*utime
  conf["diffus"] = conf["diffus"]*utime/(ulength^2)
  conf["dia"] = conf["dia"]/ulength
  conf["dt"] = conf["dt"]/utime
  conf["rep"] = conf["rep"]/ulength
  conf["contact"] = conf["contact"]/ulength
  conf["adh"] = conf["adh"]/conf["contact"]

  return conf
end
    
# Main function loop
function main()
  conf = defaultConf()
  parsedArgs = parseArgs()
  # Assign params from the configuration file
  DataIO.readConf(parsedArgs["config"], conf)
  # De-dimensionalise parameters
  dedimension(conf)

  if(parsedArgs["outdir"]!=nothing)
    conf["path"] = parsedArgs["outdir"]
  end
  # Initialize the file sysetm
  initFS(conf)
  # Log
  DataIO.log("Experiment starting...", conf)
  Experiment.run(conf)
end

main()
