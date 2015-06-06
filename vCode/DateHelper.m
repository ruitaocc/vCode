//
//  DateHelper.m
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper
//@"yyyy_MM_dd_HH_mm_ss
+(NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    dateFormatter = nil;
    return destDate;
    
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    dateFormatter = nil;
    return destDateString;
}


+(NSString *)getCurDateStringWithFormat:(NSString*)format{
    return [DateHelper stringFromDate:[NSDate date] withFormat:format];
};
@end
