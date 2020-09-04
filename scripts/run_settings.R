#!/usr/bin/env Rscript

#install.packages("ggpubr")

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

params = read.csv(paste0(workdir, "settings/", file, "_settings.csv"))
output = data.frame()

#pid = Sys.getpid()
#command = paste("psrecord", pid, "--log", paste0("../logs/", file, "_", pid,".txt"), "--plot", paste0("../logs/", file, "_", pid,".png"),"--interval 1")
#print(command)
#system(command, intern = FALSE, ignore.stdout = FALSE, ignore.stderr = FALSE, wait = FALSE, input = NULL)


for(i in 1:nrow(params)) {
  flow <- flow_initial_solution
  graph$flow <- NULL
    
  t0 = params[i,]$t0
  tf = params[i,]$tf
  it = params[i,]$it
  lambda = params[i,]$lambda
  algorithm = params[i,]$algorithm
  print(params[i,])
  if (algorithm == 1) {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor1, t0, tf, it, lambda, f=file, name="setting", with.plot=TRUE)
  } else {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor2, t0, tf, it, lambda, f=file, name="setting", with.plot=TRUE)
  }
  # solution = simulatedAnnealing(graph, nodes$nodes, flow, ff, t0, tf, it, lambda, file)
  cost = calculateCost(graph, solution)
  output = rbind(output, c(cost, solution))
}

write.table(output, paste0(workdir, "settings/solutions_", file, ".csv"), sep=";", dec = ".", row.names = F)

