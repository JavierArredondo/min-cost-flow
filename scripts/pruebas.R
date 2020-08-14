library(ggpubr)
setwd("/home/juan/Descargas")
graph <- read.csv("cap40_solution.csv")
nodes <- read.csv("cap40_solution_nodes.csv")
flow <- graph$flow
graph$flow <- NULL

a <- simulatedAnnealing(graph, nodes, flow, generateNeighboor2, 10000000, 10, 10, 0.95)

graph <- read.csv("big1_solution.csv")
nodes <- read.csv("big1_solution_nodes.csv")

flow <- graph$flow
a <- simulatedAnnealing(graph,nodes$nodes, flow, generateNeighboor2, 15000000, 1000, 2, 0.95)
