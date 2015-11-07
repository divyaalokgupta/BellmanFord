vlog bellmanford.v
vlog bellmanfordtest1.v

radix hex
add wave {sim:/bellmanfordtest1/BellmanFord/clock}
add wave {sim:/bellmanfordtest1/BellmanFord/reset}
add wave {sim:/bellmanfordtest1/BellmanFord/current_state}
add wave {sim:/bellmanfordtest1/BellmanFord/next_state}
add wave {sim:/bellmanfordtest1/BellmanFord/NodeCounter}
add wave {sim:/bellmanfordtest1/BellmanFord/NumLinks}
add wave {sim:/bellmanfordtest1/BellmanFord/LinkCounter}
add wave {sim:/bellmanfordtest1/BellmanFord/FirstLine}
add wave {sim:/bellmanfordtest1/BellmanFord/MultiLine}
add wave {sim:/bellmanfordtest1/BellmanFord/Sub}
add wave {sim:/bellmanfordtest1/BellmanFord/GMAR1}
add wave {sim:/bellmanfordtest1/BellmanFord/GMDR1_reg}
add wave {sim:/bellmanfordtest1/BellmanFord/GMAR2}
add wave {sim:/bellmanfordtest1/BellmanFord/GMDR2_reg}
add wave {sim:/bellmanfordtest1/BellmanFord/WMAR1}
add wave {sim:/bellmanfordtest1/BellmanFord/WMDR1_reg}
add wave {sim:/bellmanfordtest1/BellmanFord/WMAR2}
add wave {sim:/bellmanfordtest1/BellmanFord/WMDR2_reg}
add wave {sim:/bellmanfordtest1/BellmanFord/WMWDR}
add wave {sim:/bellmanfordtest1/BellmanFord/WMWE}
add wave {sim:/bellmanfordtest1/BellmanFord/Ureg}
add wave {sim:/bellmanfordtest1/BellmanFord/NewWeight}
add wave {sim:/bellmanfordtest1/BellmanFord/NegativeCycleCheck}
add wave {sim:/bellmanfordtest1/BellmanFord/WMDR2_reg[127:119]}
add wave {sim:/bellmanfordtest1/BellmanFord/WMWDR[127:119]}
add wave {sim:/bellmanfordtest1/BellmanFord/WMWAR}
add wave {sim:/bellmanfordtest1/BellmanFord/Vreg[1]}
add wave {sim:/bellmanfordtest1/BellmanFord/Wreg[1]}
add wave {sim:/bellmanfordtest1/BellmanFord/Vreg[2]}
add wave {sim:/bellmanfordtest1/BellmanFord/Wreg[2]}
add wave {sim:/bellmanfordtest1/BellmanFord/Vreg[3]}
add wave {sim:/bellmanfordtest1/BellmanFord/Wreg[3]}
add wave {sim:/bellmanfordtest1/BellmanFord/Vreg[4]}
add wave {sim:/bellmanfordtest1/BellmanFord/Wreg[4]}
add wave {sim:/bellmanfordtest1/BellmanFord/Vreg[5]}
add wave {sim:/bellmanfordtest1/BellmanFord/Wreg[5]}
add wave {sim:/bellmanfordtest1/BellmanFord/Vreg[6]}
add wave {sim:/bellmanfordtest1/BellmanFord/Wreg[6]}
add wave {sim:/bellmanfordtest1/BellmanFord/Vreg[7]}
add wave {sim:/bellmanfordtest1/BellmanFord/Wreg[7]}
add wave {sim:/bellmanfordtest1/BellmanFord/OMWDR}
add wave {sim:/bellmanfordtest1/BellmanFord/OMWAR}
add wave {sim:/bellmanfordtest1/BellmanFord/OMWE}
add wave {sim:/bellmanfordtest1/BellmanFord/IMDR_reg}
add wave {sim:/bellmanfordtest1/BellmanFord/IMAR}

run -all
