#include "Dithering.h"
#define IS255MODE 1
void DitheringHalftone(IplImage *I,int A []){
#if IS255MODE
	double avgLum =127.5;//average lumination
#else 
	double avgLum =0.5;//average lumination
#endif
	IplImage *temp = cvCloneImage(I);
	int A_width = I->width/3;
	for (int i = 0; i < A_width; i++) {
		for (int j = 0; j <A_width; j++) {
			double val = cvGet2D(temp,i*3+1,j*3+1).val[0];
#if IS255MODE
			val = clamp_d(val, 0., 255.);
#else 
			val = clamp_d(val, 0., 1.);
#endif
			if (val > avgLum) {
				A[i*A_width+j] = 0;//
			}
			else {
#if IS255MODE
				A[i*A_width+j] = 255;//
#else 
			A[i*A_width+j] = 1;//
#endif
			}
		}
	}
	cvReleaseImage(&temp);
	return;
}
;
