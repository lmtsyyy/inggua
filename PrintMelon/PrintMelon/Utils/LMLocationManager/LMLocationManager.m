//
//  LMLocationManager.m
//  SurveyAPP
//
//  Created by admin on 2018/12/3.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "LMLocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

@interface LMLocationManager()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKLocationService *locationService; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch; 
@property (nonatomic, strong) BMKReverseGeoCodeSearchOption *geoCodeSearchOption; 

@end

@implementation LMLocationManager

- (void)startUserLocation {
    [self.locationService startUserLocationService];
}

- (void)stopUserLocation {
    [self.locationService stopUserLocationService];
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

#pragma mark - Lazy loading
- (BMKLocationService *)locationService {
    if (!_locationService) {
        //初始化BMKLocationManager类的实例
        _locationService = [[BMKLocationService alloc] init];
        //设置定位管理类实例的代理
        _locationService.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        //        _locationService.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        //        _locationService.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationService.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationService.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        //        _locationService.locationTimeout = 10;
    }
    return _locationService;
}

- (BMKGeoCodeSearch *)geoCodeSearch {
    if(!_geoCodeSearch) {
        //初始化BMKGeoCodeSearch实例
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        //设置反地理编码检索的代理
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}

- (BMKReverseGeoCodeSearchOption *)geoCodeSearchOption {
    if(!_geoCodeSearchOption) {
        //初始化请求参数类BMKReverseGeoCodeOption的实例
        _geoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc] init];
        //是否访问最新版行政区划数据（仅对中国数据生效）
        _geoCodeSearchOption.isLatestAdmin = YES;
    }
    return _geoCodeSearchOption;
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
    if (!userLocation) {
        return;
    }
    
    //    self.userLocation = userLocation;
    //    
    //    //实现该方法，否则定位图标不出现
    //    [_mapView updateLocationData:self.userLocation];
    //    //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
    //    _mapView.centerCoordinate = self.userLocation.location.coordinate;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    if (!userLocation) {
        return;
    }
    
    /**
     根据地理坐标获取地址信息：异步方法，返回结果在BMKGeoCodeSearchDelegate的
     onGetAddrResult里
     
     reverseGeoCodeOption 反geo检索信息类
     成功返回YES，否则返回NO
     */
    
    [self getReverseGeoCodeDataWithLocation:userLocation];
    
    //    self.userLocation = userLocation;
    
    //实现该方法，否则定位图标不出现
//    [_mapView updateLocationData:userLocation];
    //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
//    _mapView.centerCoordinate = userLocation.location.coordinate;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    
}

- (void)getReverseGeoCodeDataWithLocation:(BMKUserLocation *)userLocation {
    
    // 待解析的经纬度坐标（必选）
    self.geoCodeSearchOption.location = userLocation.location.coordinate;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:self.geoCodeSearchOption];
    
    if (flag) {
        MYLog(@"反地理编码检索成功");
    } else {
        MYLog(@"反地理编码检索失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 反向地理编码检索结果回调
 
 @param searcher 检索对象
 @param result 反向地理编码检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
    
//    BMKPoiInfo *POIInfo = result.poiList[0];
//    BMKSearchRGCRegionInfo *regionInfo = [[BMKSearchRGCRegionInfo alloc] init];
//    if (result.poiRegions.count > 0) {
//        regionInfo = result.poiRegions[0];
//    }
    
    NSString *address = [NSString stringWithFormat:@"省份名称：%@\n城市名称：%@\n区县名称：%@\n乡镇：%@\n街道名称：%@\n街道号码：%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.town,result.addressDetail.streetName,result.addressDetail.streetNumber];
    MYLog(@"address = %@",address);
    
    if(!error) {
        LMLocationEntity *entity = [[LMLocationEntity alloc] init];
        entity.latitude = result.location.latitude;
        entity.longitude = result.location.longitude;
        entity.province = result.addressDetail.province;
        entity.city = result.addressDetail.city;
        entity.district = result.addressDetail.district;
        entity.town = result.addressDetail.town;
        entity.streetName = result.addressDetail.streetName;
        entity.streetNumber = result.addressDetail.streetNumber;
        
        if(self.getLocationInfo) {
            self.getLocationInfo(entity);
            [self stopUserLocation];
        }
    }
    
//    NSString *message = [NSString stringWithFormat:@"经度：%f\n纬度：%f\n地址名称：%@\n商圈名称：%@\n可信度：%ld\n国家名称：%@\n省份名称：%@\n城市名称：%@\n区县名称：%@\n乡镇：%@\n街道名称：%@\n街道号码：%@\n行政区域编码：%@\n国家代码：%@\n方向：%@\n距离：%@\nPOI名称：%@\nPOI经纬坐标：%f\nPOI纬度坐标：%f\nPOI地址信息：%@\nPOI电话号码：%@\nPOI的唯一标识符：%@\nPOI所在省份：%@\nPOI所在城市：%@\nPOI所在行政区域：%@\n街景ID：%@\n是否有详情信息：%d\nPOI方向：%@\nPOI距离：%ld\nPOI邮编：%ld\n相对位置关系：%@\n归属区域面名称：%@\n归属区域面类型：%@\n语义化结果描述：%@", result.location.longitude, result.location.latitude, result.address, result.businessCircle, (long)result.confidence, result.addressDetail.country, result.addressDetail.province, result.addressDetail.city, result.addressDetail.district, result.addressDetail.town, result.addressDetail.streetName, result.addressDetail.streetNumber, result.addressDetail.adCode, result.addressDetail.countryCode, result.addressDetail.direction, result.addressDetail.distance, POIInfo.name, POIInfo.pt.longitude, POIInfo.pt.latitude, POIInfo.address, POIInfo.phone, POIInfo.UID, POIInfo.province, POIInfo.city, POIInfo.area, POIInfo.streetID, POIInfo.hasDetailInfo, POIInfo.direction, (long)POIInfo.distance, (long)POIInfo.zipCode, regionInfo.regionDescription, regionInfo.regionName, regionInfo.regionTag, result.sematicDescription];
    
}

- (void)dealloc {
    NSLog(@"定位结束");
}

@end
