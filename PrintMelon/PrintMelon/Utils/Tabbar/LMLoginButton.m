//
//  LMLoginButton.m
//  百思不得姐
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "LMLoginButton.h"

@implementation LMLoginButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 70, 70);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), 70, 30);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
