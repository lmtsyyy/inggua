//
//  LMCommonTool.m
//  glsh_Sale
//
//  Created by Min on 2017/9/7.
//
//

#import "LMCommonTool.h"
#import "JMTabBarController.h"
//#import "LoginNavigationController.h"
#import "LoginViewController.h"
//#import <SVProgressHUD.h>

@implementation LMCommonTool

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
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


+ (BOOL)isNewestVersion {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersionStr = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    currentVersionStr = @"6.0.1";
    NSArray *currentVersionSeparatArr = [currentVersionStr componentsSeparatedByString:@"."];
    
    
    NSInteger currentVersion = [self currentVersion:currentVersionSeparatArr];
    //    currentVersion = 6000000;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"lVersion"]) {
        [defaults setObject:currentVersionStr forKey:@"lVersion"];
        [defaults synchronize];
    }
    
    NSString *lVersion = [defaults objectForKey:@"lVersion"];
    NSArray *lVSeparatArr = [lVersion componentsSeparatedByString:@"."];
    NSInteger lVer = [self currentVersion:lVSeparatArr];
    if(lVer < currentVersion) {
        [defaults setObject:currentVersionStr forKey:@"lVersion"];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

+ (NSInteger)currentVersion:(NSArray *)array {
    
    /**
     
     参考：如版本号6.2.1
     （6.2.1）=1*100+2*10000+6*1000000=6020100
     
     */
    
    NSInteger first = [[array firstObject] integerValue];
    NSInteger middle = [array[1] integerValue];
    NSInteger last = [[array lastObject] integerValue];
    
    first *= 1000000;
    middle *= 10000;
    last *= 100;
    
    return first + middle + last;
    
    
}


//比较两个日期的大小  日期格式为2016-08-14 08：46：20
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等  aa=0
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        //        aa=-1
        aa=-1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        //        aa=1
        aa=1;
    }
    
    return aa;
}

+ (NSString *)getCuccentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr =  [formatter stringFromDate:date];
    return dateStr;
}

+ (void)showTips:(NSString *)tips {
    
    UIView *promptView = [[[NSBundle mainBundle] loadNibNamed:@"PromptView" owner:nil options:nil] firstObject];
    UILabel *tipsLabel = (UILabel *)[promptView viewWithTag:101];
    tipsLabel.text = tips;
    CGRect frame = promptView.frame;
    frame.size.width = CGRectGetWidth(tipsLabel.frame) + 40;
    frame.size.height = CGRectGetHeight(tipsLabel.frame) + 10;
    frame.origin.x = (kScreenWidth - CGRectGetWidth(tipsLabel.frame) - 40) * 0.5;
    frame.origin.y = (kScreenHeight - CGRectGetHeight(tipsLabel.frame) - 10) * 0.5; // 居中
    frame.origin.y = kScreenHeight - 100;
    promptView.frame = frame;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:promptView];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [promptView removeFromSuperview];
    });
}

+(void)gradualWithView:(UIView *)view startColorHexStr:(NSString *)hex1  endColorHexStr:(NSString *)hex2 {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(view.frame));  // 设置显示的frame
    gradientLayer.colors = @[(id)[UIColor colorWithHexString:hex1].CGColor,(id)[UIColor colorWithHexString:hex2].CGColor];  // 设置渐变颜色
    gradientLayer.locations = @[@0.0, @1.0];    // 颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0);   //
    gradientLayer.endPoint = CGPointMake(0, 1);     //
    [view.layer addSublayer:gradientLayer];
}

+(void)gradualAndClipCornerWithView:(UIView *)view startColorHexStr:(NSString *)hex1  endColorHexStr:(NSString *)hex2 {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.cornerRadius = CGRectGetHeight(view.frame) * 0.5;
    gradientLayer.frame = view.bounds;  // 设置显示的frame
    gradientLayer.colors = @[(id)[UIColor colorWithHexString:hex1].CGColor,(id)[UIColor colorWithHexString:hex2].CGColor];  // 设置渐变颜色
    gradientLayer.locations = @[@0.0, @0.5];    // 颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0);   //
    gradientLayer.endPoint = CGPointMake(1, 0);     //
    [view.layer addSublayer:gradientLayer];
}

+ (void)gotoMainController {
    JMConfig *config = [JMConfig config];
    config.imageSize = CGSizeMake(24, 24);
    config.imageOffset = 6;
    config.selTitleColor = [UIColor colorWithHexString:@"FD7C13"];
    config.isClearTabBarTopLine = NO;
    config.tabBarTopLineColor = [UIColor colorWithHexString:@"F0F0F0"];
    config.isNeedCustomBtn = NO;
//    if(roleId.integerValue == 2 || roleId.integerValue == 3) {
//        config.isNeedCustomBtn = YES;
//    }
    JMTabBarController *tabBarVc = [[JMTabBarController alloc] initWithConfig:config];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    //    });
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
}

