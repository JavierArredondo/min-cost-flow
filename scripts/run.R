#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

file = args[1]

source("tools.R")
source("neighboor_algorithms.R")
source("simulatedAnnealing.R")

graph <- read.csv(paste0("../solutions/", file, "_solution.csv"))
nodes <- read.csv(paste0("../solutions/", file, "_solution_nodes.csv"))
flow_initial_solution <- graph$flow

t0 = 1000000#calculateCost(graph, flow_initial_solution)/2
tf = c(1000, 10000, 100000)
it = seq(10, 30, 6)
lambda = c(.99, .95, .9)
func = c(1,2)
# aux = c(generateNeighboor1, generateNeighboor2)
total_nodes = nrow(nodes)
total_arcs = nrow(graph)

params = expand.grid(tf = tf,
                    it = it,
                    lambda = lambda,
		    func=func)

output = data.frame()

pid = Sys.getpid()
command = paste("psrecord", pid, "--log", paste0("../logs/", file, "_", pid,".txt"), "--plot", paste0("../logs/", file, "_", pid,".png"),"--interval 1")
print(command)
system(command, intern = FALSE, ignore.stdout = FALSE, ignore.stderr = FALSE, wait = FALSE, input = NULL)


for(i in 1:nrow(params)) {
  print(paste(i, file))
  flow <- flow_initial_solution
  graph$flow <- NULL
  
  start_time = Sys.time()
  tf = params[i,]$tf
  it = params[i,]$it
  lambda = params[i,]$lambda
  f = params[i,]$func
  
  if (f == 1) {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor1, t0, tf, it, lambda, file, f)
  } else {
    solution = simulatedAnnealing(graph, nodes$nodes, flow, generateNeighboor2, t0, tf, it, lambda, file, f)
  }
  # solution = simulatedAnnealing(graph, nodes$nodes, flow, ff, t0, tf, it, lambda, file)
  cost = calculateCost(graph, solution)
  end_time = Sys.time()
  total_time = end_time - start_time
  output = rbind(output, c(total_nodes, total_arcs, f, t0, tf, it, lambda, cost, total_time))
}

colnames(output) = c("nodes", "arcs", "algorithm", "t0", "tf", "it", "lambda", "cost", "total_time")

write.csv(output, paste0("../results/_", file, ".csv"), sep=";")
