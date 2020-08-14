tabuSearch <- function(graph, nodes, flow, FUN, it, poblation){
  best <- flow
  tabuList <- list()
  tabuList <- append(tabuList, list(best))
  costs <- NULL
  actualCost <- calculateCost(graph, best)
  k <- 1
  while(it>0){
    neighborhood <- generateNeighborhood(graph, nodes, best, poblation, FUN)
    bestFit <- chooseBestFit(graph, neighborhood)
    bestNeighboor <- as.numeric(neighborhood[bestFit[[1]],])
    costs[k] <- bestFit[[2]]
    k<-k+1
    if(!is.element(list(bestNeighboor), tabuList) &&  bestFit[[2]]<actualCost){
      best <- bestNeighboor
      actualCost <- bestFit[[2]]
    }
    tabuList <- append(list(bestNeighboor), tabuList)
    if(length(a)>10){
      tabuList <- tabuList[-1]
    }
    it <- it-1
    
  }
  plot(costs)
}