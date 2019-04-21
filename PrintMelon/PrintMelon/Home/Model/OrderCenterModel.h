//
//  OrderCenterModel.h
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderCenterModel : NSObject

@property (nonatomic, copy) NSString *ID;//商品id
@property (nonatomic, copy) NSString *orderId;//订单id
@property (nonatomic, copy) NSString *ordernum;//订单号
@property (nonatomic, copy) NSString *page;//打印张数
@property (nonatomic, copy) NSString *size;//纸张规格
@property (nonatomic, copy) NSString *issingle;//单双页
@property (nonatomic, copy) NSString *color;//颜色
@property (nonatomic, copy) NSString *layout;//布局
@property (nonatomic, copy) NSString *number;//份数
@property (nonatomic, copy) NSString *binding;//装订
@property (nonatomic, copy) NSString *packfree;//包装费
@property (nonatomic, copy) NSString *price;//金额
@property (nonatomic, copy) NSString *total;//总金额
@property (nonatomic, copy) NSString *status;//订单状态
@property (nonatomic, copy) NSString *money;//实付款

@property (nonatomic, copy) NSString *totalPackfree;//实付款
@property (nonatomic, copy) NSString *orderTotalPrice;//实付款



@property (nonatomic, copy) NSString *docIDs;//文档ids，1，2，3
//@property (nonatomic, copy) NSString *apptime;//预约时间
@property (nonatomic, copy) NSString *gid;//商品id



@property (nonatomic, copy) NSString *receiptName;//收货人
@property (nonatomic, copy) NSString *receiptPhone;//收货手机号
@property (nonatomic, copy) NSString *receiptAddress;//收货地址
@property (nonatomic, copy) NSString *discountMoney;//优惠金额
@property (nonatomic, copy) NSString *needDiscountMoney;//需要优惠的金额

@property (nonatomic, strong) AddressInfoModel *addressInfo;


@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
