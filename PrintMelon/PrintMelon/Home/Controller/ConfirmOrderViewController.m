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

@interface ConfirmOrderViewController ()<ZGPickerViewDelegate>
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
@property (nonatomic, copy) NSString *selectedDayDate;
@property (nonatomic, copy) NSString *selectedHourDate;
@property (nonatomic, assign) BOOL isFirstSelectedDate;
@end

@implementation ConfirmOrderViewController

- (NSMutableArray *)dateArr {
    if(!_dateArr) {
        _dateArr = [NSMutableArray array];
        NSArray *dayDateArr = @[@"今天",@"明天"];
        [_dateArr addObject:dayDateArr];
        NSArray* hourDateArr = @[@"7:00~8:00",@"11:30~13:00",@"16:30~18:00",@"21:00~22:30"];
        [_dateArr addObject:hourDateArr];
    }
    return _dateArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
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
}

- (void)selectDefaultDate {
    NSArray *hourDateArr = [self.dateArr lastObject];
    self.selectedDayDate = [self getCurrentTime];
    self.selectedHourDate = [hourDateArr firstObject];
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
    self.packagePriceLabel.text = model.totalPackfree;
    self.xiaojiPriceLabel.text = model.total;
    self.totalPriceLabel.text = model.money;
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
    self.isFirstSelectedDate = YES;
    [self hidePickerView];
    self.dispatchTimeLabel.text = [NSString stringWithFormat:@"%@ %@",self.selectedDayDate,self.selectedHourDate];
}

#pragma mark - zgpickerview delegate
- (void)ZGPickerView:(ZGPickerView *)pickerView currentComponent:(NSInteger)currentComponent currentRow:(NSInteger)currentRow {
    NSArray *dateArr = self.dateArr[currentComponent];
    if(currentComponent == 0) {
        if(currentRow == 0) {
            self.selectedDayDate = [self getCurrentTime];
        }else if (currentRow == 1) {
            self.selectedDayDate = [self getTomorrowDay:[NSDate date]];
        }
    }else if (currentComponent == 1) {
        self.selectedHourDate = dateArr[currentRow];
    }
    NSLog(@"currentRow=%ld,currentComponent%ld",currentRow,currentComponent);
}

- (IBAction)summitOrder:(id)sender {
    
    [self sendConfirmOrderRequest];

}

- (void)sendConfirmOrderRequest {
    NSDictionary *params = @{@"fid" : self.orderCenter.docIDs ? self.orderCenter.docIDs : @"",
                             @"uid" : [AppEntity shareInstance].userid,
                             @"number" : self.orderCenter.number ? self.orderCenter.number : @"",
                             @"total" : self.orderCenter.orderTotalPrice,
                             @"packfree" : self.orderCenter.totalPackfree,
                             @"money" : self.orderCenter.money ? self.orderCenter.money : @"",
                             @"page" : self.orderCenter.page ? self.orderCenter.page : @"",
                             @"apptime" : self.dispatchTimeLabel.text,
                             @"gid" : self.orderCenter.ID
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
