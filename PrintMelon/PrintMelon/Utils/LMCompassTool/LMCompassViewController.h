//
//  LMCompassViewController.h
//  SurveyAPP
//
//  Created by admin on 2018/12/3.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMCompassViewController : BaseViewController

@property (nonatomic, copy) void(^getCompassData)(NSDictionary *dataDic);

@end

NS_ASSUME_NONNULL_END
