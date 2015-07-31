//
//  QRDetector.m
//  vCode
//
//  Created by DarkTango on 5/28/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

#import "QRDetector.h"
#import "HQR.h"
#import "HQR_typedef.h"
@implementation QRDetector
+(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str isGray:(BOOL)isgray{
    HQR* hqr = [HQR getInstance];
    return [hqr generateQRwithImg:img text:str version:0 level:QR_ECLEVEL_L style:HQR_Style_ColorHalftone];
}

+(NSString *)decodeQRwithImg:(UIImage *)img{
    HQR* hqr = [HQR getInstance];
    return [hqr decodeQRwithImg:img];
}

+(UIImage *)addWaterMarkToQRcode:(UIImage*)qrimg waterMark:(UIImage*)watermark{
    // Create a thumbnail version of the image for the event object.
    CGSize size = qrimg.size;
    
    // Crop the image before resize
    // Done cropping
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, size.width,size.height);
    CGRect rect2 = CGRectMake((size.width-watermark.size.width)/2, size.height-24, watermark.size.width,24 );
    UIGraphicsBeginImageContext(rect.size);
    [qrimg drawInRect:rect];
    [watermark drawInRect:rect2];
    
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    return ret;
};
+(UIImage *)generatePhotoThumbnail:(UIImage*)image{
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = 150.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;

};

+(UIImage *)generateQRforView:(UIImageView *) viewRef withImg:(UIImage *)img text:(NSString *)str style:(int)style version:(int)ver level:(int)lev codingarea:(float)codingarea paddingarea:(float)paddingarea guideratio:(float)ratio withFinishedBlock:(FBlock) block{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        __block UIImage *image = nil;
        dispatch_sync(concurrentQueue, ^{
            HQR* hqr = [HQR getInstance];
            [hqr setThreshold_PaddingArea:paddingarea nodePaddingArea:codingarea GuideRatio:ratio];
            UIImage*qrcode =  [hqr generateQRwithImg:img text:str version:ver level:(QRecLevel)lev style:(HQR_style)style];
            UIImage*watermark = [UIImage imageNamed:@"2vmawatermark.png"];
            image = [QRDetector addWaterMarkToQRcode:qrcode waterMark:watermark];
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            [viewRef setImage:image];
            if(block)block();
        });
    });
    return img;
    
};
+(int)getMinimunVersionWithText:(NSString*)text{
    HQR* hqr = [HQR getInstance];
    return [hqr getMinimunVersionWithText:text];
};

@end
