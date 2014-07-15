/******************************************************************************************************************************************
Function Name : dosomething()
Arguments     : No of Additions to be performed.
Functionality : This is a simple Addition program which adds two random integer numbers.
Author        : Sarang Padhye
Date          : 01-Sept-2013
*******************************************************************************************************************************************/

#include <unistd.h>
#include <stdio.h>
void dosomething(int nadd)
{
    //---------------------------------------------------------------------------
    // Do some simple operation nadd times, to get a nonzero timing block.
    // If all zeros appear, the function calling this one should increase nadd
    // to something larger.
    //---------------------------------------------------------------------------

	int ivar,isum,n1,n2;
	for(ivar=0;ivar<nadd;ivar++)
	{
		n1=rand()%20;
		n2=rand()%20;
		isum=n1+n2;
	}
	

    
    return;
}
