//
//  NameCardEntry.h
//  vCode
//
//  Created by ruitaocc on 15/6/14.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Pods/LKDBHelper/LKDBHelper/Helper/LKDBHelper.h"


@interface NameCardEntry : NSObject

@property(strong ,nonatomic)NSString *m_id;//id --> url

@property(strong ,nonatomic)NSString *m_fullname;
@property(strong ,nonatomic)NSString *m_nickname;
@property(assign ,nonatomic)NSInteger m_gender;
@property(strong ,nonatomic)NSString *m_birthday;
@property(strong ,nonatomic)NSString *m_avatar_local_name;
@property(strong ,nonatomic)NSString *m_avatar_url;
@property(strong ,nonatomic)NSString *m_tel;
@property(strong ,nonatomic)NSString *m_email;
@property(strong ,nonatomic)NSString *m_address;
@property(strong ,nonatomic)NSString *m_qq;
@property(strong ,nonatomic)NSString *m_wechat;
@property(strong ,nonatomic)NSString *m_homepage;
@property(strong ,nonatomic)NSString *m_job;
@property(strong ,nonatomic)NSString *m_org;
@property(strong ,nonatomic)NSString *m_intr;


+(NameCardEntry*)getNameCardEntryById:(NSString*)s_id;

@end
