//
//  PrintEditViewController.m
//  PrintMelon
//
//  Created by andy on 2019/3/15.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "PrintEditViewController.h"
#import "PrintEditCell.h"
#import "ConfirmOrderViewController.h"
#import "OrderCenterModel.h"
#import "AddressInfoModel.h"
#import "CouponInfoModel.h"
#import "MyDocModel.h"

@interface PrintEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL _isMatch;
    NSInteger _printNumber;
    CGFloat _firstDiscount;
    CGFloat _deliveryPrice;
    CGFloat _actualPayPrice;
    NSInteger _selectedRow;
    BOOL _isSelectedAddress;
}
@property (weak, nonatomic) IBOutlet UIView *receiptInfoBackV;
@property (weak, nonatomic) IBOutlet UIView *editBackV;
@property (weak, nonatomic) IBOutlet UIView *editGrayBackV;
@property (weak, nonatomic) IBOutlet UIView *editAlertBackV;
@property (weak, nonatomic) IBOutlet UIView *editAddressBackV;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *goods;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editAlertBackVConstraintHeight;
@property (weak, nonatomic) IBOutlet UILabel *receiptNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhizhangLable;
@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *danshuangmianLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *layoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindLable;
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *editReceiptNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *editPhoneLabel;

@property (weak, nonatomic) IBOutlet UITextField *editAddressTextF;
@property (nonatomic, strong) OrderCenterModel *orderCenter;
@property (nonatomic, strong) CouponInfoModel *couponInfo;
@property (nonatomic, strong) PrintEditModel *editModel;

@property (nonatomic, copy) NSMutableArray *goodsDicArr;
@property (nonatomic, copy) NSMutableArray *coupons;

@property (nonatomic, copy) NSMutableArray *zhizhangArr;
@property (nonatomic, copy) NSMutableArray *danshuangmianArr;
@property (nonatomic, copy) NSMutableArray *colorArr;
@property (nonatomic, copy) NSMutableArray *layoutArr;
@property (nonatomic, copy) NSMutableArray *bindArr;
@property (nonatomic, assign) NSInteger discountPrice;//优惠金额
@property (nonatomic, assign) NSInteger totalPage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *firstOrderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstOrderDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryPriceTopConstraint;

@end

static CGFloat const cellHeight = 40;

@implementation PrintEditViewController

- (NSMutableArray *)goods {
    if(!_goods) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}

- (NSMutableArray *)zhizhangArr {
    if(!_zhizhangArr) {
        _zhizhangArr = [NSMutableArray array];
    }
    return _zhizhangArr;
}

- (NSMutableArray *)danshuangmianArr {
    if(!_danshuangmianArr) {
        _danshuangmianArr = [NSMutableArray array];
    }
    return _danshuangmianArr;
}

- (NSMutableArray *)colorArr {
    if(!_colorArr) {
        _colorArr = [NSMutableArray array];
    }
    return _colorArr;
}

- (NSMutableArray *)layoutArr {
    if(!_layoutArr) {
        _layoutArr = [NSMutableArray array];
    }
    return _layoutArr;
}

- (NSMutableArray *)bindArr {
    if(!_bindArr) {
        _bindArr = [NSMutableArray array];
    }
    return _bindArr;
}

- (NSMutableArray *)goodsDicArr {
    if(!_goodsDicArr) {
        _goodsDicArr = [NSMutableArray array];
    }
    return _goodsDicArr;
}

- (NSMutableArray *)coupons {
    if(!_coupons) {
        _coupons = [NSMutableArray array];
    }
    return _coupons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"文件名")
    [self setViewBackShadowWithView:self.receiptInfoBackV];
    [self setViewBackShadowWithView:self.editBackV];
    [self setViewBackShadowWithView:self.editAlertBackV];
    [LMCommonTool inputAccessoryViewWithTextField:self.editReceiptNameLabel target:self action:@selector(hideKeyboard)];
    [LMCommonTool inputAccessoryViewWithTextField:self.editPhoneLabel target:self action:@selector(hideKeyboard)];
    [LMCommonTool inputAccessoryViewWithTextField:self.editAddressTextF target:self action:@selector(hideKeyboard)];
    self.myTableView.rowHeight = cellHeight;
    _printNumber = self.fenshuLabel.text.integerValue;
    [self sendPrintEditRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self otherSetup];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)setViewBackShadowWithView:(UIView *)view {
    view.layer.shadowColor = [UIColor colorWithHexString:@"000000" alpha:0.1].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,1);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 3;
    view.layer.cornerRadius = 6;
}

