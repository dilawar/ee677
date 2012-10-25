import graph_tool as gt
import sys

# Specify the file to read from command line
if len(sys.argv) == 2 :
  filename = sys.argv[1]
else :
  print " Usage : python reader.py graph.gml"
  exit(0)

# let's load the graph and store the vertex properties in variable name.
G = gt.load_graph(filename, "xml")
names = G.vertex_properties["name"]

# iterate over vertices of graph
for i in G.vertices() :
  if names[i] == "&" :
    print " + and Found"
  elif names[i] == "|" :
    print " + or found "
  elif names[i] == "!" :
    print " + not found " 
  else :
    print " + Input node found with name {0}".format(names[i])


