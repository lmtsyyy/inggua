//
//  UIImage+Watermark.h
//  SurveyAPP
//
//  Created by admin on 2018/12/4.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Watermark)

+ (UIImage *)addWatemarkTextImage:(UIImage *)image watemarkText:(NSString *)watemarkText ratio:(CGFloat)ratio;

@end

NS_ASSUME_NONNULL_END
