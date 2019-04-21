//
//  HowUseViewController.h
//  PrintMelon
//
//  Created by andy on 2019/3/19.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LMAgreementType) {
    LM_AGREEMENT_HOWUSE,
    LM_AGREEMENT_SERVICE,
    LM_AGREEMENT_STATEMENT,
};
@interface HowUseViewController : BaseViewController

@property (nonatomic, assign) LMAgreementType agreementType;

@end

NS_ASSUME_NONNULL_END