- (IBAction)editAddressClick:(id)sender {
    self.printEditType = PRINT_EDIT_OTHER_TYPE;
    [self setViewBackShadowWithView:self.editAddressBackV];
    self.editGrayBackV.hidden = NO;
    self.editAddressBackV.hidden = NO;
    self.myTableView.hidden = YES;
    self.editAlertBackVConstraintHeight.constant = 340;
    self.navigationController.navigationBarHidden = YES;
    if(![NSString isBlankString:self.receiptNameLabel.text] && ![self.receiptNameLabel.text hasPrefix:@"请添加"]) {
        self.editReceiptNameLabel.text = self.receiptNameLabel.text;
        self.editPhoneLabel.text = self.phoneLabel.text;
        self.editAddressTextF.text = self.addressLabel.text;
    }
}

- (IBAction)close:(id)sender {
    [self hideAlertView];
}

- (void)hideAlertView {
    self.editGrayBackV.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.view endEditing:YES];
}

- (IBAction)add:(UIButton *)sender {
    NSInteger fenshu = self.fenshuLabel.text.integerValue;
    self.fenshuLabel.text = @(++fenshu).stringValue;
    _printNumber = fenshu;
    self.orderCenter.number = @(fenshu).stringValue;
    [self calculatePricce];
}

- (IBAction)sub:(UIButton *)sender {
    NSInteger fenshu = self.fenshuLabel.text.integerValue;
    if(fenshu > 1) {
        self.fenshuLabel.text = @(--fenshu).stringValue;
    }
    _printNumber = fenshu;
//    self.totalPage *= fenshu;
    self.orderCenter.number = @(fenshu).stringValue;
    [self calculatePricce];
}

- (void)calculatePricce {
    
    NSInteger zhizhangPage = 1;//纸张页数
    if([self.orderCenter.issingle isEqualToString:@"单页"]) {
        zhizhangPage = self.totalPage;
    }else {
        if(self.totalPage == 1) {
            zhizhangPage = self.totalPage;
        } {
            NSInteger page = self.totalPage / 2;
            zhizhangPage = (self.totalPage % 2) == 0 ? page : (page + 1);
        }
    }
    
    
    //    NSInteger zhizhangPage = 1;//纸张页数
//    _printNumber = self.fenshuLabel.text.integerValue;//需要打印的份数
    NSInteger totalZhizhangPage = zhizhangPage * _printNumber;//订单总纸张数
    self.orderCenter.page = @(totalZhizhangPage).stringValue;

    CGFloat goodTotalPrice = 0;//商品的总价格
    CGFloat totalPackfree = 0;//总的包装费
    CGFloat orderTotalPrice = 0;//订单的总价
    
    NSDictionary *editElementDic = @{@"size" : self.orderCenter.size,
                                     @"issingle" : self.orderCenter.issingle,
                                     @"color" : self.orderCenter.color,
                                     @"layout" : self.orderCenter.layout,
                                     @"binding" : self.orderCenter.binding
                                     };
    
    for (NSDictionary *dic in self.goodsDicArr) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [tempDic removeObjectsForKeys:@[@"id",@"packfree",@"price"]];
        if([editElementDic isEqual:tempDic]) {//如果字典数据相等，则获取对应的包装费、价格等数据
            _isMatch = YES;
            self.orderCenter.ID = dic[@"id"];
            NSLog(@"包装费：%@,价格：%@",dic[@"packfree"],dic[@"price"]);
            //            CGFloat packfree = [dic[@"packfree"] floatValue];//包装费
            //            CGFloat price = [dic[@"price"] floatValue];//单价
            goodTotalPrice = totalZhizhangPage * [dic[@"price"] floatValue];
//            totalPackfree = totalZhizhangPage * [dic[@"packfree"] floatValue];
            totalPackfree = [dic[@"packfree"] floatValue];

            orderTotalPrice = goodTotalPrice + totalPackfree;
            //            orderTotalPrice = 2000;
            
            
            
            //获取最大的优惠金额
            for (int i = 0;i < self.coupons.count;i++) {
                CouponInfoModel *couponInfo = self.coupons[i];
                if(i == 0) {//最小的金额优惠数据
                    if(orderTotalPrice < couponInfo.condition.integerValue) {//总价比第一条数据的优惠金额还小，代表没有优惠
                        //                        _discountPrice = 0;
                        self.couponInfo.condition = @"0";
                        self.couponInfo.money = @"0";
                        break;
                    }else if (orderTotalPrice == couponInfo.condition.integerValue) {//总价刚好和第一条优惠数据相等，则优惠价格就是第一条数据的优惠金额
                        //                        _discountPrice = couponInfo.condition.integerValue;
                        self.couponInfo = couponInfo;
                        break;
                    }
                }else if (i == self.coupons.count - 1) {//最大的金额优惠数据
                    if(orderTotalPrice >= couponInfo.condition.integerValue) {//总价大于或者等于最大的优惠数据金额，则优惠价格就是最后一条数据的优惠金额
                        //                        _discountPrice = couponInfo.condition.integerValue;
                        self.couponInfo = couponInfo;
                    }else {//总价小于优惠金额，则取它的上一条优惠金额数据
                        couponInfo = self.coupons[i - 1];//取上一条数据
                        //                        orderTotalPrice = couponInfo.condition.integerValue;
                        self.couponInfo = couponInfo;
                    }
                }else {//总价大于最小的金额优惠数据并且小于最大的金额优惠数据
                    if(orderTotalPrice < couponInfo.condition.integerValue) {//总价小于优惠金额，则取它的上一条优惠金额数据
                        couponInfo = self.coupons[i - 1];//取上一条数据
                        //                        orderTotalPrice = couponInfo.condition.integerValue;
                        self.couponInfo = couponInfo;
                        break;
                    }else if (orderTotalPrice == couponInfo.condition.integerValue) {//总价刚好等于这条优惠数据的金额，则取这条优惠数据的金额
                        //                        orderTotalPrice = couponInfo.condition.integerValue;
                        self.couponInfo = couponInfo;
                        break;
                    }
                }
            }
        }
    }
    
    if(self.couponInfo.condition.integerValue == 0 && self.couponInfo.money.integerValue == 0) {
        self.couponLabel.text = @"暂无优惠";
    }else {
        self.couponLabel.text = [NSString stringWithFormat:@"满%@元优惠%@元",self.couponInfo.condition,self.couponInfo.money];
    }
    
    CGFloat actualPayPrice = orderTotalPrice - self.couponInfo.money.integerValue;//实付款
    if(actualPayPrice >= _firstDiscount) {
        actualPayPrice = orderTotalPrice - self.couponInfo.money.floatValue - _firstDiscount;//实付款
    }
    _actualPayPrice = actualPayPrice;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",actualPayPrice];
    self.pageNumLabel.text = @(totalZhizhangPage).stringValue;
    
    self.orderCenter.totalPackfree = @(totalPackfree).stringValue;
    self.orderCenter.total = @(goodTotalPrice).stringValue;
    self.orderCenter.money = @(actualPayPrice).stringValue;
    self.orderCenter.orderTotalPrice = @(orderTotalPrice).stringValue;
    
    if(!_isMatch) {
        [LMCommonTool showInfoWithStatus:@"没有相匹配的规格哦，请重新选择"];
        self.totalPriceLabel.text = @"0.00";
        self.pageNumLabel.text = @"0";
    }
}

