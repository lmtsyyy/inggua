//
//  JMTabBarController.m
//  JMTabBarController
//
//  Created by JM on 2017/12/26.
//  Copyright © 2017年 JM. All rights reserved.
//
// github: https://github.com/JunAILiang
// blog: https://www.ljmvip.cn

#import "JMTabBarController.h"
@interface JMTabBarController ()<JMTabBarDelegate>
@property (nonatomic, strong) UIButton *customBtn;
@end
NSUInteger _selectIndex = 0;
@implementation JMTabBarController

- (UIButton *)customBtn {
    if(!_customBtn) {
        _customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_customBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    }
    return _customBtn;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(instancetype)initWithConfig:(JMConfig *)config {
    
        NSArray *classNameArray = @[@"Home",@"PersonalCenter"];
        NSArray *tabbarItemImageArray = @[@"home_icon_unselect",@"personal_center_icon_unselect"];
        NSArray *tabbarItemSelectImageArray = @[@"home_icon_select",@"personal_center_icon_select"];
        NSArray *tabbarItenTitleArray = @[@"首页",@"个人中心"];
        NSMutableArray *controllersArr = [NSMutableArray array];
    
        for (int i = 0; i < classNameArray.count; i++) {
    
            NSString *className = [NSString stringWithFormat:@"%@ViewController",classNameArray[i]];
            Class myClass = NSClassFromString(className);
            UIViewController *viewController = [[myClass alloc]init];
            UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:viewController];
//            navigationVC.navigationBar.barStyle = UIBarStyleDefault;
            navigationVC.navigationBar.translucent = NO;
            navigationVC.interactivePopGestureRecognizer.delegate = (id)self;
//            navigationVC.navigationBar.barTintColor = K_Theme_Color;
//            navigationVC.navigationBar.hidden = YES;
            [controllersArr addObject:navigationVC];
    
        }
    
    
    self.viewControllers = controllersArr;
    self.JM_TabBar = [[JMTabBar alloc] initWithFrame:self.tabBar.frame norImageArr:tabbarItemImageArray SelImageArr:tabbarItemSelectImageArray TitleArr:tabbarItenTitleArray Config:config];
    self.JM_TabBar.myDelegate = self;
    
    
    [self setValue:self.JM_TabBar forKeyPath:@"tabBar"];
    
    
    [JMConfig config].tabBarController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotifacation) name:@"logoutNotifacation" object:nil];
    
    //KVO
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    if(config.isNeedCustomBtn) {
        
        [config addCustomBtn:self.customBtn AtIndex:2 BtnClickBlock:^(UIButton *btn, NSInteger index) {
            JMLog(@"点击了我");
#if 0
            AddPointLocationViewController *vc = [[AddPointLocationViewController alloc] init];
            //        vc.view.backgroundColor = [UIColor orangeColor];
            UINavigationController *naviVC = [[JMConfig config].tabBarController childViewControllers][_selectIndex];
            vc.hidesBottomBarWhenPushed = YES;
            [naviVC pushViewController:vc animated:YES];
#endif
            
            //测试代码 (两秒后自动关闭)
            //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [vc dismissViewControllerAnimated:YES completion:nil];
            //        });
        }];
    }
        
    return self;
}

- (void)logoutNotifacation {
    _selectIndex = 0;
}

#if 0
- (instancetype)initWithTabBarControllers:(NSArray *)controllers NorImageArr:(NSArray *)norImageArr SelImageArr:(NSArray *)selImageArr TitleArr:(NSArray *)titleArr Config:(JMConfig *)config{


    self.viewControllers = controllers;
    self.JM_TabBar = [[JMTabBar alloc] initWithFrame:self.tabBar.frame norImageArr:norImageArr SelImageArr:selImageArr TitleArr:titleArr Config:config];
    self.JM_TabBar.myDelegate = self;


    [self setValue:self.JM_TabBar forKeyPath:@"tabBar"];


    [JMConfig config].tabBarController = self;

    //KVO
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

    return self;
}
#endif

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSInteger selectedIndex = [change[@"new"] integerValue];
    self.JM_TabBar.selectedIndex = selectedIndex;
}

- (void)tabBar:(JMTabBar *)tabBar didSelectIndex:(NSInteger)selectIndex {
    self.selectedIndex = selectIndex;
    _selectIndex = selectIndex;
}

- (void)dealloc {
    JMLog(@"被销毁了");
    [self removeObserver:self forKeyPath:@"selectedIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
