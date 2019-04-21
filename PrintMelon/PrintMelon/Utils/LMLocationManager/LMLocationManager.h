//
//  LMLocationManager.h
//  SurveyAPP
//
//  Created by admin on 2018/12/3.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMLocationEntity.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMLocationManager : NSObject

- (void)startUserLocation;

- (void)stopUserLocation;

@property (nonatomic, copy) void(^getLocationInfo)(LMLocationEntity *locationEntity);

@end

NS_ASSUME_NONNULL_END
