//
//  ModifyNicknameViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/7.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "ModifyNicknameViewController.h"

@interface ModifyNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextF;

@end

@implementation ModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON;
    K_NAVIGATION_TITLE(@"修改昵称")
}

- (IBAction)save:(id)sender {
    if([NSString isBlankString:self.nickNameTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入需要修改的昵称"];return;
    }
    [self sendModifyNickRequest];
}

- (void)sendModifyNickRequest {
    if([NSString isBlankString:self.nickNameTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入昵称"];return;
    }
    NSDictionary *params = @{@"id" : [AppEntity shareInstance].userid,
                             @"username" : self.nickNameTextF.text
                            };
    [LMCommonTool show];
    [[HttpRequestTool shareInstance] POST:K_URL(modifyNick_URL) parameters:params success:^(id responseObject) {
        [LMCommonTool dismiss];
        NSLog(@"responseObject = %@",responseObject);
        
        if(K_SUCCESS_CODE) {
            [self lm_popVC];
            K_Show_Success_Tip
        }else {
            K_Show_Error_Tip
        }
        
    } failure:^(NSError *error) {
        [LMCommonTool dismiss];
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
