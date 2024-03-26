using Ising2D

ltc = Lattice(100, 10, -0.1, 1)

configs = generate_configuration(ltc; Nmcstep = 200, Nconfig = 1000)
