//
//  NSString+Extension.h
//  FCLBaseDemo
//
//  Created by fcl on 16/7/26.
//  Copyright © 2016年 付程隆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (Extension)
//计算文本高度
- (CGSize)textSizeWithFont:(CGFloat)aFont constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

//精确数值的比较大小
- (BOOL)decimalNumComparewithSecondStr:(NSString *)secondStr;

//获取Mac地址后4位
+ (NSString *)lastFourMacLetterWithStr:(NSString *)str;

//日期处理
//将时间戳转化为短日期
- (NSString *)changeTimestampToShortDate:(NSString *)sourceDate;
//将时间戳转化为长日期
- (NSString *)changeTimestampToLongDate:(NSString *)sourceDate;
//时间差
- (NSString *)diffTimestampToShortDate:(NSString *)sourceDate;

//MD5
+ (NSString *)md5To32bit:(NSString *)str;
+(NSString *)stringToMD5:(NSString *)inputStr;



@end
