using Test

include(joinpath(@__DIR__, "..", "src", "poly_utils.jl"))

include("test_step0_smoke.jl")
include("test_poly_utils.jl")