- (IBAction)zhizhangClick:(id)sender {
    self.printEditType = PRINT_EDIT_ZHIZHANG_TYPE;
//    [self.dataSource removeAllObjects];
//    [self.dataSource addObject:[self getModelWithTitle:@"A4"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"A3"]];
    [self resetDataWithArr:self.zhizhangArr];
}

- (IBAction)danshuangyeClick:(id)sender {
    self.printEditType = PRINT_EDIT_DANSHUANGYE_TYPE;
//    [self.dataSource removeAllObjects];
//    [self.dataSource addObject:[self getModelWithTitle:@"单面"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"双面"]];
    [self resetDataWithArr:self.danshuangmianArr];
}

- (IBAction)colorClick:(id)sender {
    self.printEditType = PRINT_EDIT_COLOR_TYPE;
//    [self.dataSource removeAllObjects];
//    [self.dataSource addObject:[self getModelWithTitle:@"黑白"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"彩色"]];
    [self resetDataWithArr:self.colorArr];
}

- (IBAction)layoutClick:(id)sender {
    self.printEditType = PRINT_EDIT_LAYOUT_TYPE;
//    [self.dataSource removeAllObjects];
//    [self.dataSource addObject:[self getModelWithTitle:@"每版打印1页"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"每版打印2页"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"每版打印4页"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"每版打印6页"]];
    [self resetDataWithArr:self.layoutArr];
}

- (IBAction)bindClick:(id)sender {
    self.printEditType = PRINT_EDIT_BIND_TYPE;
//    [self.dataSource removeAllObjects];
//    [self.dataSource addObject:[self getModelWithTitle:@"不装订"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"左上角装订"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"左侧装订"]];
//    [self.dataSource addObject:[self getModelWithTitle:@"上侧装订"]];
    [self resetDataWithArr:self.bindArr];
}

- (void)editOptionWithEditAlertVHeight:(CGFloat)height {
    self.editAlertBackVConstraintHeight.constant = height;
    self.editGrayBackV.hidden = NO;
    self.editAddressBackV.hidden = YES;
    self.myTableView.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
    [self selectRowWithRow:_selectedRow];
    
}

