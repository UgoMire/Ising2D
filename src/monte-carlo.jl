function switchspin!(ltc, I)
    ltc.spinstate[I] = -ltc.spinstate[I]
end

function switch_random_spin(ltc)
    Irand = CartesianIndex(rand(1:ltc.L), rand(1:ltc.L))

    energybefore = energy(ltc, Irand)
    for Innb in get_nearest_neightboors_index(ltc, Irand)
        energybefore += energy(ltc, Innb)
    end

    switchspin!(ltc, Irand)

    energyafter = energy(ltc, Irand)
    for Innb in get_nearest_neightboors_index(ltc, Irand)
        energyafter += energy(ltc, Innb)
    end

    switchspin!(ltc, Irand)

    dE = energyafter - energybefore

    return (; I = Irand, dE)
end

function montecarlo_step!(ltc, Nstep)
    for _ = 1:Nstep
        (; I, dE) = switch_random_spin(ltc)

        if dE < 0 || rand() < exp(-dE / ltc.T)
            switchspin!(ltc, I)
        end
    end
end

function generate_configuration(ltc; Nmcstep = 20, Nconfig = 1000)
    configs = zeros(ltc.L, ltc.L, Nconfig)

    for i = 1:Nconfig
        montecarlo_step!(ltc, Nmcstep)
        configs[:, :, i] .= ltc.spinstate
    end

    return configs
end