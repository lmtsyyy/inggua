//
//  PrintEditViewController.h
//  PrintMelon
//
//  Created by andy on 2019/3/15.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PrintEditType) {
    PRINT_EDIT_ZHIZHANG_TYPE,//纸张
    PRINT_EDIT_FENSHU_TYPE,//份数
    PRINT_EDIT_DANSHUANGYE_TYPE,//单双页
    PRINT_EDIT_COLOR_TYPE,//颜色
    PRINT_EDIT_LAYOUT_TYPE,//布局
    PRINT_EDIT_BIND_TYPE,//装订
    PRINT_EDIT_OTHER_TYPE,
};

@interface PrintEditViewController : BaseTableViewController

@property (nonatomic, assign) PrintEditType printEditType;
@property (nonatomic, copy) NSString *docIDs;

@end

NS_ASSUME_NONNULL_END
