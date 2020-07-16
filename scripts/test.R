source("scripts/read_files.R")

# flow = supplies
# sum of supply = sum of demand

select_min = function(node, graph) {
  possibles_to = graph[graph$tail == node, ]
  min_cost = which(possibles_to$flow == min(possibles_to$flow))
  return(possibles_to[min_cost, ])
}

run_pipe = function(from, to, graph) {
  arc = graph[graph$tail == from & graph$head == to, ]
  print(arc)
}
  
  
start_node = 25001
end_node = 25002

net = read_network("netg/stndrd1.net")

run_pipe(start_node, 1, net)

b = select_min(start_node, net)
b

net[1340, ]$flow = 73

