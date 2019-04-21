//
//  NSDictionary+Extension.m
//  xiaozhu
//
//  Created by fuchenglong on 2017/7/21.
//  Copyright © 2017年 fuchenglong. All rights reserved.
//

#import "NSDictionary+Extension.h"
#import "RSA.h"

@implementation NSDictionary (Extension)
#pragma mark ==========MD5+RSA加密==========
//数据RSA加密
- (NSDictionary *)dicByRSAAndMD5ToDicWithMd5Value:(NSString *)md5Value
{
    //NSString *jieMiStr = [RSA decryptString:rsaStr privateKey:RSA_DEKEY];
    NSMutableDictionary *transParamDic = [[NSMutableDictionary alloc]initWithDictionary:self];
    NSString *md5Str = [NSString stringToMD5:md5Value];
    NSString *RSA_KEY = @"";
    NSString *rsaStr = [RSA encryptString:md5Str publicKey:RSA_KEY];
    
    [transParamDic setObject:rsaStr forKey:@"rsaValue"];
    
    return transParamDic;
}

#pragma mark ==========ELSE==========
-(id)objectForKeyOrNil:(id)key
{
    id value= [self objectForKey:key];
    if ([value isEqual:[NSNull null]] || value == nil) {
        return nil;
    }else{
        return value;
    }
}

@end
