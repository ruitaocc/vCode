//
//  QRDetector.h
//  vCode
//
//  Created by DarkTango on 5/28/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRDetector : NSObject
+(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str isGray:(BOOL)isgray;
+(NSString *)decodeQRwithImg:(UIImage *)img;

+(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str style:(int)style version:(int)ver level:(int)lev codingarea:(float)codingarea paddingarea:(float)paddingarea guideratio:(float)ratio;
+(int)getMinimunVersionWithText:(NSString*)text;

@end
