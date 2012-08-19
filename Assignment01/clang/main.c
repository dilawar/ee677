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
     * Note : This type of initialization is allowed in C.
     */
    sop_t minTerms = {.vars = 0, .numMinterms = 0, .terms={0} }; 

    /*---------------------------------------------------------------------------- 
     * Minterms of a function are given in a text file. Open it and parse it to build
     * the data-structure. It is better to have a separate function to do this
     * job. After the following line, you will have minterms stored in
     * data-structure minterms.
     *----------------------------------------------------------------------------*/
    processInputFileToStoreMinterms("./minterms.txt", &minTerms);

#if  0     /* ----- #if 0 : If0Label_1 ----- */


    /*-----------------------------------------------------------------------------
     *  This section do some primitive testing on functions. You need not look
     *  at them.
     *-----------------------------------------------------------------------------*/
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


    /*-----------------------------------------------------------------------------
     *  Students must write the implementation of following function in
     *  methods.c file. You should conform to the signature of the function.
     *
     *-----------------------------------------------------------------------------*/
    
    /* We need new data-structure to store reduced minterms */
    minterms_t reducedTerms = {.vars = 0, .numMinterms = 0, .minterms = {0}, .indices={0} }; 
    quineMcClusky(&minTerms, &reducedTerms);

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

#endif     /* ----- #if 0 : If0Label_1 ----- */

    return 0;

}
