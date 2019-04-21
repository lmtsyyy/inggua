//
//  PaymentSuccessViewController.h
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderCenterModel;
@interface PaymentSuccessViewController : BaseViewController

@property (nonatomic, strong) OrderCenterModel *orderCenter;

@end

NS_ASSUME_NONNULL_END
