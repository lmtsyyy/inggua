//
//  AboutUsViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/7.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "AboutUsViewController.h"
#import "HowUseViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    [self lm_setupNaviCommonBackBarItemWithImageName:nil];
    [self lm_setupNaviTitleViewWithTitle:@"关于我们" titleColor:nil];
}

- (IBAction)introductionClick:(id)sender {
    HowUseViewController *vc = [HowUseViewController lm_VC];
    vc.agreementType = LM_AGREEMENT_STATEMENT;
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
}

- (IBAction)serviceAgreementClick:(id)sender {
    HowUseViewController *vc = [HowUseViewController lm_VC];
    vc.agreementType = LM_AGREEMENT_SERVICE;
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
}

- (IBAction)versionUpdateClick:(id)sender {
    
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
