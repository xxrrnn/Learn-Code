#include<iostream>

#include "cuda_texture_types.h"
//#include "../source_code/common/book.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime_api.h"
#include "../source_code/common/book.h"
#define SIZE (64*1024*1024)

float copy_test_hostAlloc(int size, bool up) {
	int* a, * dev_a;
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	cudaHostAlloc((void**)&a,size*sizeof(*a),cudaHostAllocDefault);
	cudaMalloc((void**)&dev_a, size * sizeof(*dev_a));
	//memset(a, 0, size * sizeof(*a));
	//cudaMemset(dev_a, 0, size * sizeof(*a));
	cudaEventRecord(start, 0);
	for (int i = 0; i < 100; i++) {
		if (up) { //up指主机到设备
			cudaMemcpy(dev_a, a, size * sizeof(*dev_a), cudaMemcpyHostToDevice);
		}
		else {
			cudaMemcpy(a, dev_a, size * sizeof(*dev_a), cudaMemcpyDeviceToHost);
		}
	}
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop); //别忘了这个啊
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);


	cudaFree(dev_a);
	cudaFreeHost(a);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	return elapsedTime;
}
float copy_test_malloc(int size, bool up) {
	int* a, * dev_a;
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	a = (int*)malloc(size * sizeof(*a));
	cudaMalloc((void**)&dev_a, size * sizeof(*dev_a));
	//memset(a, 0, size * sizeof(*a));
	//cudaMemset(dev_a, 0, size * sizeof(*a));
	cudaEventRecord(start, 0);
	for (int i = 0; i < 100; i++) {
		if (up) { //up指主机到设备
			cudaMemcpy(dev_a, a, size * sizeof(*dev_a), cudaMemcpyHostToDevice);
		}
		else {
			cudaMemcpy(a, dev_a, size * sizeof(*dev_a), cudaMemcpyDeviceToHost);
		}
	}
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop); //别忘了这个啊
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime, start, stop);


	cudaFree(dev_a);
	free(a);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);


	return elapsedTime;
}

int main1(void) {
	float MB = (float)100 * SIZE * sizeof(int) / 1024 / 1024;
	float elapsedTime;
	elapsedTime = copy_test_malloc(SIZE, true);
	printf("Time using cudaMalloc: %3.If ms\n",
		elapsedTime);
	printf("\tMB / s during copy up : % 3.1f\n" ,
		MB / (elapsedTime / 1000));
	elapsedTime = copy_test_malloc(SIZE, false);
	printf("Time using cudaMalloc: %3.If ms\n",
		elapsedTime);
	printf("\tMB / s during copy down : % 3.1f\n",
		MB / (elapsedTime / 1000));

	elapsedTime = copy_test_hostAlloc(SIZE, true);
	printf("Time using cudaHostAlloc: %3.If ms\n",
		elapsedTime);
	printf("\tMB / s during copy up : % 3.1f\n",
		MB / (elapsedTime / 1000));
	elapsedTime = copy_test_hostAlloc(SIZE, false);
	printf("Time using cudaHostAlloc: %3.If ms\n",
		elapsedTime);
	printf("\tMB / s during copy down : % 3.1f\n",
		MB / (elapsedTime / 1000));

	return 0;
}
/*
Time using cudaMalloc: 4536 ms
		MB / s during copy up :  5644.1
Time using cudaMalloc: 4580 ms
		MB / s during copy down :  5590.1
Time using cudaHostAlloc: 4357 ms
		MB / s during copy up :  5875.9
Time using cudaHostAlloc: 4400 ms
		MB / s during copy down :  5818.6
		*/