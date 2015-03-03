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
  if (nrhs != 3 || !mxIsInt32(prhs[0]) || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[2]))
    mexErrMsgTxt("calculate the reconstructed value for PMF3.\n\
		Usage: val=PMF_Reconstruct(subs, U, V)\n\
        subs: the indeces from the tensor. int32. \n\
        U, V: factors. double.\n\
        val(ind)=sum(U(:, subs(ind, 1)).*V(:, subs(ind, 2)));\n");
}

#define GetColStart(dd, mm, nn, cc) ((dd) + (cc)*(mm))

double InnerProd(double* v1, double* v2, mwSize length)
{
  register double result;
  register mwSize i;
    
  result = 0;
  for(i = 0 ; i < length ; ++ i)
    result += v1[i]*v2[i];
    
  return result;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
  mwSize m,n,d;
  mwIndex nz;
  double *pU, *pV, *pR;
  INT32 *pS1, *pS2;
  register mwIndex i;
	
  CheckInput(nlhs, plhs, nrhs, prhs);
    
  if(mxGetN(prhs[0]) != 2)
    mexErrMsgTxt("subs should have 2 columns");
  nz=mxGetM(prhs[0]);
  pS1=(INT32*)mxGetPr(prhs[0]);
  pS2=GetColStart(pS1, nz, 2, 1);
    
  m=mxGetN(prhs[1]);
  d=mxGetM(prhs[1]);
  pU=mxGetPr(prhs[1]);
    
  n=mxGetN(prhs[2]);
  if(mxGetM(prhs[2]) != d)
    mexErrMsgTxt("V should have the same dim as U");
  pV=mxGetPr(prhs[2]);
    	
  //result
  plhs[0]=mxCreateDoubleMatrix(nz, 1, mxREAL);
  pR=mxGetPr(plhs[0]);
	
  for(i = 0 ; i < nz ; i ++)
    pR[i] = InnerProd(GetColStart(pU, d, m, pS1[i] - 1),
		      GetColStart(pV, d, n, pS2[i] - 1), d);
}
