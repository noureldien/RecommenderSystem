/*% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.
 */

#include "mex.h"
#include "./lib/ex-utils.h"

void CheckInput(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Check for proper number of arguments. */
  if (nrhs != 4 || mxGetClassID(prhs[0]) != mxDOUBLE_CLASS || mxGetClassID(prhs[1]) != mxDOUBLE_CLASS ||mxGetClassID(prhs[2]) != mxINT32_CLASS || mxGetClassID(prhs[3]) != mxINT32_CLASS)
    mexErrMsgTxt("calculate Q for PMF3.\n\
		Usage: Q=PTF_ComputeQ(F1, F2, i1, i2)\n\
        F1, F2: two factors\n\
        i1, i2: subset of F1 and F2. int32\n");
}
#define GetColStart(dd, mm, nn, cc) ((dd) + (cc)*(mm))

inline void ElemProd(double* f1, double* f2, double* q, mwSize d)
{
  double* guard;
  guard = q + d;
  for(; q < guard ; f1 ++, f2 ++, q ++)
    *q=(*f1)*(*f2);
}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
  mwSize d, n1, n2, l;
  double *pF1, *pF2, *pQ;
  INT32 *pI1, *pI2;
  register mwSize i;
	
  CheckInput(nlhs, plhs, nrhs, prhs);
    
  pF1=mxGetPr(prhs[0]);
  n1=mxGetN(prhs[0]);
  d=mxGetM(prhs[0]);
  pF2=mxGetPr(prhs[1]);
  n2=mxGetN(prhs[1]);
  if(mxGetM(prhs[1]) != d)
    mexErrMsgTxt("internal error: dimension wrong.\n");
    
  pI1=(INT32*)mxGetPr(prhs[2]);
  l=mxGetNumberOfElements(prhs[2]);
  pI2=(INT32*)mxGetPr(prhs[3]);
  if(mxGetNumberOfElements(prhs[3]) != l)
    mexErrMsgTxt("internal error: index length wrong.\n");
    	
  //result
  plhs[0]=mxCreateDoubleMatrix(d, l, mxREAL);
  pQ=mxGetPr(plhs[0]);
	
  for(i = 0 ; i < l ; i ++)
    ElemProd(GetColStart(pF1, d, n1, pI1[i] - 1),
	     GetColStart(pF2, d, n2, pI2[i] - 1),
	     GetColStart(pQ, d, l, i), d);
}
