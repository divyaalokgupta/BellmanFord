add wave {sim:/bellmanfordtest/BellmanFord/clock}
add wave {sim:/bellmanfordtest/BellmanFord/reset}
add wave {sim:/bellmanfordtest/BellmanFord/current_state}
add wave {sim:/bellmanfordtest/BellmanFord/next_state}
add wave {sim:/bellmanfordtest/BellmanFord/GMAR1}
add wave {sim:/bellmanfordtest/BellmanFord/GMDR1}
add wave {sim:/bellmanfordtest/BellmanFord/GMAR2}
add wave {sim:/bellmanfordtest/BellmanFord/GMDR2}
add wave {sim:/bellmanfordtest/BellmanFord/WMAR1}
add wave {sim:/bellmanfordtest/BellmanFord/WMDR1}
add wave {sim:/bellmanfordtest/BellmanFord/WMAR2}
add wave {sim:/bellmanfordtest/BellmanFord/WMDR2}
add wave {sim:/bellmanfordtest/BellmanFord/WMWAR}
add wave {sim:/bellmanfordtest/BellmanFord/WMWDR}
add wave {sim:/bellmanfordtest/BellmanFord/WMWE}
add wave {sim:/bellmanfordtest/BellmanFord/Ureg}
add wave {sim:/bellmanfordtest/BellmanFord/NumLinks}
add wave {sim:/bellmanfordtest/BellmanFord/Vreg[1]}
add wave {sim:/bellmanfordtest/BellmanFord/Wreg[1]}
add wave {sim:/bellmanfordtest/BellmanFord/Vreg[2]}
add wave {sim:/bellmanfordtest/BellmanFord/Vreg[2]}
add wave {sim:/bellmanfordtest/BellmanFord/Vreg[3]}
add wave {sim:/bellmanfordtest/BellmanFord/Vreg[3]}
add wave {sim:/bellmanfordtest/BellmanFord/Vreg[4]}
add wave {sim:/bellmanfordtest/BellmanFord/Vreg[4]}
add wave {sim:/bellmanfordtest/BellmanFord/Wreg[5]}
add wave {sim:/bellmanfordtest/BellmanFord/Wreg[5]}
add wave {sim:/bellmanfordtest/BellmanFord/Wreg[6]}
add wave {sim:/bellmanfordtest/BellmanFord/Wreg[6]}
add wave {sim:/bellmanfordtest/BellmanFord/Wreg[7]}
add wave {sim:/bellmanfordtest/BellmanFord/Wreg[7]}

vlog bellmanfordtest.v
vlog bellmanford.v
run 150
