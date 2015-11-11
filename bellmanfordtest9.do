vlog bellmanford.v
vlog bellmanfordtest9.v

radix hex
add wave {sim:/bellmanfordtest9/BellmanFord/clock}
add wave {sim:/bellmanfordtest9/BellmanFord/reset}
add wave {sim:/bellmanfordtest9/BellmanFord/current_state}
#add wave {sim:/bellmanfordtest9/BellmanFord/next_state}
#add wave {sim:/bellmanfordtest9/BellmanFord/NodeCounter}
#add wave {sim:/bellmanfordtest9/BellmanFord/NumLinks}
#add wave {sim:/bellmanfordtest9/BellmanFord/LinkCounter}
#add wave {sim:/bellmanfordtest9/BellmanFord/FirstLine}
#add wave {sim:/bellmanfordtest9/BellmanFord/MultiLine}
#add wave {sim:/bellmanfordtest9/BellmanFord/Sub}
#add wave {sim:/bellmanfordtest9/BellmanFord/GMAR1}
#add wave {sim:/bellmanfordtest9/BellmanFord/GMDR1_reg}
#add wave {sim:/bellmanfordtest9/BellmanFord/GMAR2}
#add wave {sim:/bellmanfordtest9/BellmanFord/GMDR2_reg}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMAR1}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMDR1_reg}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMAR2}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMDR2_reg}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMWDR}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMWE}
#add wave {sim:/bellmanfordtest9/BellmanFord/Ureg}
#add wave {sim:/bellmanfordtest9/BellmanFord/NewWeight}
#add wave {sim:/bellmanfordtest9/BellmanFord/NegativeCycleCheck}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMDR2_reg[127:119]}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMWDR[127:119]}
#add wave {sim:/bellmanfordtest9/BellmanFord/WMWAR}
#add wave {sim:/bellmanfordtest9/BellmanFord/Vreg[1]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Wreg[1]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Vreg[2]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Wreg[2]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Vreg[3]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Wreg[3]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Vreg[7]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Wreg[7]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Vreg[7]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Wreg[7]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Vreg[6]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Wreg[6]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Vreg[7]}
#add wave {sim:/bellmanfordtest9/BellmanFord/Wreg[7]}
add wave {sim:/bellmanfordtest9/BellmanFord/OMWDR}
add wave {sim:/bellmanfordtest9/BellmanFord/OMWAR}
add wave {sim:/bellmanfordtest9/BellmanFord/OMWE}
#add wave {sim:/bellmanfordtest9/BellmanFord/IMDR_reg}
#add wave {sim:/bellmanfordtest9/BellmanFord/IMAR}

run -all
