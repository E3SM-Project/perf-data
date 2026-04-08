import matplotlib.pyplot as plt

def plot_data(plot_data, plot_type, plot_title):
    fig, ax = plt.subplots(figsize=(12, 9))

    linestyles = ['-', ':', '-.', '--']
    markers = ['o', 'v', 'x', 'd', '*', 'p', 'h', '^'] #['s','o', 'v', 'x', 'd', '*', 'p', 'h', '^']
    colors = ['g', 'r', 'purple', 'b', 'c', 'y', 'k']

    plot_optimal_scaling = True
    optimal_scaling_start = 35

    plot_1_sypd_line = False

    xmin = 350
    xmax = 9000

    #ymin = 20
    #ymax = 400
    #yticks = [20,30,40,50,60,70,80,90,100,125,150,200,250,300,365]

    ymin = 50
    ymax = 37000
    yticks = []


    auto_x_axis = True
    auto_y_axis = False

    timer_legend_font_size = 15
    timer_legend_loc = 'lower right'
    machine_legend_font_size = 15
    machine_legend_loc = 'upper left'

    title_fontsize=20
    markersize_ = 10
    linewidth_ = 3
    ax_label_size = 18
    tick_font_size = 17

    # Ideally, nothing below here is changed by user...

    num_timers = len(plot_data[0]["timer_data"])
    num_machines = len(plot_data)
    timer_legend = []
    machine_legend = []

    linestyle_idx=0
    color_idx=0
    for entry in plot_data:
        if num_timers!=1: color_idx=0

        # Dummy lines for machine legend
        args = {
            'label': entry['label'],
            'linestyle': linestyles[linestyle_idx],
            'color': 'k',
        }
        if num_timers == 1:
            args["color"] = colors[color_idx]
            args["marker"] = markers[color_idx]
            args["markersize"] = markersize_
            args["markerfacecolor"] = 'none'

        machine_line, = ax.plot([],[], **args)
        machine_legend.append(machine_line)

        # Plot data
        for timer in entry["timer_data"]:
            data = entry["timer_data"][timer]
            sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
            sorted_nodes = [data["nodes"][i] for i in sorted_indices]
            sorted_values = [data["values"][i] for i in sorted_indices]

            args = {
                'label': timer,
                'linestyle': linestyles[linestyle_idx],
                'linewidth': linewidth_,
                'color': colors[color_idx],
                'marker': markers[color_idx],
                'markersize': markersize_,
                'markerfacecolor': 'none',
            }
            plot_line, = ax.plot(sorted_nodes, sorted_values, **args)

            # On the first run, or if only one machine exists, add to timer legend
            if linestyle_idx==0 or num_machines == 1:
                timer_legend.append(plot_line)

            color_idx += 1
            #if num_machines == 1: linestyle_idx += 1
        linestyle_idx += 1

    if num_timers != 1:
        legend1 = ax.legend(handles=timer_legend, loc=timer_legend_loc, fontsize=timer_legend_font_size, framealpha=1)
        ax.add_artist(legend1)
    if num_machines != 1:
        ax.legend(handles=machine_legend, loc=machine_legend_loc, fontsize=machine_legend_font_size, framealpha=1)

    unique_nodes = sorted(set([int(node) for entry in plot_data for timer in entry["timer_data"] for node in entry["timer_data"][timer]["nodes"]]))
    unique_labels = [str(node) for node in unique_nodes]

    nodes_for_plotting = []
    nodes_for_plotting.append(unique_nodes[0]/2)
    while nodes_for_plotting[-1] <= unique_nodes[-1]:
        new_node = 2*nodes_for_plotting[-1]
        nodes_for_plotting.append(new_node)

    # Plot optimal scaling line
    if plot_optimal_scaling:
        if plot_type=="sypd" or plot_type=="sdpd":
            opt_vals = [optimal_scaling_start * (2 ** i) for i in range(len(nodes_for_plotting))]  # Double for each subsequent node
        elif plot_type=="time":
            opt_vals = [optimal_scaling_start / (2 ** i) for i in range(len(nodes_for_plotting))]  # Halve for each subsequent node
        ax.plot(nodes_for_plotting, opt_vals, linewidth=1,linestyle='-', color='black')

    # Plot 1 SYPD
    if plot_1_sypd_line:
        sypd_equiv = 1 if plot_type=="sypd" else 365 if plot_type=="sdpd" else 0
        ax.plot([nodes_for_plotting[0], nodes_for_plotting[-1]], [sypd_equiv]*2, color='y', linewidth=2)

    # Grid and axis options
    ax.grid(True, which="both", linestyle="--", linewidth=0.5)

    ax.set_xscale("log")
    ax.set_xlabel("Number of nodes", fontsize=ax_label_size)

    ax.set_xticks(unique_nodes)
    ax.set_xticklabels(unique_labels, fontsize=tick_font_size)
    ax.xaxis.minorticks_off()
    if not auto_x_axis:
        ax.set_xlim(xmin, xmax)
    else:
        ax.set_xlim(unique_nodes[0]*7/8,unique_nodes[-1]*9/8)

    ax.set_yscale("log")
    if plot_type=="time":
        y_label = "Elapsed time (s)"
    elif plot_type == "sypd":
        y_label = "Simulated years per wallclock day (SYPD)"
    elif plot_type == "sdpd":
        y_label = "Simulated days per wallclock day (SDPD)"
    ax.set_ylabel(y_label, fontsize=ax_label_size)

    if not auto_y_axis:
        ax.set_ylim(ymin,ymax)
        if len(yticks)>0:
            ax.set_yticks(yticks)
            ax.set_yticklabels(yticks, fontsize=tick_font_size)

    # Create title
    additional_title = ""
    if num_machines==1 and num_timers==1:
        timer_name = list(plot_data[0]["timer_data"].keys())[0]
        machine_name =  plot_data[0]["label"]
        additional_title = f"{timer_name} on {machine_name}"
    elif num_timers==1:
        timer_name = list(plot_data[0]["timer_data"].keys())[0]
        additional_title = timer_name
    elif num_machines==1:
        machine_name =  plot_data[0]["label"]
        additional_title = machine_name

    title = ""
    if plot_title == "" and additional_title != "":
        title = additional_title
    elif plot_title != "" and additional_title == "":
        title = plot_title
    elif plot_title != "" and additional_title != "":
        title = f"{plot_title}: {additional_title}"
    plt.title(title,fontsize=title_fontsize)


    plt.show()