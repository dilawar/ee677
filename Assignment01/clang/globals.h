/*
 * =====================================================================================
 *
 *       Filename:  globals.h
 *
 *    Description:  header file for definitions.
 *
 *        Version:  1.0
 *        Created:  08/18/2012 04:07:26 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dilawar Singh (), dilawar@ee.iitb.ac.in
 *   Organization:  
 *
 * =====================================================================================
 */

#ifndef  globals_INC
#define  globals_INC

/*-----------------------------------------------------------------------------
 *  Struture to hold minterms. Variable 'vars' is number of variables 
 *  and array of unsigned int are minterms. For example, if a function 
 *     f(w,x,y,z) = SOP(0,1,5,7,8,9,10,13,15), then 
 *  vars = 4 and 
 *  minterms[8] = {0,1,5,7,8,9,10,13,15}
 *
 *  Structure is made into a typedef.
 *-----------------------------------------------------------------------------*/ 
#define MAX_TERMS 10*1024
#define MAX_VARS  1024
typedef struct 
{
    unsigned int vars;
    unsigned int numMinterms;
    unsigned int minterms[MAX_TERMS]; 
    unsigned indices[MAX_VARS];
} minterms_t;


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  processInputFileToStoreMinterms
 *  Description:  This function open the file 'filename', parse it, and build
 *  the data-struture 'minterms' meant to store the minterms.
 *
 * =====================================================================================
 */
void processInputFileToStoreMinterms(const char* filename, minterms_t* minterms);

#endif   /* ----- #ifndef globals_INC  ----- */
