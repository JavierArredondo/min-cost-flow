convert_file = function(ptrn, lines) {
  mask = grepl(pattern = ptrn, lines)
  tmp_file = tempfile("test")
  content = lines[mask]
  cat(content, file = tmp_file, sep = "\n")
  df = read.table(tmp_file, sep=" ")
  unlink(tmp_file)
  return(df)
}

get_arcs = function(mask, nodes, val, origin=TRUE) {
  if (origin) {
    df = data.frame(V1 = "a",
                    V2 = rep(val, sum(mask)),
                    V3 = nodes$V2[mask],
                    V4 = nodes$V3[mask],
                    V5 = nodes$V3[mask])
  }
  else {
    df = data.frame(V1 = "a",
                    V2 = nodes$V2[mask],
                    V3 = rep(val, sum(mask)),
                    V4 = -nodes$V3[mask],
                    V5 = -nodes$V3[mask])
  }
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
  sink = get_arcs(sink_nodes, nodes, 25002, origin = FALSE)
  
  arcs
  source
  
  res = rbind(arcs, source, sink)
  res$V7 = 0
  colnames(res) = c("type", "tail", "head", "low", "cap", "cost", "flow")
  return(res)
}
