//
//  UIViewController+LMExtension.m
//  百思不得姐
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIViewController+LMExtension.h"

@implementation UIViewController (LMExtension)

+ (instancetype)lm_VC 
{
    UIViewController *vc = [[self alloc] init];
    return vc;
}

- (void)lm_pushVCWithVC:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lm_pushVCAndHidesBottomBarWhenPushedWithVC:(UIViewController *)vc {
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lm_popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lm_popToVCWithVC:(UIViewController *)vc {
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)lm_popToRootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)lm_presentVCWithVC:(UIViewController *)vc {
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)lm_dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)lm_setupNaviWithTitle:(NSString *)title 
{
    self.navigationItem.title = title;
}

- (void)lm_setupNaviTitleViewWithTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 150, 20);
//    [titleLabel sizeToFit];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [LMCommonTool mediumFontWithSize:18.0];
    titleLabel.textColor = titleColor;
    if(!titleColor) {
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

- (void)lm_setupNaviTitleViewWithImageName:(NSString *)name 
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    self.navigationItem.titleView = imageView;
}

- (void)lm_setupNaviLeftBarItemWithTitle:(NSString *)title 
                               target:(id)target 
                               action:(SEL)action 
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:title target:target action:action];
}

- (void)lm_setupNaviLeftBarItemWithTitle:(NSString *)title 
                              titleColor:(UIColor *)titleColor
                                fontSize:(CGFloat)fontSize
                                  target:(id)target 
                                  action:(SEL)action 
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:title titleColor:titleColor fontSize:fontSize target:target action:action];
}

- (void)lm_setupNaviLeftBarItemWithTitle1:(NSString *)title1 
                                title2:(NSString *)title2
                                target:(id)target
                               action1:(SEL)action1
                               action2:(SEL)action2 
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithTitle:title1 target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithTitle:title2 target:target action:action2];
    self.navigationItem.leftBarButtonItems = @[barButtonItem1,barButtonItem2];
}

- (void)lm_setupNaviLeftBarItemWithTitle1:(NSString *)title1 
                                   title2:(NSString *)title2
                               titleColor:(UIColor *)titleColor
                                 fontSize:(CGFloat)fontSize
                                   target:(id)target
                                  action1:(SEL)action1
                                  action2:(SEL)action2 
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithTitle:title1 titleColor:titleColor fontSize:fontSize target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithTitle:title2 titleColor:titleColor fontSize:fontSize target:target action:action2];
    self.navigationItem.leftBarButtonItems = @[barButtonItem1,barButtonItem2];
}

- (void)lm_setupNaviLeftBarItemWithImageName:(NSString *)imageName 
                                      target:(id)target 
                                      action:(SEL)action
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:imageName target:target action:action];
}

- (void)lm_setupNaviLeftBarItemWithImageName:(NSString *)imageName 
                        selectedImageName:(NSString *)selectedImageName 
                                   target:(id)target 
                                   action:(SEL)action
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:imageName selectedImageName:selectedImageName target:target action:action];
}

- (void)lm_setupNaviLeftBarItemWithImageName1:(NSString *)imageName1 
                        barItemWithImageName2:(NSString *)imageName2
                                       target:(id)target
                                      action1:(SEL)action1
                                      action2:(SEL)action2
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithImageName:imageName1 target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithImageName:imageName2 target:target action:action2];
    self.navigationItem.leftBarButtonItems = @[barButtonItem1,barButtonItem2];
    
}

- (void)lm_setupNaviLeftBarItemWithImageName1:(NSString *)imageName1 
                        selectedImageName1:(NSString *)selectedImageName1
                     barItemWithImageName2:(NSString *)imageName2
                        selectedImageName2:(NSString *)selectedImageName2
                                    target:(id)target
                                   action1:(SEL)action1
                                   action2:(SEL)action2
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithImageName:imageName1 selectedImageName:selectedImageName1 target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithImageName:imageName2 selectedImageName:selectedImageName2 target:target action:action2];
    self.navigationItem.leftBarButtonItems = @[barButtonItem1,barButtonItem2];

}

