
//#include "../source_code/common/book.h"
//
//
//#define SIZE (100*1024*1024)
//
//int main(void) {
//	unsigned char* buffer = 
//			(unsigned char*)big_random_block(SIZE);
//	clock_t  start, stop;
//	start = clock();
//
//	unsigned int histo[256];
//	for (int i = 0; i < 256; i++)
//		histo[i] = 0;
//	for (int i = 0; i < SIZE; i++)
//		histo[buffer[i]]++;
//
//	stop = clock();
//	float elapsedTime = (float)(stop - start) / 
//						(float)CLOCKS_PER_SEC * 1000.0f;;
//	printf("Time to generate:  %3.1f ms\n", elapsedTime);
//
//	long histoCount = 0;
//	for (int i = 0; i < 256; i++) {
//		histoCount += histo[i];
//	}
//	printf("Histogram Sum:  %ld\n", histoCount);
//
//	free(buffer);
//	//system("pause");
//	return 0;
//}
///*Time to generate:  133.0 ms
//Histogram Sum:  104857600*/