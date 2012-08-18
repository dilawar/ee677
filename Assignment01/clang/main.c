/*
 * =====================================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  Partial implementation of Quine-McCluskey method.
 *
 *        Version:  1.0
 *        Created:  08/18/2012 04:05:06 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dilawar Singh, dilawar@ee.iitb.ac.in
 *   Organization:  EE, IIT Bombay
 *
 * =====================================================================================
 */

#include <stdlib.h>
#include <stdio.h>
#include "globals.h"

/*
 * Entry point 
 */
int main(int argc, char* argv[])
{
    /* Initialize our storehouse.  */
    minterms_t minTerms = {.vars = 0, .minterms={0} }; /* structure that holds minterms */

    /* We have stored minterms of a function in a text file. Open it and build
     * the data-structure. It is better to have a separate function to do this
     * job.
     */
    processInputFileToStoreMinterms("./minterms.txt", &minTerms);

    return 0;

}
