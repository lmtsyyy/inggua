//
//  ServiceAgreementViewController.m
//  PrintMelon
//
//  Created by andy on 2019/4/4.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "ServiceAgreementViewController.h"

@interface ServiceAgreementViewController ()
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end

@implementation ServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON;
    K_NAVIGATION_TITLE(@"服务协议")
    [self sendServiceAgreementRequest];
}

- (void)sendServiceAgreementRequest {
    NSDictionary *params = @{@"id" : @"2"};
    [[HttpRequestTool shareInstance] GET:K_URL(userSet_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary *data = responseObject[@"data"];
        if(![NSString isBlankString:data[@"content"]]) {
            self.myTextView.text = data[@"content"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
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
