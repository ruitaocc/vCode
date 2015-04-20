//#define main_laplace_cpp
#ifdef main_laplace_cpp
#define HAVE_CONFIG_H  1
//#include <python2.7/Python.h>
#include "qrencode.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui.hpp>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <algorithm>
//#include <random>
#include <functional>
#include <string>
#include <vector>
#include <time.h>
#include "QR_GuideOstromoukhov.hpp"
#include "Laplace_SAED.hpp"
#include "Dithering.h"
using namespace std;

#define OTHER_INFO 1


#define INCHES_PER_METER (100.0/2.54)

#define USE_PADDING_EREA 1 
static int version = 5;
static QRecLevel level = QR_ECLEVEL_H;



static int casesensitive = 1;
static int eightbit = 0;
static int size = 3;
static int qr_point = (version-1)*4+21;
static int h_qr_point = qr_point*3;
static int margin = -1;
static int dpi = 72;
static int structured = 0;
static int micro = 0;
static int padding = 3;
static QRencodeMode hint = QR_MODE_8;
static unsigned int fg_color[4] = {0, 0, 0, 255};
static unsigned int bg_color[4] = {255, 255, 255, 255};

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

void addAlignMentPatterm_gray(IplImage * img,IplImage * Qr,QRcode *qrcode);//ij is the center of the alignmentpatterm
void addAlignMentPatterm_color(IplImage * img,IplImage * Qr,QRcode *qrcode);//ij is the center of the alignmentpatterm
void projectPointFormQR_gray(IplImage * img,IplImage * Qr,int i,int j);//QRcode to HalftoneImage
void projectPointFormQR_color(IplImage * img,IplImage * Qr,int i,int j);//QRcode HalftoneImage

void convertToBits( QRcode * qrcode,int *A,const char* filename );//int
int generateQR(char *inputstr,char* inputfile,char* outputfile){
	cout<<"start"<<endl;
	string *inputfilepath = new string(inputfile);
	string *outputfilepath = new string(outputfile);

	qr_point = (version-1)*4+21;
	h_qr_point = qr_point*3;
	int * maskImage = new int[qr_point*qr_point];
	int * paddingArea = new int[qr_point*qr_point];

	int * bits = new int[((qr_point+31)/32)*qr_point];//
    
	
   
	IplImage *I_gray;
        IplImage *I_color;
	IplImage *Ih_gray;//qr_guide_halftone
	IplImage *Ih_color;//qr_guide_halftone
	IplImage *Iqr_gray;//halftone-qr-with-ditector
	IplImage *Iqr_color;//halftone-qr-with-ditector
	
	//
	IplImage *color_original = cvLoadImage(inputfilepath->c_str(),1);
	IplImage *color_resized = cvCreateImage(cvSize(h_qr_point, h_qr_point), color_original->depth, color_original->nChannels);
	cvResize(color_original, color_resized);

	IplImage *gray_original = cvLoadImage(inputfilepath->c_str(), 0);
	IplImage *gray_resized = cvCreateImage(cvSize(h_qr_point, h_qr_point), IPL_DEPTH_8U, gray_original->nChannels);
	cvResize(gray_original, gray_resized);
	I_gray = gray_resized;
	DitheringHalftone(I_gray,maskImage);//
	memcpy(paddingArea,maskImage,sizeof(int)*qr_point*qr_point);//
	
	cout<<"pos1"<<endl;	
	
	QRcode *qrcode;
	IplImage *Qr;//qr-code
	unsigned char *intext =(unsigned char *)inputstr;
	int length = 0;
	length = strlen((char *)intext);
#if USE_PADDING_EREA
	qrcode = encode(intext, length, paddingArea);
#else
	qrcode = encode(intext, length, NULL);
#endif
	int width = qrcode->width;
	unsigned char * p = qrcode->data;

	IplImage *img = cvCreateImage(cvSize(h_qr_point, h_qr_point), IPL_DEPTH_64F, 1);
	Qr = img;
	cvZero(Qr);
	cvSet(Qr,cvScalar(255));

	//convertToBits(qrcode , bits,output_data_path->c_str());
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
					cvSet2D(Qr, i*size+k, j*size+h, cvScalar(255));
					}
				}	
			}
		}
    }
	I_color = color_resized;
	cout<<"gray qr generated"<<endl;

   // Ih = QR_Guide_OstromoukhovHalftone(I,Qr);
	Ih_gray = Qr_Guide_Laplace_SAED_Halftone_gray(I_gray,Qr);
	cout<<"gray halftone generated"<<endl; 
   //Ih_color = Qr_Guide_Laplace_SAED_Halftone_color(I_color,I_gray,Qr);
	Ih_color = Qr_Guide_Laplace_SAED_Halftone_color_paddingdata(I_color,I_gray,Qr,paddingArea);
	cout<<"half tone img generated"<<endl;    
   
	//Iqr_gray = cvCloneImage(Ih_gray);
	Iqr_color = cvCloneImage(Ih_color);
