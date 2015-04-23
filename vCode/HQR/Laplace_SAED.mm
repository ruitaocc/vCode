#include "Laplace_SAED.hpp"
#include <vector>
#include <algorithm>
#include <opencv2/highgui/highgui_c.h>
#include <stdlib.h>
#include <math.h>
#include <random>
using namespace std;
#define QR_GUIDE 1
#define CONSIDER_EDGE 1
#define GUIDE_RATIO 1
int MODIFY_THRESHOLD_PADDING_AREA = 50;
int MODIFY_THRESHOLD_NONE_PADDING_AREA =50;  //127.5-50   127.5+50

void hcvSet2D(IplImage *img,int i,int j, Scalar s,int size){
    size = 1;
    for(int k = 0; k<size;k++){
        for(int h = 0; h<size;h++){
            cvSet2D(img, i*size+k, j*size+h, s);
        }
    }
};


IplImage *Laplace_SAED_Halftone(IplImage *I) {
	
	IplImage *Laplace_o = cvCloneImage(I);
	IplImage *Laplace = cvCloneImage(I);
	IplImage *Laplace_Sobel = cvCloneImage(I);
	//edge detection
	cvLaplace(I,Laplace_o,3);
	cvScale(Laplace_o,Laplace,1,Laplace_clipping);
	
	
	
	
	IplImage *ThresholdMatrix = cvCloneImage(I);
	cvSet(ThresholdMatrix,cvScalar(0.5));

	IplImage *Ts_Matrix = cvCloneImage(I);
	cvSet(Ts_Matrix,cvScalar(0));

	IplImage *K_Matrix = cvCloneImage(I);
	cvSet(K_Matrix,cvScalar(0));

	IplImage *sigma_Matrix = cvCloneImage(I);
	cvSet(sigma_Matrix,cvScalar(0));

	IplImage *Ta_Matrix = cvCloneImage(I);
	cvSet(Ta_Matrix,cvScalar(0));
	


	CvScalar  mean,globalSigma;
	cvAvgSdv(I,&mean,&globalSigma);
	printf("original--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);

	int localWindowSize = 11;
	CvScalar sigmaMax,sigmaMin,sigmaCur;
	sigmaMax.val[0]=0;
	sigmaMin.val[0]=1;
	for (int i = localWindowSize/2;i < I->height - localWindowSize/2 ; i++ ) {
		for (int j = localWindowSize/2; j < I->width - localWindowSize/2 ; j++) {
			CvRect rect = cvRect(j - localWindowSize/2, i - localWindowSize/2,localWindowSize,localWindowSize);
			cvSetImageROI(I,rect);
			cvAvgSdv(I,&mean,&sigmaCur);
			cvSet2D(sigma_Matrix,i,j,sigmaCur);
			cvResetImageROI(I); 
			if(sigmaCur.val[0]>sigmaMax.val[0])sigmaMax.val[0]=sigmaCur.val[0];
			if(sigmaCur.val[0]<sigmaMin.val[0])sigmaMin.val[0]=sigmaCur.val[0];
		}
	}
	printf("sigmaMax:%f sigmaMin:%f\n",sigmaMax.val[0],sigmaMin.val[0]);
	int hw = localWindowSize/2;
	int ii=hw,jj=hw;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			ii = i;
			jj = j;
			if(i<hw ){
				ii=hw;
			}
			if(j<hw ){
				jj=hw;
			}
			if(i+hw + 1 > I->height ){
				ii = I->height - hw - 1;
			}
			if(j+hw + 1 > I->width ){
				jj = I->width - hw - 1;
			}
			double gray = cvGet2D(sigma_Matrix,ii,jj).val[0];
			cvSet2D(sigma_Matrix,i,j,cvScalar(gray));
		}
	}
	double val0,val1,val2=sigmaMax.val[0]-sigmaMin.val[0];
	double grayk;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			val0 = scaleFactorC/globalSigma.val[0];
			val1 = fabs(cvGet2D(sigma_Matrix,i,j).val[0]-sigmaMax.val[0]);
			grayk = val0*(val1/val2)+scaleFactorC;
			cvSet2D(K_Matrix,i,j,cvScalar(grayk));
		}
	}
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			double k = cvGet2D(K_Matrix,i,j).val[0];
			double l = cvGet2D(Laplace,i,j).val[0];
			cvSet2D(Ts_Matrix,i,j,cvScalar(k*l));
		}
	}
	std::random_device rd;
    std::mt19937 gen(rd());
    // values near the mean are the most likely
    // standard deviation affects the dispersion of generated values from the mean
    std::normal_distribution<> d(0,0.1*255);
	double rnosize;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			rnosize = d(gen);
			cvSet2D(Ta_Matrix,i,j,cvScalar(rnosize));
		}
	}
	double sumt=0;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			double s = cvGet2D(Ts_Matrix,i,j).val[0];
			double a = cvGet2D(Ta_Matrix,i,j).val[0];
			sumt+=(s+a);
			
			cvSet2D(ThresholdMatrix,i,j,cvScalar(s+a));
		}
	}
	printf("ThresholdMatrix_Avg:%f\n",sumt/(I->width*I->height));
	
	double min_v,max_v;
	cvMinMaxLoc(ThresholdMatrix,&min_v,&max_v);
	printf("min_v%f max_v%f\n",min_v,max_v);
	IplImage *temp = cvCloneImage(I);
	IplImage *res = cvCloneImage(I);
	cvZero(res);
	double Threshold=0;
	
	for (int i = 0; i < I->height - 1; i++) {
		for (int j = 1; j < I->width - 1; j++) {
			Threshold = cvGet2D(ThresholdMatrix,i,j).val[0];
			double error = 0;
			double val = cvGet2D(temp,i,j).val[0];
			val = clamp(val, 0., 255.);
			if (val > Threshold) {
				cvSet2D(res, i, j, cvScalar(255));
				error = val - 255.;
			}
			else {
				cvSet2D(res, i, j, cvScalar(0));
				error = val;
			}
			int level = mround(val);
			level = clamp(level, 0, 255);
			
			double gray_val;
			gray_val = cvGet2D(temp,i,j+1).val[0];
			gray_val += error *d10(level);
			cvSet2D(temp,i,j+1,cvScalar(gray_val));
			
			gray_val = cvGet2D(temp,i+1,j-1).val[0];
			gray_val += error *d_11(level);
			cvSet2D(temp,i+1,j-1,cvScalar(gray_val));

			gray_val = cvGet2D(temp,i+1,j).val[0];
			gray_val += error *d01(level);
			cvSet2D(temp,i+1,j,cvScalar(gray_val));
			
			//(CV_IMAGE_ELEM(temp, double, i, j + 1)) += error *d10(level);
			//(CV_IMAGE_ELEM(temp, double, i + 1, j - 1)) += error *d_11(level);
			//(CV_IMAGE_ELEM(temp, double, i + 1, j)) += error *d01(level);
		}
	}
	cvAvgSdv(res,&mean,&globalSigma);
	printf("result--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);
	cvReleaseImage(&temp);
	return res;
}