- (void)resetDataWithArr:(NSMutableArray *)arr {
    [self.dataSource removeAllObjects];
    NSInteger i = 0;
    for (NSString *str in arr) {
        PrintEditModel *model = [[PrintEditModel alloc] init];
        model.myTitle = str;
        
        if(self.printEditType == PRINT_EDIT_ZHIZHANG_TYPE) {
            if([str isEqualToString:self.zhizhangLable.text]) {
                _selectedRow = i;
            }
        }else if (self.printEditType == PRINT_EDIT_FENSHU_TYPE) {
            if([str isEqualToString:self.fenshuLabel.text]) {
                _selectedRow = i;
            }
        }else if (self.printEditType == PRINT_EDIT_DANSHUANGYE_TYPE) {
            if([str isEqualToString:self.danshuangmianLabel.text]) {
                _selectedRow = i;
            }
        }else if (self.printEditType == PRINT_EDIT_COLOR_TYPE) {
            if([str isEqualToString:self.colorLabel.text]) {
                _selectedRow = i;
            }
        }else if (self.printEditType == PRINT_EDIT_LAYOUT_TYPE) {
            if([str isEqualToString:self.layoutLabel.text]) {
                _selectedRow = i;
            }
        }else if (self.printEditType == PRINT_EDIT_BIND_TYPE) {
            if([str isEqualToString:self.bindLable.text]) {
                _selectedRow = i;
            }
        }
        
        if(str.length >= 4) {
            model.lengthGreaterThanFive = YES;
        }
        [self.dataSource addObject:model];
        i ++;
    }
    if(self.dataSource.count == 1) {
        [self editOptionWithEditAlertVHeight:190];
    }else if (self.dataSource.count == 2) {
        [self editOptionWithEditAlertVHeight:230];
    }else if (self.dataSource.count == 3) {
        [self editOptionWithEditAlertVHeight:270];
    }else if (self.dataSource.count >= 4) {
        [self editOptionWithEditAlertVHeight:310];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrintEditCell *cell = [PrintEditCell cellWithTableView:tableView vc:self];
    cell.printEditModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectRowWithRow:indexPath.row];
}

- (void)selectRowWithRow:(NSInteger)row {
    for(int i = 0;i < self.dataSource.count;i++) {
        PrintEditModel *model = self.dataSource[i];
        if(i == row) {
            model.isSelected = YES;
        }else {
            model.isSelected = NO;
        }
    }
    
    PrintEditModel *model = self.dataSource[row];
    self.editModel = model;
    
    if(self.printEditType == PRINT_EDIT_ZHIZHANG_TYPE) {
        self.orderCenter.size = model.myTitle;
    }else if (self.printEditType == PRINT_EDIT_DANSHUANGYE_TYPE) {
        self.orderCenter.issingle = model.myTitle;
    }else if (self.printEditType == PRINT_EDIT_COLOR_TYPE) {
        self.orderCenter.color = model.myTitle;
    }else if (self.printEditType == PRINT_EDIT_LAYOUT_TYPE) {
        self.orderCenter.layout = model.myTitle;
    }else if (self.printEditType == PRINT_EDIT_BIND_TYPE) {
        self.orderCenter.binding = model.myTitle;
    }
    
    [self.myTableView reloadData];
}

- (IBAction)confirmPrint:(id)sender {
    if(!_isMatch) {
        [LMCommonTool showInfoWithStatus:@"没有相匹配的规格哦，请重新选择"]; return;
    }
    if(_deliveryPrice > _actualPayPrice) {
        [LMCommonTool showInfoWithStatus:@"订单总额未达到起送价格，暂时无法下单哦！"]; return;
    }
    if(!_isSelectedAddress) {
        [LMCommonTool showInfoWithStatus:@"没有选择收获地址，暂时无法下单哦！"]; return;
    }
    if(![AppEntity shareInstance].isInsideServiceArea) {
        [LMCommonTool showInfoWithStatus:@"当前位置不在服务范围之内，暂时无法下单哦！"]; return;
    }
//    if(_firstDiscount > _actualPayPrice) {
//        _actualPayPrice += _firstDiscount;
//        self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",_actualPayPrice];
//        [LMCommonTool showInfoWithStatus:@"订单总额未达到首单优惠价格，暂时不能优惠哦"]; return;
//    }
    ConfirmOrderViewController *vc = [ConfirmOrderViewController lm_VC];
    self.orderCenter.docIDs = self.docIDs;
    vc.orderCenter = self.orderCenter;
    vc.couponInfo = self.couponInfo;
    [self lm_pushVCWithVC:vc];
}


