function plot_configuration(lt::Lattice)
    fig = Figure()

    ax = Axis(fig[1, 1])

    heatmap!(ax, lt.spinstate)

    return fig
end