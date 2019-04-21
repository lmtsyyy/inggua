//
//  BindPhoneViewController.m
//  PrintMelon
//
//  Created by andy on 2019/4/9.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()
{
    NSString *_sixBitRandomNumber;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextF;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) NSInteger second;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;

@end

@implementation BindPhoneViewController

- (NSTimer *)myTimer {
    if(!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        _second = 60;
    }
    return _myTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)timeChange {
    
    _second --;
    if(_second <= 0) {
        [self.myTimer invalidate];
        //        [self.getVerificationCodeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        self.getVerificationCodeBtn.enabled = YES;
    }else {
        //        [self.getVerificationCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%zds",_second] forState:UIControlStateNormal];
        //        self.getVerificationCodeBtn.enabled = NO;
    }
}


- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"绑定手机")
}

- (IBAction)bind:(id)sender {
    if(![NSString validateCellPhoneNumber:self.phoneTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入正确的手机格式"];return;
    }
    if(![_sixBitRandomNumber isEqualToString:self.verificationCodeTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"您输入的验证码不正确，请重新输入"];return;
    }
    if([NSString isBlankString:self.verificationCodeTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入验证码"];return;
    }
    [self sendBindPhoneRequest];
}

- (IBAction)dismiss:(id)sender {
    [self lm_dismissVC];
}

- (void)sendBindPhoneRequest {
    NSDictionary *params = @{@"phone" : self.phoneTextF.text,
                             @"id" : [AppEntity shareInstance].userid
                             };
    [[HttpRequestTool shareInstance] POST:K_URL(bindPhone_URL) parameters:params success:^(id responseObject) {
        if(K_SUCCESS_CODE) {
            NSDictionary *userInfo = responseObject[@"user"];
            [AppEntity shareInstance].userid = userInfo[@"id"];
            [AppEntity shareInstance].username = userInfo[@"username"];
            [AppEntity shareInstance].userImageUrl = userInfo[@"headimg"];
            [LMCommonTool gotoMainController];
            K_Show_Success_Tip
        }else {
            K_Show_Error_Tip
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)getVerificationCode:(id)sender {
    if(_second > 0 && _second < 60) return;
    _sixBitRandomNumber = [LMCommonTool getSixBitRandomNumber];
    if(![NSString validateCellPhoneNumber:self.phoneTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入正确的手机格式"];return;
    }
    NSDictionary *params = @{@"phone" : self.phoneTextF.text,
                             @"code" : _sixBitRandomNumber,
                             @"type" : @"4"
                             };
    __weak typeof(self) weakSelf = self;
    [[HttpRequestTool shareInstance] GET:K_URL(sendVerificationCode_URL) parameters:params success:^(id responseObject) {
        if([responseObject[@"Code"] isEqualToString:@"OK"] && [responseObject[@"Message"] isEqualToString:@"OK"]) {
            NSLog(@"发送成功");
            [LMCommonTool showSuccessWithStatus:@"验证码发送成功"];
            [weakSelf.myTimer fire];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
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
