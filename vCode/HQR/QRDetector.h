//
//  QRDetector.h
//  vCode
//
//  Created by DarkTango on 5/28/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FBlock) (void);
@interface QRDetector : NSObject
+(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str isGray:(BOOL)isgray;
+(NSString *)decodeQRwithImg:(UIImage *)img;

+(UIImage *)generateQRforView:(UIImageView *) viewRef withImg:(UIImage *)img text:(NSString *)str style:(int)style version:(int)ver level:(int)lev codingarea:(float)codingarea paddingarea:(float)paddingarea guideratio:(float)ratio withFinishedBlock:(FBlock) block;
+(int)getMinimunVersionWithText:(NSString*)text;

@end
