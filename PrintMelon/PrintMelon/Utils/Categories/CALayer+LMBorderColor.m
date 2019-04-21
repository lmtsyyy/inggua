//
//  CALayer+LMBorderColor.m
//  SurveyAPP
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "CALayer+LMBorderColor.h"

@implementation CALayer (LMBorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
