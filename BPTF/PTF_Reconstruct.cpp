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
  if (nrhs != 4 || mxGetClassID(prhs[0]) != mxINT32_CLASS || mxGetClassID(prhs[1]) != mxDOUBLE_CLASS ||mxGetClassID(prhs[2]) != mxDOUBLE_CLASS || mxGetClassID(prhs[3]) != mxDOUBLE_CLASS)
    mexErrMsgTxt("calculate the reconstructed value for PMF3.\n\
		Usage: val=PTF_Reconstruct(subs, U, V, T)\n\
        subs: the indeces from the tensor. int32.\n\
        U, V, T: factors. double.\n\
        val(ind)=sum(U(:, subs(ind, 1)).*V(:, subs(ind, 2)).*T(:, subs(ind, 3)));\n");
}

inline double InnerProd3(double* v1, double* v2, double* v3, mwSize length)
{
  register double result;
  register mwSize i;
    
  result = 0;
  for(i = 0 ; i < length ; ++ i)
    result += v1[i]*v2[i]*v3[i];
    
  return result;
}
#define GetColStart(dd, mm, nn, cc) ((dd) + (mm)*(cc))
void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
  mwSize m,n,k,d;
  mwIndex nz;
  double *pU, *pV, *pT, *pR ;
  INT32 *pS1, *pS2, *pS3;
  register mwIndex i;
	
  CheckInput(nlhs, plhs, nrhs, prhs);
    
  if(mxGetN(prhs[0]) != 3)
    mexErrMsgTxt("subs should have 3 columns");
  nz=mxGetM(prhs[0]);
  pS1=(INT32*)mxGetPr(prhs[0]);
  pS2=GetColStart(pS1, nz, 3, 1);
  pS3=GetColStart(pS1, nz, 3, 2);
    
  m=mxGetN(prhs[1]);
  d=mxGetM(prhs[1]);
  pU=mxGetPr(prhs[1]);
    
  n=mxGetN(prhs[2]);
  if(mxGetM(prhs[2]) != d)
    mexErrMsgTxt("V should have the same dim as U");
  pV=mxGetPr(prhs[2]);
    
  k=mxGetN(prhs[3]);
  if(mxGetM(prhs[3]) != d)
    mexErrMsgTxt("T should have the same dim as U");
  pT=mxGetPr(prhs[3]);
    	
  //result
  plhs[0]=mxCreateDoubleMatrix(nz, 1, mxREAL);
  pR=mxGetPr(plhs[0]);
	
  for(i = 0 ; i < nz ; i ++)
    pR[i] = InnerProd3(GetColStart(pU, d, m, pS1[i] - 1),
		       GetColStart(pV, d, n, pS2[i] - 1),
		       GetColStart(pT, d, k, pS3[i] - 1), d);
}
