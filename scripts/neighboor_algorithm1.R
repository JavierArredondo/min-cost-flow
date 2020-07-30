chooseRandomArc <- function(graph, flow){
  while(TRUE){
    arc <- sample(1:nrow(graph),1)
    if(nrow(graph[graph$tail == arc,])>1){
      if(flow[arc] >= 0){
        return(invisible(arc))
      }
    }
  }
  
}

chooseOutputArc <- function(graph, node, flow){
  arcs <- graph[graph$tail == node,]
  arcs <- as.numeric(rownames(arcs))
  todelete <- NULL
  for(n in 1:length(arcs)){
    if(flow[arcs[n]]==graph[arcs[n],]$cap){
      todelete[n] <- arcs[n]
    }
  }
  if(!is.null(todelete)){
    arcs <- arcs[arcs!=todelete]
  }
  if(length(arcs)==0 || is.na(arcs)){
    return(-1)
  }
  else if(length(arcs)==1 && !is.na(arcs)){
    return(invisible(arcs[1]))
  }

  i <- sample(1:length(arcs),1)
  
  return(invisible(arcs[i]))
}

chooseOutputArc.nonZero<- function(graph, node, flow){
  arcs <- graph[graph$tail == node,]
  arcs <- as.integer(rownames(arcs))
  i <- sample(1:length(arcs),1)
  while(TRUE){
    if(flow[arcs[i]] > 0){
      return(arcs[i])  
    }
    else{
      arcs <- arcs[arcs!=arcs[i]]
      if(length(arcs)==0){
        return(-1)
      }
      else if(length(arcs)==1){
        return(arcs[1])
      }
      else{
        i <- sample(1:length(arcs),1)
      }
    }
  }
}

chooseNeighboorArc <- function(graph, arc,flow){
  temp <- arc
  arc <- graph[arc,]
  neighborhood <- graph[graph$tail == arc$tail,]
  neighborhood <- as.integer(rownames(neighborhood))
  neighborhood <- neighborhood[neighborhood != temp]
  i <- sample(length(neighborhood),1)
  while(TRUE){
    f <- flow[neighborhood[i]]
    c <- graph[neighborhood[i],]$cap
    if( f == c){
      neighborhood <- neighborhood[neighborhood!=neighborhood[i]]
      if(length(neighborhood)==0){
        return(invisible(NA))
      }
    }
    else if(length(neighborhood)==0 || is.na(neighborhood)){
      return(invisible(NA))
    }
    else{
      return(invisible(neighborhood[i]))
    }
    i <- sample(length(neighborhood),1)
    
  }
}

addOneToFlow <- function(flow, arc){
  flow[arc] <- flow[arc] + 1
  return(invisible(flow))
}

subtractOneToFlow <- function(flow, arc){
  flow[arc] <- flow[arc] - 1
  return(invisible(flow))
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

generateNeighboor <- function(graph, nodes, flows){
  original <- flow
  temp <- TRUE
  while(temp){
    arc <- chooseRandomArc(graph, flow)
    flow <- subtractOneToFlow(flows, arc)
    neighboorArc <- chooseNeighboorArc(graph, arc, flow)
    if(!is.na(neighboorArc)){
      temp = FALSE
      flow <- original
    }
  }
  flow <- addOneToFlow(flow, neighboorArc)
  for(i in 1:length(nodes)){
    input <- inputFlow(graph = graph, flow = flow, node = i)
    output <- outputFlow(graph = graph, flow = flow, node = i)
    cost <- nodes[i]
    if(output > input+cost){
      outputArc <- chooseOutputArc.nonZero(graph = graph, node = i, flow = flow)
      if(outputArc == -1){
        return(invisible(original))
      }
      flow <- subtractOneToFlow(flow = flow, arc = outputArc)
    }
    else if(output < input+cost){
      outputArc <- chooseOutputArc(graph = graph, node = i, flow = flow)
      if(outputArc == -1){
        return(invisible(original))
      }
      flow <- addOneToFlow(flow = flow, arc = outputArc)
      
    }
  }
  return(invisible(flow))
}

calculateCost <- function(graph, flow){
  graph$flow <- flow
  cost <- sum(graph$flow*graph$cost)
  return(invisible(cost))
}

generateNeighborhood<- function(graph, nodes, flow, poblation){
  neighborhood <- data.frame()
  for(i in 1:poblation){
    neighborhood <- rbind(neighborhood,generateNeighboor(graph, nodes, flow))
  }
  return(invisible(neighborhood))
}

chooseBestFit <- function(graph, neighborhood){
  cost <- NULL
  for(i in 1:nrow(neighborhood)){
    cost[i] <- calculateCost(graph, as.numeric(neighborhood[i,]))
  }
  print(cost)
  min <- which.min(cost)
  chosen <- list(min, cost[min])
  return(invisible(chosen))
}

basicMetaheuristic <- function(graph, nodes, flow, iterations){
  actualCost <- calculateCost(graph, flow)
  costs <- c()
  costs <- append(costs, actualCost)
  for(i in 1:iterations){
    neighborhood <- generateNeighborhood(graph, nodes, flow, 100)
    bestFit <- chooseBestFit(graph, neighborhood)
    costs <- append(costs, bestFit[[2]])
    print(actualCost)
    if(bestFit[[2]]<actualCost){
      actualCost <- bestFit[[2]]
      index <- bestFit[[1]]
      flow <- as.numeric(neighborhood[index,])
      
    }
  }
  plot(costs)
  return(invisible(flow))
}


tail <- c(1,1,2,2,2,3,3,4,5)
head <- c(2,3,3,4,5,4,5,5,3)
low <- c(0,0,0,0,0,0,0,0,0)
cap <- c(15,8,1000,100,100,100,500,1000,400)
cost <- c(4,4,2,2,6,1,3,2,1)

graph <- data.frame(tail,head,low,cap,cost)
flow <- c(12, 8, 0, 5, 7, 0, 8, 0, 0)
nodes <- c(20, 0, 0, -5, -15)

neigh <- generateNeighborhood(graph, nodes, flow, 5)
c <- NULL
for(i in 1:10){
  c[i] <- calculateCost(graph, as.numeric(neigh[i,]))
}
plot(sort(c, decreasing=TRUE))

best <- basicMetaheuristic(graph, nodes, flow, 100)