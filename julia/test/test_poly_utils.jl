using Test

include(joinpath(@__DIR__, "..", "src", "poly_utils.jl"))
using .PolyUtils

function read_coeffs(path::AbstractString)
    content = strip(read(path, String))
    values = split(content, ',')
    return parse.(Float64, values)
end

function read_samples_results(path::AbstractString)
    lines = readlines(path)
    samples = Float64[]
    results = Float64[]
    for line in lines[2:end]
        vals = split(line, ',')
        push!(samples, parse(Float64, vals[1]))
        push!(results, parse(Float64, vals[2]))
    end
    return samples, results
end

@testset "polyval_descending matches Python baseline" begin
    coeffs_path = joinpath(@__DIR__, "..", "artifacts", "python_baseline", "polyval_cp_coeffs.txt")
    samples_path = joinpath(@__DIR__, "..", "artifacts", "python_baseline", "polyval_cp_samples_results.csv")

    coeffs = read_coeffs(coeffs_path)
    samples, expected = read_samples_results(samples_path)

    actual = PolyUtils.polyval_descending(coeffs, samples)
    @test length(actual) == length(expected)
    diff = abs.(actual .- expected)
    @test maximum(diff) <= 1e-10
    @test mean(diff) <= 1e-12
end
