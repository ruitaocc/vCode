//
//  HistoryEntry.h
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#ifndef vCode_HistoryEntry_h
#define vCode_HistoryEntry_h

#import <Foundation/Foundation.h>
#import "HQR_typedef.h"
#import "../Pods/LKDBHelper/LKDBHelper/Helper/LKDBHelper.h"

@interface HistoryEntry : NSObject

@property(strong ,nonatomic)NSString *m_generated_picName;

@property(strong ,nonatomic)NSString *m_original_picName;

@property(strong ,nonatomic)NSString *m_embedded_message;

@property(strong ,nonatomic)NSString *m_original_message;

@property(strong ,nonatomic)NSString *m_time;// (primary key)

@property(assign ,nonatomic)HQR_type m_type;

@property(assign ,nonatomic)int m_version;

@property(assign ,nonatomic)int m_level;

+(NSMutableArray*)getAllHistory;

@end

#endif
