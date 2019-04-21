//
//  LMCommonTool.h
//  glsh_Sale
//
//  Created by Min on 2017/9/7.
//
//

#import <Foundation/Foundation.h>

@interface LMCommonTool : NSObject

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (BOOL)isNewestVersion;

+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;
+ (NSString *)getCuccentDate;
//+ (void)showTips:(NSString *)tips;

+(void)gradualWithView:(UIView *)view startColorHexStr:(NSString *)hex1  endColorHexStr:(NSString *)hex2;
+(void)gradualAndClipCornerWithView:(UIView *)view startColorHexStr:(NSString *)hex1  endColorHexStr:(NSString *)hex2;
+(NSData *)compressImage:(UIImage *)image below_number_kb:(NSInteger)below_number_kb;
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+(NSData*)compressImageQuality:(UIImage*)image toByte:(NSInteger)maxLength;
+(void)gotoMainController;
+(void)gotoLoginController;
+ (void)alertKickWithVC:(UIViewController *)vc;

+(NSString *)appVersion;
+(NSString *)appBuildVersion;

+(void)show;
+(void)dismiss;
+(void)showInfoWithStatus:(NSString *)status;
+(void)showSuccessWithStatus:(NSString *)status;
+(void)showErrorWithStatus:(NSString *)status;

+(void)callPhoneWithTel:(NSString *)tel;

+ (void)showAlert:(NSString *)message toVC:(UIViewController *)toVC;
+ (void)showAlert:(NSString *)message toVC:(UIViewController *)toVC handler:(void(^)(UIAlertAction * _Nonnull action))handler;

+ (UIImage *)rotateUIImage:(UIImage *)image orient:(UIImageOrientation)orient;

+ (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;

+ (NSData *)compressWithImage:(UIImage *)image maxLength:(NSUInteger)maxLength;

//时间处理
//年月日
+ (NSString *)yyyymmddWithTimeStr:(NSString *)timeStr;
//年月日+时分秒
+ (NSString *)yyyymmdd_hhmmssWithTimeStr:(NSString *)timeStr;
//月日+时分
+ (NSString *)mmdd_hhmmWithTimeStr:(NSString *)timeStr;
////处理点位状态
+ (void)handlePlStatusWithPlStatus:(NSString *)plStatus 
                        titleLabel:(id)titleLabel;

+ (void)keyboardAddCustomInputAccessoryViewWithtextField:(UITextField *)textField 
                                                  target:(id)target 
                                                  action:(SEL)action;

+ (NSString *)plistFileNameWithPlistFileName:(NSString *)fileName;
+ (UIFont *)mediumFontWithSize:(CGFloat)size;
+ (void)inputAccessoryViewWithTextField:(UITextField *)textField target:(id)target action:(SEL)action;
+ (NSString *)getSixBitRandomNumber;
@end
