module PolyUtils

export polyval_descending

"""
    polyval_descending(coeffs, x)

Evaluate a polynomial with coefficients provided in descending powers (matching
NumPy's `polyval`). Supports scalar `x` and broadcasts over arrays.
"""
function polyval_descending(coeffs::AbstractVector, x)
    T = promote_type(eltype(coeffs), typeof(x))
    result = zero(T)
    for c in coeffs
        result = result * x + c
    end
    return result
end

polyval_descending(coeffs::AbstractVector, xs::AbstractArray) =
    map(x -> polyval_descending(coeffs, x), xs)

end # module PolyUtils
