import graph_tool as gt
import sys

if len(sys.argv) == 2 :
  filename = sys.argv[1]
else :
  print " Usage : python reader.py graph.gml"
  exit(0)

# let's load the graph 
G = gt.load_grao
