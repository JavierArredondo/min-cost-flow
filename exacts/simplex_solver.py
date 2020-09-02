import networkx as nx
import pandas as pd
import numpy as np
import re

import os

def read_arcs(expression, lines):
    filtered = list(filter(expression.match, lines))
    vector = map(lambda x: [int(y) for y in x.split()[1:]], filtered)
    vector = list(vector)
    col_names = ("tail", "head", "low", "cap", "cost")
    for y, x in enumerate(vector):
        if len(x) != 5:
            print(y, x)
    data = pd.DataFrame.from_records(vector, columns=col_names)
    data["flow"] = 0
    return data


def read_nodes(expression, lines, nodes):
    filtered = list(filter(expression.match, lines))
    values = list(map(lambda x: x.split()[1:], filtered))
    vector = np.zeros(nodes, dtype=int)
    for i in values:
        node = int(i[0]) - 1
        flow = int(i[1])
        vector[node] = flow
    return vector


def read_net(path_to_file):
    r_arcs = re.compile("^a")
    r_nodes = re.compile("^n")
    with open(path_to_file) as f:
        content = f.readlines()
        arcs = read_arcs(r_arcs, content)
        nodes = read_nodes(r_nodes, content, len(set(arcs["tail"]).union(arcs["head"])))
    G = nx.DiGraph()
    for i, r in arcs.iterrows():
        G.add_edge(int(r["tail"]),
                   int(r["head"]),
                   capacity = int(r["cap"]),
                   weight = int(r["cost"]))
        #min_cost_flow.AddArcWithCapacityAndUnitCost(int(r["tail"])-1, int(r["head"])-1, int(r["cap"]), int(r["cost"]))
    for i, v in enumerate(nodes):
        G.add_node(i+1, demand = -int(v))
        #min_cost_flow.SetNodeSupply(i, int(v))
    return G

if __name__ == "__main__":
    import sys
    input_file = sys.argv[0]
    G = read_net(input_file)
    flowCost, flowDict = nx.network_simplex(G)



