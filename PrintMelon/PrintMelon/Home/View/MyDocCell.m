//
//  MyDocCell.m
//  PrintMelon
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "MyDocCell.h"

@interface MyDocCell()

@property (weak, nonatomic) IBOutlet UILabel *docNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *docPageNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *docTimeLabel;

@end

@implementation MyDocCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"myDocCell";
    MyDocCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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

- (void)setDocModel:(MyDocModel *)docModel {
    if(!docModel) return;
    self.docNameLabel.text = docModel.filename;
    self.docPageNumLabel.text = [NSString stringWithFormat:@"%@页",docModel.page];
    self.docTimeLabel.text = docModel.addtime;
    
    if(docModel.isSelected) {
        self.selectedImageV.image = [UIImage imageNamed:@"print_select_icon"];
    }else {
        self.selectedImageV.image = [UIImage imageNamed:@"print_unselect_icon"];
    }
    
    if(docModel.isHideImg) {
        self.selectedImageV.hidden = YES;
    }else {
        self.selectedImageV.hidden = NO;
    }
}

@end
