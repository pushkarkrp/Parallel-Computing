#include <stdio.h>
#include <omp.h>
int main()
{
	int a[100000],i;
	#pragma omp parallel for
	for(i=0;i<100000;i++){
    		a[i] = 2 * i;
	}
}
