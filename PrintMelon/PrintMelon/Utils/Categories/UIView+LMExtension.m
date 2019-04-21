//
//  UIView+LMExtension.m
//  百思不得姐
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIView+LMExtension.h"

@implementation UIView (LMExtension)

-(void)viewWithCornorRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end
