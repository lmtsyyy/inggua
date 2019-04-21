//
//  MyDocCell.h
//  PrintMelon
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDocModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDocCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MyDocModel *docModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageV;

@end

NS_ASSUME_NONNULL_END
