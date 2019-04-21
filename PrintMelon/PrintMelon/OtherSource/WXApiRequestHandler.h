//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"

@interface WXApiRequestHandler : NSObject

+ (BOOL)addCardsToCardPackage:(NSArray *)cardIds cardExts:(NSArray *)cardExts;

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController;

+ (BOOL)openProfileWithAppID:(NSString *)appID
                 Description:(NSString *)description
                    UserName:(NSString *)userName
                      ExtMsg:(NSString *)extMessage;

+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
                      Description:(NSString *)description
                        tousrname:(NSString *)tousrname
                           ExtMsg:(NSString *)extMsg;

+ (BOOL)chooseCard:(NSString *)appid
          cardSign:(NSString *)cardSign
          nonceStr:(NSString *)nonceStr
          signType:(NSString *)signType
         timestamp:(UInt32)timestamp;

+ (BOOL)openUrl:(NSString *)url;

+ (BOOL)chooseInvoice:(NSString *)appid
             cardSign:(NSString *)cardSign
             nonceStr:(NSString *)nonceStr
             signType:(NSString *)signType
            timestamp:(UInt32)timestamp;
@end
