module PolyUtils

"""Evaluate a polynomial at `x` using coefficients in descending order.
The implementation will mirror Python's `polyval_numba` once ported."""
function polyval_descending(coeffs::AbstractVector{T}, x::T) where {T}
    error("polyval_descending is not implemented yet; port from Python `polyval_numba`.")
end

end # module PolyUtils
