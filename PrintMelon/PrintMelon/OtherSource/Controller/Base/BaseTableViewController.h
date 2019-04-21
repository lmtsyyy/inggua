//
//  BaseTableViewController.h
//  卡卡通
//
//  Created by Min on 2018/6/27.
//  Copyright © 2018年 LiMin. All rights reserved.
//

#import "BaseViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface BaseTableViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;
-(void)setupRefreshHeaderFooterWithTableView:(UITableView *)tableView;
-(void)loadNewData;
-(void)loadMoreData;
//-(void)endRefreshWithTableView:(UITableView *)tableView resultDic:(NSDictionary *)resultDic;
- (void)endRefreshWithTableView:(UITableView *)tableView responseObject:(id)responseObject;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
-(BOOL)objectIsNullWithTableView:(UITableView *)tableView responseObject:(id)responseObject;
- (void)noDataViewWithDataArr:(NSArray *)dataArr 
                    tableView:(UITableView *)tableView 
                    superView:(UIView *)superView;
@end
