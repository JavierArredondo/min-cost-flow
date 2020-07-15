library(igraph)

small = arcs[c(1:10),]

g = graph_from_edgelist(as.matrix(small[, c('V2', 'V3')]))

plot(g)