#if OTHER_INFO
	//	addAlignMentPatterm_gray(Iqr_gray,Qr,qrcode);
    addAlignMentPatterm_color(Iqr_color,Qr,qrcode);
#endif
	cout<<"saving"<<endl;
    IplImage *img_color_3 = cvCreateImage(cvSize(Iqr_color->width * 3 , Iqr_color->height * 3 ), Iqr_color->depth, Iqr_color->nChannels);
   cvResize(Iqr_color, img_color_3, CV_INTER_NN);

   IplImage *img_color_3_margin = cvCreateImage(cvSize(Iqr_color->width * 3 + 24, Iqr_color->height * 3 + 24), Iqr_color->depth, Iqr_color->nChannels);
   cv::Mat img_color_mat(Iqr_color);
   cv::Mat img_color_3_mat(img_color_3);
   cv::Mat img_color_3_margin_mat(img_color_3_margin);
   img_color_3_margin_mat.setTo(255);
   cv::Mat imageROI_color;
   imageROI_color = img_color_3_margin_mat(cv::Rect(12, 12, img_color_mat.cols * 3, img_color_mat.rows*3));
   img_color_3_mat.copyTo(imageROI_color);
   IplImage color_3_margin = img_color_3_margin_mat;
   img_color_3_margin = (IplImage*)(&color_3_margin);
   cvSaveImage(outputfilepath->c_str(), img_color_3_margin);
   cout<<"saved img"<<endl;
    //  cvReleaseImage(&Iqr);
    // cvReleaseImage(&fimg2);
    // cvReleaseImage(&img8bit3);    

  cout<<"finish"<<endl;
  delete outputfilepath;outputfilepath = NULL;
  delete inputfilepath;inputfilepath = NULL;
  delete [] maskImage; maskImage = NULL;
  delete [] bits; bits = NULL;
  return 1;

}
//PyObject* wrap_generateQR(PyObject* self,PyObject* args){
//        char* str;
//	char* in,*out;
//	int ok = PyArg_ParseTuple(args,"sss",&str,&in,&out);
//	if(!ok)return NULL;
//        int a = generateQR(str,in,out);
//	return Py_BuildValue("i",a);
//}
//static PyMethodDef HQRMethods[] ={
//	{"generateQR",wrap_generateQR,METH_VARARGS,"g(str,in,out)"},
//	{NULL,NULL}
//};
//PyMODINIT_FUNC initHQR(void){
//	PyObject* m;
//	m = Py_InitModule("HQR",HQRMethods);
//};
void projectPointFormQR_gray(IplImage * img,IplImage * Qr,int i,int j){
	bool iswirte = cvGet2D(Qr,i*3+1,j*3+1).val[0]>0.1;
	float scalar = 0;
	if(iswirte)scalar = 255.0;
	for(int k = 0; k<size;k++){
		for(int h = 0; h<size;h++){
			cvSet2D(img, i*3+k, j*3+h, cvScalar(scalar));
		}
	}
};
void projectPointFormQR_color(IplImage * img,IplImage * Qr,int i,int j){
	bool iswirte = cvGet2D(Qr,i*3+1,j*3+1).val[0]>0.1;
	float scalar = 0;
	if(iswirte)scalar = 255.0;
	for(int k = 0; k<size;k++){
		for(int h = 0; h<size;h++){
			cvSet2D(img, i*3+k, j*3+h, cvScalar(scalar,scalar,scalar));
		}
	}
};


void addAlignMentPatterm_gray(IplImage * img,IplImage * Qr,QRcode * qrcode){
  int width = qrcode->width;
  unsigned char * p = qrcode->data;
  for(int i = 0; i< width; i++){
    for(int j = 0; j< width; j++){
      //>>7 see QRcode class
      if(((*(p+i*width+j))>>7)%2==1)projectPointFormQR_gray(img,Qr,i,j);
    }
  }
};
void addAlignMentPatterm_color(IplImage * img,IplImage * Qr,QRcode * qrcode){
  int width = qrcode->width;
  unsigned char * p = qrcode->data;
  for(int i = 0; i< width; i++){
    for(int j = 0; j< width; j++){
      //>>7 see QRcode class
      if(((*(p+i*width+j))>>7)%2==1)projectPointFormQR_color(img,Qr,i,j);
    }
  }
};

 void convertToBits( QRcode * qrcode,int *A,const char* filename){
	 unsigned char *p = qrcode->data;
	 int width = qrcode->width;
	 int asize = ((width+31)/32)*width;
	 memset(A,0,sizeof(int)*asize);
	 for(int i = 0; i< width; i++){
		for(int j = 0; j< width; j++){
			if(*(p+i*width+j)%2==1){
				int index = i*2 +j/32;
				A[index]=A[index] | (0x01<<(j%32));
			}else{
				//	
			}
		}
    }
	 fstream file;
	 file.open(filename,ios::out);
	 for(int i = 0;i<asize ;i++){
		file<<A[i]<<endl;
	 }
	 file.close();
	
 }
#endif
