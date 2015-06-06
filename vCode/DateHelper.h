//
//  DateHelper.h
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
+(NSDate*) dateFromString:(NSString*)uiDate;

+ (NSString *)stringFromDate:(NSDate *)date;

+(NSString *)getCurDateString;
@end
