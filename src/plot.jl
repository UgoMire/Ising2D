function plot_configs(configs)
    fig = Figure()

    ax = Axis(fig[1, 1])

    sg = SliderGrid(fig[2, 1], (label = "step", range = 1:size(configs, 3), startvalue = 1))
    ilift = sg.sliders[1].value

    heatmap!(ax, (@lift configs[:, :, $ilift]))

    return fig
end