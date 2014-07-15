
void flopop(int vectorlength, double *x, double *y, double alpha)
{

/******************************************************************************************************************************
                                Function name : flopop
                                Arguments     : Vectors x and y and Scalar
                                Purpose       : Does the daxpy operation
                                Return value  : void
*******************************************************************************************************************************/


		int i;

		for(i=0 ; i < vectorlength ; i++)
		{

			x[i] = y[i] + alpha * x[i];
		}
    return;
}