IplImage *Qr_Guide_Laplace_SAED_Halftone_gray(IplImage *I,IplImage *Qr){
	
	IplImage *Laplace_o = cvCloneImage(I);
	IplImage *Laplace = cvCloneImage(I);
	IplImage *Laplace_Sobel = cvCloneImage(I);
	//edge detection
	cvLaplace(I,Laplace_o,3);
	
	cvScale(Laplace_o,Laplace,1,Laplace_clipping);
	
	
	
	IplImage *ThresholdMatrix = cvCloneImage(I);
	cvSet(ThresholdMatrix,cvScalar(0.5));

	IplImage *Ts_Matrix = cvCloneImage(I);
	cvSet(Ts_Matrix,cvScalar(0));

	IplImage *K_Matrix = cvCloneImage(I);
	cvSet(K_Matrix,cvScalar(0));

	IplImage *sigma_Matrix = cvCloneImage(I);
	cvSet(sigma_Matrix,cvScalar(0));

	IplImage *Ta_Matrix = cvCloneImage(I);
	cvSet(Ta_Matrix,cvScalar(0));
	
	CvScalar  mean,globalSigma;
	cvAvgSdv(I,&mean,&globalSigma);
	printf("original--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);

	int localWindowSize = 11;
	CvScalar sigmaMax,sigmaMin,sigmaCur;
	sigmaMax.val[0]=0;
	sigmaMin.val[0]=1;
	for (int i = localWindowSize/2;i < I->height - localWindowSize/2 ; i++ ) {
		for (int j = localWindowSize/2; j < I->width - localWindowSize/2 ; j++) {
			CvRect rect = cvRect(j - localWindowSize/2, i - localWindowSize/2,localWindowSize,localWindowSize);
			cvSetImageROI(I,rect);
			cvAvgSdv(I,&mean,&sigmaCur);
			cvSet2D(sigma_Matrix,i,j,sigmaCur);
			cvResetImageROI(I); 
			if(sigmaCur.val[0]>sigmaMax.val[0])sigmaMax.val[0]=sigmaCur.val[0];
			if(sigmaCur.val[0]<sigmaMin.val[0])sigmaMin.val[0]=sigmaCur.val[0];
		}
	}
	printf("sigmaMax:%f sigmaMin:%f\n",sigmaMax.val[0],sigmaMin.val[0]);
	int hw = localWindowSize/2;
	int ii=hw,jj=hw;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			ii = i;
			jj = j;
			if(i<hw ){
				ii=hw;
			}
			if(j<hw ){
				jj=hw;
			}
			if(i+hw + 1 > I->height ){
				ii = I->height - hw - 1;
			}
			if(j+hw + 1 > I->width ){
				jj = I->width - hw - 1;
			}
			double gray = cvGet2D(sigma_Matrix,ii,jj).val[0];
			cvSet2D(sigma_Matrix,i,j,cvScalar(gray));
		}
	}
	double val0,val1,val2=sigmaMax.val[0]-sigmaMin.val[0];
	double grayk;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			val0 = scaleFactorC/globalSigma.val[0];
			val1 = fabs(cvGet2D(sigma_Matrix,i,j).val[0]-sigmaMax.val[0]);
			grayk = val0*(val1/val2)+scaleFactorC;
			cvSet2D(K_Matrix,i,j,cvScalar(grayk));
		}
	}
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			double k = cvGet2D(K_Matrix,i,j).val[0];
			double l = cvGet2D(Laplace,i,j).val[0];
			cvSet2D(Ts_Matrix,i,j,cvScalar(k*l));
		}
	}
	std::random_device rd;
    std::mt19937 gen(rd());
    // values near the mean are the most likely
    // standard deviation affects the dispersion of generated values from the mean
    std::normal_distribution<> d(0,0.1*255);
	double rnosize;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			rnosize = d(gen);
			cvSet2D(Ta_Matrix,i,j,cvScalar(rnosize));
		}
	}
	double sumt=0;
	for (int i = 0; i < I->height; i++ ) {
		for (int j = 0; j < I->width; j++) {
			double s = cvGet2D(Ts_Matrix,i,j).val[0];
			double a = cvGet2D(Ta_Matrix,i,j).val[0];
			sumt+=(s+a);
			
			cvSet2D(ThresholdMatrix,i,j,cvScalar(s+a));
		}
	}
	printf("ThresholdMatrix_Avg:%f\n",sumt/(I->width*I->height));
	
	double min_v,max_v;
	cvMinMaxLoc(ThresholdMatrix,&min_v,&max_v);
	printf("min_v%f max_v%f\n",min_v,max_v);
	IplImage *temp = cvCloneImage(I);
	IplImage *Qrtemp = cvCloneImage(Qr);
	IplImage *res = cvCloneImage(I);
	printf("QR_Avg:%f \n",cvAvg(Qrtemp).val[0]);
	
	cvZero(res);
	double Threshold=0;
