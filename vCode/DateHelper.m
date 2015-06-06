//
//  DateHelper.m
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper
+(NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy_MM_dd_HH_mm_ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    dateFormatter = nil;
    return destDate;
    
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    dateFormatter = nil;
    return destDateString;
}


+(NSString *)getCurDateString{
    return [DateHelper stringFromDate:[NSDate date]];
};
@end
