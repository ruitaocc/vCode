//
//  HQR.h
//  vCode
//
//  Created by ruitaocc on 15/4/20.
//  Copyright (c) 2015年 ruitaocc. All rights reserved. contract email@cairuitao.com
//

#ifndef vCode_HQR_h
#define vCode_HQR_h
#define HAVE_CONFIG_H  1
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
#include <functional>
#include <string>
#include <vector>
#include <time.h>
#include "QR_GuideOstromoukhov.hpp"
#include "Laplace_SAED.hpp"
#include "Dithering.h"
#include "HQR_typedef.h"
using namespace std;

extern float GUIDE_RATIO ;                      //[0,1]
extern float MODIFY_THRESHOLD_PADDING_AREA ;
extern float MODIFY_THRESHOLD_NONE_PADDING_AREA ;  //127.5-50   127.5+50


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

@interface HQR : NSObject
//singletone instance
+(HQR*)getInstance;

/*
 *  @param img: target image
 *  @param str: target short url
 *  @param isgray: retrun gray img or not, Default NO;
 *  @param verdion:version version of the symbol. If 0, the library chooses the minimum
 *               version for the given input data.
 *  @param level:error correction level.QR_ECLEVEL_L = 0,QR_ECLEVEL_M,QR_ECLEVEL_Q,QR_ECLEVEL_H
 */
-(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str version:(int)ver level:(QRecLevel)lev style:(HQR_style)style;

/*
 @param img: target image
 @param ret: return the decoded result text.
  */
-(NSString *)decodeQRwithImg:(UIImage *)img;

/*
  @parea:threshold range [0.0, 127.5]
  @nparea:threshold range [0.0, 127.5]
  @guideRatio: range[0.0,1.0]
  threshold lower than 50 should give a warning. is hard for scan
*/
-(bool)setThreshold_PaddingArea:(float)parea nodePaddingArea:(float)nparea GuideRatio:(float)guideRatio;

/*
 *@return: this function will return the minimum qr code version by the given text
 */
-(int)getMinimunVersionWithText:(NSString*)text;


@end
#endif
