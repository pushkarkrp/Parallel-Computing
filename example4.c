#include <stdio.h>
#include <omp.h>
int main()
{
	#pragma omp parallel sections num_threads(3)
   	{
     		#pragma omp section
      		{
        		int tid;
        		tid=omp_get_thread_num();
        		printf("X printed by thread with id=%d\n",tid);
      		}
     		#pragma omp section
      		{
        		int tid;
        		tid=omp_get_thread_num();
        		printf("Y printed by thread with id=%d\n",tid);
      		}
     		#pragma omp section
      		{
        		int tid;
        		tid=omp_get_thread_num();
        		printf("Z printed by thread with id=%d\n",tid);
      		}
   	}
}
