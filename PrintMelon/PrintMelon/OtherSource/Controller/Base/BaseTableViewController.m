//
//  BaseTableViewController.m
//  卡卡通
//
//  Created by Min on 2018/6/27.
//  Copyright © 2018年 LiMin. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
//@property (nonatomic, strong) UIView *noDataView;
{
    UIView *_noDataView;
}
@end

@implementation BaseTableViewController

-(NSMutableArray *)dataSource {
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//- (UIView *)noDataView {
//    if(!_noDataView) {
//        _noDataView = [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:nil options:nil] lastObject];
//        _noDataView.frame = superView.bounds;
//        [superView addSubview:noDataView];
//    }
//    return _noDataView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageIndex = 1;
    _pageSize = 10;
}


-(void)setupRefreshHeaderFooterWithTableView:(UITableView *)tableView {
    
    __weak __typeof(self) weakSelf = self;
//    if(!tableView.mj_header) {
//        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadNewData];
//        }];
//        [tableView.mj_header beginRefreshing];
//    }
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [tableView.mj_header beginRefreshing];
    
//    if(!tableView.mj_footer) {
//        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf loadMoreData];
//        }];
//    }
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
}

-(void)loadNewData {
    
}

-(void)loadMoreData {
    
}

-(void)endRefreshWithTableView:(UITableView *)tableView resultDic:(NSDictionary *)resultDic {
    
    [tableView reloadData];
    [tableView.mj_header endRefreshing];
//    NSInteger hasNextPage = [resultDic[@"hasNextPage"] integerValue];
    NSInteger isLastPage = [resultDic[@"isLastPage"] integerValue];
    NSInteger pages = [resultDic[@"pages"] integerValue];
    
    if(pages > 1) {
        if(isLastPage == 1) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [tableView.mj_footer endRefreshing];
        }
    }else {
        tableView.mj_footer = nil;
    }
}

- (void)endRefreshWithTableView:(UITableView *)tableView responseObject:(id)responseObject {
    
    [tableView reloadData];
    NSInteger maxpageNum = [responseObject[@"maxpageNum"] integerValue];
    [tableView.mj_header endRefreshing];
    if(maxpageNum == 1) {//只有一页数据，不需要底部无数据的提示
        tableView.mj_footer = nil;
    }else {
        if(self.pageIndex == maxpageNum) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [tableView.mj_footer endRefreshing];
        }
    }
    
    
}

-(BOOL)objectIsNullWithTableView:(UITableView *)tableView responseObject:(id)responseObject {
    if(responseObject[@"object"] == [NSNull null]) {
        [tableView.mj_header endRefreshing];
        tableView.mj_footer = nil;
        return YES;
    }
    return NO;
}

- (void)noDataViewWithDataArr:(NSArray *)dataArr 
                    tableView:(UITableView *)tableView 
                    superView:(UIView *)superView {
    
    if(!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:nil options:nil] lastObject];
        _noDataView.frame = superView.bounds;
        [superView addSubview:_noDataView];
    }
    if(dataArr.count == 0) {
        if(tableView.mj_header) {
            [tableView.mj_header endRefreshing];
        }
        if(tableView.mj_footer) {
            tableView.mj_footer = nil;
        }
        _noDataView.hidden = NO;
    }else {
        _noDataView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
