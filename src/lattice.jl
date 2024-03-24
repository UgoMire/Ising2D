struct LatticeConfiguration
    L::Int32 # Lattice size in each direction.
    N::Int32 # Total number of site: L * L.
    spinstate::Array{Float64,2} # Current spin configuration on the lattice.

    function LatticeConfiguration(L)
        new(L, L^2, rand([-1, 1], L, L))
    end

    function LatticeConfiguration(L, M)
        if M != 1 && M != -1
            throw(ArgumentError("Magnetisation must be +1 or -1."))
        end

        new(L, L^2, M * ones(L, L))
    end
end

function average(lc::LatticeConfiguration, quantity)
    sum = 0

    for I in CartesianIndices(lc.spinstate)
        sum += quantity(lc, I)
    end

    return sum / lc.N
end

magnetisation(lc::LatticeConfiguration, I) = lc.spinstate[I]
