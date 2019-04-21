//
//  LMTabBar.m
//  百思不得姐
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "LMTabBar.h"
@interface LMTabBar()

@property (nonatomic, strong) UIButton *customButton;

@end

@implementation LMTabBar


-(instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [customButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [customButton addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:customButton];
        self.customButton = customButton;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tabbarItemWidth = CGRectGetWidth(self.frame) / 5;
    CGFloat tabbarItemHeight = CGRectGetHeight(self.frame);
    int i = 0;
    
    self.customButton.frame = CGRectMake(0, 0, self.customButton.currentImage.size.width, self.customButton.currentImage.size.height);
    self.customButton.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
    
    for (UIView *view in self.subviews) {
        
        if(![view isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        int index = i > 1 ? (i + 1) : i;
        view.frame = CGRectMake(index * tabbarItemWidth, 0, tabbarItemWidth, tabbarItemHeight);
        i ++;
    }
}

-(void)publishAction
{
//    LMRegisterLoginViewController *vc = [[LMRegisterLoginViewController alloc]init];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

@end
