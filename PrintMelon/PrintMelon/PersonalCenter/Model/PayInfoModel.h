//
//  PayInfoModel.h
//  PrintMelon
//
//  Created by andy on 2019/4/2.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayInfoModel : NSObject

@property (nonatomic, copy) NSString *appid;
/** 商家向财付通申请的商家id */
@property (nonatomic, copy) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, copy) NSString *prepayid;
/** 随机串，防重发 */
@property (nonatomic, copy) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, assign) UInt32 timestamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, copy) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, copy) NSString *sign;

@end

NS_ASSUME_NONNULL_END
