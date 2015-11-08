vlog bellmanford.v
vlog bellmanfordtest7.v

#radix hex
#add wave {sim:/bellmanfordtest7/BellmanFord/clock}
#add wave {sim:/bellmanfordtest7/BellmanFord/reset}
#add wave {sim:/bellmanfordtest7/BellmanFord/current_state}
#add wave {sim:/bellmanfordtest7/BellmanFord/next_state}
#add wave {sim:/bellmanfordtest7/BellmanFord/NodeCounter}
#add wave {sim:/bellmanfordtest7/BellmanFord/NumLinks}
#add wave {sim:/bellmanfordtest7/BellmanFord/LinkCounter}
#add wave {sim:/bellmanfordtest7/BellmanFord/FirstLine}
#add wave {sim:/bellmanfordtest7/BellmanFord/MultiLine}
#add wave {sim:/bellmanfordtest7/BellmanFord/Sub}
#add wave {sim:/bellmanfordtest7/BellmanFord/GMAR1}
#add wave {sim:/bellmanfordtest7/BellmanFord/GMDR1_reg}
#add wave {sim:/bellmanfordtest7/BellmanFord/GMAR2}
#add wave {sim:/bellmanfordtest7/BellmanFord/GMDR2_reg}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMAR1}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMDR1_reg}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMAR2}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMDR2_reg}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMWDR}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMWE}
#add wave {sim:/bellmanfordtest7/BellmanFord/Ureg}
#add wave {sim:/bellmanfordtest7/BellmanFord/NewWeight}
#add wave {sim:/bellmanfordtest7/BellmanFord/NegativeCycleCheck}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMDR2_reg[127:119]}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMWDR[127:119]}
#add wave {sim:/bellmanfordtest7/BellmanFord/WMWAR}
#add wave {sim:/bellmanfordtest7/BellmanFord/Vreg[1]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Wreg[1]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Vreg[2]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Wreg[2]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Vreg[3]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Wreg[3]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Vreg[7]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Wreg[7]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Vreg[7]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Wreg[7]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Vreg[6]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Wreg[6]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Vreg[7]}
#add wave {sim:/bellmanfordtest7/BellmanFord/Wreg[7]}
#add wave {sim:/bellmanfordtest7/BellmanFord/OMWDR}
#add wave {sim:/bellmanfordtest7/BellmanFord/OMWAR}
#add wave {sim:/bellmanfordtest7/BellmanFord/OMWE}
#add wave {sim:/bellmanfordtest7/BellmanFord/IMDR_reg}
#add wave {sim:/bellmanfordtest7/BellmanFord/IMAR}

run -all
