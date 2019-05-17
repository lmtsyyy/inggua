//
//  LoginViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/6.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterAndForgetPwdViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "BindPhoneViewController.h"
#import "UIButton+WebCache.h"

#define WX_BASE_URL @"https://api.weixin.qq.com/sns/"

@interface LoginViewController ()<WXApiManagerDelegate,WechatAuthAPIDelegate,UITextFieldDelegate>
{
    NSInteger _type;//登录类型（1为验证码登陆 2为密码登陆）
    NSString *_sixBitRandomNumber;
}
@property (weak, nonatomic) IBOutlet UIView *accountPwdBackV;
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verificationCodeDotV;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pwdDotV;
@property (weak, nonatomic) IBOutlet UIView *verificationCodeBackV;
@property (weak, nonatomic) IBOutlet UIView *pwdBackV;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *telePhoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UILabel *pwdOrCodeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backVTopConstrait;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) NSInteger second;
@property (weak, nonatomic) IBOutlet UIButton *userHeadImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *wxLoginLabel;
@property (weak, nonatomic) IBOutlet UIView *wxLoginLeftLineV;
@property (weak, nonatomic) IBOutlet UIView *wxLoginRightLineV;

@end

static NSString *kAuthScope = @"snsapi_userinfo";
static NSString *kAuthOpenID = @"wx81649484d04cf872";
//static NSString *kAuthState = @"xxx";
static CGFloat backViewDefaultTopConstraint = 10;

@implementation LoginViewController

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
    
    self.accountPwdBackV.layer.cornerRadius = 6.0;
    self.pwdTextF.placeholder = @"请输入验证码";
    self.pwdTextF.secureTextEntry = NO;
    _type = 1;//默认验证码登录
    if(K_GetUserDefaultsForKey(LM_phone)) {
        self.telePhoneTextF.text = K_GetUserDefaultsForKey(LM_phone);
    }
    [WXApiManager sharedManager].delegate = self;
    [LMCommonTool inputAccessoryViewWithTextField:self.pwdTextF target:self action:@selector(endEdit)];
    
    [self.userHeadImageBtn sd_setImageWithURL:[NSURL URLWithString:K_URL([AppEntity shareInstance].userImageUrl)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head_icon"]];
    self.userHeadImageBtn.layer.cornerRadius = CGRectGetWidth(self.userHeadImageBtn.frame) * 0.5;
    self.userHeadImageBtn.layer.masksToBounds = YES;
    
    if(![WXApi isWXAppInstalled]) {
        self.wxLoginBtn.hidden = YES;
        self.wxLoginLabel.hidden = YES;
        self.wxLoginLeftLineV.hidden = YES;
        self.wxLoginRightLineV.hidden = YES;
    }
    
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

- (IBAction)verificationCodeLoginClick:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    if(sender.view == self.verificationCodeBackV) {
        self.verificationCodeLabel.textColor = K_Theme_Color;
        self.pwdLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.verificationCodeDotV.hidden = NO;
        self.pwdDotV.hidden = YES;
        self.getVerificationCodeBtn.hidden = NO;
        self.forgetPwdBtn.hidden = YES;
        self.pwdOrCodeLabel.text = @"验证码";
        self.pwdTextF.placeholder = @"请输入验证码";
        self.pwdTextF.secureTextEntry = NO;
        _type = 1;
//        self.pwdTextF.keyboardType = UIKeyboardTypeNumberPad;
    }else if (sender.view == self.pwdBackV) {
        self.pwdLabel.textColor = K_Theme_Color;
        self.verificationCodeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.pwdLabel.text = @"密码";
        self.pwdDotV.hidden = NO;
        self.verificationCodeDotV.hidden = YES;
        self.getVerificationCodeBtn.hidden = YES;
        self.forgetPwdBtn.hidden = NO;
        self.pwdOrCodeLabel.text = @"密码";
        self.pwdTextF.placeholder = @"请输入密码";
        self.pwdTextF.secureTextEntry = YES;
        _type = 2;
//        self.pwdTextF.keyboardType = UIKeyboardTypeDefault;
    }
    self.pwdTextF.text = @"";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.pwdTextF) {
        self.backVTopConstrait.constant = -60;
        if(_type == 1) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if(_type == 2) {
            textField.keyboardType = UIKeyboardTypeDefault;
        }
    }
}

