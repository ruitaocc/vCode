//
//  HQR.h
//  vCode
//
//  Created by ruitaocc on 15/4/20.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#ifndef vCode_HQR_h
#define vCode_HQR_h
#define HAVE_CONFIG_H  1
//#include <python2.7/Python.h>
#include "qrencode.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui_c.h>
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

extern int MODIFY_THRESHOLD_PADDING_AREA ;
extern int MODIFY_THRESHOLD_NONE_PADDING_AREA ;  //127.5-50   127.5+50


#define OTHER_INFO 1
#define INCHES_PER_METER (100.0/2.54)
#define USE_PADDING_EREA 1

static unsigned int fg_color[4] = {0, 0, 0, 255};
static unsigned int bg_color[4] = {255, 255, 255, 255};
typedef enum _imageType {
    PNG_TYPE,
    EPS_TYPE,
    SVG_TYPE,
    ANSI_TYPE,
    ANSI256_TYPE,
    ASCII_TYPE,
    ASCIIi_TYPE,
    UTF8_TYPE,
    ANSIUTF8_TYPE
}imageType;

@interface HQR : NSObject {
    int _qr_point;
    int _h_qr_point;
}
+(HQR*)getInstance;

-(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str;

-(QRcode*) encode:(const unsigned char *)intext length:(int)length maskImage:(int *)maskImg ;

-(UIImage *)UIImageFromIplImage:(IplImage *)image;
-(UIImage *)UIImageFromMat:(cv::Mat)aMat;
-(IplImage *)CreateIplImageFromUIImage:(UIImage *)image;
@property(nonatomic,assign)int version;//qr code version
@property(nonatomic,assign)QRecLevel level;//error correction level
@property(nonatomic,assign)int casesensitive;
@property(nonatomic,assign)int eightbit;
@property(nonatomic,assign)int size;
//@property(nonatomic,assign)int qr_point;
//@property(nonatomic,assign)int h_qr_point;
@property(nonatomic,assign)int margin;
@property(nonatomic,assign)int dpi;
@property(nonatomic,assign)int structured;
@property(nonatomic,assign)int micro;
@property(nonatomic,assign)int padding;
@property(nonatomic,assign)QRencodeMode hint;
@property(nonatomic,assign)imageType image_type;


@end
#endif
