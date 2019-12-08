#include <stdio.h>
// Here you can set the device ID that was assigned to you
#define MYDEVICE 0
__global__
void saxpy(unsigned int n, double a, double *x, double *y)
{
  unsigned int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i];
}

int main(void)
{
  cudaSetDevice(MYDEVICE);

  // 1<<N is the equivalent to 2^N
  unsigned int N = 20 * (1 << 20);
  double *x, *y, *d_x, *d_y;
  x = (double*)malloc(N*sizeof(double));
  y = (double*)malloc(N*sizeof(double));

  cudaMalloc(&d_x, N*sizeof(double)); 
  cudaMalloc(&d_y, N*sizeof(double));

  for (unsigned int i = 0; i < N; i++) {
    x[i] = 1.0;
    y[i] = 2.0;
  }

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaMemcpy(d_x, x, N*sizeof(double), cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, y, N*sizeof(double), cudaMemcpyHostToDevice);

  cudaEventRecord(start);

  saxpy<<<(N+511)/512, 512>>>(N, 2.0, d_x, d_y);

  cudaEventRecord(stop);

  cudaMemcpy(y, d_y, N*sizeof(double), cudaMemcpyDeviceToHost);

  cudaEventSynchronize(stop);


  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);

  double maxError = 0.;
  for (unsigned int i = 0; i < N; i++) {
    maxError = max(maxError, abs(y[i]-4.0));
  }
  
  cudaFree(d_x);
  cudaFree(d_y);
  free(x);
  free(y);

}



