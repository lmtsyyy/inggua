//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "PayInfoModel.h"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response;

- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response;

- (void)managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)response;

- (void)managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)response;

- (void)managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *)response;

- (void)managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *)response;

- (void)managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *)response;

- (void)managerDidRecvPaymentResponse:(PayResp *)response;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)wxPayWithInfo:(PayInfoModel *)payInfo;

@end