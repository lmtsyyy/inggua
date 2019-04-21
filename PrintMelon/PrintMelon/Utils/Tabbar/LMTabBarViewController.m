//
//  LMTabBarViewController.m
//  百思不得姐
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "LMTabBarViewController.h"
#import "LMTabBar.h"
@interface LMTabBarViewController ()

@end

@implementation LMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *classNameArray = @[@"Project",@"Project",@"Project",@"Project"];
    NSArray *tabbarItemImageArray = @[@"conversion_",@"earnings_",@"extension_",@"mine_"];
    NSArray *tabbarItenTitleArray = @[@"精华",@"新帖",@"关注",@"我"];
    
    for (int i = 0; i < classNameArray.count; i++) {
        
        NSString *className = [NSString stringWithFormat:@"%@ViewController",classNameArray[i]];
        
        Class myClass = NSClassFromString(className);
        
        UIViewController *viewController = [[myClass alloc]init];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@unchecked",tabbarItemImageArray[i]]];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@checked",tabbarItemImageArray[i]]];
        
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:tabbarItenTitleArray[i] image:image selectedImage:selectedImage];
        
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateSelected];
        
        UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:viewController];
        
        [self addChildViewController:navigationVC];
    }
#if 0
    LMTabBar *tabbar = [[LMTabBar alloc]init];
    [self setValue:tabbar forKeyPath:@"tabBar"];
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
