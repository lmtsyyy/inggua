//
//  PaymentMethodViewController.h
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OrderIdSourceType) {
    LM_ORDER_ID_SOURCE_GOOD,
    LM_ORDER_ID_SOURCE_ORDER_LIST,
};

@class OrderCenterModel;
@interface PaymentMethodViewController : BaseViewController

@property (nonatomic, strong) OrderCenterModel *orderCenter;
@property (nonatomic, assign) OrderIdSourceType orderIdSourecType;

@end

NS_ASSUME_NONNULL_END
