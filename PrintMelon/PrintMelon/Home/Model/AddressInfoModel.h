//
//  AddressInfoModel.h
//  PrintMelon
//
//  Created by andy on 2019/3/22.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfoModel : NSObject

@property (nonatomic, copy) NSString *consignee;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
