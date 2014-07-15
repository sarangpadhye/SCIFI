#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include "elapsedtime.h"
#include "overhead.h"

/******************************************************************************************************************************
                                Function name : main
                                Arguments     : Command Line Arguments
                                Purpose       : This serves as an entry point to the program and calls overhead nsample times
                                Return value  : int
*******************************************************************************************************************************/

int main(int argc, char **argv)
{

int i,j,flag=0,vectorlength,nreps,nsamples,test;

double time,nflops;
FILE *fp1,*fp2;


//open file sizes in Read mode and timings.m in write mode

fp1 = fopen("sizes","r");
fp2 = fopen("timings.m","w");

	//printf("\nOpening Sizes!!");

	// Check whether file exists

	if(fp1==NULL || fp2==NULL)
	{

		flag=1;
		printf("\nFile does not exists !!");
		printf("\n----------------------");
		exit(1);

	}

	if(flag==0)
	{

	//printf("\nFile does exists");
	//printf("\n----------------------");
	}

	// Start Reading Input file Sizes. Accept Vector Length ,nreps and nsamples

	fscanf(fp1,"%d %d %d",&vectorlength,&nreps,&nsamples);

	/*printf("\nVector Length is --> %d",vectorlength);
	printf("\nreps is --> %d",nreps);
	printf("\nnsamples is --> %d\n",nsamples);*/

	// Write the header to timings.h

	fprintf(fp2,"%s","overheads = [...\n");

	//Call overhead nsample times

    for(i=0;i<nsamples;i++)
	{

		test = overhead(vectorlength,nreps,&time,&nflops);

		// Check whether *time is positive or negative
		if(test ==2)
		{
			continue;
		}

		// Write time and nflops to timings.m
		else
		{
			fprintf(fp2,"%1.16e	%f\n",time,nflops);
		}
	}


	fprintf(fp2,"%s","];");

    //Close both files

	fclose(fp1);
	fclose(fp2);
	return(0);



}
