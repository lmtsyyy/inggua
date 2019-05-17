//
//  OrderCenterCell.m
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "OrderCenterCell.h"
#import "OrderDetailViewController.h"
#import "OrderCenterViewController.h"
#import "PaymentMethodViewController.h"

@interface OrderCenterCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *printNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhizhangTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *danshuangmianLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *layoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *payStatusBtn;

@end

static OrderCenterViewController *_vc;
@implementation OrderCenterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView vc:(nonnull OrderCenterViewController *)vc {
    _vc = vc;
    static NSString *cellID = @"orderCenterCell";
    OrderCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderCenterModel:(OrderCenterModel *)orderCenterModel {
    if(!orderCenterModel) return;
    _orderCenterModel = orderCenterModel;
    self.orderNoLabel.text = orderCenterModel.ordernum;
    self.printNumLabel.text = orderCenterModel.page;
    self.zhizhangTypeLabel.text = orderCenterModel.size;
    self.danshuangmianLabel.text = orderCenterModel.issingle;
    self.colorLabel.text = orderCenterModel.color;
    self.layoutLabel.text = orderCenterModel.layout;
    self.fenshuLabel.text = orderCenterModel.number;
    self.packagePriceLabel.text = [NSString stringWithFormat:@"%.2f",orderCenterModel.packfree.floatValue];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",orderCenterModel.total.floatValue];;
    
    self.payStatusBtn.hidden = NO;
    orderCenterModel.cellHeight = 470;
    NSString *payStatus = @"";
    if(orderCenterModel.status.integerValue == 1) {
        payStatus = @"未支付";
        [self.payStatusBtn setTitle:@"待付款" forState:UIControlStateNormal];
    }else if (orderCenterModel.status.integerValue == 2) {
        payStatus = @"已接单";
        [self.payStatusBtn setTitle:@"签收" forState:UIControlStateNormal];
    }else if (orderCenterModel.status.integerValue == 3) {
        payStatus = @"已接单";
        [self.payStatusBtn setTitle:@"签收" forState:UIControlStateNormal];
    }else if (orderCenterModel.status.integerValue == 4) {
        payStatus = @"已完成";
        self.payStatusBtn.hidden = YES;
        orderCenterModel.cellHeight = 425;
    }
    self.payStatusLabel.text = payStatus;
}

- (IBAction)oprationPayAction:(id)sender {
    
//    OrderDetailViewController *vc = [OrderDetailViewController lm_VC];
//    vc.orderCenter = _orderCenterModel;
    if(_orderCenterModel.status.integerValue == 1) {
//        vc.paymentStatus = ORDER_PAYMENT_WAIT_PAY;
        PaymentMethodViewController *vc = [PaymentMethodViewController lm_VC];
        vc.orderIdSourecType = LM_ORDER_ID_SOURCE_ORDER_LIST;
        vc.orderCenter = _orderCenterModel;
        [_vc lm_pushVCWithVC:vc];
    }else if (_orderCenterModel.status.integerValue == 2 || _orderCenterModel.status.integerValue == 3) {
//        vc.paymentStatus = ORDER_PAYMENT_HAS_PAY;
    }else if(_orderCenterModel.status.integerValue == 4) {
//        vc.paymentStatus = ORDER_PAYMENT_TRADE_SUCCESS;
    }
    
//    [_vc lm_pushVCWithVC:vc];
}

@end
