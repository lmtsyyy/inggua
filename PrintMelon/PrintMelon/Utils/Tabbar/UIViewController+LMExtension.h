//
//  UIViewController+LMExtension.h
//  百思不得姐
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LMExtension)

+ (instancetype)lm_VC;

- (void)lm_pushVCWithVC:(UIViewController *)vc;

- (void)lm_pushVCAndHidesBottomBarWhenPushedWithVC:(UIViewController *)vc;

- (void)lm_popVC;

- (void)lm_popToVCWithVC:(UIViewController *)vc;

- (void)lm_popToRootVC;

- (void)lm_presentVCWithVC:(UIViewController *)vc;

- (void)lm_dismissVC;

- (void)lm_setupNaviWithTitle:(NSString *)title;

- (void)lm_setupNaviTitleViewWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

- (void)lm_setupNaviTitleViewWithImageName:(NSString *)name;

- (void)lm_setupNaviLeftBarItemWithTitle:(NSString *)title 
                               target:(id)target 
                               action:(SEL)action;

- (void)lm_setupNaviLeftBarItemWithTitle:(NSString *)title 
                              titleColor:(UIColor *)titleColor
                                fontSize:(CGFloat)fontSize
                                  target:(id)target 
                                  action:(SEL)action;;

- (void)lm_setupNaviLeftBarItemWithTitle1:(NSString *)title1 
                                title2:(NSString *)title2
                                target:(id)target
                               action1:(SEL)action1
                               action2:(SEL)action2;

- (void)lm_setupNaviLeftBarItemWithTitle1:(NSString *)title1 
                                   title2:(NSString *)title2
                               titleColor:(UIColor *)titleColor
                                 fontSize:(CGFloat)fontSize
                                   target:(id)target
                                  action1:(SEL)action1
                                  action2:(SEL)action2;

- (void)lm_setupNaviLeftBarItemWithImageName:(NSString *)imageName 
                                      target:(id)target 
                                      action:(SEL)action;

- (void)lm_setupNaviLeftBarItemWithImageName:(NSString *)imageName 
                        selectedImageName:(NSString *)selectedImageName 
                                   target:(id)target 
                                   action:(SEL)action;

- (void)lm_setupNaviLeftBarItemWithImageName1:(NSString *)imageName1 
                        barItemWithImageName2:(NSString *)imageName2
                                       target:(id)target
                                      action1:(SEL)action1
                                      action2:(SEL)action2;

- (void)lm_setupNaviLeftBarItemWithImageName1:(NSString *)imageName1 
                        selectedImageName1:(NSString *)selectedImageName1
                     barItemWithImageName2:(NSString *)imageName2
                        selectedImageName2:(NSString *)selectedImageName2
                                    target:(id)target
                                   action1:(SEL)action1
                                   action2:(SEL)action2;

- (void)lm_setupNaviRightBarItemWithTitle:(NSString *)title 
                                target:(id)target 
                                action:(SEL)action;

- (void)lm_setupNaviRightBarItemWithTitle:(NSString *)title 
                               titleColor:(UIColor *)titleColor
                                 fontSize:(CGFloat)fontSize
                                   target:(id)target 
                                   action:(SEL)action;

- (void)lm_setupNaviRightBarItemWithTitle1:(NSString *)title1 
                                 title2:(NSString *)title2
                                 target:(id)target
                                action1:(SEL)action1
                                action2:(SEL)action2;

- (void)lm_setupNaviRightBarItemWithTitle1:(NSString *)title1 
                                    title2:(NSString *)title2
                                titleColor:(UIColor *)titleColor
                                  fontSize:(CGFloat)fontSize
                                    target:(id)target
                                   action1:(SEL)action1
                                   action2:(SEL)action2;

- (void)lm_setupNaviRightBarItemWithImageName:(NSString *)imageName 
                                       target:(id)target 
                                       action:(SEL)action;

- (void)lm_setupNaviRightBarItemWithImageName:(NSString *)imageName 
                         selectedImageName:(NSString *)selectedImageName 
                                    target:(id)target 
                                    action:(SEL)action;

- (void)lm_setupNaviRightBarItemWithImageName1:(NSString *)imageName1 
                         barItemWithImageName2:(NSString *)imageName2
                                        target:(id)target 
                                       action1:(SEL)action1
                                       action1:(SEL)action2;

- (void)lm_setupNaviRightBarItemWithImageName1:(NSString *)imageName1 
                         selectedImageName1:(NSString *)selectedImageName1
                      barItemWithImageName2:(NSString *)imageName2
                         selectedImageName2:(NSString *)selectedImageName2
                                     target:(id)target 
                                    action1:(SEL)action1
                                    action1:(SEL)action2;

- (void)lm_setupNaviRightBarItemWithTitle:(NSString *)title
                                imageName:(NSString *)imageName
                                   target:(id)target
                                  action1:(SEL)action1
                                  action2:(SEL)action2;

- (void)lm_setupNaviCommonBackBarItemWithImageName:(NSString *)imageName;

- (void)lm_setupNaviCommonBackBarItemWithImageName:(NSString *)imageName 
                              selectedImageName:(NSString *)selectedImageName;

- (void)lm_setupNaviCommonBackBarItemWithTitle:(NSString *)title;

@end
