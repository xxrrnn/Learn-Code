/*
手打版本，遇到的问题有:
prop部分还是不太会写
cudamemcpy搞反了目标和源，从主机到设备，是设备指针为目标；
从设备到主机，是主机指针为目标
kernel函数，最后是要用threadIdx.x作为index，而不是buffer[i]
从现在开始，所有代码都要按照，读 理解 自己写 debug 参考模式
*/

#include "cuda.h"
#include<iostream>

#include "cuda_texture_types.h"
//#include "../source_code/common/book.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime_api.h"
#include "../source_code/common/book.h"
#include "../source_code/common/cpu_anim.h"

#define SIZE (100*1024*1024)

__global__ void histo_kernel_shared(unsigned char* buffer,
	long size,
	unsigned int* histo) {
	
	__shared__ unsigned int temp[256];
	temp[threadIdx.x] = 0;
	__syncthreads();
	int i = threadIdx.x + blockIdx.x * blockDim.x;
	int stride = blockDim.x * gridDim.x;
	while (i < size) {
		atomicAdd( &temp[buffer[i]], 1 );
		i += stride;
	}
	__syncthreads();
	atomicAdd( &(histo[threadIdx.x]), temp[threadIdx.x] );
}

int main(void) {
	unsigned char* buffer =
		(unsigned char*)big_random_block(SIZE);
	unsigned char* dev_buffer;
	unsigned int* dev_histo;

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);

	cudaMalloc((void**)&dev_buffer, SIZE);
	cudaMalloc((void**)&dev_histo, 256 * sizeof(int));
	cudaMemcpy(dev_buffer, buffer, SIZE, cudaMemcpyHostToDevice);
	cudaMemset(dev_histo, 0, 256 * sizeof(int));

	cudaDeviceProp prop;
	cudaGetDeviceProperties(&prop, 0);
	int blocks = prop.multiProcessorCount;

	histo_kernel_shared << <blocks * 2, 256 >> > (dev_buffer, SIZE, dev_histo);
	
	unsigned int histo[256];
	cudaMemcpy(histo, dev_histo, 256 * sizeof(int), cudaMemcpyDeviceToHost);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("Time to generate: %3.1f ms\n", elapsedTime);

	long histoCount = 0;
	for (int i = 0; i < 256; i++) {
		histoCount += histo[i];
	}
	printf("Histogram sum: %ld \n", histoCount);

	for (int i = 0; i < SIZE; i++) {
		histo[buffer[i]]--;
	}
	for (int i = 0; i < 256; i++) {
		if (histo[i] != 0) {
			printf("error: %d \n", i);
		}
	}
	cudaFree(dev_buffer);
	cudaFree(dev_histo);
	free(buffer);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	return 0;
}

/*Time to generate: 44.8 ms
Histogram sum: 104857600*/