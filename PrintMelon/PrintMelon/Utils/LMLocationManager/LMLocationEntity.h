//
//  LMLocationEntity.h
//  SurveyAPP
//
//  Created by admin on 2018/12/3.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMLocationEntity : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *streetName;
@property (nonatomic, copy) NSString *streetNumber;

@end

NS_ASSUME_NONNULL_END
