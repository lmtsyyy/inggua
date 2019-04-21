//
//  ViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/4.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LMCommonTool showSuccessWithStatus:@"成功进入主页"];
    });
}


@end
