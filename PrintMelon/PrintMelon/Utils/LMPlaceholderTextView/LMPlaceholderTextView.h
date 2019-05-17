//
//  LMPlaceholderTextView.h
//  PrintMelon
//
//  Created by min on 2019/4/23.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMPlaceholderTextView : UITextView

//@property (nonatomic, strong) UILabel *placeholderLabel;

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
