library(ggpubr)
setwd("/home/juan/Descargas")
graph <- read.csv("stndrd1_solution.csv")
nodes <- read.csv("stndrd1_solution_nodes.csv")
flow <- graph$flow
graph$flow <- NULL

a <- simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor2, 10000000, 1000, 10, 0.9)
a <- generateNeighboor1(graph, nodes$nodes, flow)
nodes <- data.frame(nodes)
graph <- read.csv("big1_solution.csv")
nodes <- read.csv("big1_solution_nodes.csv")

flow <- graph$flow
a <- simulatedAnnealing(graph,nodes$nodes, flow, generateNeighboor2, 15000000, 1000, 2, 0.95)
74857582