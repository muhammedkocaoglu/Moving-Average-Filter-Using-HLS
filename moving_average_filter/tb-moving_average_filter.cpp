#include <iostream>
#include <fstream>
#include "moving_average_filter.h"

using namespace std;

int main() {

	float result{0.0};
	float average{0.0};

	float arr1[10] = {1.7, 8.7, 4.7, 12.7, 9.4, 0.0, 2.1, 5.5, 8.3, 6.2};

	for (int i = 0; i < SIZE; i++)
		average += arr1[i] / SIZE;
	std::cout << "average: " << average << std::endl;

	moving_average_filter(arr1, &result);
	std::cout << "result: " << result << std::endl;

	if ((average - result) <= 0.001)
		cout << "test passed!" << endl;
	else
		cout << "test failed!" << endl;


	return 0;

}

