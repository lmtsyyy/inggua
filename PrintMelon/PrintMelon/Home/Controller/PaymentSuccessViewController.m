//
//  PaymentSuccessViewController.m
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "PaymentSuccessViewController.h"
#import "OrderCenterModel.h"

@interface PaymentSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *zhangshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhizhangLabel;
@property (weak, nonatomic) IBOutlet UILabel *danshuangmianLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *layoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@end

@implementation PaymentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"支付成功")
    self.zhangshuLabel.text = self.orderCenter.page;
    self.zhizhangLabel.text = self.orderCenter.size;
    self.danshuangmianLabel.text = self.orderCenter.issingle;
    self.colorLabel.text = self.orderCenter.color;
    self.layoutLabel.text = self.orderCenter.layout;
    self.fenshuLabel.text = self.orderCenter.number;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
