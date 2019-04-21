//
//  UITextField+InputAccessoryView.m
//  SurveyAPP
//
//  Created by admin on 2018/12/13.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "UITextField+InputAccessoryView.h"

@implementation UITextField (InputAccessoryView)

- (void)keyboardAddCustomInputAccessoryViewTarget:(id)target 
                                           action:(SEL)action {
    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:target action:action];
    NSArray *buttonArray = [NSArray arrayWithObjects:spaceBtn,doneBtn, nil];
    [topView setItems:buttonArray];
    [self setInputAccessoryView:topView];
}

@end
