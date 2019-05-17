//
//  HomeViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/4.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "HomeViewController.h"
#import "DocPrinterViewController.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "LMLocationManager.h"
#import "HowUseViewController.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (nonatomic ,copy) NSMutableArray *banneImages;
@property (nonatomic, strong) LMLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressNotInsideServiceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTopConstraint;

@end

@implementation HomeViewController

- (NSMutableArray *)banneImages {
    if(!_banneImages) {
        _banneImages = [NSMutableArray array];
    }
    return _banneImages;
}

- (LMLocationManager *)locationManager {
    if(!_locationManager) {
        _locationManager = [[LMLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    [self lm_setupNaviTitleViewWithTitle:@"首页" titleColor:nil];
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
//    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 500, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.placeholderImage = nil;
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_current_dot"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_dot"];
    self.cycleScrollView.pageControlBottomOffset = -20;
    [self startLocation];
    [self sendHomeRequest];
    
}

- (IBAction)docPrintClick:(id)sender {
    DocPrinterViewController *vc = [DocPrinterViewController lm_VC];
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


- (IBAction)howPrintClick:(id)sender {
    HowUseViewController *vc = [HowUseViewController lm_VC];
    vc.agreementType = LM_AGREEMENT_HOWUSE;
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
}

- (void)sendHomeRequest {
    
    [[HttpRequestTool shareInstance] GET:K_URL(home_URL) parameters:nil success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            NSArray *bannerArr = responseObject[@"banner"];
            for (NSDictionary *dic in bannerArr) {
                NSString *imageUrlStr = dic[@"image"];
                [self.banneImages addObject:K_URL(imageUrlStr)];
            }
            self.cycleScrollView.imageURLStringsGroup = self.banneImages;
        }else {
            K_Show_Info_Tip
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

- (IBAction)againLocation:(id)sender {
    [self startLocation];
}

- (void)startLocation {
//    self.addressNotInsideServiceLabel.hidden = NO;
//    self.addressTopConstraint.constant = -8;
    [self.locationManager startUserLocation];
    __weak typeof(self) weakSelf = self;
    [self.locationManager setGetLocationInfo:^(LMLocationEntity * _Nonnull locationEntity) {
        //        weakSelf.plPlaceTextF.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",locationEntity.province,locationEntity.city,locationEntity.district,locationEntity.town,locationEntity.streetName,locationEntity.streetNumber];
        weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",locationEntity.city,locationEntity.district,locationEntity.town];
        NSString *coordinate = [NSString stringWithFormat:@"%f,%f",locationEntity.longitude,locationEntity.latitude];
        [weakSelf sendServiceAreaRequestWithCoordinate:coordinate];
        [weakSelf.locationManager stopUserLocation];
    }];
}

- (NSString *)identifierForVendor {
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}


- (void)sendServiceAreaRequestWithCoordinate:(NSString *)coordinate {
    NSDictionary *params = @{@"location" : coordinate,
                             @"diu" : [self identifierForVendor]
                             };
    __weak typeof(self) weakSelf = self;
    [[HttpRequestTool shareInstance] POST:K_URL(serviceArea_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSString *errcode = responseObject[@"errcode"];
        
        if(errcode.integerValue == 0) { //成功
            NSDictionary *dataDic = responseObject[@"data"];
            NSString *status = dataDic[@"status"];
            if(status.integerValue == 0) {
                NSArray *serviceAreaArr = dataDic[@"fencing_event_list"];
                [AppEntity shareInstance].isInsideServiceArea = serviceAreaArr.count > 0 ? YES : NO;
                if([AppEntity shareInstance].isInsideServiceArea) {
                    weakSelf.addressNotInsideServiceLabel.hidden = YES;
                    weakSelf.addressTopConstraint.constant = 0;
                }
            }
        }else {
            [LMCommonTool showErrorWithStatus:responseObject[@"errmsg"]];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)dealloc {
    NSLog(@"%@--dealloc",NSStringFromClass([self class]));
    self.locationManager = nil;
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
