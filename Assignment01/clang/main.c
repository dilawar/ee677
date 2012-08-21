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

int main(int argc, char* argv[])
{
    /* Initialize our storehouse.  */
    
    /* Structure that holds minterms 
     */
    sop_t* pMinTerms = (sop_t*) calloc(1, sizeof(sop_t)) ;
    if(NULL == pMinTerms)
    {
        fprintf(stderr, "Out of memory! Existing ...\n");
        exit(0);
    }

    /*---------------------------------------------------------------------------- 
     * Minterms of a function are given in a text file. Open it and parse it to build
     * the data-structure. It is better to have a separate function to do this
     * job. After the following line, you will have minterms stored in
     * data-structure minterms.
     *----------------------------------------------------------------------------*/
    processInputFileToStoreMinterms("./minterms.txt", pMinTerms);



    /*-----------------------------------------------------------------------------
     *  This section do some primitive testing on functions. You need not look
     *  at them.
     *-----------------------------------------------------------------------------*/
    
    /* Testing some helper functions we have written */
    unsigned input[8] = {1,1,1,0,1,1,0}; /* 8 alloted but 7 filled */
    if( 55 == binaryVectorToInt(input, 6)) /*  and only 6 used */
        printf("TEST 1 PASSED : Function is ok!\n"); 
    else 
        printf("TEST 1 FAILED : Function failed \n");

    unsigned res[8];
    intToBinaryVector(55, 4, res); /* get 6 bit long representation. */
    int i, correct = 1;
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


    /*-----------------------------------------------------------------------------
     *  Students must write the implementation of following function in
     *  methods.c file. You should conform to the signature of the function.
     *
     *-----------------------------------------------------------------------------*/
    
    /* We need new data-structure to store reduced minterms */
    sop_t* pReducedTerms = (sop_t*) calloc(1, sizeof(sop_t)); 
    quineMcClusky(pMinTerms, pReducedTerms);

    /*-----------------------------------------------------------------------------
     *  At this point we should have given minterms in 'minterms' and new
     *  reduced number of minterms in 'reducedTerms'
     *
     *  TODO : TA will write some testing function on these two structures. Make
     *  sure that your implementation is correct. Passing each test will given you 1
     *  marks. 
     *
     *  I'll upload the test function 2-3 days before the submission date. I am
     *  too lazy to write them now.
     *-----------------------------------------------------------------------------*/


    /* free memory, you may like to run it again */
    free(pMinTerms);
    free(pReducedTerms);
    return 0;

}
