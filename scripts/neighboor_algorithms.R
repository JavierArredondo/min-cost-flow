generateNeighboor1 <- function(graph, nodes, flows){
  original <- flow
  flow <- redistributeFlow2(graph, flow)
  for(i in 1:length(nodes)){
    arcs <- as.numeric(rownames(graph[graph$tail == i,]))
    if(length(arcs)){
      input <- inputFlow(graph = graph, flow = flow, node = i)
      output <- outputFlow(graph = graph, flow = flow, node = i)
      cost <- nodes[i]
      if(output > input+cost){
        toAdd <- output - (input+cost)
        #print(c("To subtract: ", toAdd, "nodo", i, "entrando", input, "saliendo", output))
        flow <- subtractDifferenceToOutputFlow(graph, flow, i, toAdd)
        if(is.null(flow)){
          return(invisible(original))
        }
      }
      else if(output < input+cost){
        toAdd <- input+cost-output
        
        #print(c("To add: ", toAdd, "nodo", i, "entrando", input, "saliendo", output))
        
        flow <- addDifferenceToOutputFlow(graph, flow, i, toAdd )
        if(is.null(flow)){
          return(invisible(original))
        }
        
      }      
      
    }
    

  }
  return(invisible(flow))
}








generateNeighboor2 <- function(graph, nodes, flows){
  original <- flow
  flow <- redistributeFlow(graph, flow)
  for(i in 1:length(nodes)){
    arcs <- as.numeric(rownames(graph[graph$tail == i,]))
    if(length(arcs)){
      input <- inputFlow(graph = graph, flow = flow, node = i)
      output <- outputFlow(graph = graph, flow = flow, node = i)
      cost <- nodes[i]
      if(output > input+cost){
        toAdd <- output - (input+cost)
        flow <- subtractDifferenceToOutputFlow(graph, flow, i, toAdd)
        if(is.null(flow)){
          return(invisible(original))
        }
      }
      else if(output < input+cost){
        toAdd <- input+cost-output
        flow <- addDifferenceToOutputFlow(graph, flow, i, toAdd )
        if(is.null(flow)){
          return(invisible(original))
        }
        
      }      
      
    }

  }
  return(invisible(flow))
}



