//
//  OrderCenterCell.h
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCenterModel.h"
NS_ASSUME_NONNULL_BEGIN

@class OrderCenterViewController;
@interface OrderCenterCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView vc:(OrderCenterViewController *)vc;

@property (nonatomic, strong) OrderCenterModel *orderCenterModel;

@end

NS_ASSUME_NONNULL_END
