#include "moving_average_filter.h"

void moving_average_filter(float A[SIZE], float *average)
{
#pragma HLS array_partition variable=A block factor=10
#pragma HLS INTERFACE ap_none port=average

	static float sum{0.0};


	for (int i = 0; i < SIZE; i++) {
#pragma HLS UNROLL
		sum += A[i];
	}

	*average = sum / SIZE;
}
