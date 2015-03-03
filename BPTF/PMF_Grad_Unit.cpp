/*% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.
 */

#include "mex.h"
#include <memory.h>
#include "./lib/ex-utils.h"

static mwSize m, n, d, nz;
static double *pU, *pV, *buffer;
static double learnRate, ridge;

void CheckInput(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Check for proper number of arguments. */
  if (nrhs != 8 || !mxIsInt32(prhs[0]) || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[2]) || !mxIsDouble(prhs[3]))
    mexErrMsgTxt("estimate PMF by gradient descent.\n\
		Usage: [newU, newV]=PMF_Grad_Unit(subs, vals, U, V, learnRate, ridge, startIndex, count)\n\
        subs, vals: the indeces and values from the tensor. \n\
        U, V: factors. double.\n\
        learnRate: learning rate\n\
        ridge: ridge penalty\n\
        startIndex: index of starting samples\n\
        count: number of samples to apply.\n");
}

#define GetColStart(dd, mm, nn, cc) ((dd) + (cc)*(mm))
double InnerProd(double* v1, double* v2, mwSize length)
{
  register double result;
  register mwSize i;
    
  for(i = 0, result = 0; i < length ; ++i)
    result += v1[i]*v2[i];
    
  return result;
}
inline void train(INT32 ui, INT32 vi, double val)
{
  double err;
  double *pu, *pv;
  register mwSize i;
    
  pu=GetColStart(pU, d, m, ui);
  pv=GetColStart(pV, d, n, vi);
    
  err=val - InnerProd(pu, pv, d);
  memcpy(buffer, pu, sizeof(double)*d);
  for(i = 0 ; i < d ; i ++) {
    pu[i] += learnRate*(err*pv[i] - ridge*buffer[i]);
    pv[i] += learnRate*(err*buffer[i] - ridge*pv[i]);
  }
}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
  double *pR;
  INT32 *pS1, *pS2;
  mwIndex startIndex, count;
  register mwIndex i, k, nz1;
	
  CheckInput(nlhs, plhs, nrhs, prhs);
    
  if(mxGetN(prhs[0]) != 2)
    mexErrMsgTxt("subs should have 2 columns");
  nz=mxGetM(prhs[0]);
  pS1=(INT32*)mxGetPr(prhs[0]);
  pS2=GetColStart(pS1, nz, 2, 1);
    
  if(mxGetM(prhs[1]) != nz)
    mexErrMsgTxt("vals should have the same height as subs");
  pR=mxGetPr(prhs[1]);
    
  m=mxGetN(prhs[2]);
  d=mxGetM(prhs[2]);
  pU=mxGetPr(prhs[2]);
    
  n=mxGetN(prhs[3]);
  if(mxGetM(prhs[3]) != d)
    mexErrMsgTxt("V should have the same dim as U");
  pV=mxGetPr(prhs[3]);
    
  learnRate=mxGetScalar(prhs[4]);
  ridge=mxGetScalar(prhs[5]);
  startIndex=(mwIndex)mxGetScalar(prhs[6]) - 1;
  count=(mwIndex)mxGetScalar(prhs[7]);
    	
  //result
  plhs[0]=mxCreateDoubleMatrix(d, m, mxREAL);
  memcpy(mxGetPr(plhs[0]), pU, sizeof(double)*d*m);
  pU=mxGetPr(plhs[0]);
  plhs[1]=mxCreateDoubleMatrix(d, n, mxREAL);
  memcpy(mxGetPr(plhs[1]), pV, sizeof(double)*d*n);
  pV=mxGetPr(plhs[1]);
    
  buffer=(double*)mxCalloc(d, sizeof(double));
	
  nz1=nz - 1;
  for(i = 0, k=startIndex ; i < count ; ++ i, k = k==nz1 ? 0 : k+1)
    train(pS1[k] - 1, pS2[k] - 1, pR[k]);
}
