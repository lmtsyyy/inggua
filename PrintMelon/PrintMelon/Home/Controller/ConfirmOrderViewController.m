//
//  ConfirmOrderViewController.m
//  PrintMelon
//
//  Created by andy on 2019/3/16.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "PaymentMethodViewController.h"
#import "ZGPickerView.h"
#import "OrderCenterModel.h"
#import "CouponInfoModel.h"
#import "LMPlaceholderTextView.h"

@interface ConfirmOrderViewController ()<ZGPickerViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *receiveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTelePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dispatchTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *printZhangShuLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhiZhangGuiGeLabel;
@property (weak, nonatomic) IBOutlet UILabel *danShuangMianLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *layoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiaojiPriceLabel;
@property (weak, nonatomic) IBOutlet ZGPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerViewBackV;
@property (weak, nonatomic) IBOutlet UIView *pickerSuperView;
@property (nonatomic, strong) NSMutableArray *dateArr;
@property (nonatomic, strong) NSMutableArray *hourArr;

@property (nonatomic, copy) NSString *selectedDayDate;
@property (nonatomic, copy) NSString *selectedHourDate;
@property (nonatomic, assign) BOOL isFirstSelectedDate;
@property (nonatomic, assign) BOOL isTotay;
@property (nonatomic, assign) BOOL needFixedDispatchTime;
//@property (weak, nonatomic) IBOutlet UITextView *leaveNoteTextV;
@property (weak, nonatomic) IBOutlet LMPlaceholderTextView *leaveNoteTextV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hejiMoneyLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backVTopConstraint;

@end

@implementation ConfirmOrderViewController

- (NSMutableArray *)dateArr {
    if(!_dateArr) {
        _dateArr = [NSMutableArray array];
        NSArray *dayDateArr = @[@"今天",@"明天"];
        [_dateArr addObject:dayDateArr];
//        NSArray* hourDateArr = @[@"7:00~8:00",@"11:30~13:00",@"16:30~18:00",@"21:00~22:30"];
        [_dateArr addObject:self.hourArr];
    }
    return _dateArr;
}

- (NSMutableArray *)hourArr {
    if(!_hourArr) {
        _hourArr = [NSMutableArray arrayWithObjects:@"7:00~8:00",@"11:30~13:00",@"16:30~18:00",@"21:00~22:30", nil];
    }
    return _hourArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
    [self getCurrentHour];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"确认订单")
    [self setValueWithModel:self.orderCenter];
    self.myPickerView.layer.borderWidth = 0.5;
    self.myPickerView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.myPickerView.layer.cornerRadius = 3.0;
    self.pickerSuperView.layer.cornerRadius = 6.0;
    self.myPickerView.dataArr = self.dateArr;
    self.myPickerView.defaultSelectedRow = /*@[@(2)];//*/@[@(0),@(0)];
    self.myPickerView.selectedBackgroudColor = [UIColor colorWithHexString:@"FCF4AE"];
        //self.myPickerView.selectedTextColor = [UIColor blueColor];
    self.myPickerView.normalTextColor = [UIColor colorWithHexString:@"333333"];
    self.myPickerView.pvDelegate = self;
    [self.myPickerView reloadAllComponents];
    [self selectDefaultDate];
    
    self.leaveNoteTextV.layer.cornerRadius = 5.0;
    self.leaveNoteTextV.layer.borderColor = [UIColor colorWithHexString:@"F7F7F7"].CGColor;
    self.leaveNoteTextV.layer.borderWidth = 0.5;
    self.leaveNoteTextV.layer.masksToBounds = YES;
    
    self.leaveNoteTextV.placeholder = @"请输入留言内容...";
    self.isTotay = YES;
    
    [LMCommonTool inputAccessoryViewWithTextField:self.leaveNoteTextV target:self action:@selector(endEdit)];
}

- (void)endEdit {
    [self.view endEditing:YES];
    self.backVTopConstraint.constant = 0;
}

