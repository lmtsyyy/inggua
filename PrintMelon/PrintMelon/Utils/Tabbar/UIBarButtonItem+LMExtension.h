//
//  UIBarButtonItem+LMExtension.h
//  百思不得姐
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LMExtension)

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;
+ (instancetype)itemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;
+ (instancetype)itemWithLeftBarButtonImageName:(NSString *)imageName target:(id)target action:(SEL)action;
+ (instancetype)itemWithLeftBarButtonImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;
//+ (instancetype)itemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action;

@end
