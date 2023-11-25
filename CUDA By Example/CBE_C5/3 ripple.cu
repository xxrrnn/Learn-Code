#include<iostream>
//#include "../source_code/common/book.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime_api.h" 
#include "../source_code/common/cpu_anim.h"
#define DIM 2048
#define PI 3.1415926535897932f

__global__ void kernel_ripple(unsigned char* ptr, int ticks) {
    // map from threadIdx/BlockIdx to pixel position
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y * blockDim.y;
    int offset = x + y * blockDim.x * gridDim.x;

    // now calculate the value at that position
    float fx = x - DIM / 2;
    float fy = y - DIM / 2;
    float d = sqrtf(fx * fx + fy * fy);
    unsigned char grey = (unsigned char)(128.0f + 127.0f *
        cos(d / 10.0f - ticks / 7.0f) /
        (d / 10.0f + 1.0f));
    ptr[offset * 4 + 0] = grey;
    ptr[offset * 4 + 1] = grey;
    ptr[offset * 4 + 2] = grey;
    ptr[offset * 4 + 3] = 255;
}


struct DataBlock {
	unsigned char* dev_bitmap;
	CPUAnimBitmap* bitmap;
};

void cleanup(DataBlock* d) {
	cudaFree(d->dev_bitmap);
}

void generate_frame(DataBlock* d, int ticks) {
	dim3 blocks(DIM / 16, DIM / 16);
	dim3 threads(16, 16);
    kernel_ripple << <blocks, threads >> > (d->dev_bitmap, ticks);
	cudaMemcpy(d->bitmap->get_ptr(), d->dev_bitmap, d->bitmap->image_size(), cudaMemcpyDeviceToHost);
}

int main3(void) {
	DataBlock data;
	CPUAnimBitmap bitmap(DIM, DIM, &data);
	data.bitmap = &bitmap;
	cudaMalloc((void**)&data.dev_bitmap, bitmap.image_size());
	bitmap.anim_and_exit((void(*)(void*, int))generate_frame,
		(void(*)(void*))cleanup);
	return 0;
}