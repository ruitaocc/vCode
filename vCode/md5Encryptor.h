//
//  md5Encryptor.h
//  vCode
//
//  Created by DarkTango on 5/11/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

#ifndef vCode_md5Encryptor_h
#define vCode_md5Encryptor_h
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface md5Encryptor:NSObject
+(NSString *)md5:(NSString *)str;
@end
#endif
