//
//  BaseViewController.h
//  xib的基本使用
//
//  Created by admin on 16/5/24.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)otherSetup;
- (void)handleDataWithdData:(id)responseObject;
- (void)requestTimeoutWithError:(NSError *)error tableView:(UITableView *)tableView;
- (void)monitoringNetworkWithVC:(UIViewController *)vc;

@end