- (void)selectDefaultDate {
    NSArray *hourDateArr = [self.dateArr lastObject];
    self.selectedDayDate = [self getCurrentTime];
    self.selectedHourDate = [hourDateArr firstObject];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.backVTopConstraint.constant = -280;
    return YES;
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//传入今天的时间，返回明天的时间
- (NSString *)getTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

- (NSInteger)getCurrentHour {
    
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month =  [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    
    NSLog(@"year is: %ld", (long)year);
    NSLog(@"month is: %ld", (long)month);
    NSLog(@"day is: %ld", (long)day);
    NSLog(@" hour is: %ld",  (long)hour);
    NSLog(@"minute  is: %ld", (long)minute );
    NSLog(@"second is: %ld", (long)second);
    //字符串的转化并且拼接
    NSString *yearstr=[NSString stringWithFormat:@"%ld-",(long)year];
    NSString *monthstr=[NSString stringWithFormat:@"%ld-",(long)month];
    NSString *daystr=[NSString stringWithFormat:@"%ld ",(long)day];
    NSString *hourstr=[NSString stringWithFormat:@"%ld:",(long)hour];
    NSString *minutestr=[NSString stringWithFormat:@"%ld:",(long)minute];
    NSString *secondstr=[NSString stringWithFormat:@"%ld",(long)second];
    //字符串开始拼接
    NSString *allstr=[yearstr stringByAppendingString:monthstr];
    NSString *allstr1=[allstr stringByAppendingString:daystr];
    NSString *allstr2=[allstr1 stringByAppendingString:hourstr];
    NSString *allstr3=[allstr2 stringByAppendingString:minutestr];
    NSString *DateTime=[allstr3 stringByAppendingString:secondstr];
    NSLog(@"最后年月日时分秒拼接的结果=====%@",DateTime);
    return hour;
}

- (BOOL)currentTimeGreaterWithTime:(NSString *)time {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时进制都可以完美格式化
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
    today = [dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [dateFormat dateFromString:time];
    //NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (BOOL)currentTimelessThanWithTime:(NSString *)time {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时进制都可以完美格式化
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
    today = [dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [dateFormat dateFromString:time];
    //NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}


- (BOOL)timeEqualWithTime1:(NSString *)time1 time2:(NSString *)time2{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时进制都可以完美格式化
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
    today = [dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [dateFormat dateFromString:time1];
    NSDate *end = [dateFormat dateFromString:time2];
    //NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([start compare:end] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (void)setValueWithModel:(OrderCenterModel *)model {
    if(!model) return;
    self.receiveNameLabel.text = model.addressInfo.consignee;
    self.receiveTelePhoneLabel.text = model.addressInfo.phone;
    self.receiveAddressLabel.text = model.addressInfo.address;
    self.printZhangShuLabel.text = model.page;
    self.zhiZhangGuiGeLabel.text = model.size;
    self.danShuangMianLabel.text = model.issingle;
    self.colorLabel.text = model.color;
    self.layoutLabel.text = model.layout;
    self.fenshuLabel.text = model.number;
    self.bindLabel.text = model.binding;
    self.packagePriceLabel.text = [NSString stringWithFormat:@"%.2f",model.totalPackfree.floatValue];
    self.xiaojiPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.total.floatValue];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.money.floatValue];
    if (self.totalPriceLabel.text.length < 5) {
        self.hejiMoneyLeftConstraint.constant = -20;
    }else if(self.totalPriceLabel.text.length == 5) {
        self.hejiMoneyLeftConstraint.constant = -30;
    }else if (self.totalPriceLabel.text.length == 6) {
        self.hejiMoneyLeftConstraint.constant = -40;
    }else if (self.totalPriceLabel.text.length == 7) {
        self.hejiMoneyLeftConstraint.constant = -50;
    }else if (self.totalPriceLabel.text.length == 8) {
        self.hejiMoneyLeftConstraint.constant = -60;
    }else if (self.totalPriceLabel.text.length == 9) {
        self.hejiMoneyLeftConstraint.constant = -70;
    }else if (self.totalPriceLabel.text.length == 10) {
        self.hejiMoneyLeftConstraint.constant = -80;
    }else {
        self.hejiMoneyLeftConstraint.constant = -100;
    }
    if(self.couponInfo.condition.integerValue == 0 && self.couponInfo.money.integerValue == 0) {
        self.discountLabel.text = @"暂无优惠";
    }else {
        self.discountLabel.text = [NSString stringWithFormat:@"满%@减%@元",self.couponInfo.condition,self.couponInfo.money];
    }
}

- (IBAction)alertPickerView:(id)sender {
    self.pickerViewBackV.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)cancel:(id)sender {
    [self hidePickerView];
    if(self.isFirstSelectedDate) {
        self.dispatchTimeLabel.text = [NSString stringWithFormat:@"%@ %@",self.selectedDayDate,self.selectedHourDate];;
    }else {
        self.dispatchTimeLabel.text = @"(超过23:30分下单将于次日11:30~13:00配送)";
    }
}

- (void)hidePickerView {
    self.pickerViewBackV.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)pickerViewConfirm:(id)sender {
    
    self.dispatchTimeLabel.text = [NSString stringWithFormat:@"%@ %@",self.selectedDayDate,self.selectedHourDate];
    NSArray *hourArr = [self.selectedHourDate componentsSeparatedByString:@"~"];
    NSString *hour = [hourArr lastObject];
    if(self.isTotay) {
       
        
        // @"7:00~8:00",@"11:30~13:00",@"16:30~18:00",@"21:00~22:30"
        if([self selectDispatchTimeWithTime1:@"6:45" time2:@"8:00" time3:hour time4:@"8:00" index:1]) return;
        if([self selectDispatchTimeWithTime1:@"11:15" time2:@"13:00" time3:hour time4:@"13:00" index:2]) return;
        if([self selectDispatchTimeWithTime1:@"16:15" time2:@"18:00" time3:hour time4:@"18:00" index:3]) return;

        
        if ([self currentTimeGreaterWithTime:@"23:30"]) {
            [LMCommonTool showInfoWithStatus:@"超过23:30后下单，选择配送时间为次日11:30~13:00"];
            self.myPickerView.defaultSelectedRow = @[@(1),@(1)];
            NSArray *dateArr = self.dateArr[1];
            self.selectedHourDate = dateArr[1];
            self.needFixedDispatchTime = YES;
            self.selectedDayDate = [self getTomorrowDay:[NSDate date]];
            [self.myPickerView reloadAllComponents];
            self.isTotay = NO;return;
        }else if([self currentTimeGreaterWithTime:@"20:45"]) {
            [LMCommonTool showInfoWithStatus:@"超过20:45后下单，只能选择次日时间配送哦"];
            self.myPickerView.defaultSelectedRow = @[@(1),@(0)];
            NSArray *dateArr = self.dateArr[1];
            self.selectedHourDate = dateArr[0];
            self.selectedDayDate = [self getTomorrowDay:[NSDate date]];
            [self.myPickerView reloadAllComponents];
            self.isTotay = NO;return;
        }
        
        if([self currentTimeGreaterWithTime:hour]) {
            [LMCommonTool showInfoWithStatus:@"所选时间不在配送时间范围哦，请重新选择"];
        }else {
            self.isFirstSelectedDate = YES;
            [self hidePickerView];
        }
        
    }else {
        if(self.needFixedDispatchTime) {
            if (![self timeEqualWithTime1:hour time2:@"13:00"]) {
                [LMCommonTool showInfoWithStatus:@"超过23:30后下单，选择配送时间为次日11:30~13:00"];
                self.myPickerView.defaultSelectedRow = @[@(1),@(1)];
                NSArray *dateArr = self.dateArr[1];
                self.selectedHourDate = dateArr[1];
                [self.myPickerView reloadAllComponents];return;
            }
        }
        
        self.isFirstSelectedDate = YES;
        [self hidePickerView];
    }
    
}

- (BOOL)selectDispatchTimeWithTime1:(NSString *)time1
              time2:(NSString *)time2
              time3:(NSString *)time3
              time4:(NSString *)time4
              index:(NSInteger)index {
    if([self currentTimeGreaterWithTime:time1] && [self currentTimelessThanWithTime:time2]) { //6:45~7:00之间
        if([time3 isEqualToString:time4]) {
            [LMCommonTool showInfoWithStatus:@"配送时间前的15分钟下单只能选择下一个配送时间哦"];
            self.myPickerView.defaultSelectedRow = @[@(0),@(index)];
            NSArray *dateArr = self.dateArr[1];
            self.selectedHourDate = dateArr[index];
            [self.myPickerView reloadAllComponents];
            return YES;
        }
    }
    return NO;
}

#pragma mark - zgpickerview delegate
- (void)ZGPickerView:(ZGPickerView *)pickerView currentComponent:(NSInteger)currentComponent currentRow:(NSInteger)currentRow {
    NSArray *dateArr = self.dateArr[currentComponent];
    if(currentComponent == 0) {
        if(currentRow == 0) {
            self.selectedDayDate = [self getCurrentTime];
            self.isTotay = YES;
        }else if (currentRow == 1) {
            self.selectedDayDate = [self getTomorrowDay:[NSDate date]];
            self.isTotay = NO;
        }
    }else if (currentComponent == 1) {
        self.selectedHourDate = dateArr[currentRow];
    }
    NSLog(@"currentRow=%ld,currentComponent%ld",currentRow,currentComponent);
}

- (IBAction)summitOrder:(id)sender {
    
    if(!self.isFirstSelectedDate) {
        [LMCommonTool showInfoWithStatus:@"请选择配送时间"]; return;
    }
    [self sendConfirmOrderRequest];
}

- (void)sendConfirmOrderRequest {
    NSString *money = [NSString stringWithFormat:@"%.2f",self.orderCenter.money.floatValue];
    NSString *packfree = [NSString stringWithFormat:@"%.2f",self.orderCenter.totalPackfree.floatValue];
    NSString *total = [NSString stringWithFormat:@"%.2f",self.orderCenter.total.floatValue];
    NSDictionary *params = @{@"fid" : self.orderCenter.docIDs ? self.orderCenter.docIDs : @"",
                             @"uid" : [AppEntity shareInstance].userid,
                             @"number" : self.orderCenter.number ? self.orderCenter.number : @"",
                             @"total" : total,
                             @"packfree" : packfree,
                             @"money" : money,
                             @"page" : self.orderCenter.page ? self.orderCenter.page : @"",
                             @"apptime" : self.dispatchTimeLabel.text,
                             @"gid" : self.orderCenter.ID,
                             @"message" : self.leaveNoteTextV.text.length > 0 ? self.leaveNoteTextV.text : @""
                             };
    [LMCommonTool show];
    [[HttpRequestTool shareInstance] POST:K_URL(confirmOrder_URL) parameters:params success:^(id responseObject) {
        [LMCommonTool dismiss];
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            self.orderCenter.orderId = responseObject[@"oid"];
            PaymentMethodViewController *vc = [PaymentMethodViewController lm_VC];
            vc.orderIdSourecType = LM_ORDER_ID_SOURCE_GOOD;
            vc.orderCenter = self.orderCenter;
            [self lm_pushVCWithVC:vc];
        }else {
            K_Show_Info_Tip;
        }
    } failure:^(NSError *error) {
        [LMCommonTool dismiss];
        NSLog(@"error = %@",error.localizedFailureReason);
    }];
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
