#include "threefry.h"

__kernel void brownian( const int Mdim, const int Ndim, const float diffus,
      __global float* vel)
{
  int i = get_global_id(0);
  if(i+2 < Mdim) {
    const unsigned int MAXINT = 4294967294;
    threefry4x32_key_t k = {{i, 0xdecafbad, 0xfacebead, 0x12345678}};
    threefry4x32_ctr_t c = {{0, 0xf00dcafe, 0xdeadbeef, 0xbeeff00d}};
    union {
        threefry4x32_ctr_t c;
        int4 i;
    } u;
    c.v[0]++;
    u.c = threefry4x32(c, k);
    long x1 = u.i.x, y1 = u.i.y;
    long x2 = u.i.z, y2 = u.i.w;
    vel[i*Ndim] = diffus*(2.0*(float)x1/MAXINT-1.0);
    vel[i*Ndim+1] = diffus*(2.0*(float)y1/MAXINT-1.0);
    vel[i*Ndim+2] = diffus*(2.0*(float)x2/MAXINT-1.0);
    // Ndim = 3 at most
    //vel[i*Ndim+3] = diffus*(2.0*(float)y2/MAXINT-1.0);
  }
}


__kernel void ranTest( const int Mdim, __global float* mat ) {
  unsigned int i = get_global_id(0);
  if(i*4+3 < Mdim) {
    const unsigned int MAXINT = 4294967294;
    threefry4x32_key_t k = {{i, 0xdecafbad, 0xfacebead, 0x12345678}};
    threefry4x32_ctr_t c = {{0, 0xf00dcafe, 0xdeadbeef, 0xbeeff00d}};
    union {
        threefry4x32_ctr_t c;
        int4 i;
    } u;
    c.v[0]++;
    u.c = threefry4x32(c, k);
    long x1 = u.i.x, y1 = u.i.y;
    long x2 = u.i.z, y2 = u.i.w;
    mat[i*4] = (float)x1/MAXINT;
    mat[i*4+1] = (float)x2/MAXINT;
    mat[i*4+2] = (float)y1/MAXINT;
    mat[i*4+3] = (float)y2/MAXINT;
    /*
    float tmp_bm = sqrt(fmax(pow(-2.0,log(mat[i*4])), 0.0));
    mat[i*4]  = tmp_bm*cos(2.0*M_PI_F*mat[i*4+1]);
    mat[i*4+1] = tmp_bm*sin(2.0*M_PI_F*mat[i*4+1]);
    tmp_bm = sqrt(fmax(pow(-2.0,log(mat[i*4+2])), 0.0));
    mat[i*4+2]  = tmp_bm*cos(2.0*M_PI_F*mat[i*4+3]);
    mat[i*4+3] = tmp_bm*sin(2.0*M_PI_F*mat[i*4+3]);
    */
  }
}

__kernel void move( const int Mdim, const int Ndim,
  __global float* pos, __global float* vel, const float dt, const float diffus)
{
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  if(i < Mdim && j < Ndim) {
    //vel[i*Ndim+j] = diff*2.0*randoms[i*Ndim+j]-0.5;
    const unsigned int MAXINT = 4294967294;
    //threefry4x32_key_t k = {{i, 0xdecafbad, 0xfacebead, 0x12345678}};
    //threefry4x32_ctr_t c = {{0, 0xf00dcafe, 0xdeadbeef, 0xbeeff00d}};
    threefry4x32_key_t k = {{i*j, 0xdecafbad, 0xfacebead, 0x12345678}};
    threefry4x32_ctr_t c = {{0, 0xf00dcafe, 0xdeadbeef, 0xbeeff00d}};
    union {
        threefry4x32_ctr_t c;
        int4 i;
    } u;
    c.v[0]++;
    u.c = threefry4x32(c, k);
    float x1 = (2.0*(float)(u.i.x)/MAXINT-1.0);
    float x2 = (2.0*(float)(u.i.y)/MAXINT-1.0);
    //float y1 = (2.0*(float)(u.i.z)/MAXINT-1.0);
    //float y2 = (2.0*(float)(u.i.w)/MAXINT-1.0);
    float y1 = sqrt(-2.0*log(x1))*cos(2.0*M_PI_F*x2);
    float y2 = sqrt(-2.0*log(x1))*sin(2.0*M_PI_F*x2);
    vel[i*Ndim+j] = diffus*x1;

    pos[i*Ndim+j] += vel[i*Ndim+j]*dt;
  }
}

