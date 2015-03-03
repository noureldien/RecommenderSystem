/*% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.
 */

#ifndef EXUTILS_H
#define EXUTILS_H

#include <math.h>

#if defined(_MSC_VER)

typedef unsigned __int8 BYTE;
typedef __int16 INT16;
typedef unsigned __int16 UINT16;
typedef __int32 INT32;
typedef unsigned __int32 UINT32;
typedef  __int64 INT64;
typedef unsigned __int64 UINT64;

#include <hash_map>
#include <hash_set>
using namespace std;
using namespace stdext;

#else

#include <stdint.h>

typedef uint8_t BYTE;
typedef int16_t INT16;
typedef uint16_t UINT16;
typedef int32_t INT32;
typedef uint32_t UINT32;
typedef int64_t INT64;
typedef uint64_t UINT64; 

#include <tr1/unordered_set>
#include <tr1/unordered_map>

using namespace std::tr1;

#define hash_set unordered_set
#define hash_map unordered_map

#endif

#define Index2D(i, j, nrow) ((i) + (j)*(nrow))
#define Index3D(i, j, k, nrow, ncol) ((i) + (j)*(nrow) + (k)*(nrow)*(ncol))

bool Is64()
{
  return sizeof(int) == 8;
}

template<class T>
int ArgMax(T* p, int n) 
{
  int idx = 0;
  T mx = p[idx];

  for (int i = 1 ; i < n ; ++ i) {
    if (p[i] > mx) {
      idx = i;
      mx = p[i];
    }
  }
  
  return idx;
}

template<class T>
int ArgMin(T* p, int n) 
{
  int idx = 0;
  T mn = p[idx];

  for (int i = 1 ; i < n ; ++ i) {
    if (p[i] < mn) {
      idx = i;
      mn = p[i];
    }
  }

  return idx;
}

#endif
