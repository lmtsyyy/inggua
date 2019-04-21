//
//  PrintEditModel.h
//  PrintMelon
//
//  Created by andy on 2019/3/16.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrintEditModel : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *myTitle;
@property (nonatomic, assign) BOOL lengthGreaterThanFive;
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
