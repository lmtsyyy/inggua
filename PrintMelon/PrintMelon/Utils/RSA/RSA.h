//
//  RSA.h
//  善理
//
//  Created by Leo的Mac on 16/5/18.
//  Copyright © 2016年 付程隆. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface RSA : NSObject

// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

// string 分割加解密 支持中文
+ (NSString *)encryptByRsaWith:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSString *)decryptByRsaWith:(NSString *)str privateKey:(NSString *)privKey;
+ (NSString *)encryptByRsaWithString:(NSString *)str publicKey:(NSString *)pubKey;

@end

