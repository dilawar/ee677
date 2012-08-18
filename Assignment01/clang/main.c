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

    /* 
     * We have stored minterms of a function in a text file. Open it and build
     * the data-structure. It is better to have a separate function to do this
     * job.
     */
    processInputFileToStoreMinterms("./minterms.txt", &minTerms);

    /* TESTING */

     /* Let's print out whatever we had processed. */
    int i;
    for(i = 0; i < minTerms.numMinterms; i++)
        printf("%d,", minTerms.minterms[i]);
    printf("\n");
    /* Test functions we have written */
    unsigned input[8] = {1,1,1,0,1,1,0}; /* 8 alloted but 7 filled */
    if( 55 == binaryVectorToInt(input, 6)) /*  and only 6 used */
        printf("TEST 1 PASSED : Function is ok!\n"); 
    else 
        printf("TEST 1 FAILED : Function failed \n");

    unsigned* res = intToBinaryVector(55, 4); /* get 6 bit long representation. */
    int correct = 1;
    for(i = 0; i < 4; i++)
    {
        if(input[i] != res[i])
            correct = 0;
    }
    printf("\n");
    if(0 == correct)
        printf("TEST 2 FAILED : Int to binary conversion is wrong. \n");
    else 
        printf("TEST 2 PASSED : Int to binary conversion is successful. \n");

    return 0;

}
