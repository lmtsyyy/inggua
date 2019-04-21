//
//  PrintEditCell.h
//  PrintMelon
//
//  Created by andy on 2019/3/16.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintEditModel.h"

NS_ASSUME_NONNULL_BEGIN
@class PrintEditViewController;
@interface PrintEditCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView vc:(PrintEditViewController *)vc;

@property (nonatomic, strong) PrintEditModel *printEditModel;

@end

NS_ASSUME_NONNULL_END
