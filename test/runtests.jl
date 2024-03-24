using Ising2D
using Test

@testset "Magnetisation and energy of a random configuration vanishes" begin
    L = 100
    lc = Lattice(L, 1, 1, 1)

    @test average(lc, magnetisation) ≈ 0 atol = 0.1
    @test average(lc, energy) ≈ 0 atol = 0.1
end

@testset "Magnetisation of a uniform configuration is 1 or -1" begin
    L = 100

    lc = Lattice(L, 1, 1, 1; M = -1)
    @test average(lc, magnetisation) == -1

    lc = Lattice(L, 1, 1, 1; M = 1)
    @test average(lc, magnetisation) == 1
end

@testset "Energy of a uniform configuration" begin
    L = 100
    J = 2
    H = 0
    T = 1

    lc = Lattice(L, J, H, T; M = 1)

    # Energy at a given site is -4J.
    @test energy(lc, CartesianIndex(1, 1)) == -4 * J
    @test energy(lc, CartesianIndex(lc.L, 1)) == -4 * J
    @test energy(lc, CartesianIndex(1, lc.L)) == -4 * J
    @test energy(lc, CartesianIndex(lc.L, lc.L)) == -4 * J
    @test energy(lc, CartesianIndex(45, 89)) == -4 * J

    # Average energy is -4J.
    @test average(lc, energy) == -4 * J
end

@testset "Spin-switch change the energy by 2 * 2 * 4 * J for a uniform configuration" begin
    L = 100
    J = 2
    H = 0
    T = 1

    ltc = Lattice(L, J, H, T; M = 1)

    (; dE) = switch_random_spin(ltc)
    @test dE == 2 * 2 * 4J
end

@testset "Spin-switch energy change agree with average energy change" begin
    L = 100
    J = 2
    H = 0
    T = 1

    for ltc in [Lattice(L, J, H, T; M = 1), Lattice(L, J, H, T)]
        (; I, dE) = switch_random_spin(ltc)

        average_energy_before = average(ltc, energy)
        switchspin!(ltc, I)
        average_energy_after = average(ltc, energy)

        # The average energy should change by dE.
        @test average_energy_after - average_energy_before ≈ dE / ltc.N atol = 0.01
    end
end