- (IBAction)saveModifyAddress:(id)sender {
    [self hideAlertView];
    if(self.printEditType == PRINT_EDIT_ZHIZHANG_TYPE) {
        self.zhizhangLable.text = self.editModel.myTitle;
    }else if (self.printEditType == PRINT_EDIT_FENSHU_TYPE) {
        self.fenshuLabel.text = self.editModel.myTitle;
    }else if (self.printEditType == PRINT_EDIT_DANSHUANGYE_TYPE) {
        self.danshuangmianLabel.text = self.editModel.myTitle;
    }else if (self.printEditType == PRINT_EDIT_COLOR_TYPE) {
        self.colorLabel.text = self.editModel.myTitle;
    }else if (self.printEditType == PRINT_EDIT_LAYOUT_TYPE) {
        self.layoutLabel.text = self.editModel.myTitle;
    }else if (self.printEditType == PRINT_EDIT_BIND_TYPE) {
        self.bindLable.text = self.editModel.myTitle;
    }else {
        self.editGrayBackV.hidden = NO;
        [self sendModifyAddressRequest];
    }
    
    _isMatch = NO;
    [self calculatePricce];
    
//    BOOL isMatch = NO;
//    NSInteger zhizhangPage = 1;//纸张页数
//    NSInteger printNumber = self.fenshuLabel.text.integerValue;//需要打印的份数
//    NSInteger totalZhizhangPage = zhizhangPage * printNumber;//订单总纸张数
//    CGFloat orderTotalPrice = 0;//订单的总价
    
//    NSInteger zhizhangPage = 1;//纸张页数
//    if([self.orderCenter.issingle isEqualToString:@"单页"]) {
//        zhizhangPage = self.totalPage;
//    }else {
//        if(self.totalPage == 1) {
//            zhizhangPage = self.totalPage;
//        } {
//            NSInteger page = self.totalPage / 2;
//            zhizhangPage = (self.totalPage % 2) == 0 ? page : (page + 1);
//        }
//    }
//
////    NSInteger zhizhangPage = 1;//纸张页数
//    _printNumber = self.fenshuLabel.text.integerValue;//需要打印的份数
//    NSInteger totalZhizhangPage = zhizhangPage * _printNumber;//订单总纸张数
//    CGFloat goodTotalPrice = 0;//商品的总价格
//    CGFloat totalPackfree = 0;//总的包装费
//    CGFloat orderTotalPrice = 0;//订单的总价
//
//    NSDictionary *editElementDic = @{@"size" : self.orderCenter.size,
//                                     @"issingle" : self.orderCenter.issingle,
//                                     @"color" : self.orderCenter.color,
//                                     @"layout" : self.orderCenter.layout,
//                                     @"binding" : self.orderCenter.binding
//                                     };
//
//    for (NSDictionary *dic in self.goodsDicArr) {
//        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        [tempDic removeObjectsForKeys:@[@"id",@"packfree",@"price"]];
//        if([editElementDic isEqual:tempDic]) {//如果字典数据相等，则获取对应的包装费、价格等数据
//            _isMatch = YES;
//            self.orderCenter.ID = dic[@"id"];
//            NSLog(@"包装费：%@,价格：%@",dic[@"packfree"],dic[@"price"]);
////            CGFloat packfree = [dic[@"packfree"] floatValue];//包装费
////            CGFloat price = [dic[@"price"] floatValue];//单价
//            goodTotalPrice = totalZhizhangPage * [dic[@"price"] floatValue];
//            totalPackfree = totalZhizhangPage * [dic[@"packfree"] floatValue];
//            orderTotalPrice = goodTotalPrice + totalPackfree;
////            orderTotalPrice = 2000;
//
//
//
//            //获取最大的优惠金额
//            for (int i = 0;i < self.coupons.count;i++) {
//                CouponInfoModel *couponInfo = self.coupons[i];
//                if(i == 0) {//最小的金额优惠数据
//                    if(orderTotalPrice < couponInfo.condition.integerValue) {//总价比第一条数据的优惠金额还小，代表没有优惠
////                        _discountPrice = 0;
//                        self.couponInfo.condition = @"0";
//                        self.couponInfo.money = @"0";
//                        break;
//                    }else if (orderTotalPrice == couponInfo.condition.integerValue) {//总价刚好和第一条优惠数据相等，则优惠价格就是第一条数据的优惠金额
////                        _discountPrice = couponInfo.condition.integerValue;
//                        self.couponInfo = couponInfo;
//                        break;
//                    }
//                }else if (i == self.coupons.count - 1) {//最大的金额优惠数据
//                    if(orderTotalPrice >= couponInfo.condition.integerValue) {//总价大于或者等于最大的优惠数据金额，则优惠价格就是最后一条数据的优惠金额
////                        _discountPrice = couponInfo.condition.integerValue;
//                        self.couponInfo = couponInfo;
//                    }else {//总价小于优惠金额，则取它的上一条优惠金额数据
//                        couponInfo = self.coupons[i - 1];//取上一条数据
////                        orderTotalPrice = couponInfo.condition.integerValue;
//                        self.couponInfo = couponInfo;
//                    }
//                }else {//总价大于最小的金额优惠数据并且小于最大的金额优惠数据
//                    if(orderTotalPrice < couponInfo.condition.integerValue) {//总价小于优惠金额，则取它的上一条优惠金额数据
//                        couponInfo = self.coupons[i - 1];//取上一条数据
////                        orderTotalPrice = couponInfo.condition.integerValue;
//                        self.couponInfo = couponInfo;
//                        break;
//                    }else if (orderTotalPrice == couponInfo.condition.integerValue) {//总价刚好等于这条优惠数据的金额，则取这条优惠数据的金额
////                        orderTotalPrice = couponInfo.condition.integerValue;
//                        self.couponInfo = couponInfo;
//                        break;
//                    }
//                }
//            }
//        }
//    }
//
//    if(self.couponInfo.condition.integerValue == 0 && self.couponInfo.money.integerValue == 0) {
//        self.couponLabel.text = @"暂无优惠";
//    }else {
//        self.couponLabel.text = [NSString stringWithFormat:@"满%@元优惠%@元",self.couponInfo.condition,self.couponInfo.money];
//    }
//
//    CGFloat actualPayPrice = orderTotalPrice - self.couponInfo.money.integerValue;//实付款
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",actualPayPrice];
//    self.pageNumLabel.text = @(zhizhangPage).stringValue;
//
//    self.orderCenter.totalPackfree = @(totalPackfree).stringValue;
//    self.orderCenter.total = @(goodTotalPrice).stringValue;
//    self.orderCenter.money = @(actualPayPrice).stringValue;
//    self.orderCenter.orderTotalPrice = @(orderTotalPrice).stringValue;
//
//    if(!_isMatch) {
//        [LMCommonTool showInfoWithStatus:@"没有相匹配的规格哦，请重新选择"];
//        self.totalPriceLabel.text = @"0.00";
//        self.pageNumLabel.text = @"0";
//    }

}

