//
//  PrintEditCell.m
//  PrintMelon
//
//  Created by andy on 2019/3/16.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "PrintEditCell.h"
#import "PrinteditViewController.h"

@interface PrintEditCell()

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageV;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXOffsetConstraint;

@end

static PrintEditViewController *_vc;
@implementation PrintEditCell

+ (instancetype)cellWithTableView:(UITableView *)tableView vc:(nonnull PrintEditViewController *)vc {
    _vc = vc;
    static NSString *cellID = @"printEditCell";
    PrintEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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

- (void)setPrintEditModel:(PrintEditModel *)printEditModel {
    if(!printEditModel) return;
    self.myTitleLabel.text = printEditModel.myTitle;
    if(printEditModel.isSelected) {
        self.selectedImageV.image = [UIImage imageNamed:@"print_select_icon"];
    }else {
        self.selectedImageV.image = [UIImage imageNamed:@"print_unselect_icon"];
    }
    if(printEditModel.lengthGreaterThanFive) {
        self.centerXOffsetConstraint.constant = -30;
    }else {
        self.centerXOffsetConstraint.constant = 0;
    }
}

@end
