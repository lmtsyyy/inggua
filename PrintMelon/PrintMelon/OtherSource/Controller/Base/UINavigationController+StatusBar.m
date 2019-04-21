//
//  UINavigationController+StatusBar.m
//  StoryboardDemo
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "UINavigationController+StatusBar.h"

@implementation UINavigationController (StatusBar)

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.visibleViewController;
}


@end
