vlog bellmanford.v
vlog bellmanfordtest8.v

radix hex
add wave {sim:/bellmanfordtest8/BellmanFord/clock}
add wave {sim:/bellmanfordtest8/BellmanFord/reset}
add wave {sim:/bellmanfordtest8/BellmanFord/current_state}
add wave {sim:/bellmanfordtest8/BellmanFord/next_state}
add wave {sim:/bellmanfordtest8/BellmanFord/NodeCounter}
add wave {sim:/bellmanfordtest8/BellmanFord/NumLinks}
add wave {sim:/bellmanfordtest8/BellmanFord/LinkCounter}
add wave {sim:/bellmanfordtest8/BellmanFord/FirstLine}
add wave {sim:/bellmanfordtest8/BellmanFord/MultiLine}
add wave {sim:/bellmanfordtest8/BellmanFord/Sub}
add wave {sim:/bellmanfordtest8/BellmanFord/GMAR1}
add wave {sim:/bellmanfordtest8/BellmanFord/GMDR1_reg}
add wave {sim:/bellmanfordtest8/BellmanFord/GMAR2}
add wave {sim:/bellmanfordtest8/BellmanFord/GMDR2_reg}
add wave {sim:/bellmanfordtest8/BellmanFord/WMAR1}
add wave {sim:/bellmanfordtest8/BellmanFord/WMDR1_reg}
add wave {sim:/bellmanfordtest8/BellmanFord/WMAR2}
add wave {sim:/bellmanfordtest8/BellmanFord/WMDR2_reg}
add wave {sim:/bellmanfordtest8/BellmanFord/WMWDR}
add wave {sim:/bellmanfordtest8/BellmanFord/WMWE}
add wave {sim:/bellmanfordtest8/BellmanFord/Ureg}
add wave {sim:/bellmanfordtest8/BellmanFord/NewWeight}
add wave {sim:/bellmanfordtest8/BellmanFord/NegativeCycleCheck}
add wave {sim:/bellmanfordtest8/BellmanFord/WMDR2_reg[127:119]}
add wave {sim:/bellmanfordtest8/BellmanFord/WMWDR[127:119]}
add wave {sim:/bellmanfordtest8/BellmanFord/WMWAR}
add wave {sim:/bellmanfordtest8/BellmanFord/Vreg[1]}
add wave {sim:/bellmanfordtest8/BellmanFord/Wreg[1]}
add wave {sim:/bellmanfordtest8/BellmanFord/Vreg[2]}
add wave {sim:/bellmanfordtest8/BellmanFord/Wreg[2]}
add wave {sim:/bellmanfordtest8/BellmanFord/Vreg[3]}
add wave {sim:/bellmanfordtest8/BellmanFord/Wreg[3]}
add wave {sim:/bellmanfordtest8/BellmanFord/Vreg[7]}
add wave {sim:/bellmanfordtest8/BellmanFord/Wreg[7]}
add wave {sim:/bellmanfordtest8/BellmanFord/Vreg[7]}
add wave {sim:/bellmanfordtest8/BellmanFord/Wreg[7]}
add wave {sim:/bellmanfordtest8/BellmanFord/Vreg[6]}
add wave {sim:/bellmanfordtest8/BellmanFord/Wreg[6]}
add wave {sim:/bellmanfordtest8/BellmanFord/Vreg[7]}
add wave {sim:/bellmanfordtest8/BellmanFord/Wreg[7]}
add wave {sim:/bellmanfordtest8/BellmanFord/OMWDR}
add wave {sim:/bellmanfordtest8/BellmanFord/OMWAR}
add wave {sim:/bellmanfordtest8/BellmanFord/OMWE}
add wave {sim:/bellmanfordtest8/BellmanFord/IMDR_reg}
add wave {sim:/bellmanfordtest8/BellmanFord/IMAR}

run -all
