//
//  PersonalCenterViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/4.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalInfoViewController.h"
#import "AboutUsViewController.h"
#import "OrderCenterViewController.h"
#import "UIImageView+WebCache.h"
#import "HowUseViewController.h"

@interface PersonalCenterViewController ()

@property (weak, nonatomic) IBOutlet UIView *headImgBackV;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageV;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)otherSetup {
    self.headImgBackV.layer.cornerRadius = CGRectGetWidth(self.headImgBackV.frame) * 0.5;
    self.userHeadImageV.layer.cornerRadius = CGRectGetHeight(self.userHeadImageV.frame) * 0.5;
    self.userHeadImageV.layer.masksToBounds = YES;
    NSString *headImageUrl = [NSString stringWithFormat:@"%@%@",HOST_URL,[AppEntity shareInstance].userImageUrl];
    [self.userHeadImageV sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"head_rect_icon"] completed:nil];
    self.userNickNameLabel.text = [AppEntity shareInstance].username;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self otherSetup];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)headImagClick:(id)sender {
    PersonalInfoViewController *vc = [PersonalInfoViewController lm_VC];
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
    
}

- (IBAction)oederCenter:(id)sender {
    OrderCenterViewController *vc = [OrderCenterViewController lm_VC];
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
}

- (IBAction)howUse:(id)sender {
    HowUseViewController *vc = [HowUseViewController lm_VC];
    vc.agreementType = LM_AGREEMENT_HOWUSE;
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
}

- (IBAction)aboutUs:(id)sender {
    AboutUsViewController *vc = [AboutUsViewController lm_VC];
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
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
