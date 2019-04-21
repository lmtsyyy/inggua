//
//  HttpRequestTool.m
//  DeepEyeAPP
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "HttpRequestTool.h"
#import <AFNetworking/AFNetworking.h>
@implementation HttpRequestTool

+(instancetype)shareInstance {
    static HttpRequestTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance) {
            instance = [[HttpRequestTool alloc] init];
        }
    });
    return instance;
}

-(void)GET:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [LMCommonTool show];
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LMCommonTool dismiss];
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LMCommonTool dismiss];
        NSLog(@"error = %@",error);
        failure(error);
    }];
}

-(void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure {
    
    [self POST:urlStr parameters:parameters success:success failure:failure contentType:@"application/json" isNeedAuthorization:YES isNeedHud:YES];
    
}


-(void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure contentType:(NSString *)contentType isNeedAuthorization:(BOOL)isNeedAuthorization isNeedHud:(BOOL)isNeedHud {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [manager.requestSerializer setTimeoutInterval:10];
    
//    if(isNeedAuthorization) {
//        [manager.requestSerializer setValue:K_GetUserDefaultsForKey(k_Token) forHTTPHeaderField:@"Authorization"];
//    }
    
    if(isNeedHud) {
        [LMCommonTool show];
    }
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LMCommonTool dismiss];
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LMCommonTool dismiss];
        NSLog(@"error = %@",error);
        failure(error);
    }];
    
}

-(void)POSTNeedHud:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure {
    
    [self POST:urlStr parameters:parameters success:success failure:failure contentType:@"application/json" isNeedAuthorization:YES isNeedHud:YES];
    
}


- (void)loginPOST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure {
    
//    [self POST:urlStr parameters:parameters success:success failure:failure contentType:@"application/x-www-form-urlencoded" isNeedAuthorization:NO];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager.requestSerializer setTimeoutInterval:10];
    
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)POST:(NSString *)url parameter:(NSDictionary *)parameter data:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/octet-stream"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
//    [manager.requestSerializer setValue:K_GetUserDefaultsForKey(k_Token) forHTTPHeaderField:@"Authorization"];
    
    [LMCommonTool show];
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LMCommonTool dismiss];
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LMCommonTool dismiss];
        failure(error);
    }];
    
    
    
    
}

@end
