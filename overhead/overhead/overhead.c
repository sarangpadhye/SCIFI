#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include "elapsedtime.h"
#include "flopop.h"

/******************************************************************************************************************************
                                Function name : overhead
                                Arguments     : vectorlength , nreps , &time , &nflops
                                Purpose       : This functions performs the following activities
                                                - calls daxpy nreps time
                                                - calculates Overhead time , and nflops.
                                                - Error handling to handle some undesirable input
                                Return value  : int
*******************************************************************************************************************************/






int overhead(int vectorlength, int nreps, double *time, double *nflops)
{



    int flag = 0,i=0,j=0;

    double *x , *y , number, start_time , alpha=10 , time_start1 , Time1 , Time2 , time_end1 , time_block2 , Gflops , time_start2 , time_end2 ;



    // Allocate space for the vectors
    x = malloc(vectorlength*(sizeof(double)));
    y = malloc(vectorlength*(sizeof(double)));

	//Check whether vector length is negative. Error code -1

    if(vectorlength < 0)
    {


		printf("\nError code -1 : Vector Length is negative. Please reset vector length in file sizes and rerun again\n");
		exit(1);

	}

	//Check whether nreps is negative. Error code -2

	else if(nreps < 0)
	{

		printf("\nError code -2 : Nreps is negative. Please reset vector length in file sizes and rerun again\n");
		exit(1);

	}

	//Check if malloc has failed

	if(x==NULL || y==NULL)
	{

		printf("\n Malloc failed");

	}


    //Initialize vectors x and y to some random numbers


	for(i=0;i<vectorlength;i++)
	{

		number = rand() % 20;

		if(number == 0)
		{
			number = 5;

		}

		x[i] = number;
		y[i] = number;


	}

	// Block 1 : This calculates time without a call to the timer


	time_start1 = elapsedtime();

	for(i=0;i<nreps;i++)
	{

		flopop(vectorlength,x,y,alpha);
	}

	time_end1 =  elapsedtime();

	Time1 = time_end1 - time_start1;

	Gflops = (2.0e-9*vectorlength*nreps)/Time1;



	//Block 2 : This block calls the timer for every daxpy operation


	time_start2 = elapsedtime();

	for(i=0;i<nreps;i++)
	{

		time_block2 = elapsedtime();
		//time_block2 = elapsedtime();
		flopop(vectorlength,x,y,alpha);
	}

	time_end2 =  elapsedtime();

	Time2 = time_end2 - time_start2;

    //Calculate Overhead Time

    *time = (Time2 - Time1)/nreps;

    if(*time < 0)
    {
		return(2);

	}


    //Calculate nflops

   *nflops = 1.0e9 * Gflops * *time;


    //deallocate memory

    free(x);
	free(y);

    return(0);
}









/*printf("\n---------------Block 1--------------------\n");

	printf("Start Time - %1.16e\n",time_start1);

	printf("End Time - %1.16e\n",time_end1);

	printf("Time1 - %1.16e\n",Time1);

	printf("Gflops - %f\n",Gflops);

	printf("\n------------------------------------------\n");*/

/*printf("\n---------------Block 2--------------------\n");

	printf("Start Time - %1.16e\n",time_start2);

	printf("End Time - %1.16e\n",time_end2);

	printf("Time2 - %1.16e\n",Time2);

	printf("\n------------------------------------------\n");


    printf("\n---------------End result------------------\n");

	printf("Overhead Time - %1.16e\n",*time);

	printf("nflops - %f\n",*nflops);

	printf("\n------------------------------------------\n"); */