- (void)lm_setupNaviRightBarItemWithTitle:(NSString *)title 
                                target:(id)target 
                                action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:title target:target action:action];
}

- (void)lm_setupNaviRightBarItemWithTitle:(NSString *)title 
                               titleColor:(UIColor *)titleColor
                                 fontSize:(CGFloat)fontSize
                                   target:(id)target 
                                   action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:title titleColor:titleColor fontSize:fontSize target:target action:action];
}

- (void)lm_setupNaviRightBarItemWithTitle1:(NSString *)title1 
                                 title2:(NSString *)title2
                                 target:(id)target
                                action1:(SEL)action1
                                action2:(SEL)action2
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithTitle:title1 target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithTitle:title2 target:target action:action2];
    self.navigationItem.rightBarButtonItems = @[barButtonItem1,barButtonItem2];
}

- (void)lm_setupNaviRightBarItemWithTitle1:(NSString *)title1 
                                    title2:(NSString *)title2
                                titleColor:(UIColor *)titleColor
                                  fontSize:(CGFloat)fontSize
                                    target:(id)target
                                   action1:(SEL)action1
                                   action2:(SEL)action2
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithTitle:title1 titleColor:titleColor fontSize:fontSize target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithTitle:title2 titleColor:titleColor fontSize:fontSize target:target action:action2];
    self.navigationItem.rightBarButtonItems = @[barButtonItem1,barButtonItem2];
}

- (void)lm_setupNaviRightBarItemWithImageName:(NSString *)imageName 
                                       target:(id)target 
                                       action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:imageName target:target action:action];
}

- (void)lm_setupNaviRightBarItemWithImageName:(NSString *)imageName 
                         selectedImageName:(NSString *)selectedImageName 
                                    target:(id)target 
                                    action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:imageName selectedImageName:selectedImageName target:target action:action];
}

- (void)lm_setupNaviRightBarItemWithImageName1:(NSString *)imageName1 
                         barItemWithImageName2:(NSString *)imageName2
                                        target:(id)target 
                                       action1:(SEL)action1
                                       action1:(SEL)action2
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithImageName:imageName1 target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithImageName:imageName2 target:target action:action2];
    self.navigationItem.rightBarButtonItems = @[barButtonItem1,barButtonItem2];
}

- (void)lm_setupNaviRightBarItemWithImageName1:(NSString *)imageName1 
                         selectedImageName1:(NSString *)selectedImageName1
                      barItemWithImageName2:(NSString *)imageName2
                         selectedImageName2:(NSString *)selectedImageName2
                                     target:(id)target 
                                    action1:(SEL)action1
                                    action1:(SEL)action2
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithImageName:imageName1 selectedImageName:selectedImageName1 target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithImageName:imageName2 selectedImageName:selectedImageName2 target:target action:action2];
    self.navigationItem.rightBarButtonItems = @[barButtonItem1,barButtonItem2];
}

- (void)lm_setupNaviRightBarItemWithTitle:(NSString *)title
                                imageName:(NSString *)imageName
                                   target:(id)target
                                  action1:(SEL)action1
                                  action2:(SEL)action2
{
    UIBarButtonItem *barButtonItem1 = [UIBarButtonItem itemWithTitle:title target:target action:action1];
    UIBarButtonItem *barButtonItem2 = [UIBarButtonItem itemWithImageName:imageName target:target action:action2];
    self.navigationItem.rightBarButtonItems = @[barButtonItem2,barButtonItem1];
}

- (void)lm_setupNaviCommonBackBarItemWithImageName:(NSString *)imageName 
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftBarButtonImageName:imageName target:self action:@selector(back)];
}

- (void)lm_setupNaviCommonBackBarItemWithImageName:(NSString *)imageName 
                              selectedImageName:(NSString *)selectedImageName 
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:imageName selectedImageName:selectedImageName target:self action:@selector(back)];
}

- (void)lm_setupNaviCommonBackBarItemWithTitle:(NSString *)title 
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_return" target:self action:@selector(back)];
    [self lm_setupNaviTitleViewWithTitle:title titleColor:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
