#include<iostream>

#include "cuda_texture_types.h"
//#include "../source_code/common/book.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime_api.h"
//#include "../source_code/common/book.h"

#define N   (1024*1024)
#define FULL_DATA_SIZE   (N*20)
//#define FULL_DATA_SIZE   (N*200)

__global__ void single_stream_kernel(int* a, int* b, int* c) { //无特殊含义，只是一个普通函数
	int idx = threadIdx.x + blockIdx.x * blockDim.x;
	if (idx < N) {
		int idx1 = (idx + 1) % 256;
		int idx2 = (idx + 2) % 256;
		float   as = (a[idx] + a[idx1] + a[idx2]) / 3.0f;
		float   bs = (b[idx] + b[idx1] + b[idx2]) / 3.0f;
		c[idx] = (as + bs) / 2;
	}
}

int main(void) {
	cudaDeviceProp prop;
	int whichdevice;
	cudaGetDevice(&whichdevice);
	cudaGetDeviceProperties(&prop, whichdevice);
	if (!prop.deviceOverlap) {
		printf("device will not handle overlaps,so no speed up from streams\n");
		return 0;
	}


	int* host_a, * host_b, * host_c;
	int* dev_a, * dev_b, * dev_c;
	float elapsedTime;
	cudaStream_t stream0;
	cudaStreamCreate(&stream0);
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);


	cudaHostAlloc((void**)&host_a, FULL_DATA_SIZE * sizeof(int), cudaHostAllocDefault);
	cudaHostAlloc((void**)&host_b, FULL_DATA_SIZE * sizeof(int), cudaHostAllocDefault);
	cudaHostAlloc((void**)&host_c, FULL_DATA_SIZE * sizeof(int), cudaHostAllocDefault);

	cudaMalloc((void**)&dev_a, N * sizeof(int));
	cudaMalloc((void**)&dev_b, N * sizeof(int));
	cudaMalloc((void**)&dev_c, N * sizeof(int));

	for (int i = 0; i < FULL_DATA_SIZE; i++) {
		host_a[i] = rand();
		host_b[i] = rand();
	}

	cudaEventRecord(start, 0);
	for (int i = 0; i < FULL_DATA_SIZE; i += N) {
		cudaMemcpyAsync(dev_a, host_a + i, N * sizeof(int), cudaMemcpyHostToDevice,stream0);
		cudaMemcpyAsync(dev_b, host_b + i, N * sizeof(int), cudaMemcpyHostToDevice, stream0);
		single_stream_kernel << <N / 256, 256 ,0,stream0>> > (dev_a, dev_b, dev_c);
		cudaMemcpyAsync(host_c + i, dev_c, N * sizeof(int), cudaMemcpyDeviceToDevice, stream0);

	}
	
	cudaStreamSynchronize(stream0);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("Time taken: %3.1f ms\n", elapsedTime);

	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	cudaFreeHost(host_a);
	cudaFreeHost(host_b);
	cudaFreeHost(host_c);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	cudaStreamDestroy(stream0);

	return 0;
}
/*
Time taken: 50.8 ms

Time taken: 756.0 ms
*/