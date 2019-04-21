//
//  MyDocViewController.h
//  PrintMelon
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, MyDocType) {
    LM_MYDOC_DOC_TYPE,
    LM_MYDOC_PDF_TYPE,
    LM_MYDOC_PPT_TYPE,
};
@interface MyDocViewController : BaseTableViewController

@property (nonatomic, assign) MyDocType myDocType;

@end

NS_ASSUME_NONNULL_END
