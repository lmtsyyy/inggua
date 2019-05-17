//
//  OrderDetailModel.h
//  PrintMelon
//
//  Created by andy on 2019/3/23.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispatchStaffModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *ordernum;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *issingle;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *layout;
@property (nonatomic, copy) NSString *binding;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *packfree;
@property (nonatomic, copy) NSString *consignee;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *goodprice;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *deliverytime;
@property (nonatomic, copy) NSString *finishtime;
@property (nonatomic, copy) NSString *apptime;

@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) DispatchStaffModel *staff;

@end


NS_ASSUME_NONNULL_END