+ (void)gotoLoginController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

//压缩图片到100以内
+(NSData *)compressImage:(UIImage *)image below_number_kb:(NSInteger)below_number_kb {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0); //不改变图片大小，只改变图片质量

    while (imageData.length > below_number_kb * 1024) {
        image = [self scaleImage:image toScale:0.5];
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    NSLog(@"压缩后的图片大小:%.0fkb",imageData.length / 1024.0);
    return imageData;
}


+(NSData*)compressImageQuality:(UIImage*)image toByte:(NSInteger)maxLength {
    
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    UIImage *newImage = image;
    
    while(data.length > maxLength*1024 && compression > 0) {
        
        if(data.length > 1024*1024*10) {
            compression -= 0.5;
        }else if(data.length > 1024*1024*5) {
            compression -= 0.4;
        }else if(data.length > 1024*1024*3) {
            compression -= 0.3;
        }else if(data.length>1024*1024) {
            compression -= 0.25;
        }else if(data.length> maxLength) {
            compression -= 0.1;
        }
        compression -= 0.01;
        data = UIImageJPEGRepresentation(newImage, compression);
        newImage = [UIImage imageWithData:data];
    }
    NSLog(@"压缩后的图片大小:%.0fkb",data.length / 1024.0);
    return data;
}

+(NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *)appBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


//按比例压缩图片的大小
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(void)show {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD show];
}

+(void)dismiss {
    [SVProgressHUD dismiss];
}

+(void)showInfoWithStatus:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, SafeAreaTopHeight)];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD showInfoWithStatus:status];
    [SVProgressHUD dismissWithDelay:1.5];
}

+(void)showSuccessWithStatus:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:1.5];
}

+(void)showErrorWithStatus:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD dismissWithDelay:1.5];
}

+(void)callPhoneWithTel:(NSString *)tel {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

+ (void)showAlert:(NSString *)message toVC:(UIViewController *)toVC {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [toVC presentViewController:alertVC animated:YES completion:nil];
}

+ (void)showAlert:(NSString *)message toVC:(UIViewController *)toVC handler:(void(^)(UIAlertAction * _Nonnull action))handler {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(handler) {
            handler(action);
        }
    }];
    [alertVC addAction:action];
    [toVC presentViewController:alertVC animated:YES completion:nil];
}

+ (UIImage *)rotateUIImage:(UIImage *)image orient:(UIImageOrientation)orient {
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = image.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            // would get you an exact copy of the original
            assert(false);
            return nil;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

static CGRect swapWidthAndHeight(CGRect rect) {
    CGFloat swap = rect.size.width;
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    return rect;
}


+ (NSData *)compressWithImage:(UIImage *)image maxLength:(NSUInteger)maxLength {
    // Compress by quality
    
    NSUInteger length = maxLength * 1024;
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < length) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < length * 0.9) {
            min = compression;
        } else if (data.length > length) {
            max = compression;
        } else {
            break;
        }
    }
    NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < length) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > length && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)length / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

+ (void)alertKickWithVC:(UIViewController *)vc {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已被踢下线，是否重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutNotifacation" object:nil];
        [LMCommonTool gotoLoginController];
        K_UserDefaults(k_Token, @"");
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
}

+ (NSString *)yyyymmddWithTimeStr:(NSString *)timeStr {
    if([timeStr containsString:@"T"]) {
        NSArray *componentArr = [timeStr componentsSeparatedByString:@"T"];
        NSString *time = [componentArr firstObject];
        return time;
    }else {
        NSArray *componentArr = [timeStr componentsSeparatedByString:@" "];
        NSString *time = [componentArr firstObject];
        return time;
    }
}

+ (NSString *)yyyymmdd_hhmmssWithTimeStr:(NSString *)timeStr {
    if([timeStr containsString:@"T"]) {
        NSArray *componentTArr = [timeStr componentsSeparatedByString:@"T"];
        NSString *yyyymmdd = [componentTArr firstObject];
        NSString *otherTime = [componentTArr lastObject];
        if([otherTime containsString:@"."]) {
            NSArray *componentDotArr = [otherTime componentsSeparatedByString:@"."];
            NSString *hhmmss = [componentDotArr firstObject];
            return [NSString stringWithFormat:@"%@ %@",yyyymmdd,hhmmss];
        }
        return yyyymmdd;
    }
    return timeStr;
}

