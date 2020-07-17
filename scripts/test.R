source("scripts/read_files.R")

# flow = supplies
# sum of supply = sum of demand

select_min = function(node, graph) {
  possibles_to = graph[graph$tail == node, ]
  min_cost = which(possibles_to$cost == min(possibles_to$cost))
  return(possibles_to[min_cost, ])
}

select_random = function(node, graph) {
  possibles_to = graph[graph$tail == node, ]
  to = sample(1:nrow(possibles_to), 1)
  return(possibles_to[to, ])
}

open_pipe = function(arc, graph) {
  if(arc$cap >= arc$flow) {
    row_index = rownames(arc)
    arc$flow = arc$cap
    graph[row_index,] =  arc
  }
  return(graph)
}

current_random = function(graph) {
  mask = graph$flow != 0
  current = graph[mask, ]
  availables = unique(c(current$head, current$tail))
  return(sample(availables, 1))
}

run_pipe = function(start, end, graph) {
  # while input != output
  in_node = start
  for(i in c(1:10)) {
    print(in_node)
    if (in_node != end) {
      go_to = select_random(in_node, graph)
      graph = open_pipe(go_to, graph)
      in_node = current_random(graph)
    }
  }
  return(graph)
}

eval_cost_flow = function(graph) {
  is_used = graph$flow > 0
  total_cost = sum(is_used * graph$cost)
  return(total_cost)
}

is_solution = function(graph, start, end) {
  start_nodes = graph[graph$tail == start, ]
  end_nodes = graph[graph$head == end, ]
  
  return(
    sum(start_nodes$cap) == sum(end_nodes$cap) && 
    sum(start_nodes$flow) == sum(end_nodes$flow)
    )
  
}
  
start_node = 25001
end_node = 25002

net = read_network("netg/stndrd1.net")

solution = run_pipe(start_node, end_node, net)
parcial_cost = eval_cost_flow(solution)
is_solution(solution, start_node, end_node)
parcial_cost

small = read.csv("small.csv")
small

a  = run_pipe(1, 6, small)
