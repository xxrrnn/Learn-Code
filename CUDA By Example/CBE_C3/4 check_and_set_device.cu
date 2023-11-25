#include<iostream>
//#include "../source_code/common/book.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime_api.h"

int main(void) {
	cudaDeviceProp prop;
	int dev;

	cudaGetDevice(&dev);
	printf("ID of current CUDA device: %d \n", dev);

	memset(&prop, 0, sizeof(cudaDeviceProp));

	prop.major = 1;
	prop.minor = 3;
	cudaChooseDevice(&dev, &prop);
	printf("ID of CUDA device closest to revision 1.3: %d/n", dev);
	cudaSetDevice(dev);
}