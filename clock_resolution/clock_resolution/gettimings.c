/******************************************************************************************************************************************
Function Name : gettimings(int,int)
Arguments     : nsamples and nadds from sizes
Functionality : This is a program which calculated the time difference of nadds over nsamples and write the result in 17 significant bits to              file results
Author        : Sarang Padhye
Date          : 01-Sept-2013
*******************************************************************************************************************************************/
#include <unistd.h>
#include <stdio.h>
#include "elapsedtime.h"
#include "dosomething.h"
int gettimings(int nadds, int nsamples)
{    
FILE *ft;
ft=fopen("results","w");

double d_stime,d_etime,d_timediff;
int i_var,flag=0;

if(ft==NULL)
{
	printf("File does not exists!!\n");
	flag=1;
}


/*Loop to calculate the time difference and write the output to the file*/	
if (flag==0)
{
	for(i_var=0;i_var<nsamples-1;i_var++)
	{
	d_stime=elapsedtime();
	dosomething(nadds);
	d_etime = elapsedtime();
	d_timediff = d_etime-d_stime;
	fprintf(ft,"%1.16e\n",d_timediff);
	}
	
}
fclose(ft);
return 0;
}
