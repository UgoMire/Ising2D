struct Lattice
    L::Int32 # Lattice size in each direction.
    N::Int32 # Total number of site: L * L.

    J::Float64 # Nearest neightboor coupling.
    H::Float64 # External magnetic field.
    T::Float64 # Temperature.

    spinstate::Array{Float64,2} # Current spin configuration on the lattice.

    function Lattice(L, J, H, T; M = nothing)
        if isnothing(M)
            new(L, L^2, J, H, T, rand([-1, 1], L, L))
        elseif M == 1 || M == -1
            new(L, L^2, J, H, T, M * ones(L, L))
        else
            throw(ArgumentError("Magnetisation must be +1 or -1."))
        end
    end
end

function average(lc::Lattice, quantity)
    sum = 0

    for I in CartesianIndices(lc.spinstate)
        sum += quantity(lc, I)
    end

    return sum / lc.N
end

magnetisation(lc::Lattice, index) = lc.spinstate[index]

function get_nearest_neightboors_index(ltc::Lattice, index)
    (; L) = ltc
    i, j = Tuple(index)

    ip = i == L ? 1 : i + 1
    im = i == 1 ? L : i - 1
    jp = j == L ? 1 : j + 1
    jm = j == 1 ? L : j - 1

    return [
        CartesianIndex(im, j),
        CartesianIndex(ip, j),
        CartesianIndex(i, jp),
        CartesianIndex(i, jm),
    ]
end

function energy(ltc::Lattice, index)
    (; H, J, spinstate) = ltc

    energy = -H * spinstate[index]

    for Innb in get_nearest_neightboors_index(ltc, index)
        energy += -J * spinstate[index] * spinstate[Innb]
    end

    return energy
end