#pragma  once

#include "OstrHeader.hpp"

#define Laplace_clipping 0
#define  scaleFactorC  5.0
#define LAPLACE_THREHOLD_MODULATION 1 //threshold modulation	
#define CENTORAL_MODULE_COMBINE 1 //central module combine 0/1	

#define MODIFY_THRESHOLD_PADDING_AREA 50  //127.5-50   127.5+50
#define MODIFY_THRESHOLD_NONE_PADDING_AREA 50  //127.5-50   127.5+50
IplImage *Laplace_SAED_Halftone(IplImage *I);
IplImage *Qr_Guide_Laplace_SAED_Halftone_gray(IplImage *I,IplImage *Qr);
IplImage *Qr_Guide_Laplace_SAED_Halftone_color(IplImage *I_color,IplImage *I_gray,IplImage *Qr);//qr is gray
IplImage *Qr_Guide_Laplace_SAED_Halftone_color_paddingdata(IplImage *I_color,IplImage *I_gray,IplImage *Qr,int * paddingArea);//qr is gray
