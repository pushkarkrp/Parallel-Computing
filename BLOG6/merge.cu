#include<bits/stdc++.h>
#include <cuda.h>

#define SHARED 8000
  //Device function called locally
__device__ solve(int **tempList, int left_start, int right_start , int old_left_start, int my_start, int my_end, int left_end, int right_end, int headLoc)
 {
	 for (int i = 0; i < walkLen; i++){
		 if (tempList[current_list][left_start] < tempList[current_list][right_start]) {
			 tempList[!current_list][headLoc] = tempList[current_list][left_start];/*Compare if my left value is smaller than the
			 left_start++;                                                           right value store it into the !current_list
			 headLoc++;                                                               row of array tempList*/
			 //Check if l is now empty
			 if (left_start == left_end) {
       //place the left over elements into the array
				 for (int j = right_start; j < right_end; j++){
					 tempList[!current_list][headLoc] = tempList[current_list][right_start];
					 right_start++;
					 headLoc++;
				 }
			 }
		 }
		 else {
			 tempList[!current_list][headLoc] = tempList[current_list][right_start];/*Compare if my right value is smaller than the 
			 right_start++;                                                             left value store it into the !current_list
			 //Check if r is now empty                                                   row of array tempList*/
			 if (right_start == right_end) {
       //place the left over elements into the array
				 for (int j = left_start; j < left_end; j++){
					 tempList[!current_list][headLoc] = tempList[current_list][right_start];
					 right_start++;
					 headLoc++;
				 }
			 }
		 }
	 }


 }

/* Mergesort definition.  Takes a pointer to a list of floats, the length
  of the list, and the number of list elements given to each thread.
  Puts the list into sorted order */
__global__ void Device_Merge(float *d_list, int length, int elementsPerThread){//Device function

    	int my_start, my_end; //indices of each thread's start/end

    	//Declare counters requierd for recursive mergesort
    	int left_start, right_start; //Start index of the two lists being merged
    	int old_left_start;
    	int left_end, right_end; //End index of the two lists being merged
    	int headLoc; //current location of the write head on the newList
    	short current_list = 0; /* Will be used to determine which of two lists is the
				most up-to-date */

    	//allocate enough shared memory for this block's list...

    	__shared__ float tempList[2][SHARED/sizeof(float)];

    	//Load memory
    	int index = blockIdx.x*blockDim.x + threadIdx.x;
    	for (int i = 0; i < elementsPerThread; i++){
		if (index + i < length){
	    		tempList[current_list][elementsPerThread*threadIdx.x + i]=d_list[index + i];
		}
    	}

    	//Wait until all memory has been loaded
    	__syncthreads();

    	//Merge the left and right lists.
    	for (int walkLen = 1; walkLen < length; walkLen *= 2) {
		//Set up start and end indices.
		my_start = elementsPerThread*threadIdx.x;
		my_end = my_start + elementsPerThread;
		left_start = my_start;

		while (left_start < my_end) {
	    		old_left_start = left_start; //left_start will be getting incremented soon.
	    		//If this happens, we are done.
	    		if (left_start > my_end){
				      left_start = length;
			      	break;
	    		}

	    		left_end = left_start + walkLen;
	    		if (left_end > my_end) {
				left_end = length;
	    		}

	    		right_start = left_end;
	    		if (right_start > my_end) {
				right_end = length;
	    		}

	    		right_end = right_start + walkLen;
	    		if (right_end > my_end) {
				right_end = length;
	    		}

	    		solve(&tempList, left_start, right_start , old_left_start, my_start, int my_end, left_end, right_end, headLoc);
			left_start = old_left_start + 2*walkLen;
	       	 	current_list = !current_list;
		}
	}
      //Wait until all thread completes swapping if not race condition will appear
			//as it might update non sorted value to d_list
    	__syncthreads();

    	int index = blockIdx.x*blockDim.x + threadIdx.x;
    	for (int i = 0; i < elementsPerThread; i++){
       		if (index + i < length){
	   		d_list[index + i]=subList[current_list][elementsPerThread*threadIdx.x + i];
       		}
    	}
      //Wait until all memory has been loaded
	__syncthreads();

	return;

}

/* Mergesort definition.  Takes a pointer to a list of floats.
  the length of the list, the number of threads per block, and
  the number of blocks on which to execute.
  Puts the list into sorted order in-place.*/
void MergeSort(float *h_list, int len, int threadsPerBlock, int blocks) {

	//device copy
    	float *d_list;
	//Allocate space for device copy
	cudaMalloc((void **) &d_list, len*sizeof(float));
	//copy input to device
    	cudaMemcpy(d_list, h_list, len*sizeof(float), cudaMemcpyHostToDevice);

    	int elementsPerThread = ceil(len/float(threadsPerBlock*blocks));

	// Launch a Device_Merge kernel on GPU
    	Device_Merge<<<blocks, threadsPerBlock>>>(d_list, len, elementsPerThread);

    	cudaMemcpy(h_list, d_list, len*sizeof(float), cudaMemcpyDeviceToHost);
	cudaFree(d_list);

}





int main(){

    	int length;
    	float *h_list;

  	h_list = (float *)malloc(len*sizeof(float));
  	cout<<"Enter length of the array"<<endl;
	cin>>len;
    	for (int i = 0; i < length; i++){
	    	h_list[i]=rand()%length;
    	}

    	MergeSort(h_list, length, 8, 512);

	for (int i = 0; i < length; i++){
        	cout<<h_list[i]<<" ";
    	}
	cout<<endl;

    	return 0;
}
