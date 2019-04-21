//
//  LMCompassTool.h
//  SurveyAPP
//
//  Created by admin on 2018/12/3.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMCompassTool : NSObject

+ (void)openCompassWithVC:(UIViewController *)vc getCompasssData:(void(^)(NSDictionary *dataDic))getCompasssData;

@end

NS_ASSUME_NONNULL_END
