#include<iostream>
//#include "../source_code/common/book.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime_api.h" 

#define N 100
__global__ void add(int* a, int* b, int* c) {
	int tid = threadIdx.x;  //�����������������
	if (tid < N) {
		c[tid] = a[tid] + b[tid];
	}
}


int main1(void) {
	int a[N], b[N], c[N];
	int* dev_a, * dev_b, * dev_c;
	//��gpu�Ϸ����ڴ�
	cudaMalloc((void**)&dev_a, N*sizeof(int));
	cudaMalloc((void**)&dev_b, N*sizeof(int));
	cudaMalloc((void**)&dev_c, N*sizeof(int));
	//��cpu��Ϊ����ab��ֵ
	for (int i = 0; i < N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}
	//��ab���Ƶ�gpu
	cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

	add <<<1,N>>> (dev_a, dev_b, dev_c); //N���豸��ִ�к˺���ʱʹ�õĲ����߳̿������
	cudaMemcpy(c, dev_c, N * sizeof(int),cudaMemcpyDeviceToHost);
	for (int i = 0; i < N; i++) {
		printf("%d + %d = %d\n", a[i], b[i], c[i]);
	}

	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	return 0;
}