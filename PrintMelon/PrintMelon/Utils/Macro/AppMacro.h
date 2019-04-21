//
//  AppMacro.h
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

//常用工具
#import "NSString+Extend.h"
#import "UIColor+Hex.h"
#import "NSDictionary+Extension.h"
#import "NSString+Extension.h"
#import "LMCommonTool.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIBarButtonItem+LMExtension.h"
#import "UIViewController+LMExtension.h"
#import "HttpRequestTool.h"
#import <MJExtension/MJExtension.h>
#import "BaseTableViewController.h"
#import "AppEntity.h"
#import "ConstValue.h"

#define K_COMMOM_BACK_BUTTON [self lm_setupNaviCommonBackBarItemWithImageName:nil];   
#define K_NAVIGATION_TITLE(title) [self lm_setupNaviTitleViewWithTitle:title titleColor:nil];

#define K_Theme_Color [UIColor colorWithHexString:@"FBDC19"]
#define K_Work_Color [UIColor colorWithHexString:@"FF9F00"]
#define K_Complete_Color [UIColor colorWithHexString:@"11CD03"]
#define K_Discard_Color [UIColor colorWithHexString:@"878787"]
#define K_Reject_Color [UIColor colorWithHexString:@"EF3131"]

#define K_BackColor [UIColor colorWithHexString:@"EFEFF4"]

#define k_Token @"token"
#define k_Userid @"userid"
#define k_Roleid @"roleid"
#define k_Username @"username"
#define k_Role @"role"
#define k_Account @"account"
#define k_Password @"password"
#define k_UserHeadImage @"userHeadImage"

#define K_GetUserDefaultsForKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define K_UserDefaults(key,value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]

#define SVProgressShowTime 2

#define NSStringNotNullForKey(key) [NSString isBlankString:resultDic[key]] ? @"" : resultDic[key]
#define NSStringFromNumberForKey(key) [NSString stringWithFormat:@"%@",resultDic[key]];

#define K_Success_Status_Code [responseObject[@"status"] integerValue] == 200 &&  [responseObject[@"errCode"] integerValue] == 0
#define K_Kick_Status_Code [responseObject[@"errCode"] integerValue] == 1200 || [responseObject[@"errCode"] integerValue] == 2300
#define K_Show_Error_Tip if([responseObject[@"msg"] isKindOfClass:[NSString class]]) {\
[LMCommonTool showErrorWithStatus:responseObject[@"msg"]];\
}
#define K_Show_Success_Tip if([responseObject[@"msg"] isKindOfClass:[NSString class]]) {\
[LMCommonTool showSuccessWithStatus:responseObject[@"msg"]];\
}
#define K_Show_Info_Tip if([responseObject[@"msg"] isKindOfClass:[NSString class]]) {\
[LMCommonTool showInfoWithStatus:responseObject[@"msg"]];\
}
#define K_Request_Timeout if([error.localizedDescription hasSuffix:@"timed out"]) {\
[LMCommonTool showErrorWithStatus:@"网路超时了哦~"];\
}\
[LMCommonTool dismiss];\
MYLog(@"error = %@",error.localizedDescription);

#define K_SUCCESS_CODE [responseObject[@"code"] integerValue] == 1
#define K_URL(url) [NSString stringWithFormat:@"%@%@",HOST_URL,url]

#define IF_MESSAGE_IS_NULL if(responseObject[@"message"] == [NSNull null]) return;
#define IF_OBJECT_NULL if(responseObject[@"object"] == [NSNull null]) return;
#define TOKEN_INVALID [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]] isEqualToString:@"000005"]
#define TOKEN_INVALID_TIP @"你的登录已失效，请重新登录"
/**
 *  本类放app相关的宏定义
 */

/**                                      
 *  1 时为生产环境，0 为测试环境
 */
#define APP_BASE_URL 0 ? @"" : @""

#endif /* AppMacro_h */
