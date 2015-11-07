vlog bellmanford.v
vlog bellmanfordtest3.v

radix hex
add wave {sim:/bellmanfordtest3/BellmanFord/clock}
add wave {sim:/bellmanfordtest3/BellmanFord/reset}
add wave {sim:/bellmanfordtest3/BellmanFord/current_state}
add wave {sim:/bellmanfordtest3/BellmanFord/next_state}
add wave {sim:/bellmanfordtest3/BellmanFord/NodeCounter}
add wave {sim:/bellmanfordtest3/BellmanFord/NumLinks}
add wave {sim:/bellmanfordtest3/BellmanFord/LinkCounter}
add wave {sim:/bellmanfordtest3/BellmanFord/FirstLine}
add wave {sim:/bellmanfordtest3/BellmanFord/MultiLine}
add wave {sim:/bellmanfordtest3/BellmanFord/Sub}
add wave {sim:/bellmanfordtest3/BellmanFord/GMAR1}
add wave {sim:/bellmanfordtest3/BellmanFord/GMDR1_reg}
add wave {sim:/bellmanfordtest3/BellmanFord/GMAR2}
add wave {sim:/bellmanfordtest3/BellmanFord/GMDR2_reg}
add wave {sim:/bellmanfordtest3/BellmanFord/WMAR1}
add wave {sim:/bellmanfordtest3/BellmanFord/WMDR1_reg}
add wave {sim:/bellmanfordtest3/BellmanFord/WMAR2}
add wave {sim:/bellmanfordtest3/BellmanFord/WMDR2_reg}
add wave {sim:/bellmanfordtest3/BellmanFord/WMWDR}
add wave {sim:/bellmanfordtest3/BellmanFord/WMWE}
add wave {sim:/bellmanfordtest3/BellmanFord/Ureg}
add wave {sim:/bellmanfordtest3/BellmanFord/NewWeight}
add wave {sim:/bellmanfordtest3/BellmanFord/NegativeCycleCheck}
add wave {sim:/bellmanfordtest3/BellmanFord/WMDR2_reg[127:119]}
add wave {sim:/bellmanfordtest3/BellmanFord/WMWDR[127:119]}
add wave {sim:/bellmanfordtest3/BellmanFord/WMWAR}
add wave {sim:/bellmanfordtest3/BellmanFord/Vreg[1]}
add wave {sim:/bellmanfordtest3/BellmanFord/Wreg[1]}
add wave {sim:/bellmanfordtest3/BellmanFord/Vreg[2]}
add wave {sim:/bellmanfordtest3/BellmanFord/Wreg[2]}
add wave {sim:/bellmanfordtest3/BellmanFord/Vreg[3]}
add wave {sim:/bellmanfordtest3/BellmanFord/Wreg[3]}
add wave {sim:/bellmanfordtest3/BellmanFord/Vreg[4]}
add wave {sim:/bellmanfordtest3/BellmanFord/Wreg[4]}
add wave {sim:/bellmanfordtest3/BellmanFord/Vreg[5]}
add wave {sim:/bellmanfordtest3/BellmanFord/Wreg[5]}
add wave {sim:/bellmanfordtest3/BellmanFord/Vreg[6]}
add wave {sim:/bellmanfordtest3/BellmanFord/Wreg[6]}
add wave {sim:/bellmanfordtest3/BellmanFord/Vreg[7]}
add wave {sim:/bellmanfordtest3/BellmanFord/Wreg[7]}
add wave {sim:/bellmanfordtest3/BellmanFord/OMWDR}
add wave {sim:/bellmanfordtest3/BellmanFord/OMWAR}
add wave {sim:/bellmanfordtest3/BellmanFord/OMWE}
add wave {sim:/bellmanfordtest3/BellmanFord/IMDR_reg}
add wave {sim:/bellmanfordtest3/BellmanFord/IMAR}

run -all
