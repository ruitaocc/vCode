//
//  HistoryEntry.m
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//
#import "HistoryEntry.h"
#import "DateHelper.h"
//@interface NSObject(LKDBHelper_Delegate)
//
//+(void)dbDidCreateTable:(LKDBHelper*)helper tableName:(NSString*)tableName;
//+(void)dbDidAlterTable:(LKDBHelper*)helper tableName:(NSString*)tableName addColumns:(NSArray*)columns;
//
//+(BOOL)dbWillInsert:(NSObject*)entity;
//+(void)dbDidInserted:(NSObject*)entity result:(BOOL)result;
//
//+(BOOL)dbWillUpdate:(NSObject*)entity;
//+(void)dbDidUpdated:(NSObject*)entity result:(BOOL)result;
//
//+(BOOL)dbWillDelete:(NSObject*)entity;
//+(void)dbDidDeleted:(NSObject*)entity result:(BOOL)result;
//
/////data read finish
//+(void)dbDidSeleted:(NSObject*)entity;
//
//@end

@implementation HistoryEntry

@synthesize m_generated_picName;

@synthesize m_original_picName;

@synthesize m_embedded_message;

@synthesize m_original_message;

@synthesize m_time;

@synthesize m_type;

@synthesize m_version;

@synthesize m_level;

-(id)init{
    if(self = [super init]){
        m_time = [DateHelper getCurDateStringWithFormat:@"yyyy_MM_dd_HH_mm_ss"];
        m_generated_picName = @"";
        m_original_picName = @"";
        m_embedded_message = @"";
        m_generated_picName = @"";
        m_original_message = @"";
        m_type = HQR_Unknown;
        m_version = -1;
        m_level = -1;
    }
    return self;
}

+(NSString *)getTableName
{
    return @"t_History";
}

+(NSMutableArray*)getAllHistory{
    NSInteger row = [HistoryEntry rowCountWithWhere:nil];
    NSMutableArray* array = [HistoryEntry searchWithWhere:nil orderBy:nil offset:0 count:row];
    return array;
};

@end