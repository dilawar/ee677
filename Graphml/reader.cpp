/*
 * =====================================================================================
 *
 *       Filename:  reader.cpp
 *
 *    Description:  To read a graphml file using boost.
 *
 *        Version:  1.0
 *        Created:  Thursday 25 October 2012 05:22:26  IST
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dilawar Singh (), dilawar@ee.iitb.ac.in
 *   Organization:  
 *
 * =====================================================================================
 */

#include <boost/graph/graphml.hpp>
#include <string>
#include <fstream>


using namespace std;
using namespace boost;

/*  Define what vertex of the graph should hold. Not all fields declared are
 *  used 
 */
struct vertex_info {
  std::string name;
  std::string label;
  /* 0 : primary input, 1 : primary output, 2 : gate/latch node. */
  int type;                                 
};

/* Define the type of graph */
typedef boost::adjacency_list<boost::vecS, boost::vecS, boost::bidirectionalS
  , vertex_info> graph_t;

/* Declare dynamic properties for graphml format. */
boost::dynamic_properties dp;


/*  Declare function prototype */
void readGraphMLFile(graph_t& graphToBuild, string gmlFileToRead);

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  readGraphMLFile
 *  Description:  Read a graphml file and update the graph designG.
 * =====================================================================================
 */
void readGraphMLFile ( graph_t& designG, string fileName )
{
  dp.property("name", get(&vertex_info::name, designG));

  ifstream gmlStream;
  gmlStream.open(fileName.c_str(), ifstream::in);
 
  boost::read_graphml(gmlStream, designG, dp);
  gmlStream.close();

}		/* -----  end of method ExpressionGraph::readGraphMLFile  ----- */


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  main
 *  Description:  
 * =====================================================================================
 */
int main(int argc, char** argv)
{
  if(argc < 2)
  {
    cerr<<"USAGE : ./a.out filename"<<endl;
    exit(0);
  }
  std::string filename = argv[1];

  graph_t graph;
  readGraphMLFile(graph, filename);
}
