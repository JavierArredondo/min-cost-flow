convert_file = function(ptrn, lines) {
  mask = grepl(pattern = ptrn, lines)
  tmp_file = tempfile("test")
  content = lines[mask]
  cat(content, file = tmp_file, sep = "\n")
  df = read.table(tmp_file, sep=" ")
  unlink(tmp_file)
  return(df)
}

read_network = function(filepath, ptrn) {
  content = file(filepath, "r")
  lines = readLines(content)
  close(content)
  res = convert_file(ptrn, lines)
  return(res)
}


nodes = read_network("netg/stndrd1.net", "^n")
arcs = read_network("netg/stndrd1.net", "^a")
