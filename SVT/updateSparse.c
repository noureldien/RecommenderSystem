/* 
 * Stephen Becker, 11/10/08
 * Updates a sparse vector very quickly
 * calling format:
 *      updateSparse(Y,b)
 * which updates the values of Y to be b
 *
 * Modified 11/12/08 to allow unsorted omega
 * (omega is the implicit index: in Matlab, what
 *  we are doing is Y(omega) = b. So, if omega
 *  is unsorted, then b must be re-ordered appropriately 
 * */

#include "mex.h"
#ifndef true
    #define true 1
#endif
#ifndef false
    #define false 0
#endif

void printUsage() {
    mexPrintf("usage:\tupdateSparse(Y,b)\nchanges the sparse Y matrix");
    mexPrintf(" to have values b\non its nonzero elements.  Be careful:\n\t");
    mexPrintf("this assumes b is sorted in the appropriate order!\n");
    mexPrintf("If b (i.e. the index omega, where we want to perform Y(omega)=b)\n");
    mexPrintf("  is unsorted, then call the command as follows:\n");
    mexPrintf("\tupdateSparse(Y,b,omegaIndx)\n");
    mexPrintf("where [temp,omegaIndx] = sort(omega)\n");
}

void mexFunction(
         int nlhs,       mxArray *plhs[],
         int nrhs, const mxArray *prhs[]
         )
{
    /* Declare variable */
    int M, N, i, j, m, n;
    double *b, *S, *omega;
    int SORTED = true;
    
    /* Check for proper number of input and output arguments */    
    if ( (nrhs < 2) || (nrhs > 3) )  {
        printUsage();
        mexErrMsgTxt("Needs 2 or 3 input arguments");
    } 
    if ( nrhs == 3 ) SORTED = false;
    if(nlhs > 0){
        printUsage();
        mexErrMsgTxt("No output arguments!");
    }
    
    /* Check data type of input argument  */
    if (!(mxIsSparse(prhs[0])) || !((mxIsDouble(prhs[1]))) ){
        printUsage();
        mexErrMsgTxt("Input arguments wrong data-type (must be sparse, double).");
    }   

    /* Get the size and pointers to input data */
    /* Check second input */
    N = mxGetN( prhs[1] );
    M = mxGetM( prhs[1] );
    if ( (M>1) && (N>1) ) {
        printUsage();
        mexErrMsgTxt("Second argument must be a vector");
    }
    N = (N>M) ? N : M;

    
    /* Check first input */
    M = mxGetNzmax( prhs[0] );
    if ( M != N ) {
        printUsage();
        mexErrMsgTxt("Length of second argument must match nnz of first argument");
    }

    /* if 3rd argument provided, check that it agrees with 2nd argument */
    if (!SORTED) {
       m = mxGetM( prhs[2] );
       n = mxGetN( prhs[2] );
       if ( (m>1) && (n>1) ) {
           printUsage();
           mexErrMsgTxt("Third argument must be a vector");
       }
       n = (n>m) ? n : m;
       if ( n != N ) {
           printUsage();
           mexErrMsgTxt("Third argument must be same length as second argument");
       }
       omega = mxGetPr( prhs[2] );
    }

    
    b = mxGetPr( prhs[1] );
    S = mxGetPr( prhs[0] );

    if (SORTED) {
        /* And here's the really fancy part:  */
        for ( i=0 ; i < N ; i++ )
            S[i] = b[i];
    } else {
        for ( i=0 ; i < N ; i++ ) {
            /* this is a little slow, but I should really check
             * to make sure the index is not out-of-bounds, otherwise
             * Matlab could crash */
            j = (int)omega[i]-1; /* the -1 because Matlab is 1-based */
            if (j >= N){
                printUsage();
                mexErrMsgTxt("Third argument must have values < length of 2nd argument");
            }
/*             S[ j ] = b[i]; */  /* this is incorrect */
            S[ i ] = b[j];  /* this is the correct form */
        }
    }
}