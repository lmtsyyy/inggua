//
//  AppEntity.h
//  SurveyAPP
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppEntity : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *userImageUrl;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) BOOL networkAvailable;
@property (nonatomic, assign) BOOL needImmediatelyExecuteTimer;

@end

NS_ASSUME_NONNULL_END
