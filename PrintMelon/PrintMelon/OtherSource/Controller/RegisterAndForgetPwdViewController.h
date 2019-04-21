//
//  RegisterAndForgetPwdViewController.h
//  PrintMelon
//
//  Created by admin on 2019/3/6.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,LMRegisterOrForgetPwdType) {
    LM_REGISTER_TYPE,//注册
    LM_FORGETPWD_TYPE,//忘记密码
};

@interface RegisterAndForgetPwdViewController : BaseViewController

@property (nonatomic, assign) LMRegisterOrForgetPwdType registerOrForgetPwdType;

@end

NS_ASSUME_NONNULL_END
