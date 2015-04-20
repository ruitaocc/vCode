//#define masking_qr_cpp
#ifdef masking_qr_cpp
#define HAVE_CONFIG_H  1

#include "qrencode.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cv.h>	
#include <highgui.h>
#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <random>
#include <functional>
#include <vector>
#include "Ostromoukhov.h"
#include "Dithering.h"
using namespace std;
#define INCHES_PER_METER (100.0/2.54)

static int casesensitive = 1;
static int eightbit = 0;
static int version = 5;//
static int size = 3;//
static int qr_point = (version-1)*4+21;
static int h_qr_point = qr_point*3;
static int margin = -1;
static int dpi = 72;
static int structured = 0;
static int micro = 0;
static QRecLevel level = QR_ECLEVEL_L;
static QRencodeMode hint = QR_MODE_8;
static unsigned int fg_color[4] = {0, 0, 0, 255};
static unsigned int bg_color[4] = {255, 255, 255, 255};
void addAlignMentPatterm(IplImage * img,IplImage * Qr,QRcode * qrcode);
enum imageType {
	PNG_TYPE,
	EPS_TYPE,
	SVG_TYPE,
	ANSI_TYPE,
	ANSI256_TYPE,
	ASCII_TYPE,
	ASCIIi_TYPE,
	UTF8_TYPE,
	ANSIUTF8_TYPE
};


double rand_double() {
	return double(rand()) / double(RAND_MAX);
}





static enum imageType image_type = PNG_TYPE;
static QRcode *encode(const unsigned char *intext, int length, int * maskImage)
{
	QRcode *code;

	if(micro) {
		if(eightbit) {
			code = QRcode_encodeDataMQR(length, intext, version, level);
		} else {
			code = QRcode_encodeStringMQR((char *)intext, version, level, hint, casesensitive);
		}
	} else {
		if(eightbit) {
			code = QRcode_encodeData(length, intext, version, level);
		} else {
			code = QRcode_encodeString((char *)intext, version, level, hint, casesensitive, maskImage);//use
		}
	}

	return code;
}
void addDetector(IplImage * img);

