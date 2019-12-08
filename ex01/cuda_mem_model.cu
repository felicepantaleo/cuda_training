// includes, system
#include <iostream>
#include <assert.h>

// Here you can set the device ID that was assigned to you
#define MYDEVICE 0

// Simple utility function to check for CUDA runtime errors
void checkCUDAError(const char *msg);

///////////////////////////////////////////////////////////////////////////////
// Program main
///////////////////////////////////////////////////////////////////////////////
int main() 
{
    cudaSetDevice(MYDEVICE);
    // pointer and dimension for host memory
    int dimA = 8;
    float *h_a;

    // pointers for device memory
    float *d_a, *d_b;

    // allocate and initialize host memory
    // Bonus: try using cudaMallocHost in place of malloc
    // it has the same syntax as cudaMalloc, but it enables asynchronous copies
    h_a = (float *) malloc(dimA*sizeof(float));
    for (int i = 0; i<dimA; ++i)
    {
        h_a[i] = i;
    }

    // Part 1 of 5: allocate device memory
    size_t memSize = dimA*sizeof(float);
    cudaMalloc(  );
    cudaMalloc(  );

    // Part 2 of 5: host to device memory copy
    cudaMemcpy(  );

    // Part 3 of 5: device to device memory copy
    cudaMemcpy(  );

    // clear host memory
    for (int i=0; i<dimA; ++i )
    {
        h_a[i] = 0.f;
    }

    // Part 4 of 5: device to host copy
    cudaMemcpy(  );

    // Check for any CUDA errors
    checkCUDAError("cudaMemcpy calls");

    // verify the data on the host is correct
    for (int i=0; i<dimA; ++i)
    {
        assert(h_a[i] == (float) i);
    }

    // Part 5 of 5: free device memory pointers d_a and d_b
    cudaFree( );
    cudaFree( );

    // Check for any CUDA errors
    checkCUDAError("cudaFree");

    // free host memory pointer h_a
    free(h_a);

    // If the program makes it this far, then the results are correct and
    // there are no run-time errors.  Good work!
    std::cout << "Correct!" << std::endl;

    return 0;
}

void checkCUDAError(const char *msg)
{
    cudaError_t err = cudaGetLastError();
    if( cudaSuccess != err) 
    {
        std::cerr << "Cuda error: " << msg << " " << cudaGetErrorString(err) << std::endl;
        exit(-1);
    }                         
}