+ (NSString *)mmdd_hhmmWithTimeStr:(NSString *)timeStr {
    if([timeStr containsString:@"T"]) {
        NSArray *componentTArr = [timeStr componentsSeparatedByString:@"T"];
        NSString *yyyymmdd = [componentTArr firstObject];
        NSArray *componentLineArr = [yyyymmdd componentsSeparatedByString:@"-"];
        NSString *mmdd = @"";
        if(componentLineArr.count == 3) {
            mmdd = [NSString stringWithFormat:@"%@-%@",componentLineArr[1],componentLineArr
                              [2]];
        }
        
        NSString *hhmm = @"";
        NSString *otherTime = [componentTArr lastObject];
        if([otherTime containsString:@"."]) {
            NSArray *componentDotArr = [otherTime componentsSeparatedByString:@"."];
            NSString *hhmmss = [componentDotArr firstObject];
            NSArray *componentColonArr = [hhmmss componentsSeparatedByString:@":"];
            
            if(componentColonArr.count == 3) {
                hhmm = [NSString stringWithFormat:@"%@:%@",componentColonArr[0],componentColonArr[1]];
            }
        }
        return [NSString stringWithFormat:@"%@ %@",mmdd,hhmm];
    }else {
        NSArray *componentTArr = [timeStr componentsSeparatedByString:@" "];
        NSString *yyyymmdd = [componentTArr firstObject];
        NSArray *componentLineArr = [yyyymmdd componentsSeparatedByString:@"-"];
        NSString *mmdd = @"";
        if(componentLineArr.count == 3) {
            mmdd = [NSString stringWithFormat:@"%@-%@",componentLineArr[1],componentLineArr
                    [2]];
        }
        NSString *hhmm = @"";
        NSString *otherTime = [componentTArr lastObject];
        NSArray *componentColonArr = [otherTime componentsSeparatedByString:@":"];
        
        if(componentColonArr.count == 3) {
            hhmm = [NSString stringWithFormat:@"%@:%@",componentColonArr[0],componentColonArr[1]];
        }
        return [NSString stringWithFormat:@"%@ %@",mmdd,hhmm];
    }
}

//处理点位状态
+ (void)handlePlStatusWithPlStatus:(NSString *)plStatus 
                        titleLabel:(id)titleLabel {
    
    if([titleLabel isKindOfClass:[UILabel class]]) {
        UILabel *textLabel = (UILabel *)titleLabel;
        if(plStatus.integerValue == 1 || plStatus.integerValue == 5) {
            textLabel.textColor = K_Theme_Color;
            textLabel.text = @"勘测";
        }else if (plStatus.integerValue == 2) {
            textLabel.textColor = K_Work_Color;
            textLabel.text = @"施工";
        }else if (plStatus.integerValue == 3) {
            textLabel.textColor = K_Complete_Color;
            textLabel.text = @"完工";
        }else if (plStatus.integerValue == 4) {
            textLabel.textColor = K_Discard_Color;
            textLabel.text = @"丢弃";
        }
    }else if ([titleLabel isKindOfClass:[UITextField class]]) {
        UITextField *textLabel = (UITextField *)titleLabel;
        if(plStatus.integerValue == 1 || plStatus.integerValue == 5) {
            textLabel.textColor = K_Theme_Color;
            textLabel.text = @"勘测";
        }else if (plStatus.integerValue == 2) {
            textLabel.textColor = K_Work_Color;
            textLabel.text = @"施工";
        }else if (plStatus.integerValue == 3) {
            textLabel.textColor = K_Complete_Color;
            textLabel.text = @"完工";
        }else if (plStatus.integerValue == 4) {
            textLabel.textColor = K_Discard_Color;
            textLabel.text = @"丢弃";
        }
    }
    
}

+ (void)keyboardAddCustomInputAccessoryViewWithtextField:(UITextField *)textField 
                                                  target:(id)target 
                                                  action:(SEL)action {
    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:target action:action];
    NSArray *buttonArray = [NSArray arrayWithObjects:spaceBtn,doneBtn, nil];
    [topView setItems:buttonArray];
    [textField setInputAccessoryView:topView];
}

+ (NSString *)plistFileNameWithPlistFileName:(NSString *)fileName {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (UIFont *)mediumFontWithSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

+ (void)inputAccessoryViewWithTextField:(id)textField
                                 target:(id)target
                                 action:(SEL)action {
    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem* spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:target action:action];
    NSArray *buttonArray = [NSArray arrayWithObjects:spaceBtn,doneBtn, nil];
    [topView setItems:buttonArray];
    if([textField isKindOfClass:[UITextField class]]) {
        UITextField *textF = textField;
        [textF setInputAccessoryView:topView];
    }
    if([textField isKindOfClass:[UITextView class]]) {
        UITextView *textV = textField;
        [textV setInputAccessoryView:topView];
    }
    
}

+ (NSString *)getSixBitRandomNumber {
    int a = arc4random() % 100000;
    return [NSString stringWithFormat:@"%06d", a];
}


@end
