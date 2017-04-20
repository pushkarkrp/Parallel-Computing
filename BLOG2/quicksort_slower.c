#include<bits/stdc++.h>
#define n 100000000
int arr[n];
/* This function takes first element as pivot, places
   the pivot element at its correct position in sorted
    array, and places all smaller (smaller than pivot)
   to left of pivot and all greater elements to right
   of pivot */
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

/* The main function that implements QuickSort
 arr[] --> Array to be sorted,
  low  --> Starting index,
  high  --> Ending index */
void quicksort(int arr[], int low, int high)
{
	int j;

	if(low < high){
		j = partition(arr, low, high);

		#pragma omp parallel sections
		{
			#pragma omp section
			{
        			quicksort(arr,0, j - 1);//Thread 1
    			}
			#pragma omp section
			{
        			quicksort(arr, j + 1, n-1);//Thread 2
   			}
		}
	}
}


int main()
{
	int start_s=clock();//start time
	for(int i=0;i<n;i++){
		arr[i]=rand()%n;//filling random value
	}
  quicksort(arr, 0, n - 1);//calling quicksort function
	int stop_s=clock();//end Time
	printf("Time taken: %.6fs\n", (double)(stop_s - start_s)/CLOCKS_PER_SEC);
}
