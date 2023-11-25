//#include "cuda.h"
//#include<iostream>
//
//#include "cuda_texture_types.h"
////#include "../source_code/common/book.h"
//#include "device_launch_parameters.h"
//#include "cuda.h"
//#include "cuda_runtime_api.h"
//#include "../source_code/common/book.h"
//#include "../source_code/common/cpu_anim.h"
//
//
//
//
//
//
//
//
//#define SIZE (100*1024*1024)
//
//__global__ void histo_kernel_global(unsigned char* buffer,
//	long size,
//	unsigned int* histo) {
//	int i = threadIdx.x + blockIdx.x * blockDim.x;
//	int stride = gridDim.x * blockDim.x;
//	while (i < size) {
//		histo[buffer[i]]++; //这个都是错的，必须用原子加法
//		//atomicAdd(&histo[buffer[i]], 1);
//		i += stride;
//	}
//}
//int main(void) {
//	unsigned char* buffer =
//		(unsigned char*)big_random_block(SIZE);
//	// capture the start time
//   // starting the timer here so that we include the cost of
//   // all of the operations on the GPU.
//	cudaEvent_t     start, stop;
//	cudaEventCreate(&start);
//	cudaEventCreate(&stop);
//	cudaEventRecord(start, 0);
//
//
//	unsigned char *dev_buffer;
//	unsigned int *dev_histo;
//	cudaMalloc((void**)&dev_buffer, SIZE);
//	cudaMemcpy(dev_buffer, buffer, SIZE , cudaMemcpyHostToDevice);
//	cudaMalloc((void**)&dev_histo, 256 * sizeof(int));
//	cudaMemset(dev_histo, 0, 256 * sizeof(int));
//	cudaDeviceProp prop;
//	cudaGetDeviceProperties(&prop, 0);
//	int blocks = prop.multiProcessorCount;
//	histo_kernel_global << <blocks * 2, 256 >> > (dev_buffer, SIZE, dev_histo);
//
//	unsigned int histo[256];
//	cudaMemcpy(histo, dev_histo, 256 * sizeof(int), cudaMemcpyDeviceToHost);
//	cudaEventRecord(stop, 0);
//	float elapsedTime;
//	cudaEventElapsedTime(&elapsedTime, start, stop);
//	printf("Time to generate: %3.1f ms\n", elapsedTime);
//
//	for (int i = 0; i < SIZE; i++) {
//		histo[buffer[i]]--;
//	}
//	for (int i = 0; i < 256; i++) {
//		if (histo[i] != 0) {
//			printf("Failure at %d!  Off by %d\n", i, histo[i]);
//		}
//	}
//	cudaEventDestroy(start);
//	cudaEventDestroy(stop);
//	cudaFree(dev_histo);
//	cudaFree(dev_buffer);
//	free(buffer);
//	return 0;
//	
//	
//}//Time to generate: 162.2 ms 
//
