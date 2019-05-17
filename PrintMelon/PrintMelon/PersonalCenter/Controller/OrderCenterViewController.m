//
//  OrderCenterViewController.m
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "OrderCenterViewController.h"
#import "OrderCenterCell.h"
#import "OrderDetailViewController.h"

typedef NS_ENUM(NSInteger,OrderStatusType) {
    ORDER_STATUS_WAIT_PAY,//带付款
    ORDER_STATUS_HAS_PAY,//已付款
    ORDER_STATUS_HAS_COMPLETE,//已完成
};

#define K_BOTTOM_DOT_WIDTH self.bottomDotView.image.size.width * 0.5

@interface OrderCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDotLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *bottomDotView;
@property (weak, nonatomic) IBOutlet UIButton *allStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *hasPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *hasCompleteBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) NSString *tapOption;

@end

@implementation OrderCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self sendOrderListRequestWithOption:@""];
    if([NSString isBlankString:self.tapOption]) {
        self.tapOption = @"";
    }
    [self sendOrderListRequestWithOption:self.tapOption];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"订单中心")
    self.bottomDotLeftConstraint.constant = kScreenWidth * 0.125 - K_BOTTOM_DOT_WIDTH;
    [self setTitleOtherColor];
    [self.allStatusBtn setTitleColor:[UIColor colorWithHexString:@"FD7C13"] forState:UIControlStateNormal];
    
//    for(int i = 0;i < 5;i++) {
//        OrderCenterModel *model = [[OrderCenterModel alloc] init];
//        [self.dataSource addObject:model];
//    }
    
}

- (IBAction)payStatusClick:(UIButton *)sender {
    [self setTitleOtherColor];
    [sender setTitleColor:[UIColor colorWithHexString:@"FD7C13"] forState:UIControlStateNormal];
    CGFloat offset = 0.125;
    if(sender == self.allStatusBtn) {
        offset = 0.125;
        self.tapOption = @"";
    }else if (sender == self.waitPayBtn) {
        offset = 0.375;
        self.tapOption = @"1";
    }else if (sender == self.hasPayBtn) {
        offset = 0.625;
        self.tapOption = @"2";
    }else if (sender == self.hasCompleteBtn) {
        offset = 0.875;
        self.tapOption = @"3";
    }
    [self sendOrderListRequestWithOption:self.tapOption];
    self.bottomDotLeftConstraint.constant = kScreenWidth * offset - K_BOTTOM_DOT_WIDTH;
}

- (void)setTitleOtherColor {
    [self.allStatusBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.waitPayBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.hasPayBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.hasCompleteBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCenterCell *cell = [OrderCenterCell cellWithTableView:tableView vc:self];
    cell.orderCenterModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCenterModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrderDetailViewController *vc = [OrderDetailViewController lm_VC];
    vc.orderCenter = self.dataSource[indexPath.row];
    vc.isPaySuccess = NO;
    [self lm_pushVCWithVC:vc];
}

- (void)sendOrderListRequestWithOption:(NSString *)option {
    [self.dataSource removeAllObjects];
    NSDictionary *params = @{@"uid" : [AppEntity shareInstance].userid,
                             @"option" : option
                             };
    [[HttpRequestTool shareInstance] GET:K_URL(orderList_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            NSArray *orderArr = responseObject[@"order"];
//            NSDictionary *dic = orderArr[0];
//            NSString *status = dic[@"status"];
//            status = @"4";
//            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
//            [dic1 setObject:status forKey:@"status"];
//            dic = dic1;
//            NSMutableArray *arr1 = [NSMutableArray arrayWithArray:orderArr];
//            [arr1 addObject:dic1];
            self.dataSource = [OrderCenterModel mj_objectArrayWithKeyValuesArray:orderArr];
            [self.myTableView reloadData];
        }else if([responseObject[@"code"] integerValue] == 0){
            K_Show_Error_Tip
            [self.myTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
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
