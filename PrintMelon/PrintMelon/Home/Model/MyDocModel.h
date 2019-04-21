//
//  MyDocModel.h
//  PrintMelon
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDocModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *uid;


@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isHideImg;

@end

NS_ASSUME_NONNULL_END
