//
//  OrderDetailViewController.h
//  PrintMelon
//
//  Created by andy on 2019/3/16.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,OrderPaymentStatus) {
    ORDER_PAYMENT_WAIT_PAY,//未付款
    ORDER_PAYMENT_HAS_PAY,//已付款
    ORDER_PAYMENT_TRADE_SUCCESS,//交易成功
};

@class OrderCenterModel;
@interface OrderDetailViewController : BaseViewController

@property (nonatomic, assign) OrderPaymentStatus paymentStatus;
@property (nonatomic, strong) OrderCenterModel *orderCenter;
@property (nonatomic, assign) BOOL isPaySuccess;

@end

NS_ASSUME_NONNULL_END
