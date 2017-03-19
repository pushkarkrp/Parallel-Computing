#include<bits/stdc++.h>
#define n 100000000
int arr[n];
int partition(int arr[], int low, int high){
	int i, j, temp, key;
	key = arr[low];
	i= low + 1;
	j= high;
	while(1){
		while(i < high && key >= arr[i])
    			i++;
		while(key < arr[j])
    			j--;
		if(i < j){
			temp = arr[i];
			arr[i] = arr[j];
			arr[j] = temp;
		}
		else{
			temp= arr[low];
			arr[low] = arr[j];
			arr[j]= temp;
			return(j);
		}
	}
}


void quicksort(int arr[], int low, int high)
{
	int j;

	if(low < high){
		j = partition(arr, low, high);

		quicksort(arr, low, j - 1);
		quicksort(arr, j + 1, high);

	}
}


int main()
{
	int start_s=clock();
	for(int i=0;i<n;i++){
		arr[i]=rand()%n;
	}

	int j = partition(arr,0,n-1);
		#pragma omp parallel sections
		{
			#pragma omp section
			{
        			quicksort(arr,0, j - 1);
    			}
			#pragma omp section
			{
        			quicksort(arr, j + 1, n-1);
   			}
		}
	int stop_s=clock();
	printf("Time taken: %.6fs\n", (double)(stop_s - start_s)/CLOCKS_PER_SEC);
}
