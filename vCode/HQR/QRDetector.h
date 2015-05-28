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
@end
