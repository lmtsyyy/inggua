//
//  HowUseViewController.m
//  PrintMelon
//
//  Created by andy on 2019/3/19.
//  Copyright © 2019 intellifusion. All rights reserved.
//

#import "HowUseViewController.h"
#import <WebKit/WebKit.h>

@interface HowUseViewController ()<UIWebViewDelegate>

//@property (nonatomic, strong) WKWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation HowUseViewController

//- (WKWebView *)myWebView {
//    if(!_myWebView) {
//        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
//        //注册方法
//        //    [configuration.userContentController addScriptMessageHandler:self name:@"方法名"];
//        //    configuration.userContentController addsc
//
//        _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:configuration];
//        _myWebView.UIDelegate = self;
//        _myWebView.navigationDelegate = self;
//    }
//    return _myWebView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    NSString *title = @"";
    NSString *htmlName = @"";
    if(self.agreementType == LM_AGREEMENT_HOWUSE) {
        htmlName = @"HowToUse";
        title = @"如何使用";
    }else if (self.agreementType == LM_AGREEMENT_SERVICE) {
        htmlName = @"Protocol";
        title = @"服务协议";
    }else if (self.agreementType == LM_AGREEMENT_STATEMENT) {
        htmlName = @"Secret";
        title = @"说明";
    }
    K_NAVIGATION_TITLE(title)

    NSString *filePath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [self.myWebView loadRequest:urlRequest];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HowToUse" ofType:@"html"];
//    [self.myWebView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:filePath]];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"HowToUse.html" withExtension:nil];
//    [self.myWebView loadFileURL:url allowingReadAccessToURL:url];
    
    [self.myWebView loadRequest:urlRequest];
    [LMCommonTool show];
    
//    if (self.myWebView.canGoBack == YES) {
//        [self.myWebView goBack];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//
    
//    [self sendHowUseRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(!webView.isLoading) {
        [LMCommonTool dismiss];
    }
}

//- (void)sendHowUseRequest {
//    NSString *type = @"1";
//    if(self.agreementType == LM_AGREEMENT_HOWUSE) {
//        type = @"1";
//    }else if (self.agreementType == LM_AGREEMENT_SERVICE) {
//        type = @"2";
//    }else if (self.agreementType == LM_AGREEMENT_STATEMENT) {
//        type = @"3";
//    }
//    NSDictionary *params = @{@"id" : type};
//    [[HttpRequestTool shareInstance] GET:K_URL(userSet_URL) parameters:params success:^(id responseObject) {
//        NSLog(@"responseObject = %@",responseObject);
//        NSDictionary *data = responseObject[@"data"];
//        if(![NSString isBlankString:data[@"content"]]) {
//            self.myTextView.text = data[@"content"];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"error = %@",error.localizedDescription);
//    }];
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
