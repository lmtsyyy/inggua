//
//  BaseViewController.m
//  xib的基本使用
//
//  Created by admin on 16/5/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "BaseViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
@interface BaseViewController ()



@end



@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self otherSetup];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *navigationBarBottomLineV = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    navigationBarBottomLineV.hidden = YES;
//    [self monitoringNetworkWithVC:self];
}

- (void)otherSetup {
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)requestTimeoutWithError:(NSError *)error tableView:(UITableView *)tableView {
    if(tableView) {
        [tableView.mj_header endRefreshing];
        tableView.mj_footer = nil;
//        tableView.mj_header = nil;
    }
//    if([error.localizedDescription hasSuffix:@"timed out."]) {
//        [LMCommonTool showAlert:@"网路超时了哦~" toVC:self];
//    }
    [LMCommonTool showAlert:@"网络出现异常，请稍后再试哦~" toVC:self];
    [LMCommonTool dismiss];
    MYLog(@"error = %@",error.localizedDescription);
}

- (void)monitoringNetworkWithVC:(UIViewController *)vc {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            [LMCommonTool showAlert:@"网络出了点小状况，请稍后再试~" toVC:vc];
            [AppEntity shareInstance].needImmediatelyExecuteTimer = NO;
            [AppEntity shareInstance].networkAvailable = NO;
        }else {
            [AppEntity shareInstance].networkAvailable = YES;
            if(![AppEntity shareInstance].needImmediatelyExecuteTimer) {
                [[NSNotificationCenter defaultCenter] postNotificationName:LMInsertLocalDataSuccessNotification object:nil];
            }
            [AppEntity shareInstance].needImmediatelyExecuteTimer = YES;
        }
    }];
    [manager startMonitoring];
}


//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)dealloc {
    NSLog(@"%@--dealloc",NSStringFromClass([self class]));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
