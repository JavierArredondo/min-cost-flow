redistributeFlow <- function(graph, flow){
  original <- flow
  while(TRUE){
    arc <- sample(1:nrow(graph),1)
    flow <- original
    if(nrow(graph[graph$tail==graph[arc,]$tail,])>1){
      if(flow[arc]>0){
        aux <- flow[arc]
        flow[arc] <- 0
        arcs <- as.numeric(rownames(graph[graph$tail==graph[arc,]$tail, ]))

        for(i in 1:length(arcs)){

          if(aux>0 && i == length(arcs)){
            if(aux + flow[arcs[i]] <= graph[arcs[i],]$cap ){
              flow[arcs[i]] <- flow[arcs[i]] + aux
              return(invisible(flow))
            }
          }
          else if(aux > 0){
            possibleFlow <- flow[arcs[i]] - graph[arcs[i],]$cap
            if(possibleFlow < 0){
              if(abs(possibleFlow)-aux>0){
                flowToAdd <- sample(1:aux, 1)
                flow[arcs[i]] <- flow[arcs[i]] + abs(flowToAdd)
                aux <- aux - abs(flowToAdd)                
              }
              else{
                flowToAdd <- sample(1:abs(possibleFlow),1)
                flow[arcs[i]] <- flow[arcs[i]] + abs(flowToAdd)
                aux <- aux - abs(flowToAdd)
              }

            }
          }
          else if(aux == 0){
            return(invisible(flow))
          }
        }
      }
    }
  }
}

addDifferenceToOutputFlow <- function(graph, flow, node, toAdd){
  arcs <- as.numeric(rownames(graph[graph$tail == node,]))
  aux <- toAdd
  original <- flow
  while(TRUE){
    for(i in 1:length(arcs)){
      possibleFlow <- flow[arcs[i]] - graph[arcs[i], ]$cap
      if(i == length(arcs)){
        if(aux + flow[arcs[i]] <= graph[arcs[i],]$cap){
          flow[arcs[i]] <- flow[arcs[i]] + aux
          return(invisible(flow))
        }
        else{
          return(NULL)
        }
      }
      else if(aux>0){
        if(possibleFlow<0){
          if(abs(possibleFlow)<aux){
            flowToAdd <- sample(1:abs(possibleFlow),1)
            flow[arcs[i]] <- flowToAdd + flow[arcs[i]]
            aux <- aux - flowToAdd
          }
          else{
            flowToAdd <- sample(1:aux, 1)
            flow[arcs[i]] <- flowToAdd + flow[arcs[i]]
            aux <- aux - flowToAdd
          }
        }
      }
      else if(aux == 0){
        return(invisible(flow))
      }
    }
  }
}

subtractDifferenceToOutputFlow <- function(graph, flow, node, toAdd){
  arcs <- as.numeric(rownames(graph[graph$tail == node,]))
  aux <- toAdd
  original <- flow
  while(TRUE){
    for(i in 1:length(arcs)){
      possibleFlow <- flow[arcs[i]] - aux
      if(i == length(arcs)){
        if(flow[arcs[i]] - aux >= 0){
          flow[arcs[i]] <- flow[arcs[i]] - aux
          return(invisible(flow))
        }
        else{
          return(NULL) 
        }
      }
      else if(aux>0){
        if(possibleFlow >= 0){
          flowToAdd <- sample(1:abs(possibleFlow),1)
          flow[arcs[i]] <- flowToAdd - flow[arcs[i]]
          aux <- aux - flowToAdd
        }
        else{
          flowToAdd <- sample(1:abs(possibleFlow), 1)
          flow[arcs[i]] <- flow[arcs[i]] - flowToAdd
          aux <- aux - flowToAdd
        }
      }
      else if(aux == 0){
        return(invisible(flow))
      }
    }
  }
}



generateNeighboor2 <- function(graph, nodes, flows){
  original <- flow
  flow <- redistributeFlow(graph, flow)
  for(i in 1:length(nodes)){
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
  return(invisible(flow))
}



