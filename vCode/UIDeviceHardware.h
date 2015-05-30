
//
//  UIDeviceHardware.h
//  vCode
//
//  Created by ruitaocc on 15/5/29.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#ifndef vCode_UIDeviceHardware_h
#define vCode_UIDeviceHardware_h

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject

- (NSString *) platform;
- (NSString *) platformString;
- (BOOL)Is_IPH_56;
-(BOOL)Is_Simulator;
@end

#endif
