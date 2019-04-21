//
//  UIBarButtonItem+LMExtension.m
//  百思不得姐
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIBarButtonItem+LMExtension.h"

@implementation UIBarButtonItem (LMExtension)

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    return [self itemWithImageName:imageName selectedImageName:nil target:target action:action];
}

+ (instancetype)itemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }else {
        [button setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    }
    
    if(selectedImageName) {
        [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    }
    button.frame = CGRectMake(0, 0, button.currentImage.size.width, button.currentImage.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (instancetype)itemWithLeftBarButtonImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    return [self itemWithLeftBarButtonImageName:imageName selectedImageName:nil target:target action:action];
}

+ (instancetype)itemWithLeftBarButtonImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
    if(imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }else {
        [button setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    }
    
    if(selectedImageName) {
        [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    }
    button.frame = CGRectMake(0, 0, button.currentImage.size.width * 5, button.currentImage.size.height * 2);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

//+ (instancetype)itemWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title target:(id)target action:(SEL)action
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    button.titleLabel.font = [UIFont systemFontOfSize:13];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
//    [button sizeToFit];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    return [[UIBarButtonItem alloc]initWithCustomView:button];
//}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self itemWithTitle:title titleColor:[UIColor colorWithHexString:@"333333"] fontSize:13 target:target action:action];
}

+ (instancetype)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}




@end
