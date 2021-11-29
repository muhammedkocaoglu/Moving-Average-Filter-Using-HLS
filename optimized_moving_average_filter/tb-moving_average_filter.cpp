#include "moving_average_filter.h"
#include <vector>
#include <iostream>

#include <fstream>
#include <sstream>
#include <string>


#include <iterator>
#include <algorithm> // for std::copy


using namespace std;

template< typename T > vector< T > loadtxt_1D( const string &filename );
template< typename T > void print_1D( const vector< T > &data );

int main()
{
	float result{0.0};

	auto aVect = loadtxt_1D<float>("noisy_signal.txt");
	print_1D<float>(aVect);

	cout << "moving average results: " << endl;
	for (int i = 0; i < aVect.size()-10; i++) {
		moving_average_filter(aVect[i], aVect[i + 10], &result);
		cout << result  <<endl;
	}

	return 0;
}


// initialize a vector from file
template< typename T > vector< T > loadtxt_1D( const string &filename )
{
	std::ifstream is(filename);
	std::istream_iterator<float> start(is), end;
	std::vector<float> numbers(start, end);
	std::cout << "Read " << numbers.size() << " numbers" << std::endl;

	return numbers;
}

// print the vector
template< typename T > void print_1D( const vector< T > &data )
{
	std::copy(	data.begin(),
				data.end(),
			    std::ostream_iterator<double>(std::cout, "\n"));
	std::cout << std::endl;
}



