module IHCP

using LinearAlgebra
using SparseArrays

include("poly_utils.jl")
include("grid_setup.jl")
include("dhcp.jl")
include("adjoint.jl")
include("cgm.jl")
include("sliding_window.jl")

using .PolyUtils
using .GridSetup
using .DHCP
using .Adjoint
using .CGM
using .SlidingWindow

end # module IHCP
