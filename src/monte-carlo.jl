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