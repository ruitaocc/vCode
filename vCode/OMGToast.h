//
//  OMGToast.h
//  vCode
//
//  Created by ruitaocc on 15/8/7.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#ifndef vCode_OMGToast_h
#define vCode_OMGToast_h
#define DEFAULT_DISPLAY_DURATION 2.0f
#import <Foundation/Foundation.h>
@interface OMGToast : NSObject {
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

@end

#endif
