/*
 * =====================================================================================
 *
 *       Filename:  methods.c
 *
 *    Description:  Implementation of Quine-McClusky method.
 *
 *        Version:  1.0
 *        Created:  08/18/2012 04:07:53 AM
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
#include <math.h>
#include <string.h>
#include "globals.h"


/* 
 * ===  FUNCTION  ======================================================================
 *
 *         Name:  processInputFileToStoreMinterms
 *  Description:  See the header file globals.h for details.
 * =====================================================================================
 */
void processInputFileToStoreMinterms(const char* fileName, minterms_t* pMinterms)
{
    fprintf(stdout, "Reading file containing minterms \n");

    FILE* fp = fopen(fileName, "r");
    if(NULL == fp)
        fprintf(stderr, "ERROR 1 : File %s does not exists. Quiting ...\n", fileName);
    else 
        fprintf(stdout, " + Successfully opened file %s.\n", fileName);
    
    /* read till the  end of file */
    char* line = NULL;
    int len = 0;
    int sizeLine = 0;
    int varsFound = 0;
    int mintermsFound = 0;
    while((sizeLine = getline(&line, &len, fp)) != -1)
    {
        if(len > 1) 
        {
            char* saveptr, *token;
            char* str1;
            int j;
            const char* delim = " =\n";
            for(j = 1, str1 = line; ; j++, str1 = NULL)
            {
                token = strtok_r(str1, delim, &saveptr);
                if(NULL == token)
                    break;
                if(j==1 && strcmp(token,"vars") == 0)
                    varsFound = 1;                
                if(varsFound == 1 && j == 2)
                    pMinterms->vars = ((int)*token)-44;

                if(j==1 && strcmp(token, "minterms") == 0)
                    mintermsFound = 1;
                if(mintermsFound == 1 && j == 2)
                {
                    /* seprate each minterms given in csv */
                    const char* subdelim = ",";
                    char* subToken, saveptr2;
                    char* str2;
                    int k;
                    for(k = 1, str2 = token; ; k++, str2 = NULL)
                    {
                        subToken = strtok_r(str2, subdelim, &saveptr2);
                        if(NULL == subToken)
                            break;
                        unsigned int mterm = (unsigned int)(*subToken) - 44;
                        pMinterms->minterms[k] = mterm;
                        pMinterms->numMinterms += 1;
                    }
                }
            }
        }
    }
    
    fclose(fp);

    /*  Sanity test */
    if(pMinterms->numMinterms == 0)
    {
        fprintf(stderr, "ERROR : It is embarassing but I can not parse minterms.\n");
        exit(-9);
    }

    if(pMinterms -> vars == 0)
    {
        fprintf(stderr, "Warning : I can not figure out how many variables are in your function.\n");
        fprintf(stderr, " ++ Guessing it from minterms.\n");
        unsigned maxTerm = 0;
        int i;
        for(i = 0; i < pMinterms->numMinterms; i++)
            if(pMinterms->minterms[i] > maxTerm)
                maxTerm = pMinterms->minterms[i];
        pMinterms->vars = (int)ceil(sqrt((double)maxTerm));
    }
    /*
     * Test case : Make sure that number of minterms do not exceed 2^vars. 
     */
    printf("\nDoes your text-file contain following minterms?\n");
    if(pMinterms->numMinterms > (1<<pMinterms->vars))
    {
        fprintf(stderr, "ERROR : Number of minterms are larger than expected for %d variables "
                , pMinterms->vars);
        exit(-10);
    }

}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  binaryVectorToInt
 *  Description:  Convert a binary vector to int. For instant a vector "0110"
 *  is converted to 6.
 *
 *  Note that vector is an array and lower index of this array is lsb.
 * =====================================================================================
 */
unsigned int binaryVectorToInt(unsigned* vector, unsigned len)
{
    if(len == 0)
        return 0;
    int i, sum = 0;
    for(i = 0; i < len; i++)
        if(1 == *(vector+i))
            sum += (1<<i);
        else if(0 != *(vector+i))
        {
            fprintf(stderr, "ERROR : Only 0 and 1 are allowed in the argument. \n");
            fprintf(stderr, "++ Invalid entry at index %d in first argument of function binaryVectorToInt \n", i);
            fprintf(stderr, "  I am quitting ...\n");
            exit(-12);
        }
    return sum;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  intToBinaryVector
 *  Description:  Convert a given unsigned integer to a binary vector of given
 *  length
 * =====================================================================================
 */
unsigned* intToBinaryVector(unsigned num, unsigned len)
{
    unsigned result[len+1];
    unsigned temp = num;
    int i;
    for(i = 0; i < len; i++)
    {
        *(result+i) = temp % 2;
        temp = temp/2;
    }
    return result;
}

