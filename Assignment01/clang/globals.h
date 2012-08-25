/*
 * =====================================================================================
 *
 *       Filename:  globals.h
 *
 *    Description:  Header file for definitions.
 *
 *        Version:  1.0
 *        Created:  08/18/2012 04:07:26 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dilawar Singh , dilawar@ee.iitb.ac.in
 *   Organization:  EE, IIT Bombay
 *
 * =====================================================================================
 */

#ifndef  globals_INC
#define  globals_INC

typedef enum boolean { FALSE, TRUE,  DNTCR} boolean_t;

/*-----------------------------------------------------------------------------
 *  Structure of a single boolean term.
 *
 *  For instance if a term is xy'z then its size is 3 and term = [TRUE, FALSE,
 *  TRUE]; Note that variable name is not important. You can see this term as
 *  '101'.
 *
 *  For term wx-z' or '11-0' size is 4 and term = [TRUE, TRUE, DNTCR, FALSE] 
 *
 *-----------------------------------------------------------------------------*/
#define MAX_SIZE 1024
typedef struct 
{
    unsigned size; /* size of the minterm */
    boolean_t term[MAX_SIZE];
} term_t;

/*-----------------------------------------------------------------------------
 *  Struture to hold sum of product. Variable 'vars' is number of variables in
 *  function.
 *  
 *  If a function is 
 *     f(w,x,y,z) = SOP(0,1,5,7,8,9,10,13,15), then 
 *  vars = 4 and 
 *  minterms[8] = {term_t for 0, term_t for 1,  ..., term_t for 15}
 *  
 *  term_t for 1 : size = 4, term[4] = {FALSE, FALSE, TRUE}.
 *
 *  Note that if there is no don't care (DNTCR) then term is a minterm.
 *-----------------------------------------------------------------------------*/ 
#define MAX_TERMS 10*1024
#define MAX_VARS  1024
typedef struct 
{
    unsigned vars;
    unsigned nSOP;
    term_t terms[MAX_TERMS]; 
} sop_t;

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  processInputFileToStoreMinterms
 *  Description:  This function open the file 'filename', parse it, and build
 *  the data-struture 'minterms' meant to store the minterms.
 *
 * =====================================================================================
 */
void processInputFileToStoreMinterms(const char* filename, sop_t* pSops);


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  intToMinterm
 *  Description:  Convert an integer to a minterm
 * =====================================================================================
 */
void intToMinterm(term_t* pTerm, unsigned num, unsigned n);


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  quineMcClusky
 *  Description:  Compute minimal form of a binary function
 * =====================================================================================
 */
void quineMcClusky(sop_t* minterms, sop_t* minimal);


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  binaryVectorToInt
 *  Description:  Convert a binary vector to its equivalent unsigned int
 *  value.
 * =====================================================================================
 */
unsigned binaryVectorToInt(unsigned* vec, unsigned len);


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  intToBinaryVector
 *  Description:  Convert an unsigned integer to ints binary vector form.
 * =====================================================================================
 */
void intToBinaryVector(unsigned val, unsigned len, unsigned* vec);

#endif   /* ----- #ifndef globals_INC  ----- */
