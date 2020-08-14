library(ggpubr)
simulatedAnnealing <- function(graph, nodes, flow, FUN, Tmax,Tmin,it, beta){
  s <- flow
  T <- Tmax
  actualCost <- calculateCost(graph, flow)
  actualSolution <- flow
  n = 1
  k = 1
  temperatures <- NULL
  costs <- NULL
  bestCostByT <- NULL
  while(T > Tmin){
    for(i in 1:it){
      neighbor <- FUN(graph, nodes, actualSolution)
      cost <- calculateCost(graph, neighbor)
      delta_E <- cost - actualCost
      if(delta_E <= 0){
        actualCost <- cost
        actualSolution <- neighbor
      }
      else{
        bolztmanProb <- exp((-delta_E)/T)
        temp <- sample(c(0,1), 1, prob = c(1-bolztmanProb, bolztmanProb), replace = TRUE)
        if(temp == 1){
          actualCost <- cost
          actualSolution <- neighbor
        }
      }
      costs[k] <- actualCost
      k <- k+1
    }
    #T <- T - n*beta
    T <- T*beta
    print(T)
    temperatures[n] <- T
    bestCostByT[n] <- actualCost
    n <- n + 1
  }
  x <- 1:length(costs)
  costs <- data.frame(costs,x)
  temperatures <- data.frame(bestCostByT, temperatures)
  p1 <- ggscatter(costs, "x", "costs", size = 2, 
                  xlab = "Iteración", ylab = "Costo",
                 mean.point = TRUE, color = "#00AFBB", shape = 21)
  p2 <- ggscatter(temperatures, "temperatures", "bestCostByT", size = 2,
                 xlab = "Temperatura",  ylab = "Costo",
                 mean.point = TRUE, color = "#00AFBB", shape = 21)
  print(p1)
  print(p2)
  
  print(actualCost)
  return(invisible(actualSolution))
}


