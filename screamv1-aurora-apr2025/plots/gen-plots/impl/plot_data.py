import matplotlib.pyplot as plt

def plot_data(aurora_timer_data, aurora_timer_data2, frontier_timer_data, pm_gpu_timer_data, pm_cpu_timer_data, plot_type, timing_col, no_title):
    fig, ax = plt.subplots(figsize=(12, 9))

    aurora_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in aurora_timer_data.values())
    aurora2_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in aurora_timer_data2.values())
    frontier_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in frontier_timer_data.values())
    pm_gpu_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in pm_gpu_timer_data.values())
    pm_cpu_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in pm_cpu_timer_data.values())

    #markers = ['o', 'v', 's', 'd', 'x', '*', 'p', 'h', '^']
    #colors = ['r','g','b', 'm', 'y', 'c']
    #colors = ['k', 'r', 'g','b', 'm', 'y', 'c'] # FULL MODEL

    # DYCORE ONLY
    colors = ['g', 'r', 'purple', 'b', 'c', 'y', 'k']
    markers = ['s','o', 'v', 'x', 'd', '*', 'p', 'h', '^']
    markersize_ = 10
    linewidth_ = 3
    ax_label_size = 18
    tick_font_size = 17


    timer_to_label_dict = {
        "CPL:RUN_LOOP": "Model",
        "CPL:ATM_RUN": "Atmosphere",
        "a:EAMxx::homme::run": "Dycore",
        "a:EAMxx::physics::run": "Physics"
    }
    idx=0
    for timer, data in aurora_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='--',marker=markers[idx], markersize=markersize_, markerfacecolor='none', color=colors[idx])
        if(not aurora_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in aurora_timer_data2.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        ax.plot(sorted_nodes, sorted_values, linewidth=2,linestyle='--')
        #ax.plot(sorted_nodes, sorted_values, linewidth=2,linestyle=':',marker=markers[idx], markersize=markersize_, markerfacecolor='none', color=colors[idx])
        if(not aurora2_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in frontier_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        #ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='--')
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='--',marker=markers[idx+1], markersize=markersize_, markerfacecolor='none', color=colors[idx+1], label=timer_to_label_dict.get(timer, timer))
        if(not frontier_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in pm_gpu_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        if len(sorted_values) > 0:
            sorted_values[-2] *=2# HACK because sim is 2x length here
            sorted_values[-1] *=2 # HACK because sim is 2x length here
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='--',marker=markers[idx+2], markersize=markersize_, markerfacecolor='none', color=colors[idx+2])
        if(not pm_gpu_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in pm_cpu_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='--',marker=markers[idx+3], markersize=markersize_, markerfacecolor='none', color=colors[idx+3])
        if(not pm_cpu_is_empty): idx+=1

    # Get a legend without aurora/frontier/pm lines
    first_legend = ax.legend(loc='lower left', fontsize=9)#fontsize=15)

    # Dummy lines for machine
    machine_lines = []
    idx=0
    if not aurora_is_empty:
        aurora_line, = ax.plot([],[],linestyle='--',color=colors[0],marker=markers[0],label='Aurora [Intel]', markerfacecolor='none')
        machine_lines.append(aurora_line)
        #idx+=1
    if not aurora2_is_empty:
        aurora_line2, = ax.plot([],[],linestyle='--',color=colors[-1],label='Aurora2',markerfacecolor='none')
        machine_lines.append(aurora_line2)
        #idx+=1
    if not frontier_is_empty:
        frontier_line, = ax.plot([],[],linestyle='--',color=colors[1],marker=markers[1],label='Frontier [AMD]',markerfacecolor='none')
        machine_lines.append(frontier_line)
        #idx+=1
    if not pm_gpu_is_empty:
        pm_gpu_line, = ax.plot([],[],linestyle='--',color=colors[2],marker=markers[2],label='Perlmutter-GPU [NVIDIA]',markerfacecolor='none')
        machine_lines.append(pm_gpu_line)
        #idx+=1
    if not pm_cpu_is_empty:
        pm_cpu_line, = ax.plot([],[],linestyle='--',color=colors[3],marker=markers[3],label='Perlmutter-CPU [AMD]',markerfacecolor='none')
        machine_lines.append(pm_cpu_line)

    unique_nodes = sorted(set([int(node) for timer_data in [aurora_timer_data, aurora_timer_data2, frontier_timer_data, pm_gpu_timer_data, pm_cpu_timer_data] for timer in timer_data.values() for node in timer["nodes"]]))

    # Calculate "optimal scaling" line
    if not aurora_is_empty:
        first_values = [data["values"][0] for data in aurora_timer_data.values()]  # First data point for each timer
    if not aurora2_is_empty:
        first_values = [data["values"][0] for data in aurora_timer_data2.values()]  # First data point for each timer
    elif not frontier_is_empty:
        first_values = [data["values"][0] for data in frontier_timer_data.values()]  # First data point for each timer
    elif not pm_gpu_is_empty:
        first_values = [data["values"][0] for data in pm_gpu_timer_data.values()]  # First data point for each timer

    optimal_start = 35 #FULL MODEL
    opt_nodes = sorted(set([int(node) for timer_data in [aurora_timer_data, aurora_timer_data2, frontier_timer_data] for timer in timer_data.values() for node in timer["nodes"]]))
    first = opt_nodes[0]
    last = opt_nodes[-1]
    opt_nodes.insert(0, first/2)
    opt_nodes.append(last*2)
    if plot_type=="sypd" or plot_type=="sdpd":
        optimal_values = [optimal_start * (2 ** i) for i in range(len(opt_nodes))]  # Double for each subsequent node

    else:
        optimal_values = [optimal_start / (2 ** i) for i in range(len(opt_nodes))]  # Halve for each subsequent node

    # Plot "optimal scaling" line
    ax.plot(opt_nodes, optimal_values, linewidth=1,linestyle='-', color='black')

    # Plot at 1 SYPD
    nodes=[100,10000]
    sypd_365=[365,365]
    ax.plot(nodes, sypd_365, color='y', linewidth=2)

    ax.set_xscale("log")
    if True or plot_type=="sypd" or plot_type=="time": ax.set_yscale("log")
    x_label = "Number of nodes"
    ax.set_xlabel(x_label, fontsize=ax_label_size)
    if plot_type=="time":
        y_label = "Elapsed time (s)"
    elif plot_type == "sypd":
        y_label = "Simulated years per wallclock day (SYPD)"
    elif plot_type == "sdpd":
        y_label = "Simulated days per wallclock day (SDPD)"
    ax.set_ylabel(y_label, fontsize=ax_label_size)

    # FULL MODEL OUTPUT
    #yticks = [20,30,40,50,60,70,80,90,100,125,150,175,200,250,300, 350,400,500,600,700]
    yticks = [30,40,50,60,70,80,90,100,125,150,200,250,300,365,400,450,500,575]
    #yticks = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,1,2]

    # ax.set_ylim(min(yticks)-0.02, max(yticks))
    ax.set_yticks(yticks)
    ax.set_yticklabels(yticks, fontsize=tick_font_size)
    ax.set_xlim(350,9000)

    # FULL MODEL OUTPUT
    #ax.set_xlim(480,2200)

    ax.set_ylim(20,600)

    # ax.set_xlim(500, 2100)
    #ax.set_ylim(0.05, 2)

    # EFFICIENCY
    #ax.set_ylim(.35, 45)

    # Add legend with aurora frontier pm lines, and add first legend back
    ax.legend(handles=machine_lines, loc='lower right', fontsize=15)#fontsize=15)
    #ax.add_artist(first_legend)

    ax.grid(True, which="both", linestyle="--", linewidth=0.5)

    # if not no_title:
    #     if not aurora_is_empty and not frontier_is_empty:
    #         ax.set_title("Aurora and Frontier Scalaing ("+timing_col+")")
    #     elif not aurora_is_empty:
    #         ax.set_title("Aurora Scalaing ("+timing_col+")")
    #     else:
    #         ax.set_title("Frontier Scalaing ("+timing_col+")")
    ax.set_title("Atmosphere", fontsize=20)

    unique_labels = [str(node) for node in unique_nodes]
    ax.set_xticks(unique_nodes)
    ax.set_xticklabels(unique_labels, fontsize=tick_font_size)
    ax.xaxis.minorticks_off()

    plt.show()