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
@end

static CGFloat const scrollView_default_height = 969;

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
//    self.contactDispatchPeopleBtn.hidden = YES;
    self.recievePeopleTopConstraint.constant = 96;
    if(self.paymentStatus == ORDER_PAYMENT_WAIT_PAY) {//未付款
        self.scrollViewHeightConstraint.constant = scrollView_default_height - 90 - 64;
        [self.rightOperationBtn setTitle:@"付款" forState:UIControlStateNormal];
        self.dispatchPeopleBackV.hidden = YES;
        self.sendGoodsTimeBackV.hidden = YES;
        self.recievePeopleTopConstraint.constant = 6;
    }else if (self.paymentStatus == ORDER_PAYMENT_HAS_PAY || self.paymentStatus == ORDER_PAYMENT_TRADE_SUCCESS) {//已付款或者交易成功
        if(self.paymentStatus == ORDER_PAYMENT_HAS_PAY) {//已付款
            [self.rightOperationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.contactDispatchPeopleBtn.hidden = NO;
        }else {
            [self.rightOperationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
    }

    [self sendOrderDetailRequest];
}

- (IBAction)rightBtnOperation:(id)sender {
    if(self.paymentStatus == ORDER_PAYMENT_WAIT_PAY) {
        PaymentMethodViewController *vc = [PaymentMethodViewController lm_VC];
        vc.orderIdSourecType = LM_ORDER_ID_SOURCE_ORDER_LIST;
        vc.orderCenter = self.orderCenter;
        [self lm_pushVCWithVC:vc];
    }
}

- (void)sendOrderDetailRequest {
    NSDictionary *params = @{@"id" : self.orderCenter.ID};
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
    if(model.status.integerValue == 1) {//待付款
        self.hasPayImageV.image = [UIImage imageNamed:@"order_hasPay_gray"];
        self.hasPayLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.tradeSuccessImageV.image = [UIImage imageNamed:@"order_complete_gray"];
        self.tradeSuccessLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.scrollViewHeightConstraint.constant = scrollView_default_height - 90 - 64;
        [self.rightOperationBtn setTitle:@"付款" forState:UIControlStateNormal];
        self.dispatchPeopleBackV.hidden = YES;
        self.sendGoodsTimeBackV.hidden = YES;
        self.recievePeopleTopConstraint.constant = 6;
    }else if (model.status.integerValue == 2 || model.status.integerValue == 3) {//已付款
        self.hasPayImageV.image = [UIImage imageNamed:@"order_hasPay"];
        self.hasPayLabel.textColor = [UIColor colorWithHexString:@"#FD7C13"];
        self.tradeSuccessImageV.image = [UIImage imageNamed:@"order_complete_gray"];
        self.tradeSuccessLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }else if (model.status.integerValue == 4) {//交易成功
        self.hasPayImageV.image = [UIImage imageNamed:@"order_hasPay"];
        self.hasPayLabel.textColor = [UIColor colorWithHexString:@"FD7C13"];
        self.tradeSuccessImageV.image = [UIImage imageNamed:@"order_complete"];
        self.tradeSuccessLabel.textColor = [UIColor colorWithHexString:@"FD7C13"];
        [self.rightOperationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    }
    
    if(self.paymentStatus == ORDER_PAYMENT_WAIT_PAY) {//未付款
        self.scrollViewHeightConstraint.constant = scrollView_default_height - 90 - 64;
        [self.rightOperationBtn setTitle:@"付款" forState:UIControlStateNormal];
        self.dispatchPeopleBackV.hidden = YES;
        self.sendGoodsTimeBackV.hidden = YES;
        self.recievePeopleTopConstraint.constant = 6;
    }else if (self.paymentStatus == ORDER_PAYMENT_HAS_PAY || self.paymentStatus == ORDER_PAYMENT_TRADE_SUCCESS) {//已付款或者交易成功
        if(self.paymentStatus == ORDER_PAYMENT_HAS_PAY) {//已付款
            [self.rightOperationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.contactDispatchPeopleBtn.hidden = NO;
        }else {
            [self.rightOperationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
    }
    
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
    self.goodTotalPriceLabel.text = model.total;
    self.packagePriceLabel.text = model.packfree;
    self.orderTotalPriceLabel.text = @"0";
    self.faceTotalPriceLabel.text = model.money;
    self.orderNumberLabel.text = model.ID;
    self.createTimeLabel.text = model.addtime;
    self.sendGoodTimeLabel.text = model.deliverytime;
    self.successTimeLabel.text = model.finishtime;
    
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