#if CONSIDER_EDGE
	for (int i = 0; i < I->height; i++) {
		for (int j = 0; j < I->width; j++) {
#else
	for (int i = 0; i < I->height - 1; i++) {
		for (int j = 1; j < I->width - 1; j++) {
#endif
#if QR_GUIDE
			bool isQr_Point = isQrPoint(i,j,3);
#endif
			Threshold = cvGet2D(ThresholdMatrix,i,j).val[0];
			double error = 0;
			double val = cvGet2D(temp,i,j).val[0];
			val = clamp(val, 0., 255.);
#if QR_GUIDE
			if(isQr_Point){
				double val_qr = cvGet2D(Qrtemp,i,j).val[0];
				if(val_qr>0.01){
					cvSet2D(res, i, j, cvScalar(255));
					error = val - 255.;
					error*=GUIDE_RATIO;
				}else{
					cvSet2D(res, i, j, cvScalar(0));
					error = val;
					error*=GUIDE_RATIO;
				}
			}else{
				if (val > Threshold) {
					cvSet2D(res, i, j, cvScalar(255));
					error = val - 255.;
				}
				else {
					cvSet2D(res, i, j, cvScalar(0));
					error = val;
				}
			}
#else
			
			if (val > Threshold) {
				cvSet2D(res, i, j, cvScalar(255));
				error = val - 255.;
			}
			else {
				cvSet2D(res, i, j, cvScalar(0));
				error = val;
			}
#endif

			

			int level = mround(val);
			level = clamp(level, 0, 255);
#if CONSIDER_EDGE
			double gray_val;
			if(j==0 && (i!=(I->height-1))){
				gray_val = cvGet2D(temp,i,j+1).val[0];
				gray_val += error *d10(level);
				cvSet2D(temp,i,j+1,cvScalar(gray_val));
				gray_val = cvGet2D(temp,i+1,j).val[0];
				gray_val += error *d01(level);
				cvSet2D(temp,i+1,j,cvScalar(gray_val));
			}else if((i!=(I->height-1))&&(j!=(I->width-1))){
				gray_val = cvGet2D(temp,i,j+1).val[0];
				gray_val += error *d10(level);
				cvSet2D(temp,i,j+1,cvScalar(gray_val));
				gray_val = cvGet2D(temp,i+1,j-1).val[0];
				gray_val += error *d_11(level);
				cvSet2D(temp,i+1,j-1,cvScalar(gray_val));
				gray_val = cvGet2D(temp,i+1,j).val[0];
				gray_val += error *d01(level);
				cvSet2D(temp,i+1,j,cvScalar(gray_val));
				
			}else if((i==(I->height-1))&&(j==(I->width-1))){
				continue;
			}else if(i==(I->height-1)){
				gray_val = cvGet2D(temp,i,j+1).val[0];
				gray_val += error *d10(level);
				cvSet2D(temp,i,j+1,cvScalar(gray_val));
				
			}else if(j==(I->width-1)){
				gray_val = cvGet2D(temp,i+1,j-1).val[0];
				gray_val += error *d_11(level);
				cvSet2D(temp,i+1,j-1,cvScalar(gray_val));
				gray_val = cvGet2D(temp,i+1,j).val[0];
				gray_val += error *d01(level);
				cvSet2D(temp,i+1,j,cvScalar(gray_val));
			}
#else
			double gray_val;
			gray_val = cvGet2D(temp,i,j+1).val[0];
			gray_val += error *d10(level);
			cvSet2D(temp,i,j+1,cvScalar(gray_val));
			
			gray_val = cvGet2D(temp,i+1,j-1).val[0];
			gray_val += error *d_11(level);
			cvSet2D(temp,i+1,j-1,cvScalar(gray_val));

			gray_val = cvGet2D(temp,i+1,j).val[0];
			gray_val += error *d01(level);
			cvSet2D(temp,i+1,j,cvScalar(gray_val));
#endif			
			//(CV_IMAGE_ELEM(temp, double, i, j + 1)) += error *d10(level);
			//(CV_IMAGE_ELEM(temp, double, i + 1, j - 1)) += error *d_11(level);
			//(CV_IMAGE_ELEM(temp, double, i + 1, j)) += error *d01(level);
		}
	}
	cvAvgSdv(res,&mean,&globalSigma);
	printf("result--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);
	
	cvReleaseImage(&temp);
	cvReleaseImage(&Laplace_o);
	cvReleaseImage(&Laplace);
	cvReleaseImage(&Laplace_Sobel);
	cvReleaseImage(&ThresholdMatrix);
	cvReleaseImage(&Ts_Matrix);
	cvReleaseImage(&K_Matrix);
	cvReleaseImage(&sigma_Matrix);
	cvReleaseImage(&Ta_Matrix);
	cvReleaseImage(&temp);

	return res;
};


IplImage *Qr_Guide_Laplace_SAED_Halftone_color(IplImage *I_color,IplImage *I_gray,IplImage *Qr){
	
	IplImage *Laplace_o = cvCloneImage(I_gray);
	IplImage *Laplace = cvCloneImage(I_gray);
	IplImage *Laplace_Sobel = cvCloneImage(I_gray);
	//edge detection
	cvLaplace(I_gray,Laplace_o,3);
	
	cvScale(Laplace_o,Laplace,1,Laplace_clipping);
	
	
	
	IplImage *ThresholdMatrix = cvCloneImage(I_gray);
	cvSet(ThresholdMatrix,cvScalar(0.5));

	IplImage *Ts_Matrix = cvCloneImage(I_gray);
	cvSet(Ts_Matrix,cvScalar(0));

	IplImage *K_Matrix = cvCloneImage(I_gray);
	cvSet(K_Matrix,cvScalar(0));

	IplImage *sigma_Matrix = cvCloneImage(I_gray);
	cvSet(sigma_Matrix,cvScalar(0));

	IplImage *Ta_Matrix = cvCloneImage(I_gray);
	cvSet(Ta_Matrix,cvScalar(0));
	
	CvScalar  mean,globalSigma;
	cvAvgSdv(I_gray,&mean,&globalSigma);
	printf("original--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);

	int localWindowSize = 11;
	CvScalar sigmaMax,sigmaMin,sigmaCur;
	sigmaMax.val[0]=0;
	sigmaMin.val[0]=1;
	for (int i = localWindowSize/2;i < I_gray->height - localWindowSize/2 ; i++ ) {
		for (int j = localWindowSize/2; j < I_gray->width - localWindowSize/2 ; j++) {
			CvRect rect = cvRect(j - localWindowSize/2, i - localWindowSize/2,localWindowSize,localWindowSize);
			cvSetImageROI(I_gray,rect);
			cvAvgSdv(I_gray,&mean,&sigmaCur);
			cvSet2D(sigma_Matrix,i,j,sigmaCur);
			cvResetImageROI(I_gray); 
			if(sigmaCur.val[0]>sigmaMax.val[0])sigmaMax.val[0]=sigmaCur.val[0];
			if(sigmaCur.val[0]<sigmaMin.val[0])sigmaMin.val[0]=sigmaCur.val[0];
		}
	}
	printf("sigmaMax:%f sigmaMin:%f\n",sigmaMax.val[0],sigmaMin.val[0]);
	int hw = localWindowSize/2;
	int ii=hw,jj=hw;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			ii = i;
			jj = j;
			if(i<hw ){
				ii=hw;
			}
			if(j<hw ){
				jj=hw;
			}
			if(i+hw + 1 > I_gray->height ){
				ii = I_gray->height - hw - 1;
			}
			if(j+hw + 1 > I_gray->width ){
				jj = I_gray->width - hw - 1;
			}
			double gray = cvGet2D(sigma_Matrix,ii,jj).val[0];
			cvSet2D(sigma_Matrix,i,j,cvScalar(gray));
		}
	}
	double val0,val1,val2=sigmaMax.val[0]-sigmaMin.val[0];
	double grayk;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			val0 = scaleFactorC/globalSigma.val[0];
			val1 = fabs(cvGet2D(sigma_Matrix,i,j).val[0]-sigmaMax.val[0]);
			grayk = val0*(val1/val2)+scaleFactorC;
			cvSet2D(K_Matrix,i,j,cvScalar(grayk));
		}
	}
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			double k = cvGet2D(K_Matrix,i,j).val[0];
			double l = cvGet2D(Laplace,i,j).val[0];
			cvSet2D(Ts_Matrix,i,j,cvScalar(k*l));
		}
	}
	std::random_device rd;
    std::mt19937 gen(rd());
    // values near the mean are the most likely
    // standard deviation affects the dispersion of generated values from the mean
    std::normal_distribution<> d(0,0.1*255);
	double rnosize;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			rnosize = d(gen);
			cvSet2D(Ta_Matrix,i,j,cvScalar(rnosize));
		}
	}
	double sumt=0;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			double s = cvGet2D(Ts_Matrix,i,j).val[0];
			double a = cvGet2D(Ta_Matrix,i,j).val[0];
			sumt+=(s+a);
			
			cvSet2D(ThresholdMatrix,i,j,cvScalar(s+a));
		}
	}
	printf("ThresholdMatrix_Avg:%f\n",sumt/(I_gray->width*I_gray->height));
	double min_v,max_v;
	cvMinMaxLoc(ThresholdMatrix,&min_v,&max_v);
	printf("min_v%f max_v%f\n",min_v,max_v);
	
	IplImage *temp = cvCloneImage(I_color);
	IplImage *Qrtemp = cvCloneImage(Qr);
	IplImage *res = cvCloneImage(I_color);
	printf("QR_Avg:%f \n",cvAvg(Qrtemp).val[0]);//255
	
	cvZero(res);
	double Threshold=0;
