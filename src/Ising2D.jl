module Ising2D

using GLMakie

export Lattice
export magnetisation
export energy
export average

export switchspin!
export switch_random_spin

export plot_configuration

include("lattice.jl")
include("monte-carlo.jl")
include("plot.jl")

end
