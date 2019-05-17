//
//  OrderDetailViewController.m
//  PrintMelon
//
//  Created by andy on 2019/3/16.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PaymentMethodViewController.h"
#import "OrderDetailModel.h"
#import "OrderCenterModel.h"

@interface OrderDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *contactDispatchPeopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightOperationBtn;
@property (weak, nonatomic) IBOutlet UIView *dispatchPeopleBackV;
@property (weak, nonatomic) IBOutlet UIView *sendGoodsTimeBackV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recievePeopleTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *waitPayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hasPayImageV;
@property (weak, nonatomic) IBOutlet UILabel *hasPayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tradeSuccessImageV;
@property (weak, nonatomic) IBOutlet UILabel *tradeSuccessLabel;
@property (weak, nonatomic) IBOutlet UILabel *dispatchPeopleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dispatchPeoplePhone;
@property (weak, nonatomic) IBOutlet UILabel *receiptNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *printNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhizhangLabel;
@property (weak, nonatomic) IBOutlet UILabel *danshuangmianLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *layoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *faceTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendGoodTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *successTimeLabel;
@property (nonatomic, assign) BOOL isHasPay;
@property (weak, nonatomic) IBOutlet UILabel *dispatchTimeLabel;

@end

static CGFloat const scrollView_default_height = 1047;

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"订单详情")
    
    self.scrollViewHeightConstraint.constant = scrollView_default_height;
    self.dispatchPeopleBackV.hidden = NO;
    self.sendGoodsTimeBackV.hidden = NO;
    self.contactDispatchPeopleBtn.hidden = YES;
    self.recievePeopleTopConstraint.constant = 96;
//    if(self.paymentStatus == ORDER_PAYMENT_WAIT_PAY) {//未付款
//        self.scrollViewHeightConstraint.constant = scrollView_default_height - 90 - 64;
//        [self.rightOperationBtn setTitle:@"付款" forState:UIControlStateNormal];
//        self.dispatchPeopleBackV.hidden = YES;
//        self.sendGoodsTimeBackV.hidden = YES;
//        self.recievePeopleTopConstraint.constant = 6;
//    }else if (self.paymentStatus == ORDER_PAYMENT_HAS_PAY || self.paymentStatus == ORDER_PAYMENT_TRADE_SUCCESS) {//已付款或者交易成功
//        if(self.paymentStatus == ORDER_PAYMENT_HAS_PAY) {//已付款
//            [self.rightOperationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//            self.contactDispatchPeopleBtn.hidden = NO;
//        }else {
//            [self.rightOperationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
//        }
//    }

    [self sendOrderDetailRequest];
}

- (IBAction)rightBtnOperation:(id)sender {
    if(self.paymentStatus == ORDER_PAYMENT_WAIT_PAY) {
        PaymentMethodViewController *vc = [PaymentMethodViewController lm_VC];
        vc.orderIdSourecType = LM_ORDER_ID_SOURCE_ORDER_LIST;
        vc.orderCenter = self.orderCenter;
        [self lm_pushVCWithVC:vc];
    }else if (self.paymentStatus == ORDER_PAYMENT_HAS_PAY) {
        [self sendModifyOrderStatusRequest];
    }else if (self.paymentStatus == ORDER_PAYMENT_TRADE_SUCCESS) {
        [self sendDeleteOrderRequest];
    }
}

- (IBAction)contactDispatchPeople:(id)sender {
    if([NSString isBlankString:self.dispatchPeoplePhone.text]) {
        [LMCommonTool showInfoWithStatus:@"配送员电话为空"];return;
    }
    [LMCommonTool callPhoneWithTel:self.dispatchPeoplePhone.text];
}

