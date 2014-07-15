/*****************************************************************************************************************************************
Function Name : Main program
Arguments     : Command line arguments
Functionality : This is a program in which all the othe modules are called.
Author        : Sarang Padhye
Date          : 01-Sept-2013
*******************************************************************************************************************************************/
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "elapsedtime.h"
#include "gettimings.h"
int main(int argc, char **argv)
{
    //---------------------------------------------------------------------------
    // Do many nsamples timings of nadd integer additions, to check for clock
    // resolution. If all zeros appear, bump up nadd. Output is to a file named
    // data_resolution. 
    //---------------------------------------------------------------------------
    FILE *fp;
    int i_var,nadds,nsamples;	
    fp=fopen("sizes","r");
    system("clear");
/*Check if the file exists*/
	if(fp==NULL)
	{
	printf("File does not exists!!\n");
	}
/*Start Reading the file*/
	fscanf(fp,"%d %d",&nadds,&nsamples);
	gettimings(nadds,nsamples);
	fclose(fp);
    return(0);
}
