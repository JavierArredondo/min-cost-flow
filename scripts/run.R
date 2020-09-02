#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

file = args[1]
iteration = args[2]
algorithm = args[3]
workdir = args[4]

# stndrd10 stndrd19 cap1 cap10

#file = "stndrd10"
#iteration = 1
#algorithm = 1

source("tools.R")
source("neighboor_algorithms.R")
source("simulatedAnnealing.R")

graph <- read.csv(paste0(workdir, "solutions/", file, "_solution.csv"))
nodes <- read.csv(paste0(workdir, "solutions/", file, "_solution_nodes.csv"))
flow_initial_solution <- graph$flow
cost_initial_solution <- calculateCost(graph, flow_initial_solution)

t0 = c(cost_initial_solution/10, cost_initial_solution/3)
tf = c(1000, 10000, 100000)
it = seq(15, 30, 5)
lambda = seq(.79, .99, .05)

total_nodes = nrow(nodes)
total_arcs = nrow(graph)

params = expand.grid(t0 = t0,
                     tf = tf,
                     it = it,
                     lambda = lambda)

output = data.frame()

#pid = Sys.getpid()
#command = paste("psrecord", pid, "--log", paste0("../logs/", file, "_", pid,".txt"), "--plot", paste0("../logs/", file, "_", pid,".png"),"--interval 1")
#print(command)
#system(command, intern = FALSE, ignore.stdout = FALSE, ignore.stderr = FALSE, wait = FALSE, input = NULL)


for(i in 1:nrow(params)) {
  flow <- flow_initial_solution
  graph$flow <- NULL
  
  start_time = Sys.time()
  
  t0 = params[i,]$t0
  tf = params[i,]$tf
  it = params[i,]$it
  lambda = params[i,]$lambda
  
  if (algorithm == 1) {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor1, t0, tf, it, lambda, file, f)
  } else {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor2, t0, tf, it, lambda, file, f)
  }
  # solution = simulatedAnnealing(graph, nodes$nodes, flow, ff, t0, tf, it, lambda, file)
  cost = calculateCost(graph, solution)
  end_time = Sys.time()
  total_time = end_time - start_time
  total_time = as.numeric(total_time, units = "secs")
  output = rbind(output, c(total_nodes, total_arcs, algorithm, t0, tf, it, lambda, cost, total_time))
}

colnames(output) = c("nodes", "arcs", "algorithm", "t0", "tf", "it", "lambda", "cost", "total_time")

write.table(output, paste0(workdir, "results/", file, "_algorithm", algorithm, "_", iteration, ".csv"), sep=";", dec = ".", row.names = F)
