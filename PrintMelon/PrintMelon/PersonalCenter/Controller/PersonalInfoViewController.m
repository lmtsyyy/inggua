//
//  PersonalInfoViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/7.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "ModifyNicknameViewController.h"
#import "UIImageView+WebCache.h"
#import "ImagePickerUtil.h"

@interface PersonalInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"个人信息")
    if(![NSString isBlankString:[AppEntity shareInstance].username]) {
        self.nicknameLabel.text = [AppEntity shareInstance].username;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sendUserInfoRequest];
}



- (IBAction)headImgClick:(id)sender {
    
    
    [[ImagePickerUtil shareInstance] openAlbumWithVC:self getImageBlock:^(UIImage * _Nonnull image, NSString * _Nonnull imageUrlStr) {
        [self sendModifyUserHeadImageRequestWithImage:image imageUrlStr:imageUrlStr];
    }];
    
}

- (IBAction)nicknameClick:(id)sender {
    ModifyNicknameViewController *vc = [ModifyNicknameViewController lm_VC];
    [self lm_pushVCWithVC:vc];
}

- (void)sendModifyUserHeadImageRequestWithImage:(UIImage *)image imageUrlStr:(NSString *)imageUrlStr {
    
    NSData *imageData = [LMCommonTool compressWithImage:image maxLength:100];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    NSDictionary *params = @{@"uid" : [AppEntity shareInstance].userid,
                             @"headimg" : imageUrlStr
                             };
    
    
    [[HttpRequestTool shareInstance] POST:K_URL(modifyHeadImage_URL) parameter:params data:imageData name:@"headimg" fileName:fileName mimeType:@"image/jpeg" success:^(id responseObject) {
        if(K_SUCCESS_CODE) {
            [self.headImageV sd_setImageWithURL:[NSURL URLWithString:K_URL(responseObject[@"data"])] placeholderImage:[UIImage imageNamed:@"head_rect_icon"] completed:nil];
            K_Show_Success_Tip
        }else {
            K_Show_Error_Tip
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)sendUserInfoRequest {
    NSDictionary *params = @{@"uid" : [AppEntity shareInstance].userid};
    [[HttpRequestTool shareInstance] POST:K_URL(userInfo_URL) parameters:params success:^(id responseObject) {
        if(K_SUCCESS_CODE) {
            NSDictionary *userDic = responseObject[@"user"];
            [AppEntity shareInstance].username = userDic[@"username"];
            [AppEntity shareInstance].userImageUrl = userDic[@"headimg"];
            self.nicknameLabel.text = [AppEntity shareInstance].username;
            NSString *headImageUrl = [NSString stringWithFormat:@"%@%@",HOST_URL,[AppEntity shareInstance].userImageUrl];
            [self.headImageV sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"head_rect_icon"] completed:nil];
        }else {
            
        }
    } failure:^(NSError *error) {
    }];
}

- (IBAction)logout:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"您确定要退出吗" preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction *cancelAcrion = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LMCommonTool gotoLoginController];
        K_UserDefaults(LM_userid, @"");
        K_UserDefaults(LM_username, @"");
        K_UserDefaults(LM_userImageUrl, @"");
    }];
    [alertVC addAction:cancelAcrion];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
