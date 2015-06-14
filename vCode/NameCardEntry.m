//
//  NameCardEntry.m
//  vCode
//
//  Created by ruitaocc on 15/6/14.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "NameCardEntry.h"

@implementation NameCardEntry

@synthesize m_id;//id --> url

@synthesize m_fullname;
@synthesize m_nickname;
@synthesize m_gender;
@synthesize m_birthday;
@synthesize m_avatar_local_name;
@synthesize m_avatar_url;
@synthesize m_tel;
@synthesize m_email;
@synthesize m_address;
@synthesize m_qq;
@synthesize m_wechat;
@synthesize m_homepage;
@synthesize m_job;
@synthesize m_org;
@synthesize m_intr;

-(id)init{
    if(self = [super init]){
         m_id =  nil;//id --> url
        
         m_fullname = nil;
         m_nickname = nil;
         m_gender = 0;
         m_birthday = nil;
         m_avatar_url = nil;
         m_avatar_local_name= nil;
         m_tel = nil;
         m_email = nil;
         m_address= nil;
         m_qq= nil;
         m_wechat= nil;
         m_homepage= nil;
         m_job= nil;
         m_org= nil;
         m_intr= nil;
        
    }
    return self;
}

+(NSString *)getTableName
{
    return @"t_NameCardTable";
}


+(NameCardEntry*)getNameCardEntryById:(NSString*)s_id{

    NSInteger row = [NameCardEntry rowCountWithWhere:nil];
    NSString *condition = [NSString stringWithFormat:@"m_id = %@",s_id];
    NSMutableArray* array = [NameCardEntry searchWithWhere:condition orderBy:nil offset:0 count:row];
    if ([array count]) {
        return [array objectAtIndex:0];
    }
    return nil;
};

@end
