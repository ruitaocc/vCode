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
    return [hqr generateQRwithImg:img text:str isGray:isgray];
}

+(NSString *)decodeQRwithImg:(UIImage *)img{
    HQR* hqr = [HQR getInstance];
    return [hqr decodeQRwithImg:img];
}
@end
