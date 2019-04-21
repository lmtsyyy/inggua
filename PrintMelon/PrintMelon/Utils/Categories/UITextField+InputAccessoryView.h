//
//  UITextField+InputAccessoryView.h
//  SurveyAPP
//
//  Created by admin on 2018/12/13.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (InputAccessoryView)

- (void)keyboardAddCustomInputAccessoryViewTarget:(id)target 
                                                   action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
