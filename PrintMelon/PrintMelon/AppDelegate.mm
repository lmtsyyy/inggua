//
//  AppDelegate.m
//  PrintMelon
//
//  Created by admin on 2019/3/4.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#define kBOUNDARY @"WebKitFormBoundaryJa8BALfIc9saou2X"
@interface AppDelegate ()

@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[LoginViewController alloc] init];
//     [LMCommonTool gotoMainController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self aaaWithArr:nil];
    });
//    [self aaaWithArr:nil];
    [self wxRegisterApp];
    [self baiduMapSetup];

    return YES;
}
     
- (void)wxRegisterApp {
 //向微信注册
 [WXApi registerApp:WX_APP_ID enableMTA:YES];
}

- (void)baiduMapSetup {
    
    //要使用百度地图，请先启动BMKMapManager
    _mapManager = [[BMKMapManager alloc] init];
    /**
     百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        MYLog(@"经纬度类型设置成功");
    } else {
        MYLog(@"经纬度类型设置失败");
    }
    
    //启动引擎并设置AK并设置delegate
    BOOL result = [_mapManager start:@"kImd8g11zFgljRhKYNfKAzebVjk95b5q" generalDelegate:nil];
    if (!result) {
        MYLog(@"启动引擎失败");
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if([resultDic[@"resultStatus"] integerValue] == 9000) {
                NSDictionary *payInfoDic = [LMCommonTool dictionaryWithJsonString:resultDic[@"result"]];
                NSDictionary *tradeDic = payInfoDic[@"alipay_trade_app_pay_response"];
                if([tradeDic[@"msg"] isEqualToString:@"Success"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LMPayResultNotification object:nil];
                }
            }
        }];
        return YES;
    }else if ([url.host isEqualToString:@"pay"] || [url.absoluteString containsString:@"oauth"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else {
        if (url != nil && [url isFileURL]) { //上传doc、pdf、ppt等文件
            NSString *fileUrlStr = url.path;
            NSArray *inboxArr = [fileUrlStr componentsSeparatedByString:@"Inbox"];
            NSString *fileName = [inboxArr lastObject];
            if([fileName containsString:@"/"]) {
                fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
            }
            NSData *fileData = [NSData dataWithContentsOfURL:url];
            NSDictionary *params = @{@"uid" : [AppEntity shareInstance].userid,
                                     @"ufile[]" : @[fileUrlStr]
                                     };
            NSString *mimeType = @"";
            if([fileName containsString:@"doc"]) {
                mimeType = @"application/msword";
            }else if ([fileName containsString:@"pdf"]) {
                mimeType = @"application/pdf";
            }else if ([fileName containsString:@"ppt"]) {
//                mimeType = @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
                mimeType = @"application/vnd.ms-powerpoint";
            }
            
            [[HttpRequestTool shareInstance] POST:K_URL(uploadFile_URL) parameter:params data:fileData name:@"ufile[]" fileName:fileName mimeType:mimeType success:^(id responseObject) {
                [LMCommonTool showSuccessWithStatus:responseObject[@"msg"]];
            } failure:^(NSError *error) {

            }];
            
//            [self aaaWithArr:@[fileUrlStr]];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


- (void)aaaWithArr:(NSArray *)arr {
    // 网络链接
    NSString *netUrl = @"http://www.inggua.com/home/user/uploadfile";
    
    // 文件路径
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"准备起航，APP服务器搭建.pptx" ofType:nil];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"head2.png" ofType:nil];
    NSArray *array = @[path1];
    
    // 字段名
    NSString *fieldName = @"ufile[]";
    // 数据字典
    NSDictionary *dict = @{@"uid":[AppEntity shareInstance].userid};
    // 上传文件
    [self uploadFiles:netUrl fieldName:fieldName filePaths:array params:dict];
}

// 上传多个文件
// netUrl 网络链接
// fieldName 字段名
// filePaths 文件路径数组
// params 参数字典
- (void)uploadFiles:(NSString *)netUrl fieldName:(NSString *)fieldName filePaths:(NSArray *)filePaths params:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:netUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    // Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryJa8BALfIc9saou2X
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBOUNDARY] forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self body:fieldName filePaths:filePaths params:params];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         if (connectionError) {
             NSLog(@"连接错误 %@", connectionError);
             return;
         }
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
             // 解析数据
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dict[@"msg"]);
         } else {
             NSLog(@"服务器内部错误");
         }
     }];
}

// 构建请求体
- (NSData *)body:(NSString *)fieldName filePaths:(NSArray *)filePaths params:(NSDictionary *)params {
    NSMutableData *mData = [NSMutableData data];
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X
    //    Content-Disposition: form-data; name="userfile[]"; filename="head1.png"
    //    Content-Type: image/png
    //
    //    文件二进制数据
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X
    //    Content-Disposition: form-data; name="userfile[]"; filename="head2.png"
    //    Content-Type: image/png
    //
    //    文件二进制数据
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X
    //    Content-Disposition: form-data; name="username"
    //
    //    mazaiting
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X--
    
    // 构建文件,遍历数组
    [filePaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //              ------WebKitFormBoundaryJa8BALfIc9saou2X
        //            Content-Disposition: form-data; name="userfile[]"; filename="head2.png"
        //            Content-Type: image/png
        //
        //            文件二进制数据
        
        NSMutableString *mString = [NSMutableString string];
        // 判断是否是第一个文件，如果是则不需要添加"\r\n"
        if (idx != 0) {
            [mString appendString:@"\r\n"];
        }
        [mString appendFormat:@"--%@\r\n", kBOUNDARY];
        [mString appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", fieldName, [obj lastPathComponent]];
        [mString appendString:@"Content-Type: application/octet-stream\r\n"];
        [mString appendString:@"\r\n"];
        [mData appendData:[mString dataUsingEncoding:NSUTF8StringEncoding]];
        // 拼接文件的二进制数据
        NSData *data = [NSData dataWithContentsOfFile:obj];
        [mData appendData:data];
    }];
    
    // 构建数据
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X
    //    Content-Disposition: form-data; name="username"
    //
    //    mazaiting
    //    ------WebKitFormBoundaryJa8BALfIc9saou2X--
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableString *mString = [NSMutableString string];
        [mString appendFormat:@"\r\n--%@\r\n", kBOUNDARY];
        [mString appendFormat:@"Content-Disposition: form-data; name=%@\r\n", key];
        [mString appendString:@"\r\n"];
        [mString appendFormat:@"%@", obj];
        [mData appendData:[mString dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 结束语句
    NSString *end = [NSString stringWithFormat:@"\r\n--%@--", kBOUNDARY];
    [mData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    return mData.copy;
}

    

@end
