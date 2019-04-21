//
//  AppEntity.m
//  SurveyAPP
//
//  Created by admin on 2018/11/16.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "AppEntity.h"

@implementation AppEntity

static AppEntity *_appEntity = nil;
+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_appEntity) {
            _appEntity = [[AppEntity alloc] init];
        }
    });
    return _appEntity;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_appEntity) {
            _appEntity = [super allocWithZone:zone];
        }
    });
    return _appEntity;
}

@end
