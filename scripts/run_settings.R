#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

workdir = args[1]
file = args[2]

source("tools.R")
source("neighboor_algorithms.R")
source("simulatedAnnealing.R")

graph <- read.csv(paste0(workdir, "solutions/", file, "_solution.csv"))
nodes <- read.csv(paste0(workdir, "solutions/", file, "_solution_nodes.csv"))
flow_initial_solution <- graph$flow
cost_initial_solution <- calculateCost(graph, flow_initial_solution)

settings = read.csv(paste0(workdir, "settings/", file, "_settings.csv"))

output = data.frame()

#pid = Sys.getpid()
#command = paste("psrecord", pid, "--log", paste0("../logs/", file, "_", pid,".txt"), "--plot", paste0("../logs/", file, "_", pid,".png"),"--interval 1")
#print(command)
#system(command, intern = FALSE, ignore.stdout = FALSE, ignore.stderr = FALSE, wait = FALSE, input = NULL)


for(i in 1:nrow(settings)) {
  flow <- flow_initial_solution
  graph$flow <- NULL
  
  start_time = Sys.time()
  
  t0 = params[i,]$t0
  tf = params[i,]$tf
  it = params[i,]$it
  lambda = params[i,]$lambda
  algorithm = params[i,]$algorithm
  
  if (algorithm == 1) {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor1, t0, tf, it, lambda, file, f)
  } else {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor2, t0, tf, it, lambda, file, f)
  }
  # solution = simulatedAnnealing(graph, nodes$nodes, flow, ff, t0, tf, it, lambda, file)
  cost = calculateCost(graph, solution)
  output = rbind(output, solution)
}

colnames(output) = c("nodes", "arcs", "algorithm", "t0", "tf", "it", "lambda", "cost", "total_time")

write.table(output, paste0(workdir, "results/", file, "_algorithm", algorithm, "_", iteration, ".csv"), sep=";", dec = ".", row.names = F)
