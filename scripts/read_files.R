convert_file = function(ptrn, lines) {
  mask = grepl(pattern = ptrn, lines)
  tmp_file = tempfile("test")
  content = lines[mask]
  cat(content, file = tmp_file, sep = "\n")
  df = read.table(tmp_file, sep=" ")
  unlink(tmp_file)
  df$V7 = 0
  return(df)
}

get_arcs = function(mask, nodes, val) {
  if (val == 25001) {
    df = data.frame(V1 = "a",
                    V2 = rep(val, sum(mask)),
                    V3 = nodes$V2[mask],
                    V7 = nodes$V3[mask])
  }
  else {
    df = data.frame(V1 = "a",
                    V2 = nodes$V2[mask],
                    V3 = rep(val, sum(mask)),
                    V7 = nodes$V3[mask])
  }
  
  df$V4 = 0
  df$V5 = 0
  df$V6 = 0
  return(df)
}

read_network = function(filepath) {
  content = file(filepath, "r")
  lines = readLines(content)
  close(content)
  nodes = convert_file("^n", lines)
  arcs = convert_file("^a", lines)
  
  source_nodes = nodes$V3 >  0
  sink_nodes = nodes$V3 <  0
  
  source = get_arcs(source_nodes, nodes, 25001)
  sink = get_arcs(sink_nodes, nodes, 25002)
  
  res = rbind(source, arcs, sink)

  return(res)
}

eval_flow = function(low_cap, capacity, cost, flow) {
  is_used = flow > 0
  total_cost = is_used * cost
  return(total_cost)
}



net = read_network("netg/stndrd1.net")
eval_flow(arcs$V4, arcs$V5, arcs$V6, arcs$V7)
