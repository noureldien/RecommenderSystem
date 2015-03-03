/*% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.
 */

#include <utility>
#include "mex.h"
#include "ex-utils.h"

using namespace std;

void CheckInput(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Check for proper number of arguments. */
  if (nrhs != 2 || 
      mxGetClassID(prhs[0]) != mxINT64_CLASS ||
      mxGetClassID(prhs[1]) != mxINT64_CLASS) {
    mexErrMsgTxt("encode a int64 array.\n\
		Usage: B=EncodeInt64Array(A, codebook)\n\
        A: original array. \n\
		codebook: codebook for A.\n");
  }
}

//input the strongly influence relationship matrix, output the selected nodes
void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
  mwSize n, nCodes, i;
  INT64 *pA, *pC;
  INT32 *pB;
  hash_map<INT64, INT32> ht;
  hash_map<INT64, INT32> :: const_iterator iter;
	
  CheckInput(nlhs, plhs, nrhs, prhs);
    
  pA=(INT64*)mxGetPr(prhs[0]);
  pC=(INT64*)mxGetPr(prhs[1]);
  n=mxGetNumberOfElements(prhs[0]);
  nCodes=mxGetNumberOfElements(prhs[1]);
    
  //result
  plhs[0]=mxCreateNumericMatrix(mxGetM(prhs[0]), mxGetN(prhs[0]), mxINT32_CLASS, mxREAL);
  pB=(INT32*)mxGetPr(plhs[0]);
    
  for(i = 0 ; i < nCodes ; i ++)
    ht.insert(pair <INT64, INT32>(pC[i], i + 1));
    
  for(i = 0 ; i < n ; i ++) {
    iter = ht.find(pA[i]);
    pB[i] = iter != ht.end() ? iter->second : 0;
  }
}
