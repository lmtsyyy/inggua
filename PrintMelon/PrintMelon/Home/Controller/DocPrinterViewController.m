//
//  DocPrinterViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "DocPrinterViewController.h"
#import "MyDocViewController.h"

@interface DocPrinterViewController ()<UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *wordBackV;
@property (weak, nonatomic) IBOutlet UIView *pdfBackV;
@property (weak, nonatomic) IBOutlet UIView *pptBackV;
@property (weak, nonatomic) IBOutlet UIView *wechatInputBackV;
@property (weak, nonatomic) IBOutlet UIView *qqInputBackV;
@property (weak, nonatomic) IBOutlet UIView *wpsInputBackV;
@property (weak, nonatomic) IBOutlet UIView *moreInputBackV;
@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation DocPrinterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    [self lm_setupNaviCommonBackBarItemWithImageName:nil];
    [self lm_setupNaviTitleViewWithTitle:@"文档打印" titleColor:nil];
    NSArray *views = @[self.wechatInputBackV,self.qqInputBackV,self.wpsInputBackV,self.moreInputBackV];
    for (UIView *view in views) {
        view.layer.shadowColor = [UIColor colorWithHexString:@"000000" alpha:0.1].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,1);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 3;
        view.layer.cornerRadius = 5.8;
    }
    
}

- (IBAction)wordClick:(id)sender {
    [self pushVCWithDocType:LM_MYDOC_DOC_TYPE];
}

- (IBAction)pdfClick:(id)sender {
    [self pushVCWithDocType:LM_MYDOC_PDF_TYPE];
}

- (IBAction)pptClick:(id)sender {
    [self pushVCWithDocType:LM_MYDOC_PPT_TYPE];
}

- (void)pushVCWithDocType:(MyDocType)docType {
    MyDocViewController *vc = [MyDocViewController lm_VC];
    vc.myDocType = docType;
    [self lm_pushVCAndHidesBottomBarWhenPushedWithVC:vc];
}

- (IBAction)wechatClick:(id)sender {
    if(![self openOtherAppWithSchemeStr:@"weixin://"]) {
        [LMCommonTool showInfoWithStatus:@"您还没有安装微信哦"];
    }
}

- (IBAction)qqClick:(id)sender {
    if(![self openOtherAppWithSchemeStr:@"mqq://"]) {
        [LMCommonTool showInfoWithStatus:@"您还没有安装qq哦"];
    }
}

- (IBAction)wpsClick:(id)sender {
    if(![self openOtherAppWithSchemeStr:@"KingsoftOfficeApp://"]) {
        [LMCommonTool showInfoWithStatus:@"您还没有安装wps哦"];
    }
}

- (IBAction)moreClick:(id)sender {
    
}

- (BOOL)openOtherAppWithSchemeStr:(NSString *)schemeStr {
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schemeStr]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:schemeStr]];
        return YES;
    }
    return NO;
}

- (void)openDocumentInResourceFolder {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    _documentController = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _documentController.delegate = self;
//    _documentController.UTI = @"com.printMelon.limin";
    [_documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
//    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
//    }
}

- (void)listFilesFromDocumentsFolder {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSMutableString *filesStr = [NSMutableString stringWithString:@"Documents文件夹中文件的名称： \n"];
    for (NSString *str in fileList) {
        [filesStr appendFormat:@"%@ \n", str];
    }
    [self displayAlert:filesStr];
    [self loadFileFromDocumentsFolder:[fileList lastObject]];
}

- (void)displayAlert:(NSString *)str {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadFileFromDocumentsFolder:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//    [self handleDocumentOpenURL:fileURL];
}


#pragma mark - UIDocumentInteractionControllerDelegate
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    
}
- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    
}
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    
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