- (void)sendPrintEditRequest {
    NSDictionary *params = @{@"uid" : [AppEntity shareInstance].userid,
                             @"fid" : self.docIDs ? self.docIDs : @""
                             };
    [[HttpRequestTool shareInstance] POST:K_URL(printEdit_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            [self setValueWithResponseObject:responseObject];
            
        }else {
            K_Show_Info_Tip
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

- (void)sendModifyAddressRequest {
    if([NSString isBlankString:self.editReceiptNameLabel.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入收件人姓名"];return;
    }
    if(![NSString validateCellPhoneNumber:self.editPhoneLabel.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入正确的手机格式"];return;
    }
    if([NSString isBlankString:self.editAddressTextF.text]) {
        [LMCommonTool showInfoWithStatus:@"请输入收件地址"];return;
    }
    NSDictionary *params = @{@"uid" : [AppEntity shareInstance].userid,
                             @"consignee" : self.editReceiptNameLabel.text,
                             @"phone" : self.editPhoneLabel.text,
                             @"address" : self.editAddressTextF.text
                             };
    [[HttpRequestTool shareInstance] POST:K_URL(modifyAddress_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            self.editGrayBackV.hidden = YES;
            NSDictionary *addressDic = responseObject[@"address"];
            self.orderCenter.addressInfo.consignee = addressDic[@"consignee"];
            self.orderCenter.addressInfo.phone = addressDic[@"phone"];
            self.orderCenter.addressInfo.address = addressDic[@"address"];
            self.receiptNameLabel.text = addressDic[@"consignee"];
            self.phoneLabel.text = addressDic[@"phone"];
            self.addressLabel.text = addressDic[@"address"];
            self->_isSelectedAddress = YES;
        }else {
            
        }

    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

- (void)setValueWithResponseObject:(id)responseObject {
    NSArray *addressArr = responseObject[@"address"];//收货地址
    AddressInfoModel *addressInfo = nil;
    _isSelectedAddress = addressArr.count > 0 ? YES : NO;
    if(addressArr.count > 0) {
        NSDictionary *addressDic = [addressArr firstObject];
        addressInfo = [AddressInfoModel mj_objectWithKeyValues:addressDic];
        self.receiptNameLabel.text = addressInfo.consignee;
        self.phoneLabel.text = addressInfo.phone;
        self.addressLabel.text = addressInfo.address;
    }else {
        addressInfo = [[AddressInfoModel alloc] init];
        addressInfo.consignee = @"请添加收货人姓名";
        addressInfo.phone = @"";
        addressInfo.address = @"请添加收货地址";
        self.receiptNameLabel.text = addressInfo.consignee;
        self.phoneLabel.text = addressInfo.phone;
        self.addressLabel.text = addressInfo.address;
    }
    
    NSArray *googArr = responseObject[@"good"];
    for (NSDictionary *dic in googArr) {
        [self.goodsDicArr addObject:dic];
    }
    self.goods = [OrderCenterModel mj_objectArrayWithKeyValuesArray:googArr];
    
    //把后台配置的选项加入对应的接收数组
    NSMutableArray *zhizhangArr = [NSMutableArray array];
    NSMutableArray *danshuangmianArr = [NSMutableArray array];
    NSMutableArray *colorArr = [NSMutableArray array];
    NSMutableArray *layoutArr = [NSMutableArray array];
    NSMutableArray *bindArr = [NSMutableArray array];
    for (OrderCenterModel *model in self.goods) {
        [zhizhangArr addObject:model.size];
        [danshuangmianArr addObject:model.issingle];
        [colorArr addObject:model.color];
        [layoutArr addObject:model.layout];
        [bindArr addObject:model.binding];
        NSLog(@"纸张：%@",model.size);
        NSLog(@"单双面：%@",model.issingle);
        NSLog(@"颜色：%@",model.color);
        NSLog(@"布局：%@",model.layout);
        NSLog(@"装订：%@",model.binding);
    }
    
    [self removeRepeatElementWithBeforeArr:zhizhangArr after:self.zhizhangArr];
    [self removeRepeatElementWithBeforeArr:danshuangmianArr after:self.danshuangmianArr];
    [self removeRepeatElementWithBeforeArr:colorArr after:self.colorArr];
    [self removeRepeatElementWithBeforeArr:layoutArr after:self.layoutArr];
    [self removeRepeatElementWithBeforeArr:bindArr after:self.bindArr];

    
    OrderCenterModel *goodInfo = [self.goods firstObject];
//    goodInfo.size = [self.zhizhangArr firstObject];
//    goodInfo.issingle = [self.danshuangmianArr firstObject];
//    goodInfo.color = [self.colorArr firstObject];
//    goodInfo.layout = [self.layoutArr firstObject];
//    goodInfo.binding = [self.bindArr firstObject];
    goodInfo.addressInfo = addressInfo;
    self.orderCenter = goodInfo;
    self.orderCenter.number = self.fenshuLabel.text;
    self.zhizhangLable.text = goodInfo.size;
    self.danshuangmianLabel.text = goodInfo.issingle;
    self.colorLabel.text = goodInfo.color;
    self.layoutLabel.text = goodInfo.layout;
    self.bindLable.text = goodInfo.binding;
    NSArray *couponArr = responseObject[@"coupon"];
    NSDictionary *couponDic = [couponArr firstObject];
    CouponInfoModel *couponInfo = [CouponInfoModel mj_objectWithKeyValues:couponDic];
    
    //第一次下单优惠
    NSDictionary *userDic = responseObject[@"user"];
    NSString *firstorder = [NSString stringWithFormat:@"%@",userDic[@"firstorder"]];
//    firstorder = @"1";
    //第一次下单有1.5元的优惠
    if([firstorder isEqualToString:@"1"]) {
        _firstDiscount = 1.5;
        self.bottomViewHeightConstraint.constant = 150;
        self.firstOrderTitleLabel.hidden = NO;
        self.firstOrderDiscountLabel.hidden = NO;
        self.deliveryPriceTopConstraint.constant = 34;
    }else {
        _firstDiscount = 0;
        self.bottomViewHeightConstraint.constant = 120;
        self.deliveryPriceTopConstraint.constant = 8;
    }
    
    
    //起送价格
    //第一次下单优惠
    NSDictionary *setDic = responseObject[@"set"];
    NSString *deliveryPrice = [NSString stringWithFormat:@"%@",setDic[@"content"]];
    _deliveryPrice = deliveryPrice.floatValue;
    self.deliveryPriceLabel.text = [NSString stringWithFormat:@"满%.1f元起送",_deliveryPrice];
    self.coupons = [CouponInfoModel mj_objectArrayWithKeyValuesArray:couponArr];
    
    NSMutableArray *pages = [NSMutableArray array];
    pages = [MyDocModel mj_objectArrayWithKeyValuesArray:responseObject[@"file"]];
//    NSInteger totalPage = 0;
    for (MyDocModel *model in pages) {
        self.totalPage += model.page.integerValue;
    }
    
    _isMatch = YES;
    NSInteger zhizhangPage = 1;//纸张页数
    if([self.orderCenter.issingle isEqualToString:@"单页"]) {
        zhizhangPage = self.totalPage;
    }else {
        if(self.totalPage == 1) {
            zhizhangPage = self.totalPage;
        }else {
            NSInteger page = self.totalPage / 2;
            zhizhangPage = (self.totalPage % 2) == 0 ? page : (page + 1);
        }
    }
    
    
    
    _printNumber = self.fenshuLabel.text.integerValue;//需要打印的份数
    NSInteger totalZhizhangPage = zhizhangPage * _printNumber;//订单总纸张数
    self.orderCenter.page = @(totalZhizhangPage).stringValue;
    CGFloat goodTotalPrice = totalZhizhangPage * goodInfo.price.floatValue;//商品的总价格
//    CGFloat totalPackfree = totalZhizhangPage * goodInfo.packfree.floatValue;//总的包装费
    CGFloat totalPackfree = goodInfo.packfree.floatValue;//总的包装费

    CGFloat orderTotalPrice = goodTotalPrice + totalPackfree;//订单的总价
    
    
    //获取最大的优惠金额
    for (int i = 0;i < self.coupons.count;i++) {
        CouponInfoModel *couponInfo = self.coupons[i];
        if(i == 0) {//最小的金额优惠数据
            if(orderTotalPrice < couponInfo.condition.integerValue) {//总价比第一条数据的优惠金额还小，代表没有优惠
                //                        _discountPrice = 0;
                self.couponInfo.condition = @"0";
                self.couponInfo.money = @"0";
                break;
            }else if (orderTotalPrice == couponInfo.condition.integerValue) {//总价刚好和第一条优惠数据相等，则优惠价格就是第一条数据的优惠金额
                //                        _discountPrice = couponInfo.condition.integerValue;
                self.couponInfo = couponInfo;
                break;
            }
        }else if (i == self.coupons.count - 1) {//最大的金额优惠数据
            if(orderTotalPrice >= couponInfo.condition.integerValue) {//总价大于或者等于最大的优惠数据金额，则优惠价格就是最后一条数据的优惠金额
                //                        _discountPrice = couponInfo.condition.integerValue;
                self.couponInfo = couponInfo;
            }else {//总价小于优惠金额，则取它的上一条优惠金额数据
                couponInfo = self.coupons[i - 1];//取上一条数据
                //                        orderTotalPrice = couponInfo.condition.integerValue;
                self.couponInfo = couponInfo;
            }
        }else {//总价大于最小的金额优惠数据并且小于最大的金额优惠数据
            if(orderTotalPrice < couponInfo.condition.integerValue) {//总价小于优惠金额，则取它的上一条优惠金额数据
                couponInfo = self.coupons[i - 1];//取上一条数据
                //                        orderTotalPrice = couponInfo.condition.integerValue;
                self.couponInfo = couponInfo;
                break;
            }else if (orderTotalPrice == couponInfo.condition.integerValue) {//总价刚好等于这条优惠数据的金额，则取这条优惠数据的金额
                //                        orderTotalPrice = couponInfo.condition.integerValue;
                self.couponInfo = couponInfo;
                break;
            }
        }
    }
    
    if(self.coupons.count == 0) {
        self.couponLabel.text = @"暂无优惠";
    }else if(self.couponInfo.condition.integerValue == 0 && self.couponInfo.money.integerValue == 0) {
        self.couponLabel.text = @"暂无优惠";
    }else {
        self.couponLabel.text = [NSString stringWithFormat:@"满%@元优惠%@元",self.couponInfo.condition,self.couponInfo.money];
    }
    
    
    CGFloat actualPayPrice = orderTotalPrice - self.couponInfo.money.floatValue;//实付款
    if(actualPayPrice >= _firstDiscount) {
        actualPayPrice -= _firstDiscount;//实付款
    }
    _actualPayPrice = actualPayPrice;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",actualPayPrice];
    self.pageNumLabel.text = @(totalZhizhangPage).stringValue;
    
    self.orderCenter.totalPackfree = @(totalPackfree).stringValue;
    self.orderCenter.total = @(goodTotalPrice).stringValue;
    self.orderCenter.money = @(actualPayPrice).stringValue;
    self.orderCenter.orderTotalPrice = @(orderTotalPrice).stringValue;
    
}

- (void)removeRepeatElementWithBeforeArr:(NSMutableArray *)beforeArr after:(NSMutableArray *)afterArr {
    for (NSString *str in beforeArr) {
        if(![afterArr containsObject:str]) {
            [afterArr addObject:str];
        }
    }
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
