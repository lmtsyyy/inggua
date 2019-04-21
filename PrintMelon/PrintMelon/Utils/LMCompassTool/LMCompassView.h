//
//  LMCompassView.h
//  SurveyAPP
//
//  Created by admin on 2018/12/3.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMCompassView : UIView

//重置刻度标志的方向
- (void)resetDirection:(CGFloat)heading;

@end

NS_ASSUME_NONNULL_END
