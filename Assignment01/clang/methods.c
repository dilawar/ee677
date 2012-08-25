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
void processInputFileToStoreMinterms(const char* fileName, sop_t* pMinterms)
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
    pMinterms->vars = 0;
    while((sizeLine = getline(&line, &len, fp)) != -1)
    {
        char newLine[strlen(line)];
        int i=0, j = 0;
        /*  remove all whitespaces */
        while(line[i]!='\0')
        {
            if(line[i] != ' ')
            {
                newLine[j] = line[i];
                j++;
            }
            i++;
        }
        newLine[j-1] = '\0';
        
        if(strstr(newLine, "vars"))
        {
            char* find = index(newLine, '=');
            varsFound = 1;
            i = 0;
            int digits[10] = {0};
            int count = 0;
            while(find[i+1] != '\0')
            {
                int num = (int)find[i+1] - 48;
                digits[i] = num;
                count++;
                i++;
            }
            int m = 0;
            for(i = 0; i < count; i++)
                m += (digits[count-i-1] * pow(10, i));
            pMinterms->vars = m;
        }

        if(0 == varsFound)
        {
            fprintf(stderr, "\n FATAL : Line containing vars = <num> is not found. \n");
            exit(-3);
        }

        if(strstr(newLine, "minterms"))
        {
            mintermsFound = 1;
            term_t thisTerm = {.size = 0, .term = {0} };
            char* find = index(newLine, '=');
            char* sep;
            while(sep = rindex(find+1, ','))
            {
                int i = 0, count = 0;
                int digits[10] = {0};
                if((int) sep[1] != 0)
                {
                    while(sep[i+1] != '\0')
                    {
                        int num = (int)sep[i+1] - 48;
                        digits[i] = num;
                        count++;
                        i++;
                    }

                    unsigned m = 0;
                    for(i = 0; i < count; i++)
                        m += (digits[count-i-1] * pow(10, i));

                    intToMinterm(&thisTerm, m, (unsigned)pMinterms->vars);
                    pMinterms->terms[pMinterms->nSOP] = thisTerm;
                    pMinterms->nSOP++;
                }
                *sep = '\0';
            }
        }
    }

    fclose(fp);

    /*  Sanity test */
    if(pMinterms->nSOP == 0)
    {
        fprintf(stderr, "ERROR : It is embarassing but I can not parse minterms.\n");
        exit(-9);
    }

    /*
     * Test case : Make sure that number of minterms do not exceed 2^vars. 
     */
    printf("\nDoes your text-file contain following minterms?\n");
    int i, ii;
    for(i = 0; i < pMinterms->nSOP; i++)
    {
        for(ii = 0; ii < pMinterms->vars; ii++)
            printf("%d", pMinterms->terms[i].term[(pMinterms->vars)-ii-1]);
        printf(", ");
    }
    printf("\n");



    if(pMinterms->nSOP > (1<<pMinterms->vars))
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
void intToBinaryVector(unsigned num, unsigned len, unsigned* result)
{
    unsigned temp = num;
    int i;
    for(i = 0; i < len; i++)
    {
        *(result+i) = temp % 2;
        temp = temp/2;
    }
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  intToMinterm
 *  Description:  Gievn an unsigned int, convert it to minterm.
 * =====================================================================================
 */
void intToMinterm(term_t* pTerm, unsigned num, unsigned n)
{
    printf(" |- Converting %d to minterms (%d bit long) \n", num, n);
    int i;
    pTerm->size = n;
    for(i = 0; i < n; i++)
    {
        if( (num&(1<<i)) == 0)
            pTerm->term[i] = FALSE;
        else if( (num&(1<<i)) > 0)
            pTerm->term[i] = TRUE;
        else 
        {
            fprintf(stderr, "FATAL : Invalid !! \n");
            exit(-1);
        }
    }   
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  quineMcClusky
 *  Description:  Quine-McClusky method to minimize a boolean function.
 * =====================================================================================
 */
void quineMcClusky(sop_t* minterms, sop_t* reducedTerms)
{
    printf("\n*********************************************\n");
    printf(" Write your implementation here \n");
    printf("**********************************************\n");


}
