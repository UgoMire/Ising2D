using Ising2D
using Test

@testset "Magnetisation of Random Configuration Vanishes" begin
    L = 100
    lc = LatticeConfiguration(L)

    @test average(lc, magnetisation) ≈ 0 atol = 0.1
end

@testset "Magnetisation of Uniform Configuration is 1 or -1" begin
    L = 100

    lc = LatticeConfiguration(L, -1)
    @test average(lc, magnetisation) == -1

    lc = LatticeConfiguration(L, 1)
    @test average(lc, magnetisation) == 1
end