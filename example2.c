#include <stdio.h>
#include <omp.h>
int main()
{
	#pragma omp parallel num_threads(7)
	{
		printf("Hello World\n");
	}
}
