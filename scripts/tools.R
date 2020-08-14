
#########################################################################
# RedistributeFlow -> Redistribuye el flujo inicial del grafo basándose en
# un arco. Es el core de las funciones de vecindad. El balanceo se realiza
# en las funciones de vecindad mismas.
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


redistributeFlow2 <- function(graph, flow){
  original <- flow
  while(TRUE){
    arc <- sample(1:nrow(graph),1)
    flow <- original
    if(nrow(graph[graph$tail==graph[arc,]$tail,])>1){
      if(flow[arc]>0){
        aux <- sample(1:flow[arc], 1)
        flow[arc] <- flow[arc] - aux
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

################################################################################

addDifferenceToOutputFlow <- function(graph, flow, node, toAdd){
  arcs <- as.numeric(rownames(graph[graph$tail == node,]))
  if(length(arcs) == 0){
    return(NULL)
  }
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
  if(length(arcs) == 0){
    return(NULL)
  }
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


inputFlow <- function(graph, flow, node){
  graph$flow <- flow
  input <- graph[graph$head == node,]
  input <- sum(input$flow)
  return(invisible(input))
}

outputFlow <- function(graph, flow, node){
  graph$flow <- flow
  output <- graph[graph$tail == node,]
  output <- sum(output$flow)
  return(invisible(output))
}

calculateCost <- function(graph, flow){
  cost <- sum(flow*graph$cost)
  return(invisible(cost))
}

chooseBestFit <- function(graph, neighborhood){
  cost <- NULL
  for(i in 1:nrow(neighborhood)){
    cost[i] <- calculateCost(graph, as.numeric(neighborhood[i,]))
  }
  min <- which.min(cost)
  chosen <- list(min, cost[min])
  return(invisible(chosen))
}



example <- function(){
  tail <- c(1,1,2,2,2,3,3,4,5)
  head <- c(2,3,3,4,5,4,5,5,3)
  low <- c(0,0,0,0,0,0,0,0,0)
  cap <- c(15,8,1000,100,100,100,500,1000,400)
  cost <- c(4,4,2,2,6,1,3,2,1)

  graph <- data.frame(tail,head,low,cap,cost)
  flow <- c(12, 8, 0, 5, 7, 0, 8, 0, 0)
  nodes <- c(20, 0, 0, -5, -15)


}
#best <- basicMetaheuristic(graph, nodes, flow, 100)