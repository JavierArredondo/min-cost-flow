source("scripts/read_files.R")

# flow = supplies
# sum of supply = sum of demand

select_min = function(node, graph) {
  possibles_to = graph[graph$tail == node, ]
  min_cost = which(possibles_to$cost == min(possibles_to$cost))
  return(possibles_to[min_cost, ])
}

select_random = function(node, graph) {
  possibles_to = graph[graph$tail == node & graph$cap > graph$flow, ]
  to = sample(1:nrow(possibles_to), 1)
  return(possibles_to[to, ])
}

open_pipe = function(arc, graph, flow_with_dembow) {
  if(arc$cap >= arc$flow + flow_with_dembow) {
    row_index = rownames(arc)
    arc$flow = arc$flow + flow_with_dembow#arc$cap
    graph[row_index,] =  arc
  }
  return(graph)
}

current_random = function(graph) {
  mask = graph$flow != 0
  current = graph[mask, ]
  availables = unique(current$head)
  return(sample(availables, 1))
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

yet_available = function(in_node, graph, input_flow) {
  possible_to = graph[graph$tail == in_node, ]
  return(input_flow > sum(possible_to$flow))
}

run_pipe = function(start, end, graph, input_flow, ouput_flow) {
  set.seed(input_flow)
  # while input != output
  in_node = start
  flow_available = input_flow
  for(i in c(1:100)) {
    #if (sum(graph$flow[graph$tail == in_node]) != input_flow)  {
    if (nrow(graph[graph$tail == in_node, ]) != 0) {
      is_final = which(small$head == end & small$tail == in_node)
      if (length(is_final) > 0) {
        if(graph$cap[is_final] > graph$flow[is_final]) {
          go_to = graph[which(small$head == end & small$tail == in_node), ]
        }
        else {
          go_to = select_random(in_node, graph)
        }
      }
      else {
        go_to = select_random(in_node, graph)
      }
      aux = c(1:(go_to$cap - go_to$flow))
      flow = sample(aux[aux<=flow_available], 1)
      if(go_to$cap >= (flow + go_to$flow) &
         (flow_available - flow) >= 0){
        graph = open_pipe(go_to, graph, flow)
        flow_available = flow_available - flow
      }
    }
    #print(in_node)
    #print(!yet_available(in_node, graph, input_flow))
    #print(graph)
    if(!yet_available(in_node, graph, input_flow)) {
      in_node = current_random(graph)
      flow_available = sum(graph$flow[graph$head == in_node])
      input_flow = flow_available
      
      print(sum(graph$flow[graph$tail == start]))
      print(sum(graph$flow[graph$head == end]))
      print(in_node)
    }
    else {
      in_node = current_random(graph)
      flow_available = sum(graph$flow[graph$head == in_node])
      input_flow = flow_available
      print(graph)
      print(in_node)
    }
  }
  return(graph)
}
small = read.csv("small.csv")
small

a  = run_pipe(1, 6, small, 20, -20)
a


start_node = 25001
end_node = 25002

net = read_network("netg/stndrd1.net")

solution = run_pipe(start_node, end_node, net)
parcial_cost = eval_cost_flow(solution)
is_solution(solution, start_node, end_node)
parcial_cost


