//
//  LMCompassTool.m
//  SurveyAPP
//
//  Created by admin on 2018/12/3.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "LMCompassTool.h"
#import "LMCompassViewController.h"

@implementation LMCompassTool

+ (void)openCompassWithVC:(UIViewController *)vc getCompasssData:(void (^)(NSDictionary * _Nonnull))getCompasssData {
    
    LMCompassViewController *compassVC = [[LMCompassViewController alloc] init];
    [compassVC setGetCompassData:^(NSDictionary * _Nonnull dataDic) {
        
        if(getCompasssData) {
            getCompasssData(dataDic);
        }
    }];
    [vc presentViewController:compassVC animated:YES completion:nil];
}
@end
