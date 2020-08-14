library(ggpubr)
setwd("/home/juan/Descargas")
graph <- read.csv("cap26.net_solution.csv")
nodes <- read.csv("cap26.net_solution_nodes.csv")
flow <- graph$flow
graph$flow <- NULL

a <- simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor1, 10000000, 10, 5, 0.99)

a <- generateNeighboor1(graph, nodes$nodes, flow)
nodes <- data.frame(nodes)
graph <- read.csv("big1_solution.csv")
nodes <- read.csv("big1_solution_nodes.csv")

flow <- graph$flow
a <- simulatedAnnealing(graph,nodes$nodes, flow, generateNeighboor2, 15000000, 1000, 2, 0.95)
