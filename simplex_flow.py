# import networkx
import networkx as nx

# create directed graph
G = nx.DiGraph()

# add node to graph with negative (!) supply for each supply node 
G.add_node(1, demand = -20)

# you can ignore transshipment nodes with zero supply when you are working with the mcfp-solver 
# of networkx
# add node to graph with positive (!) demand for each demand node
G.add_node(4, demand = 5)
G.add_node(5, demand = 15)

# add arcs to the graph: fromNode,toNode,capacity,cost (=weight)
G.add_edge(1, 2, capacity = 15, weight = 4)
G.add_edge(1, 3, capacity = 8, weight = 4)
G.add_edge(2, 3, capacity = 1000, weight = 2)
G.add_edge(2, 4, capacity = 100, weight = 2)
G.add_edge(2, 5, capacity = 100, weight = 6)
G.add_edge(3, 4, capacity = 100, weight = 1)
G.add_edge(3, 5, capacity = 500, weight = 3)
G.add_edge(4, 5, capacity = 1000, weight = 2)
G.add_edge(5, 3, capacity = 400, weight = 1)


# solve the min cost flow problem
# flowDict contains the optimized flow
# flowCost contains the total minimized optimum
flowCost, flowDict = nx.network_simplex(G)

print("Optimum: %s" %flowCost)  #should be 14