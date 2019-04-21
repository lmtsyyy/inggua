//
//  HttpRequestTool.h
//  DeepEyeAPP
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(id responseObject);
typedef void(^Failure)(NSError *error);
@interface HttpRequestTool : NSObject

//@property (nonatomic, copy) Success success;
//@property (nonatomic, copy) Failure failure;

+(instancetype)shareInstance;

-(void)GET:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
-(void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
-(void)POSTNeedHud:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;
- (void)loginPOST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure;

- (void)POST:(NSString *)url parameter:(NSDictionary *)parameter data:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