- (IBAction)getVerificationCode:(id)sender {
    if(_second > 0 && _second < 60) return;
    _sixBitRandomNumber = [LMCommonTool getSixBitRandomNumber];
    if(![NSString validateCellPhoneNumber:self.telePhoneTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入正确的手机格式"];return;
    }
    NSDictionary *params = @{@"phone" : self.telePhoneTextF.text,
                             @"code" : _sixBitRandomNumber,
                             @"type" : @"1"
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

- (IBAction)hideKeyboard:(id)sender {
    [self endEdit];
}

- (void)endEdit {
    [self.view endEditing:YES];
    self.backVTopConstrait.constant = backViewDefaultTopConstraint;
}

- (IBAction)login:(id)sender {
//    if([NSString isBlankString:self.telePhoneTextF.text]) {
//        [LMCommonTool showInfoWithStatus:@"请输入手机号"];return;
//    }
    if(![NSString validateCellPhoneNumber:self.telePhoneTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入正确的手机格式"];return;
    }
    
    if([NSString isBlankString:self.pwdTextF.text]) {
        if(_type == 1) {
            [LMCommonTool showInfoWithStatus:@"请输入验证码"];return;
        }else if(_type == 2) {
            [LMCommonTool showInfoWithStatus:@"请输入密码"];return;
        }
    }
    
    if(_type == 1) {
        if(![_sixBitRandomNumber isEqualToString:self.pwdTextF.text]) {
            [LMCommonTool showInfoWithStatus:@"您输入的验证码不正确，请重新输入"];return;
        }
    }
   
    
    
    
    
    [self sendLoginRequest];
    
    
}

- (IBAction)registerUser:(id)sender {
    RegisterAndForgetPwdViewController *vc = [RegisterAndForgetPwdViewController lm_VC];
    vc.registerOrForgetPwdType = LM_REGISTER_TYPE;
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)forgetPwd:(id)sender {
    RegisterAndForgetPwdViewController *vc = [RegisterAndForgetPwdViewController lm_VC];
    vc.registerOrForgetPwdType = LM_FORGETPWD_TYPE;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)sendLoginRequest {
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST_URL,login_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.telePhoneTextF.text forKey:@"phone"];
    [params setObject:@(_type).stringValue forKey:@"type"];
    if(_type == 2) {
        [params setObject:self.pwdTextF.text forKey:@"password"];
    }
    
    [LMCommonTool show];
    [[HttpRequestTool shareInstance] POST:url parameters:params success:^(id responseObject) {
        [LMCommonTool dismiss];
        NSLog(@"responseObject = %@",responseObject);
        
        if(K_SUCCESS_CODE) {//登录成功
            [LMCommonTool gotoMainController];
            NSDictionary *userInfo = responseObject[@"user"];
            [AppEntity shareInstance].userid = [NSString stringWithFormat:@"%@",userInfo[@"id"]];
            [AppEntity shareInstance].username = userInfo[@"username"];
            [AppEntity shareInstance].userImageUrl = userInfo[@"headimg"];
            K_UserDefaults(LM_phone, userInfo[@"phone"]);
            K_UserDefaults(LM_userid, [AppEntity shareInstance].userid);
            K_UserDefaults(LM_username, [AppEntity shareInstance].username);
            K_UserDefaults(LM_userImageUrl, [AppEntity shareInstance].userImageUrl);
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {//注册失败
            K_Show_Error_Tip
        }
        
    } failure:^(NSError *error) {
        [LMCommonTool dismiss];
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

//微信登录
- (IBAction)wxLogin:(id)sender {
//    [self sendWxLoginRequest];
    NSString *accessToken = K_GetUserDefaultsForKey(WX_ACCESS_TOKEN);
    NSString *openid = K_GetUserDefaultsForKey(WX_OPEN_ID);
    if(![NSString isBlankString:accessToken] && ![NSString isBlankString:openid]) {
        NSString *refreshToken = K_GetUserDefaultsForKey(WX_REFRESH_TOKEN);
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WX_BASE_URL,WX_APP_ID,refreshToken];
        [[HttpRequestTool shareInstance] GET:refreshUrlStr parameters:nil success:^(id responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            NSString *accessToken = responseObject[WX_ACCESS_TOKEN];
            // 如果accessToken为空,说明accessToken也过期了,反之则没有过期
            if (![NSString isBlankString:accessToken]) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[WX_OPEN_ID] forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self wechatLoginByRequestForUserInfo];
            }
            else {
                [self sendAuthRequest];
            }
        } failure:^(NSError *error) {
            
        }];
    }else {
        [self sendAuthRequest];
    }
    
}

- (void)sendWxLoginRequestWithOpenid:(NSString *)openid nickName:(NSString *)nickname {
    
    NSDictionary *params = @{@"openid" : openid,
                             @"nickname" : nickname
                             };
    [[HttpRequestTool shareInstance] POST:K_URL(wxLogin_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            
            NSDictionary *userInfo = responseObject[@"user"];
            [AppEntity shareInstance].userid = [NSString stringWithFormat:@"%@",userInfo[@"id"]];

            [AppEntity shareInstance].username = userInfo[@"username"];
            [AppEntity shareInstance].userImageUrl = userInfo[@"headimg"];
            [AppEntity shareInstance].phone = userInfo[@"phone"];
            if(![NSString isBlankString:[AppEntity shareInstance].phone]) {
                K_UserDefaults(LM_phone, [AppEntity shareInstance].phone);
            }
            K_UserDefaults(LM_userid, [AppEntity shareInstance].userid);
            K_UserDefaults(LM_username, [AppEntity shareInstance].username);
            K_UserDefaults(LM_userImageUrl, [AppEntity shareInstance].userImageUrl);
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *phone = userInfo[@"phone"];
            if([NSString isBlankString:phone]) {//绑定手机号
                BindPhoneViewController *vc = [BindPhoneViewController lm_VC];
                [self lm_presentVCWithVC:vc];
            }else {
                [LMCommonTool gotoMainController];
            }
        }else {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

#pragma mark -WXApiManagerDelegate
- (void)sendAuthRequest {
    [WXApiRequestHandler sendAuthRequestScope:kAuthScope
                                        State:[NSString randomKey]
                                       OpenID:kAuthOpenID
                             InViewController:self];
}



- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    
    if(response.errCode == 0) {//成功
        NSString *wxAuthUrlStr = [NSString stringWithFormat:@"%@oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_BASE_URL,WX_APP_ID,WX_APP_SECRET,response.code];
        
        [[HttpRequestTool shareInstance] GET:wxAuthUrlStr parameters:nil success:^(id responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            NSDictionary *accessDic = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *accessToken = [accessDic objectForKey:@"access_token"];
            NSString *openID = [accessDic objectForKey:@"openid"];
            NSString *refreshToken = [accessDic objectForKey:@"refresh_token"];
            // 本地持久化，以便access_token的使用、刷新或者持续
            if (![NSString isBlankString:accessToken] && ![NSString isBlankString:openID]) {
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
            }
            [self wechatLoginByRequestForUserInfo];
            
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    
//    [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfo {
    NSString *accessToken = K_GetUserDefaultsForKey(WX_ACCESS_TOKEN);
    NSString *openID = K_GetUserDefaultsForKey(WX_OPEN_ID);
    NSString *userUrlStr = [NSString stringWithFormat:@"%@userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    // 请求用户数据
    [[HttpRequestTool shareInstance] GET:userUrlStr parameters:nil success:^(id responseObject) {
        NSLog(@"请求用户信息的response = %@", responseObject);
        [self sendWxLoginRequestWithOpenid:responseObject[@"openid"] nickName:responseObject[@"nickname"]];
    } failure:^(NSError *error) {
        NSLog(@"获取用户信息时出错 = %@", error);
    }];
}

#pragma mark -WechatAuthAPIDelegate
//微信成功登录
- (void)onAuthFinish:(int)errCode AuthCode:(NSString *)authCode {
    NSLog(@"onAuthFinish");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"onAuthFinish"
                                                    message:[NSString stringWithFormat:@"authCode:%@ errCode:%d", authCode, errCode]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
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
