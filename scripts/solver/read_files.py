import pandas as pd
import re


def arcs_to_vector(expression: re.Pattern, lines: list) -> pd.DataFrame:
    filtered = list(filter(expression.match, lines))
    vector = map(lambda x: x.split()[1:], filtered)
    colnames = ("tail", "head", "low", "cap", "cost")
    data = pd.DataFrame.from_records(list(vector), columns=colnames).astype(int)
    data["flow"] = 0
    return data


def special_nodes_to_arc(nodes: pd.DataFrame, value: int, origin=True):
    if origin:
        data = {"head": nodes["node"], "cap": nodes["flow"], "low": nodes["flow"], "tail": value}
    else:
        data = {"tail": nodes["node"], "cap": -nodes["flow"], "low": -nodes["flow"], "head": value}
    data["cost"] = 0
    data["flow"] = 0
    return pd.DataFrame(data, columns=("tail", "head", "low", "cap", "cost", "flow"))


def nodes_to_vector(expression: re.Pattern, lines: list) -> pd.DataFrame:
    filtered = list(filter(expression.match, lines))
    vector = map(lambda x: x.split()[1:], filtered)
    nodes = pd.DataFrame.from_records(list(vector), columns=("node", "flow")).astype(int)

    source_nodes = nodes["flow"] > 0
    sink_nodes = nodes["flow"] < 0

    return pd.concat([
        special_nodes_to_arc(nodes[source_nodes], 25001),
        special_nodes_to_arc(nodes[sink_nodes], 25002, origin=False),
    ])


def read_file(path_to_file: str) -> pd.DataFrame:
    r_arcs = re.compile("^a")
    r_nodes = re.compile("^n")
    with open(path_to_file) as f:
        content = f.readlines()
        arcs = arcs_to_vector(r_arcs, content)
        nodes = nodes_to_vector(r_nodes, content)
    response = pd.concat([arcs, nodes], ignore_index=True)
    return response
