//
//  UIColor+Hex.h
//  dfs
//
//  Created by Ranbal on 15/9/6.
//  Copyright (c) 2015年 Ranbal. All rights reserved.
//  用于16进制色值

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
/**
 *  用于16进制色值,支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
