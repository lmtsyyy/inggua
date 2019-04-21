//
//  ConfirmOrderViewController.h
//  PrintMelon
//
//  Created by andy on 2019/3/16.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderCenterModel;
@class CouponInfoModel;

@interface ConfirmOrderViewController : BaseViewController

@property (nonatomic, strong) OrderCenterModel *orderCenter;
@property (nonatomic, strong) CouponInfoModel *couponInfo;
@property (nonatomic, copy) NSString *orderId;



@end

NS_ASSUME_NONNULL_END
