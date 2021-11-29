#include "moving_average_filter.h"

void moving_average_filter(float data_prev, float data_in, float *average)
{
#pragma HLS INTERFACE ap_none port=average
#pragma HLS INTERFACE ap_none port=data_in
#pragma HLS INTERFACE ap_none port=data_prev
	static float sum{0.0};

	sum = sum + data_in/SIZE - data_prev/SIZE;

	*average = sum;
}
