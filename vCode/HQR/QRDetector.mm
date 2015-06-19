//
//  QRDetector.m
//  vCode
//
//  Created by DarkTango on 5/28/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

#import "QRDetector.h"
#import "HQR.h"
@implementation QRDetector
+(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str isGray:(BOOL)isgray{
    HQR* hqr = [HQR getInstance];
    return [hqr generateQRwithImg:img text:str version:0 level:QR_ECLEVEL_L isGray:isgray];
}

+(NSString *)decodeQRwithImg:(UIImage *)img{
    HQR* hqr = [HQR getInstance];
    return [hqr decodeQRwithImg:img];
}


+(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str style:(int)style version:(int)ver level:(int)lev codingarea:(float)codingarea paddingarea:(float)paddingarea guideratio:(float)ratio{
    HQR* hqr = [HQR getInstance];
    [hqr setThreshold_PaddingArea:paddingarea nodePaddingArea:codingarea GuideRatio:ratio];
    return [hqr generateQRwithImg:img text:str version:ver level:(QRecLevel)lev isGray:NO];
};
+(int)getMinimunVersionWithText:(NSString*)text{
    HQR* hqr = [HQR getInstance];
    return [hqr getMinimunVersionWithText:text];
};

@end
