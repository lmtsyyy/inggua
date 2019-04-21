//
//  RegisterAndForgetPwdViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/6.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "RegisterAndForgetPwdViewController.h"

@interface RegisterAndForgetPwdViewController ()<UITextFieldDelegate>
{
    NSString *_sixBitRandomNumber;
}
@property (weak, nonatomic) IBOutlet UIView *agreeBackV;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (assign, nonatomic) BOOL isAgree;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImageV;
@property (weak, nonatomic) IBOutlet UIButton *registerAndForgetPwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *telePhoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *againPwdTextF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backVTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) NSInteger second;

@end

static CGFloat backViewDefaultTopConstraint = 10;

@implementation RegisterAndForgetPwdViewController

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
    if(self.registerOrForgetPwdType == LM_REGISTER_TYPE) {
        self.myTitleLabel.text = @"注册";
        self.pwdLabel.text = @"密码";
        self.agreeBackV.hidden = NO;
        [self.registerAndForgetPwdBtn setTitle:@"注册" forState:UIControlStateNormal];
    }else if (self.registerOrForgetPwdType == LM_FORGETPWD_TYPE) {
        self.myTitleLabel.text = @"忘记密码";
        self.pwdLabel.text = @"设置密码";
        self.agreeBackV.hidden = YES;
        [self.registerAndForgetPwdBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    }
    [LMCommonTool inputAccessoryViewWithTextField:self.pwdTextF target:self action:@selector(endEdit)];
    [LMCommonTool inputAccessoryViewWithTextField:self.againPwdTextF target:self action:@selector(endEdit)];
    if(K_GetUserDefaultsForKey(LM_phone)) {
        self.telePhoneTextF.text = K_GetUserDefaultsForKey(LM_phone);
    }
}

- (IBAction)agree:(id)sender {
    _isAgree = !_isAgree;
    if(_isAgree) {
        self.agreeImageV.image = [UIImage imageNamed:@"register_agree_check"];
    }else {
        self.agreeImageV.image = [UIImage imageNamed:@"register_agree_uncheck"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.pwdTextF) {
        self.backVTopConstraint.constant = -60;
    }else if (textField == self.againPwdTextF) {
        self.backVTopConstraint.constant = -120;
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self endEdit];
}

- (void)endEdit {
    [self.view endEditing:YES];
    self.backVTopConstraint.constant = backViewDefaultTopConstraint;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerOrLogin:(id)sender {
    if(![NSString validateCellPhoneNumber:self.telePhoneTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入正确的手机格式"];return;
    }
    if([NSString isBlankString:self.verificationCodeTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入验证码"];return;
    }
//    if([NSString isBlankString:self.pwdTextF.text]) {
//        [LMCommonTool showInfoWithStatus:@"请输入密码"];return;
//    }
//    if([NSString isBlankString:self.againPwdTextF.text]) {
//        [LMCommonTool showInfoWithStatus:@"请再次输入密码"];return;
//    }
    if(![NSString inputShouldLetterOrNum:self.pwdTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"密码只能包含6-12位数字和字母"];return;
    }
    if(![NSString inputShouldLetterOrNum:self.againPwdTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"密码只能包含6-12位数字和字母"];return;
    }
    if(![NSString isBlankString:self.pwdTextF.text] && ![NSString isBlankString:self.againPwdTextF.text]) {
        if(![self.pwdTextF.text isEqualToString:self.againPwdTextF.text]) {
            [LMCommonTool showInfoWithStatus:@"两次密码输入不一致，请重新输入"];return;
        }
    }
    
    if(![_sixBitRandomNumber isEqualToString:self.verificationCodeTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"你输入的验证码不正确，请重新输入"];return;
    }
    
    NSString *urlStr = K_URL(register_URL);
    if(self.registerOrForgetPwdType == LM_REGISTER_TYPE) {
        if(!_isAgree) {
            [LMCommonTool showInfoWithStatus:@"注册需同意使用条款及隐私声明哦"];return;
        }
        urlStr = K_URL(register_URL);
    }else if (self.registerOrForgetPwdType == LM_FORGETPWD_TYPE) {
        urlStr = K_URL(modifyPwd_URL);
    }
    [self sendRegisterOrModifyPwdRequestwithUrl:urlStr];
}

- (void)sendRegisterOrModifyPwdRequestwithUrl:(NSString *)urlStr {
    NSDictionary *params = @{@"phone" : self.telePhoneTextF.text,
                             @"password" : self.pwdTextF.text
                             };
    [[HttpRequestTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            K_Show_Success_Tip
            [self lm_dismissVC];
        }else {
            K_Show_Error_Tip
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

- (IBAction)getVerificationCode:(id)sender {
    if(_second > 0 && _second < 60) return;
    NSString *type = @"2";
    if(self.registerOrForgetPwdType == LM_REGISTER_TYPE) {
        type = @"2";
    }else if (self.registerOrForgetPwdType == LM_FORGETPWD_TYPE) {
        type = @"3";
    }
    if(![NSString validateCellPhoneNumber:self.telePhoneTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入正确的手机格式"];return;
    }
    _sixBitRandomNumber = [LMCommonTool getSixBitRandomNumber];
    NSDictionary *params = @{@"phone" : self.telePhoneTextF.text,
                             @"code" : _sixBitRandomNumber,
                             @"type" : type
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

- (void)dealloc {
    
    [self.myTimer invalidate];
    self.myTimer = nil;
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
