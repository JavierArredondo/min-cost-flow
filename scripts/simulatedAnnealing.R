#library(ggpubr)

simulatedAnnealing <- function(graph, nodes, flow, FUN, Tmax, Tmin, it, beta, name=NULL, f=NULL, with.plot=FALSE){
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
    #print(T)
    temperatures[n] <- T
    bestCostByT[n] <- actualCost
    n <- n + 1
  }
  x <- 1:length(costs)
  
  if (with.plot == TRUE) {
    title = paste(length(nodes), nrow(graph), Tmax, Tmin, it, beta)
    costs <- data.frame(costs, x)
    temperatures <- data.frame(bestCostByT, temperatures)
    
    file_costs = paste(name, "costs", f, length(nodes), nrow(graph), Tmax, Tmin, it, beta, sep = "_")
    file_temperature = paste(name, "temperatures", f, length(nodes), nrow(graph), Tmax, Tmin, it, beta, sep = "_")
    
    write.csv(costs, paste0(workdir, "output/", file_costs, ".csv"))
    write.csv(temperatures, paste0(workdir, "output/", file_temperature, ".csv"))
  }
  
  
  #file_temperature = paste(name, "temperatures", f, length(nodes), nrow(graph), Tmax, Tmin, it, beta, sep = "_")
  #file_costs = paste(name, "costs", f, length(nodes), nrow(graph), Tmax, Tmin, it, beta, sep = "_")
  
  
  #temperatures <- data.frame(bestCostByT, temperatures)
  
  
  
  #p2 <- ggscatter(temperatures, "temperatures", "bestCostByT", size = 2, title = title,
  #               xlab = "Temperatura",  ylab = "Costo",
  #               mean.point = FALSE, color = "#00AFBB", shape = 21) %>% 
  #  ggexport(filename = paste0("../plots/", file_temperature, ".png"), width = 720, height = 720)
  
  #write.csv(costs, paste0("../output/", file_costs, ".csv"))
  #write.csv(temperatures, paste0("../output/", file_temperature, ".csv"))
  return(invisible(actualSolution))
}


