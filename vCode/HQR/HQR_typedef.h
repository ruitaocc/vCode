//
//  HQR_typedef.h
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#ifndef vCode_HQR_typedef_h
#define vCode_HQR_typedef_h

typedef enum _HQR_type{
    HQR_Unknown = 0,
    HQR_Url,
    HQR_Weichat,
    HQR_Qr2vCode,//qr code 2 v code
    HQR_Text,
    HQR_Online_NameCard
}HQR_type;

typedef enum _HQR_style{
    HQR_Style_ImageGuide,
    HQR_Style_ColorHalftone,
    HQR_Style_GrayHalftone,
    HQR_Style_PaddingOptimize,
    HQR_Style_Normal
}HQR_style;

#endif
