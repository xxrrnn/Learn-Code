#include "cuda.h"
#include<iostream>

#include "cuda_texture_types.h"
//#include "../source_code/common/book.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime_api.h"
#include "../source_code/common/book.h"
#include "../source_code/common/cpu_anim.h"

texture<int> testIn;
texture<int> testOUT;

__global__ void test_kernel(int* dst) {
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	int c = tex1Dfetch(testIn, tid);
	dst[tid] = c * c;
}
__global__ void test_kernel_no_texture(int* dst, int * a) {
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	int c = a[tid];
	dst[tid] = c * c;
}


int main(void) {
	int* a, *b;
	cudaMalloc((void**)&a, sizeof(int) * 100000);
	cudaMalloc((void**)&b, sizeof(int) * 100000);
	cudaBindTexture(NULL, testIn, a, sizeof(int) * 100000);
	cudaBindTexture(NULL, testOUT, b, sizeof(int) * 100000);
	
	int* temp = (int*)malloc(100000 * sizeof(int));
	for (int i = 0; i < 100000; i++) {
		temp[i] = i*i;
		//temp2[i] = 2 * i;
		//printf("temp = %d\n", temp[i]);
	}
	cudaMemcpy(a, temp, sizeof(int) * 100000, cudaMemcpyHostToDevice);
	//cudaMemcpy(b, temp2, sizeof(int) * 100000, cudaMemcpyHostToDevice);
	
	
	cudaEvent_t     start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);
	test_kernel << <256, 256 >> > (b);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	float   elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("Time to generate:  %3.1f ms\n", elapsedTime);

	cudaEvent_t     start_2, stop_2;
	cudaEventCreate(&start_2);
	cudaEventCreate(&stop_2);
	cudaEventRecord(start_2, 0);
	test_kernel_no_texture << <256, 256 >> > (b,a);
	cudaEventRecord(stop_2, 0);
	cudaEventSynchronize(stop_2);
	//float   elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start_2, stop_2);
	printf("Time to generate:  %3.1f ms\n", elapsedTime);




	int* output2 = (int*)malloc(100000 * sizeof(int));

	cudaMemcpy(output2, b, 100000 * sizeof(int), cudaMemcpyDeviceToHost);
	for (int i = 0; i < 100000; i++)
	{
		//printf("output2[%d]= %d\n", i, output2[i]);
	}
	cudaUnbindTexture(testIn);
	cudaUnbindTexture(testOUT);
	cudaFree(a);
	cudaFree(b);
	

	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	free(temp);

	return 0;
}