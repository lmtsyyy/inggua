//
//  PaymentMethodViewController.m
//  PrintMelon
//
//  Created by andy on 2019/3/17.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "PaymentSuccessViewController.h"
#import "OrderCenterModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "PayInfoModel.h"

@interface PaymentMethodViewController ()<WXApiManagerDelegate>

@property (nonatomic ,assign) BOOL isWechatPay;//微信支付
@property (weak, nonatomic) IBOutlet UIImageView *wechatSelectedIconImageV;
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoSelectedIconImageV;
@property (weak, nonatomic) IBOutlet UILabel *zhangshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhizhangLabel;
@property (weak, nonatomic) IBOutlet UILabel *danshuangmianLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *layoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *packfreeLabel;
@end

@implementation PaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"选择支付方式")
    _isWechatPay = YES;//默认选择微信支付
    [WXApiManager sharedManager].delegate = self;
    self.orderIdLabel.text = self.orderCenter.orderId;
//    [self setValueWithModel:self.orderCenter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult) name:LMPayResultNotification object:nil];
    
    [self sendSelectPaymentRequest];
}

- (void)payResult {
    if(self.isWechatPay) {
        
    }else {
        
    }
    [self pushPaySuccessVC];
}

- (void)pushPaySuccessVC {
    PaymentSuccessViewController *vc = [PaymentSuccessViewController lm_VC];
    vc.orderCenter = self.orderCenter;
    [self lm_pushVCWithVC:vc];
}


- (IBAction)selectedwechatPay:(id)sender {
    _isWechatPay = YES;
    self.wechatSelectedIconImageV.image = [UIImage imageNamed:@"print_select_icon"];
    self.zhifubaoSelectedIconImageV.image = [UIImage imageNamed:@"print_unselect_icon"];
}

- (IBAction)selectedZhifubaoPay:(id)sender {
    _isWechatPay = NO;
    self.wechatSelectedIconImageV.image = [UIImage imageNamed:@"print_unselect_icon"];
    self.zhifubaoSelectedIconImageV.image = [UIImage imageNamed:@"print_select_icon"];
}

- (IBAction)goPay:(id)sender {
    if(_isWechatPay) {//微信支付
        NSLog(@"微信支付");
//        PaymentSuccessViewController *vc = [PaymentSuccessViewController lm_VC];
//        [self lm_pushVCWithVC:vc];
    }else {//支付宝支付
        NSLog(@"支付宝支付");
    }
    [self sendPaymentRequest];
}

- (void)sendSelectPaymentRequest {
    NSString *orderId = @"";
    if(self.orderIdSourecType == LM_ORDER_ID_SOURCE_GOOD) {
        orderId = self.orderCenter.orderId;
    }else if (self.orderIdSourecType == LM_ORDER_ID_SOURCE_ORDER_LIST) {
        orderId = self.orderCenter.ID;
    }
    NSDictionary *params = @{@"oid" : orderId};
    [[HttpRequestTool shareInstance] GET:K_URL(payMethod_URL) parameters:params success:^(id responseObject) {
       
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            NSDictionary *orderDic = responseObject[@"order"];
            OrderCenterModel *goodInfo = [OrderCenterModel mj_objectWithKeyValues:orderDic];
            [self setValueWithModel:goodInfo];
        }else {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
    
}

- (void)setValueWithModel:(OrderCenterModel *)model {
    self.zhangshuLabel.text = model.page;
    self.zhizhangLabel.text = model.size;
    self.danshuangmianLabel.text = model.issingle;
    self.colorLabel.text = model.color;
    self.layoutLabel.text = model.layout;
    self.fenshuLabel.text = model.number;
    self.bindLabel.text = model.binding;
    self.packfreeLabel.text = model.packfree;
    self.totalPriceLabel.text = model.money;
    
}

- (void)sendPaymentRequest {
    NSString *paymode = @"1";
    if(_isWechatPay) {
        paymode = @"1";
    }else {
        paymode = @"2";
    }
    NSDictionary *params = @{@"oid" : self.orderCenter.orderId ? self.orderCenter.orderId : @"",
                             @"paymode" : paymode
                             };
    [LMCommonTool show];
    __weak typeof(self) weakSelf = self;
    [[HttpRequestTool shareInstance] POST:K_URL(payment_URL) parameters:params success:^(id responseObject) {
        [LMCommonTool dismiss];
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            if(weakSelf.isWechatPay) {
                NSDictionary *dataDic = [LMCommonTool dictionaryWithJsonString:responseObject[@"data"]];
                PayInfoModel *payInfo = [PayInfoModel mj_objectWithKeyValues:dataDic];
                [[WXApiManager sharedManager] wxPayWithInfo:payInfo];
            }else {
                NSString *orderString = responseObject[@"data"];
                [self invokeZfbPayWithOrderString:orderString];
            }
            
        }else {
            
        }
        
    } failure:^(NSError *error) {
        [LMCommonTool dismiss];
        NSLog(@"error = %@",error.localizedFailureReason);
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)invokeZfbPayWithOrderString:(NSString *)orderString {
    //    NSString *payMoney = nil;
    //    if(_isSelectedSeniorMember) {
    //        payMoney = self.seniorMemberLabel.text;
    //    }else {
    //        payMoney = self.goldMemberLabel.text;
    //    }
    // NOTE: 如果加签成功，则继续执行支付
    if (![NSString isBlankString:orderString]) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"com.inggua.printmelon";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        //                NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
        //                                         orderInfoEncoded, signedString];
        //        orderString = @"biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%220628172148-1731%22%7D&method=alipay.trade.app.pay&charset=utf-8&version=1.0&notify_url=http%3A%2F%2Fkktdev.spider-iot.com%2Falipay%2Fcallback&app_id=2018060660314759&timestamp=2016-07-29+16%3A55%3A53&sign_type=RSA2&sign=Q%2Bq%2B3P6kAeQlsHAPbpWTLfdwSZagIHmo7ZTX6BLrsXdVBKXwSDvpIjrvJmQgnWlua83BdKQWRvZX7hbP29eQQp0T94%2FP9b%2F8REb835JItGPFXBOsnaYfzjz16s1tmDS58rXegUIycJ%2BRdPFtehcpo13O%2FGovZAQvlsqsyMRiyWB2XaJTggwp%2BpF8Q%2F%2BFtmg9zI4n%2BQwJe7JbbKr%2BEbcI098%2FpnLddQFVCaOdKQzEqDfh%2B4weOFAa2kuontM0RcaapjQF5HaA3grShF%2BnykPp%2FAPBx4yhsYDDRgntPOZFtUhJyp9XPVRKYr6183SYgK42fA1GfWNJOxBsvVoFqgGAmw%3D%3D";
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
//            [self cancel];
        }];
    }
}

#pragma mark-WXApiManagerDelegate
- (void)managerDidRecvPaymentResponse:(PayResp *)response {
    switch(response.errCode){
        case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            NSLog(@"支付成功");
            [self pushPaySuccessVC];
            break;
        case WXErrCodeUserCancel:
            NSLog(@"用户取消支付");
            break;
        default:
            NSLog(@"支付失败，retcode=%d",response.errCode);
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