int main(int argc,const char ** argv){
	int * maskImage = new int[qr_point*qr_point];
	IplImage *I;
	IplImage *Ih;//halftone
	
	IplImage *Ir;//halftone-qr-merge
	IplImage *Iqr;//halftone-qr-with-ditector
	IplImage *img3 = cvLoadImage("C:/Users/Administrator/Desktop/qq.png", 0);
	IplImage *img4 = cvCreateImage(cvSize(h_qr_point, h_qr_point), IPL_DEPTH_8U, img3->nChannels);
	cvResize(img3, img4);
	
	cvShowImage("original", img4);
	IplImage *fimg2 = cvCreateImage(cvGetSize(img4), IPL_DEPTH_64F, img4->nChannels);
	cvCvtScale(img4, fimg2, 1.0/255.);

	I = fimg2;


	DitheringHalftone(I,maskImage);
	
	for(int i = 0; i< 37; i++){
		for(int j = 0; j< 37; j++){
			if(maskImage[i*37+j])printf("*");
			else printf(" ");
			
		}
		printf("\n");
	}
	QRcode *qrcode;
	IplImage *Qr;//qr-code
	unsigned char *intext =(unsigned char *)"http://www.taobao.com/";
	int length = 0;
	length = strlen((char *)intext);
	qrcode = encode(intext, length,maskImage);
	int width = qrcode->width;
	unsigned char * p = qrcode->data;
	/*
	for(int i = 0; i< width; i++){
		for(int j = 0; j< width; j++){
			if(*(p+i*width+j)%2==1)printf("*");
			else printf(" ");
			
		}
		printf("\n");
	}*/
	
	QRcode *binary_image;

	IplImage *img = cvCreateImage(cvSize(h_qr_point, h_qr_point), IPL_DEPTH_64F, 1);
	Qr = img;
	cvZero(Qr);
	int qwidth = Qr->width;
	for(int i = 0; i< qwidth; i++){
		for(int j = 0; j< qwidth; j++){
			cvSet2D(Qr, i, j, cvScalar(1));
		}
	}

	for(int i = 0; i< width; i++){
		for(int j = 0; j< width; j++){
			if(*(p+i*width+j)%2==1){
				for(int k = 0; k<size; k++){
					for(int h = 0; h<size; h++){
						cvSet2D(Qr, i*size+k, j*size+h, cvScalar(0));
					}
				}
			}else{
				for(int k = 0; k<size; k++){
					for(int h = 0; h<size; h++){
						cvSet2D(Qr, i*size+k, j*size+h, cvScalar(1));
					}
				}
				
			}
			
		}
		
	}
	cvShowImage("Qr", Qr);


	//qr halftone
	Ih = OstromoukhovHalftone(I);
	cvShowImage("Ih", Ih);
	cvWaitKey();
	
	Ir = cvCloneImage(Ih);
	for(int i = 0; i< width; i++){
		for(int j = 0; j< width; j++){
			if(*(p+i*width+j)%2==1)cvSet2D(Ir, i*3+1, j*3+1, cvScalar(0));
			else cvSet2D(Ir, i*3+1, j*3+1, cvScalar(1));
		}
	}
	cvShowImage("Ir", Ir);
	Iqr = cvCloneImage(Ir);
	addAlignMentPatterm(Iqr, Qr,qrcode);
	//addDetector(Iqr);
	IplImage *img8bit = cvCreateImage(cvSize(h_qr_point, h_qr_point), IPL_DEPTH_8U, 1);
	IplImage *img8bit3 = cvCreateImage(cvSize(h_qr_point*3, h_qr_point*3), IPL_DEPTH_8U, 1);
	cvCvtScale(Iqr, img8bit,255);
	cvResize(img8bit, img8bit3,CV_INTER_NN);
	cvSaveImage("C:/Users/Administrator/Desktop/half/img8bit111.png",img8bit3);
	cvShowImage("Iqr", Iqr);
	cvWaitKey();
}
void addDetector(IplImage * img){
	for(int i =0; i<7	;i++){
		for(int j =0; j<7	;j++){
			for(int k = 0; k<size;k++){
				for(int h = 0; h<size;h++){
					cvSet2D(img, i*3+k, j*3+h, cvScalar(0));
				}
			}
		}
	}
	for(int i =1; i<6	;i++){
		for(int j =1; j<6	;j++){
			if(i==1||i==5||j==1||j==5){
				for(int k = 0; k<size;k++){
					for(int h = 0; h<size;h++){
						cvSet2D(img, i*3+k, j*3+h, cvScalar(1));
					}
				}
			}
		}
	}
	int i_index = (version-1)*4+21-7;
	for(int i =i_index; i<i_index+7;i++){
		for(int j =0; j<7	;j++){
			for(int k = 0; k<size;k++){
				for(int h = 0; h<size;h++){
					cvSet2D(img, i*3+k, j*3+h, cvScalar(0));
				}
			}
		}
	}
	for(int i =i_index+1; i<i_index+6	;i++){
		for(int j =1; j<6	;j++){
			if(i==i_index+1||i==i_index+5||j==1||j==5){
				for(int k = 0; k<size;k++){
					for(int h = 0; h<size;h++){
						cvSet2D(img, i*3+k, j*3+h, cvScalar(1));
					}
				}
			}
		}
	}
	int j_index = (version-1)*4+21-7;
	for(int i =0; i<7;i++){
		for(int j =j_index; j<j_index+7	;j++){
			for(int k = 0; k<size;k++){
				for(int h = 0; h<size;h++){
					cvSet2D(img, i*3+k, j*3+h, cvScalar(0));
				}
			}
		}
	}
	for(int i =1; i<6	;i++){
		for(int j =j_index+1; j<j_index+6	;j++){
			if(i==1||i==5||j==j_index+1||j==j_index+5){
				for(int k = 0; k<size;k++){
					for(int h = 0; h<size;h++){
						cvSet2D(img, i*3+k, j*3+h, cvScalar(1));
					}
				}
			}
		}
	}
	int ii_index = i_index-2;
	int jj_index = j_index-2;
	for(int i =ii_index; i<ii_index+5;i++){
		for(int j =jj_index; j<jj_index+5	;j++){
			for(int k = 0; k<size;k++){
				for(int h = 0; h<size;h++){
					cvSet2D(img, i*3+k, j*3+h, cvScalar(0));
				}
			}
		}
	}
	for(int i =ii_index+1; i<ii_index+4	;i++){
		for(int j =jj_index+1; j<jj_index+4	;j++){
			if(i==ii_index+1||i==ii_index+3||j==jj_index+1||j==jj_index+3){
				for(int k = 0; k<size;k++){
					for(int h = 0; h<size;h++){
						cvSet2D(img, i*3+k, j*3+h, cvScalar(1));
					}
				}
			}
		}
	}
};
void projectPointFormQR(IplImage * img,IplImage * Qr,int i,int j){
	bool iswirte = cvGet2D(Qr,i*3+1,j*3+1).val[0]>0.1;
	float scalar = 0;
	if(iswirte)scalar = 255.0;
	for(int k = 0; k<size;k++){
		for(int h = 0; h<size;h++){
			cvSet2D(img, i*3+k, j*3+h, cvScalar(scalar));
		}
	}
};

void addAlignMentPatterm(IplImage * img,IplImage * Qr,QRcode * qrcode){
  int width = qrcode->width;
  unsigned char * p = qrcode->data;
  for(int i = 0; i< width; i++){
    for(int j = 0; j< width; j++){
      //>>7 see QRcode class
      if(((*(p+i*width+j))>>7)%2==1)projectPointFormQR(img,Qr,i,j);
    }
  }
};
#endif