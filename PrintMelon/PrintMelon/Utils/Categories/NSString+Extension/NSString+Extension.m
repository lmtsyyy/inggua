//
//  NSString+Extension.m
//  FCLBaseDemo
//
//  Created by fcl on 16/7/26.
//  Copyright © 2016年 付程隆. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark ==========计算文本的高度和宽度==========
- (CGSize)textSizeWithFont:(CGFloat)aFont constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    UIFont *font = [UIFont systemFontOfSize:aFont];
    if (self.length == 0) {
        return CGSizeMake(0, 0);
    }
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    return textSize;
}

#pragma mark ==========比较大小==========
- (BOOL)decimalNumComparewithSecondStr:(NSString *)secondStr
{
    NSDecimalNumber *firstDecimalNum = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *secondDecimalNum = [NSDecimalNumber decimalNumberWithString:secondStr];
    NSDecimalNumber *subtractDecimalNum = [firstDecimalNum decimalNumberBySubtracting:secondDecimalNum];
    if ([subtractDecimalNum doubleValue]>=0) {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

#pragma mark ==========日期转化==========
//将时间戳转化为短日期
- (NSString *)changeTimestampToShortDate:(NSString *)sourceDate
{
    //获取时间戳
    NSString *str=[NSString stringWithFormat:@"%@", sourceDate];//时间戳
    // 用的毫秒 所以要减3个0
    str = [str substringToIndex:str.length - 3];
    
    //转化为NSDate类型
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //设置时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *lasetDateString = [dateFormatter stringFromDate:detailDate];
    return lasetDateString;
}

//将时间戳转化为长日期
- (NSString *)changeTimestampToLongDate:(NSString *)sourceDate
{
    NSString *str=[NSString stringWithFormat:@"%@", sourceDate];//时间戳
    // 用的毫秒 所以要减3个0
    str = [str substringToIndex:str.length - 3];
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:detaildate];
    return strDate;
}
//时间差
- (NSString *)diffTimestampToShortDate:(NSString *)sourceDate
{
    //获取时间戳
    //NSString *dateString = [NSString stringWithFormat:@"%ld",[sourceDate integerValue]];
    //转化为NSDate类型
    NSTimeInterval time = [sourceDate doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    //设置时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *lasetDateString = [dateFormatter stringFromDate:detailDate];
    return lasetDateString;
    
}

//获取Mac地址后4位
+ (NSString *)lastFourMacLetterWithStr:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (str.length > 4) {
        str = [str substringFromIndex:str.length-4];
    }
    return str;
}



/*
 - (void)textHeight
 {
 UILabel *textLabel = [[UILabel alloc]init];
 textLabel.frame = CGRectMake(10, 100, 375-20, 200);
 textLabel.numberOfLines = 0;
 textLabel.font = [UIFont systemFontOfSize:15];
 textLabel.backgroundColor = [UIColor orangeColor];
 [self.view addSubview:textLabel];
 
 NSString *str = @"这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据";
 CGSize strSize = [str textSizeWithFont:15 constrainedToSize:CGSizeMake(375-20, 1000) lineBreakMode:NSLineBreakByWordWrapping];
 textLabel.height = strSize.height;
 textLabel.width = strSize.width;
 textLabel.x = (375-strSize.width)/2;
 textLabel.text = str;
 
 }

 
 */


+ (NSString *)md5To32bit:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i =0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x",digest[i]];
    }
    return result;
}

+(NSString *)stringToMD5:(NSString *)inputStr{
    const char *cStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return [resultStr lowercaseString];
}


@end