#if CONSIDER_EDGE
	for (int i = 0; i < I_color->height; i++) {
		for (int j = 0; j < I_color->width; j++) {
#else
	for (int i = 0; i < I_gray->height - 1; i++) {
		for (int j = 1; j < I_gray->width - 1; j++) {
#endif
#if QR_GUIDE
			bool isQr_Point = isQrPoint(i,j,3);
#endif
#if LAPLACE_THREHOLD_MODULATION
			Threshold = cvGet2D(ThresholdMatrix,i,j).val[0];
#else
			Threshold = 127.5;
#endif
			double r_error = 0;
			double g_error = 0;
			double b_error = 0;
			double r_val = cvGet2D(temp,i,j).val[2];
			double g_val = cvGet2D(temp,i,j).val[1];
			double b_val = cvGet2D(temp,i,j).val[0];
			r_val = clamp(r_val, 0., 255.);
			g_val = clamp(g_val, 0., 255.);
			b_val = clamp(b_val, 0., 255.);
#if QR_GUIDE
			if(isQr_Point){
#if CENTORAL_MODULE_COMBINE
				double val_qr = cvGet2D(Qrtemp,i,j).val[0];
				if(val_qr>0.01){
					cvSet2D(res, i, j, cvScalar(255,255,255));
					r_error = r_val - 255.;
					g_error = g_val - 255.;
					b_error = b_val - 255.;
					r_error*=GUIDE_RATIO;
					g_error*=GUIDE_RATIO;
					b_error*=GUIDE_RATIO;
				}else{
					cvSet2D(res, i, j, cvScalar(0,0,0));
					r_error = r_val;
					g_error = g_val;
					b_error = b_val;
					r_error*=GUIDE_RATIO;
					g_error*=GUIDE_RATIO;
					b_error*=GUIDE_RATIO;
				}
#else
				if(r_val>254&&g_val>254&&b_val>254){
					double val_qr = cvGet2D(Qrtemp,i,j).val[0];
					if(val_qr>0.01){
						cvSet2D(res, i, j, cvScalar(255,255,255));
						r_error = r_val - 255.;
						g_error = g_val - 255.;
						b_error = b_val - 255.;
						r_error*=GUIDE_RATIO;
						g_error*=GUIDE_RATIO;
						b_error*=GUIDE_RATIO;
					}else{
						cvSet2D(res, i, j, cvScalar(0,0,0));
						r_error = r_val;
						g_error = g_val;
						b_error = b_val;
						r_error*=GUIDE_RATIO;
						g_error*=GUIDE_RATIO;
						b_error*=GUIDE_RATIO;
					}
				}else{
					double val_qr = cvGet2D(Qrtemp,i,j).val[0];
					//r
					CvScalar cur = cvScalar(0,0,0);
					if (r_val > Threshold) {
						cur.val[2]=255;
						r_error = r_val - 255.;
					}
					else {
						cur.val[2]=0;
						r_error = r_val;
					}
					//g
					if (g_val > Threshold) {
						cur.val[1]=255;
						g_error = g_val - 255.;
					}
					else {
						cur.val[1]=0;
						g_error = g_val;
					}
					//b
					if (b_val > Threshold) {
						cur.val[0]=255;
						b_error = b_val - 255.;
					}
					else {
						cur.val[0]=0;
						b_error = b_val;
					}
					//
					if(val_qr>0.01){
						//white
						if((0.0722*cur.val[2]+0.7152*cur.val[1]+0.2126*cur.val[0])<127.5){
							r_error =cur.val[2] ; cur.val[2] = 0;
							g_error =cur.val[1] - 255; cur.val[1]= 255;
							b_error =cur.val[0] ; cur.val[0]= 0;
						}
					}else{
						//black
						if((0.0722*cur.val[2]+0.7152*cur.val[1]+0.2126*cur.val[0])>127.5){
							r_error =cur.val[2] - 255; cur.val[2] = 255;
							g_error =cur.val[1] ;		 cur.val[1]= 0;
							b_error =cur.val[0] - 255; cur.val[0]=255;
						}
					}
					r_error*=GUIDE_RATIO;
					g_error*=GUIDE_RATIO;
					b_error*=GUIDE_RATIO;
					cvSet2D(res, i, j, cur);
				}
#endif
			}else{
				//r
				CvScalar cur = cvScalar(0,0,0);
				if (r_val > Threshold) {
					cur.val[2]=255;
					r_error = r_val - 255.;
				}
				else {
					cur.val[2]=0;
					r_error = r_val;
				}
				//g
				if (g_val > Threshold) {
					cur.val[1]=255;
					g_error = g_val - 255.;
				}
				else {
					cur.val[1]=0;
					g_error = g_val;
				}
				//b
				if (b_val > Threshold) {
					cur.val[0]=255;
					b_error = b_val - 255.;
				}
				else {
					cur.val[0]=0;
					b_error = b_val;
				}
				r_error*=GUIDE_RATIO;
				g_error*=GUIDE_RATIO;
				b_error*=GUIDE_RATIO;
				cvSet2D(res, i, j, cur);
			}
#else
			
			if (val > Threshold) {
				cvSet2D(res, i, j, cvScalar(255));
				error = val - 255.;
			}
			else {
				cvSet2D(res, i, j, cvScalar(0));
				error = val;
			}
#endif

			

			int r_level = mround(r_val);
			r_level = clamp(r_level, 0, 255);
			int g_level = mround(g_val);
			g_level = clamp(g_level, 0, 255);
			int b_level = mround(b_val);
			b_level = clamp(b_level, 0, 255);
#if CONSIDER_EDGE
			double next_r_val;
			double next_g_val;
			double next_b_val;
			if(j==0 && (i!=(I_color->height-1))){
				next_r_val = cvGet2D(temp,i,j+1).val[2];
				next_g_val = cvGet2D(temp,i,j+1).val[1];
				next_b_val = cvGet2D(temp,i,j+1).val[0];
				next_r_val+=r_error *d10(r_level);
				next_g_val+=g_error *d10(g_level);
				next_b_val+=b_error *d10(b_level);
				cvSet2D(temp,i,j+1,cvScalar(next_b_val,next_g_val,next_r_val));
				
				next_r_val = cvGet2D(temp,i+1,j).val[2];
				next_g_val = cvGet2D(temp,i+1,j).val[1];
				next_b_val = cvGet2D(temp,i+1,j).val[0];
				next_r_val+=r_error *d01(r_level);
				next_g_val+=g_error *d01(g_level);
				next_b_val+=b_error *d01(b_level);
				cvSet2D(temp,i+1,j,cvScalar(next_b_val,next_g_val,next_r_val));

			}else if((i!=(I_gray->height-1))&&(j!=(I_gray->width-1))){
				
				next_r_val = cvGet2D(temp,i,j+1).val[2];
				next_g_val = cvGet2D(temp,i,j+1).val[1];
				next_b_val = cvGet2D(temp,i,j+1).val[0];
				next_r_val+=r_error *d10(r_level);
				next_g_val+=g_error *d10(g_level);
				next_b_val+=b_error *d10(b_level);
				cvSet2D(temp,i,j+1,cvScalar(next_b_val,next_g_val,next_r_val));
				
				next_r_val = cvGet2D(temp,i+1,j-1).val[2];
				next_g_val = cvGet2D(temp,i+1,j-1).val[1];
				next_b_val = cvGet2D(temp,i+1,j-1).val[0];
				next_r_val+=r_error *d_11(r_level);
				next_g_val+=g_error *d_11(g_level);
				next_b_val+=b_error *d_11(b_level);
				cvSet2D(temp,i+1,j-1,cvScalar(next_b_val,next_g_val,next_r_val));
				
				next_r_val = cvGet2D(temp,i+1,j).val[2];
				next_g_val = cvGet2D(temp,i+1,j).val[1];
				next_b_val = cvGet2D(temp,i+1,j).val[0];
				next_r_val+=r_error *d01(r_level);
				next_g_val+=g_error *d01(g_level);
				next_b_val+=b_error *d01(b_level);
				cvSet2D(temp,i+1,j,cvScalar(next_b_val,next_g_val,next_r_val));
				
			}else if((i==(I_gray->height-1))&&(j==(I_gray->width-1))){
				continue;
			}else if(i==(I_gray->height-1)){

				next_r_val = cvGet2D(temp,i,j+1).val[2];
				next_g_val = cvGet2D(temp,i,j+1).val[1];
				next_b_val = cvGet2D(temp,i,j+1).val[0];
				next_r_val+=r_error *d10(r_level);
				next_g_val+=g_error *d10(g_level);
				next_b_val+=b_error *d10(b_level);
				cvSet2D(temp,i,j+1,cvScalar(next_b_val,next_g_val,next_r_val));
				
			}else if(j==(I_gray->width-1)){
				next_r_val = cvGet2D(temp,i+1,j-1).val[2];
				next_g_val = cvGet2D(temp,i+1,j-1).val[1];
				next_b_val = cvGet2D(temp,i+1,j-1).val[0];
				next_r_val+=r_error *d_11(r_level);
				next_g_val+=g_error *d_11(g_level);
				next_b_val+=b_error *d_11(b_level);
				cvSet2D(temp,i+1,j-1,cvScalar(next_b_val,next_g_val,next_r_val));
				
				next_r_val = cvGet2D(temp,i+1,j).val[2];
				next_g_val = cvGet2D(temp,i+1,j).val[1];
				next_b_val = cvGet2D(temp,i+1,j).val[0];
				next_r_val+=r_error *d01(r_level);
				next_g_val+=g_error *d01(g_level);
				next_b_val+=b_error *d01(b_level);
				cvSet2D(temp,i+1,j,cvScalar(next_b_val,next_g_val,next_r_val));
			}
#else
			double gray_val;
			gray_val = cvGet2D(temp,i,j+1).val[0];
			gray_val += error *d10(level);
			cvSet2D(temp,i,j+1,cvScalar(gray_val));
			
			gray_val = cvGet2D(temp,i+1,j-1).val[0];
			gray_val += error *d_11(level);
			cvSet2D(temp,i+1,j-1,cvScalar(gray_val));

			gray_val = cvGet2D(temp,i+1,j).val[0];
			gray_val += error *d01(level);
			cvSet2D(temp,i+1,j,cvScalar(gray_val));
#endif			
			//(CV_IMAGE_ELEM(temp, double, i, j + 1)) += error *d10(level);
			//(CV_IMAGE_ELEM(temp, double, i + 1, j - 1)) += error *d_11(level);
			//(CV_IMAGE_ELEM(temp, double, i + 1, j)) += error *d01(level);
		}
	}
	cvAvgSdv(res,&mean,&globalSigma);
	printf("result--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);
	
	cvReleaseImage(&temp);
	cvReleaseImage(&Laplace_o);
	cvReleaseImage(&Laplace);
	cvReleaseImage(&Laplace_Sobel);
	cvReleaseImage(&ThresholdMatrix);
	cvReleaseImage(&Ts_Matrix);
	cvReleaseImage(&K_Matrix);
	cvReleaseImage(&sigma_Matrix);
	cvReleaseImage(&Ta_Matrix);
	cvReleaseImage(&temp);

	return res;
};

IplImage *Qr_Guide_Laplace_SAED_Halftone_color_paddingdata(IplImage *I_color,IplImage *I_gray,IplImage *Qr,int * paddingArea,int size){
	int width = Qr->width/size;
	IplImage *Laplace_o = cvCloneImage(I_gray);
	IplImage *Laplace = cvCloneImage(I_gray);
	IplImage *Laplace_Sobel = cvCloneImage(I_gray);
	//edge detection
	cvLaplace(I_gray,Laplace_o,3);
	
	cvScale(Laplace_o,Laplace,1,Laplace_clipping);
	
	
	
	IplImage *ThresholdMatrix = cvCloneImage(I_gray);
	cvSet(ThresholdMatrix,cvScalar(0.5));

	IplImage *Ts_Matrix = cvCloneImage(I_gray);
	cvSet(Ts_Matrix,cvScalar(0));

	IplImage *K_Matrix = cvCloneImage(I_gray);
	cvSet(K_Matrix,cvScalar(0));

	IplImage *sigma_Matrix = cvCloneImage(I_gray);
	cvSet(sigma_Matrix,cvScalar(0));

	IplImage *Ta_Matrix = cvCloneImage(I_gray);
	cvSet(Ta_Matrix,cvScalar(0));
	
	CvScalar  mean,globalSigma;
	cvAvgSdv(I_gray,&mean,&globalSigma);
	printf("original--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);

	int localWindowSize = 11;
	CvScalar sigmaMax,sigmaMin,sigmaCur;
	sigmaMax.val[0]=0;
	sigmaMin.val[0]=1;
	for (int i = localWindowSize/2;i < I_gray->height - localWindowSize/2 ; i++ ) {
		for (int j = localWindowSize/2; j < I_gray->width - localWindowSize/2 ; j++) {
			CvRect rect = cvRect(j - localWindowSize/2, i - localWindowSize/2,localWindowSize,localWindowSize);
			cvSetImageROI(I_gray,rect);
			cvAvgSdv(I_gray,&mean,&sigmaCur);
			cvSet2D(sigma_Matrix,i,j,sigmaCur);
			cvResetImageROI(I_gray); 
			if(sigmaCur.val[0]>sigmaMax.val[0])sigmaMax.val[0]=sigmaCur.val[0];
			if(sigmaCur.val[0]<sigmaMin.val[0])sigmaMin.val[0]=sigmaCur.val[0];
		}
	}
	printf("sigmaMax:%f sigmaMin:%f\n",sigmaMax.val[0],sigmaMin.val[0]);
	int hw = localWindowSize/2;
	int ii=hw,jj=hw;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			ii = i;
			jj = j;
			if(i<hw ){
				ii=hw;
			}
			if(j<hw ){
				jj=hw;
			}
			if(i+hw + 1 > I_gray->height ){
				ii = I_gray->height - hw - 1;
			}
			if(j+hw + 1 > I_gray->width ){
				jj = I_gray->width - hw - 1;
			}
			double gray = cvGet2D(sigma_Matrix,ii,jj).val[0];
			cvSet2D(sigma_Matrix,i,j,cvScalar(gray));
		}
	}
	double val0,val1,val2=sigmaMax.val[0]-sigmaMin.val[0];
	double grayk;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			val0 = scaleFactorC/globalSigma.val[0];
			val1 = fabs(cvGet2D(sigma_Matrix,i,j).val[0]-sigmaMax.val[0]);
			grayk = val0*(val1/val2)+scaleFactorC;
			cvSet2D(K_Matrix,i,j,cvScalar(grayk));
		}
	}
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			double k = cvGet2D(K_Matrix,i,j).val[0];
			double l = cvGet2D(Laplace,i,j).val[0];
			cvSet2D(Ts_Matrix,i,j,cvScalar(k*l));
		}
	}
	std::random_device rd;
    std::mt19937 gen(rd());
    // values near the mean are the most likely
    // standard deviation affects the dispersion of generated values from the mean
    std::normal_distribution<> d(0,0.1*255);
	double rnosize;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			rnosize = d(gen);
			cvSet2D(Ta_Matrix,i,j,cvScalar(rnosize));
		}
	}
	double sumt=0;
	for (int i = 0; i < I_gray->height; i++ ) {
		for (int j = 0; j < I_gray->width; j++) {
			double s = cvGet2D(Ts_Matrix,i,j).val[0];
			double a = cvGet2D(Ta_Matrix,i,j).val[0];
			sumt+=(s+a);
			
			cvSet2D(ThresholdMatrix,i,j,cvScalar(s+a));
		}
	}
	printf("ThresholdMatrix_Avg:%f\n",sumt/(I_gray->width*I_gray->height));
	double min_v,max_v;
	cvMinMaxLoc(ThresholdMatrix,&min_v,&max_v);
	printf("min_v%f max_v%f\n",min_v,max_v);
	
	IplImage *temp = cvCloneImage(I_color);
	IplImage *Qrtemp = cvCloneImage(Qr);
	IplImage *res = cvCloneImage(I_color);
	printf("QR_Avg:%f \n",cvAvg(Qrtemp).val[0]);//255
	
	cvZero(res);
	double Threshold=0;

	for (int i = 0; i < I_color->height; i++) {
		for (int j = 0; j < I_color->width; j++) {


			bool isQr_Point = isQrPoint(i,j,size);


			Threshold = cvGet2D(ThresholdMatrix,i,j).val[0];

	
			double r_error = 0;
			double g_error = 0;
			double b_error = 0;
			double r_val = cvGet2D(temp,i,j).val[2];
			double g_val = cvGet2D(temp,i,j).val[1];
			double b_val = cvGet2D(temp,i,j).val[0];
			double gray_val = cvGet2D(I_gray,i,j).val[0];
			double gray_val_pre = gray_val;
			bool modified = 0;
			if(isQr_Point){
				double val_qr = cvGet2D(Qrtemp,i,j).val[0];
				if(!paddingArea[(i/size)*width + (j/size)]){
					if(val_qr>0.01){
						gray_val = clamp(gray_val,127.5+MODIFY_THRESHOLD_NONE_PADDING_AREA,255.0);
							
						double ratio = gray_val/gray_val_pre;
						b_error = b_val- b_val*ratio; b_val = b_val*ratio;
						g_error = g_val- g_val*ratio;g_val = g_val*ratio;
						r_error = r_val- r_val*ratio;r_val = r_val*ratio;
						r_error*=GUIDE_RATIO;
						g_error*=GUIDE_RATIO;
						b_error*=GUIDE_RATIO;
						cvSet2D(res, i, j, cvScalar(b_val,g_val,r_val));
						
					}else{
						gray_val = clamp(gray_val,0.0,127.5-MODIFY_THRESHOLD_NONE_PADDING_AREA);
						double ratio = gray_val/gray_val_pre;
						b_error = b_val- b_val*ratio; b_val = b_val*ratio;
						g_error = g_val- g_val*ratio;g_val = g_val*ratio;
						r_error = r_val- r_val*ratio;r_val = r_val*ratio;
						r_error*=GUIDE_RATIO;
						g_error*=GUIDE_RATIO;
						b_error*=GUIDE_RATIO;
						cvSet2D(res, i, j, cvScalar(b_val,g_val,r_val));
						
					}
				}else{
						modified = isModified(gray_val,127.5-MODIFY_THRESHOLD_PADDING_AREA,127.5+MODIFY_THRESHOLD_PADDING_AREA);
						if(!modified){
							cvSet2D(res, i, j, cvScalar(b_val,g_val,r_val));
							r_error = 0;
							g_error = 0;
							b_error = 0;
						}
						else{
							double ratio = gray_val/gray_val_pre;
							b_error = b_val- b_val*ratio; b_val = b_val*ratio;
							g_error = g_val- g_val*ratio;g_val = g_val*ratio;
							r_error = r_val- r_val*ratio;r_val = r_val*ratio;
							r_error*=GUIDE_RATIO;
							g_error*=GUIDE_RATIO;
							b_error*=GUIDE_RATIO;
							cvSet2D(res, i, j, cvScalar(b_val,g_val,r_val));
						}
				}
			}else{
				{
					cvSet2D(res, i, j, cvScalar(b_val,g_val,r_val));
					r_error = 0;
					g_error = 0;
					b_error = 0;
				}

			}
			int r_level = mround(r_val);
			r_level = clamp(r_level, 0, 255);
			int g_level = mround(g_val);
			g_level = clamp(g_level, 0, 255);
			int b_level = mround(b_val);
			b_level = clamp(b_level, 0, 255);
			double next_r_val;
			double next_g_val;
			double next_b_val;
			if(j==0 && (i!=(I_color->height-1))){
				next_r_val = cvGet2D(temp,i,j+1).val[2];
				next_g_val = cvGet2D(temp,i,j+1).val[1];
				next_b_val = cvGet2D(temp,i,j+1).val[0];
				next_r_val+=r_error *d10(r_level);
				next_g_val+=g_error *d10(g_level);
				next_b_val+=b_error *d10(b_level);
				hcvSet2D(temp,i,j+1,cvScalar(next_b_val,next_g_val,next_r_val),size);
				
				next_r_val = cvGet2D(temp,i+1,j).val[2];
				next_g_val = cvGet2D(temp,i+1,j).val[1];
				next_b_val = cvGet2D(temp,i+1,j).val[0];
				next_r_val+=r_error *d01(r_level);
				next_g_val+=g_error *d01(g_level);
				next_b_val+=b_error *d01(b_level);
				hcvSet2D(temp,i+1,j,cvScalar(next_b_val,next_g_val,next_r_val),size);

			}else if((i!=(I_gray->height-1))&&(j!=(I_gray->width-1))){
				
				next_r_val = cvGet2D(temp,i,j+1).val[2];
				next_g_val = cvGet2D(temp,i,j+1).val[1];
				next_b_val = cvGet2D(temp,i,j+1).val[0];
				next_r_val+=r_error *d10(r_level);
				next_g_val+=g_error *d10(g_level);
				next_b_val+=b_error *d10(b_level);
				hcvSet2D(temp,i,j+1,cvScalar(next_b_val,next_g_val,next_r_val),size);
				
				next_r_val = cvGet2D(temp,i+1,j-1).val[2];
				next_g_val = cvGet2D(temp,i+1,j-1).val[1];
				next_b_val = cvGet2D(temp,i+1,j-1).val[0];
				next_r_val+=r_error *d_11(r_level);
				next_g_val+=g_error *d_11(g_level);
				next_b_val+=b_error *d_11(b_level);
				hcvSet2D(temp,i+1,j-1,cvScalar(next_b_val,next_g_val,next_r_val),size);
				
				next_r_val = cvGet2D(temp,i+1,j).val[2];
				next_g_val = cvGet2D(temp,i+1,j).val[1];
				next_b_val = cvGet2D(temp,i+1,j).val[0];
				next_r_val+=r_error *d01(r_level);
				next_g_val+=g_error *d01(g_level);
				next_b_val+=b_error *d01(b_level);
				hcvSet2D(temp,i+1,j,cvScalar(next_b_val,next_g_val,next_r_val),size);
				
			}else if((i==(I_gray->height-1))&&(j==(I_gray->width-1))){
				continue;
			}else if(i==(I_gray->height-1)){

				next_r_val = cvGet2D(temp,i,j+1).val[2];
				next_g_val = cvGet2D(temp,i,j+1).val[1];
				next_b_val = cvGet2D(temp,i,j+1).val[0];
				next_r_val+=r_error *d10(r_level);
				next_g_val+=g_error *d10(g_level);
				next_b_val+=b_error *d10(b_level);
				hcvSet2D(temp,i,j+1,cvScalar(next_b_val,next_g_val,next_r_val),size);
				
			}else if(j==(I_gray->width-1)){
				next_r_val = cvGet2D(temp,i+1,j-1).val[2];
				next_g_val = cvGet2D(temp,i+1,j-1).val[1];
				next_b_val = cvGet2D(temp,i+1,j-1).val[0];
				next_r_val+=r_error *d_11(r_level);
				next_g_val+=g_error *d_11(g_level);
				next_b_val+=b_error *d_11(b_level);
				hcvSet2D(temp,i+1,j-1,cvScalar(next_b_val,next_g_val,next_r_val),size);
				
				next_r_val = cvGet2D(temp,i+1,j).val[2];
				next_g_val = cvGet2D(temp,i+1,j).val[1];
				next_b_val = cvGet2D(temp,i+1,j).val[0];
				next_r_val+=r_error *d01(r_level);
				next_g_val+=g_error *d01(g_level);
				next_b_val+=b_error *d01(b_level);
				hcvSet2D(temp,i+1,j,cvScalar(next_b_val,next_g_val,next_r_val),size);
			}	
		}
	}
	cvAvgSdv(res,&mean,&globalSigma);
	printf("result--mean:%f globalSigma:%f\n",mean.val[0],globalSigma.val[0]);
	
	cvReleaseImage(&temp);
	cvReleaseImage(&Laplace_o);
	cvReleaseImage(&Laplace);
	cvReleaseImage(&Laplace_Sobel);
	cvReleaseImage(&ThresholdMatrix);
	cvReleaseImage(&Ts_Matrix);
	cvReleaseImage(&K_Matrix);
	cvReleaseImage(&sigma_Matrix);
	cvReleaseImage(&Ta_Matrix);
	cvReleaseImage(&temp);

	return res;
}