- (void)sendOrderDetailRequest {
    NSString *orderId = @"";
    if(self.isPaySuccess) {
        orderId = self.orderCenter.orderId;
    }else {
        orderId = self.orderCenter.ID;
    }
    NSDictionary *params = @{@"id" : orderId};
    [[HttpRequestTool shareInstance] GET:K_URL(orderDetail_URL) parameters:params success:^(id responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            NSDictionary *orderDic = responseObject[@"order"];
            OrderDetailModel *orderDetail = [OrderDetailModel mj_objectWithKeyValues:orderDic];
            [self setValueWithModel:orderDetail];
            
        }else {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
    
}

- (void)setValueWithModel:(OrderDetailModel *)model {
//    model.status = @"3";
    if(model.status.integerValue == 1) {//待付款
        self.paymentStatus = ORDER_PAYMENT_WAIT_PAY;
        self.hasPayImageV.image = [UIImage imageNamed:@"order_hasPay_gray"];
        self.hasPayLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.tradeSuccessImageV.image = [UIImage imageNamed:@"order_complete_gray"];
        self.tradeSuccessLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.scrollViewHeightConstraint.constant = scrollView_default_height - 90 - 92;
        [self.rightOperationBtn setTitle:@"付款" forState:UIControlStateNormal];
        self.dispatchPeopleBackV.hidden = YES;
        self.sendGoodsTimeBackV.hidden = YES;
        self.contactDispatchPeopleBtn.hidden = YES;
        self.recievePeopleTopConstraint.constant = 6;
    }else if (model.status.integerValue == 2 || model.status.integerValue == 3) {//已付款
        self.paymentStatus = ORDER_PAYMENT_HAS_PAY;
        self.hasPayImageV.image = [UIImage imageNamed:@"order_hasPay"];
        self.hasPayLabel.textColor = [UIColor colorWithHexString:@"#FD7C13"];
        self.tradeSuccessImageV.image = [UIImage imageNamed:@"order_complete_gray"];
        self.tradeSuccessLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.rightOperationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        self.contactDispatchPeopleBtn.hidden = NO;
        if(model.status.integerValue == 3) {
            self.isHasPay = YES;
        }
    }else if (model.status.integerValue == 4) {//交易成功
        self.paymentStatus = ORDER_PAYMENT_TRADE_SUCCESS;
        self.hasPayImageV.image = [UIImage imageNamed:@"order_hasPay"];
        self.hasPayLabel.textColor = [UIColor colorWithHexString:@"FD7C13"];
        self.tradeSuccessImageV.image = [UIImage imageNamed:@"order_complete"];
        self.tradeSuccessLabel.textColor = [UIColor colorWithHexString:@"FD7C13"];
        [self.rightOperationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        self.contactDispatchPeopleBtn.hidden = YES;
    }
    
//    if(self.paymentStatus == ORDER_PAYMENT_WAIT_PAY) {//未付款
//        self.scrollViewHeightConstraint.constant = scrollView_default_height - 90 - 64;
//        [self.rightOperationBtn setTitle:@"付款" forState:UIControlStateNormal];
//        self.dispatchPeopleBackV.hidden = YES;
//        self.sendGoodsTimeBackV.hidden = YES;
//        self.recievePeopleTopConstraint.constant = 6;
//    }else if (self.paymentStatus == ORDER_PAYMENT_HAS_PAY || self.paymentStatus == ORDER_PAYMENT_TRADE_SUCCESS) {//已付款或者交易成功
//        if(self.paymentStatus == ORDER_PAYMENT_HAS_PAY) {//已付款
//            [self.rightOperationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//            self.contactDispatchPeopleBtn.hidden = NO;
//        }else {
//            [self.rightOperationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
//        }
//    }
    
    self.dispatchPeopleLabel.text = model.staff.staffname;
    self.dispatchPeoplePhone.text = model.staff.phone;
    self.receiptNameLabel.text = model.consignee;
    self.receiptPhoneLabel.text = model.phone;
    self.receiptAddressLabel.text = model.address;
    self.orderNoLabel.text = model.ordernum;
    self.printNumLabel.text = model.page;
    self.zhizhangLabel.text = model.size;
    self.danshuangmianLabel.text = model.issingle;
    self.colorLabel.text = model.color;
    self.layoutLabel.text = model.layout;
    self.fenshuLabel.text = model.number;
    self.bindLabel.text = model.binding;
    if(model.total.floatValue - model.packfree.floatValue < 0) {
        self.goodTotalPriceLabel.text = @"0.00";
    }else {
        self.goodTotalPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.total.floatValue - model.packfree.floatValue];
    }
    self.packagePriceLabel.text = [NSString stringWithFormat:@"%.2f",model.packfree.floatValue];
    self.orderTotalPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.total.floatValue];
    self.faceTotalPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.money.floatValue];
    self.orderNumberLabel.text = model.ID;
    self.createTimeLabel.text = [self convertStrToTime:model.addtime];
    if([NSString isBlankString:model.deliverytime]) {
        self.sendGoodTimeLabel.text = @"无";
    }else {
        self.sendGoodTimeLabel.text = [self convertStrToTime:model.deliverytime];
    }
    if([NSString isBlankString:model.finishtime]) {
        self.successTimeLabel.text = @"无";
    }else {
        self.successTimeLabel.text = [self convertStrToTime:model.finishtime];
    }
    self.dispatchTimeLabel.text = model.apptime;

}

- (void)sendDeleteOrderRequest {
    NSDictionary *params = @{@"id" : self.orderCenter.ID};
    [[HttpRequestTool shareInstance] GET:K_URL(deleteOrder_URL) parameters:params success:^(id responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            K_Show_Success_Tip
            [self lm_popVC];
        }else {
            K_Show_Error_Tip
        }
    } failure:^(NSError *error) {
    }];
}

- (void)sendModifyOrderStatusRequest {
    if(self.isHasPay) {
        NSDictionary *params = @{@"id" : self.orderCenter.ID,
                                 @"status" : @"4"
                                 };
        [[HttpRequestTool shareInstance] GET:K_URL(modifyOrderStatus_URL) parameters:params success:^(id responseObject) {
            
            NSLog(@"responseObject = %@",responseObject);
            if(K_SUCCESS_CODE) {
                //            K_Show_Success_Tip
                self.paymentStatus = ORDER_PAYMENT_TRADE_SUCCESS;
                self.hasPayImageV.image = [UIImage imageNamed:@"order_hasPay"];
                self.hasPayLabel.textColor = [UIColor colorWithHexString:@"FD7C13"];
                self.tradeSuccessImageV.image = [UIImage imageNamed:@"order_complete"];
                self.tradeSuccessLabel.textColor = [UIColor colorWithHexString:@"FD7C13"];
                [self.rightOperationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                self.contactDispatchPeopleBtn.hidden = YES;
                
            }else {
                K_Show_Error_Tip
            }
        } failure:^(NSError *error) {
        }];
        
    }else {
        [LMCommonTool showInfoWithStatus:@"订单还未配送哦"];
    }
    
}

//时间戳变为格式时间
- (NSString *)convertStrToTime:(NSString *)timeStr {
    long long time = [timeStr longLongValue];
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    //    long long time=[timeStr longLongValue] / 1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString=[formatter stringFromDate:date];
    return timeString;
}

- (IBAction)contactMerchant:(id)sender {
    [LMCommonTool callPhoneWithTel:@"15521439868"];
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
