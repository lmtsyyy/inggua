//
//  UIImage+Watermark.m
//  SurveyAPP
//
//  Created by admin on 2018/12/4.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "UIImage+Watermark.h"

@implementation UIImage (Watermark)

+ (UIImage *)addWatemarkTextImage:(UIImage *)image watemarkText:(NSString *)watemarkText ratio:(CGFloat)ratio {
    int w = image.size.width;    
    int h = image.size.height;    
    UIGraphicsBeginImageContext(image.size);
    [[UIColor whiteColor] set];
    [image drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:11.0*ratio];
    CGRect rect = [watemarkText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    [watemarkText drawInRect:CGRectMake(image.size.width - rect.size.width, image.size.height - rect.size.height, rect.size.width, rect.size.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
