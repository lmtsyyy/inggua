//
//  MyDocViewController.m
//  PrintMelon
//
//  Created by admin on 2019/3/8.
//  Copyright © 2019年 intellifusion. All rights reserved.
//

#import "MyDocViewController.h"
#import "MyDocCell.h"
#import "PrintEditViewController.h"

@interface MyDocViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, assign) BOOL isBatchPrinter;
@property (nonatomic, assign) BOOL isClickBatchPrinter;
@property (nonatomic, strong) UIButton *rightItemBtn;
@property (weak, nonatomic) IBOutlet UIView *myBottomView;
@property (weak, nonatomic) IBOutlet UIButton *printBtn;

@end

@implementation MyDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self otherSetup];
}

- (void)otherSetup {
    K_COMMOM_BACK_BUTTON
    K_NAVIGATION_TITLE(@"我的文档")
    [self lm_setupNaviRightBarItemWithTitle:@"批量打印" target:self action:@selector(batchPrint)];
    self.navigationItem.rightBarButtonItem = [self rightItem];
    self.myTableView.rowHeight = 60;
    self.myTableView.allowsMultipleSelection = YES;
//    for(int i = 0;i<10;i++) {
//        MyDocModel *model = [[MyDocModel alloc] init];
//        model.docName = @"我的文档.doc";
//        model.docPageNum = @"3页";
//        model.docTime = @"2019-03-08 12:00:00";
//        model.isHideImg = YES;
//        [self.dataSource addObject:model];
//    }
    
    [self listFilesFromDocumentsFolder];
    
    [self sendMyDocRequest];
}

- (void)listFilesFromDocumentsFolder {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *inboxPath = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:inboxPath error:nil];
    NSMutableString *filesStr = [NSMutableString stringWithString:@"Documents文件夹中文件的名称： \n"];
    for (NSString *str in fileList) {
        [filesStr appendFormat:@"%@ \n", str];
        NSString *docPath = [inboxPath stringByAppendingPathComponent:str];
        const char *resultCString = NULL;
        if ([docPath canBeConvertedToEncoding:NSUTF8StringEncoding]) {
            resultCString = [docPath cStringUsingEncoding:NSUTF8StringEncoding];
        }
//        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("公司介绍.pdf"), NULL, NULL);
        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)docPath, NULL, NULL);

        //创建CGPDFDocument对象
        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        //获取pdf文档的页数
        long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
        MyDocModel *model = [[MyDocModel alloc] init];
        model.filename = str;
//        model.docPageNum = @(pageSum).stringValue;
        model.addtime = @"2019-03-08 12:00:00";
        model.isHideImg = YES;
//        [self.dataSource addObject:model];
    }
//    [self displayAlert:filesStr];
//    [self loadFileFromDocumentsFolder:[fileList lastObject]];
    
    
}

- (void)displayAlert:(NSString *)str {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)loadFileFromDocumentsFolder:(NSString *)filename {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//    //    [self handleDocumentOpenURL:fileURL];
//}



- (UIBarButtonItem *)rightItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightItemBtn = button;
    [button setTitle:@"批量打印" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button sizeToFit];
    [button addTarget:self action:@selector(batchPrint) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)leftItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button sizeToFit];
    [button addTarget:self action:@selector(cancelPrint) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)batchPrint {
    self.isClickBatchPrinter = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.dataSource.count == 0) {
        [LMCommonTool showInfoWithStatus:@"没有需要打印的数据"];return;
    }
    _isBatchPrinter = !_isBatchPrinter;
    self.myBottomView.hidden = NO;
    self.navigationItem.leftBarButtonItem = [self leftItem];
    for (MyDocModel *model in self.dataSource) {
        model.isHideImg = NO;
    }
    if(_isBatchPrinter) {
        [self.rightItemBtn setTitle:@"全选" forState:UIControlStateNormal];
        for (MyDocModel *model in self.dataSource) {
            model.isSelected = NO;
        }
        [self.printBtn setBackgroundImage:[UIImage imageNamed:@"home_batch_gray_bg"] forState:UIControlStateNormal];
    }
    else {
        [self.rightItemBtn setTitle:@"不全选" forState:UIControlStateNormal];
        for (MyDocModel *model in self.dataSource) {
            model.isSelected = YES;
        }
        [self.printBtn setBackgroundImage:[UIImage imageNamed:@"home_batch_theme_bg"] forState:UIControlStateNormal];
    }
    [self.myTableView reloadData];
    
}

- (void)cancelPrint {
    K_COMMOM_BACK_BUTTON
    self.isClickBatchPrinter = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    self.myBottomView.hidden = YES;
    [self.rightItemBtn setTitle:@"批量打印" forState:UIControlStateNormal];
    _isBatchPrinter = NO;
    for (MyDocModel *model in self.dataSource) {
        model.isHideImg = YES;
    }
    [self.myTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    MyDocCell *cell = [MyDocCell cellWithTableView:tableView];
    cell.docModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.isClickBatchPrinter) {
        [self selectedWithTableView:tableView indexPath:indexPath];
    }else {
        PrintEditViewController *vc = [PrintEditViewController lm_VC];
        vc.printEditType = PRINT_EDIT_OTHER_TYPE;
//        NSMutableString *docIDs = [NSMutableString string];
        MyDocModel *model = self.dataSource[indexPath.row];
//        [docIDs appendFormat:@",%@",model.ID];
        vc.docIDs = model.ID;
        [self lm_pushVCWithVC:vc];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectedWithTableView:tableView indexPath:indexPath];
}

- (void)selectedWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyDocModel *model = self.dataSource[indexPath.row];
    model.isSelected = !model.isSelected;
    MyDocCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.docModel = model;
    BOOL isSelected = NO;
    for (MyDocModel *docModel in self.dataSource) {
        if(docModel.isSelected) {
            isSelected = YES;
        }
    }
    if(isSelected) {
        [self.printBtn setBackgroundImage:[UIImage imageNamed:@"home_batch_theme_bg"] forState:UIControlStateNormal];

    }else {
        [self.printBtn setBackgroundImage:[UIImage imageNamed:@"home_batch_gray_bg"] forState:UIControlStateNormal];

    }
}

- (IBAction)clickPrint:(id)sender {
    if(![self isSelectedDocWithTip:@"未选中待打印文档"]) return;
    //打印文档操作
    PrintEditViewController *vc = [PrintEditViewController lm_VC];
    vc.printEditType = PRINT_EDIT_OTHER_TYPE;
    NSMutableString *docIDs = [NSMutableString string];
    for (MyDocModel *model in self.dataSource) {
        if(model.isSelected) {
            [docIDs appendFormat:@",%@",model.ID];
        }
    }
    vc.docIDs = [self getDocIds];
    [self lm_pushVCWithVC:vc];
}

- (NSString *)getDocIds {
    NSMutableString *docIDs = [NSMutableString string];
    for (MyDocModel *model in self.dataSource) {
        if(model.isSelected) {
            [docIDs appendFormat:@",%@",model.ID];
        }
    }
    return [docIDs substringFromIndex:1];
}

- (BOOL)isSelectedDocWithTip:(NSString *)tip {
    BOOL isSelected = NO;
    for (MyDocModel *model in self.dataSource) {
        if(model.isSelected) {
            isSelected = YES;
        }
    }
    if(!isSelected) {
        [LMCommonTool showErrorWithStatus:tip];
        return NO;
    }
    return YES;
}


- (void)sendMyDocRequest {
    
    NSString *type = @"1";
    if(self.myDocType == LM_MYDOC_DOC_TYPE) {
        type = @"1";
    }else if (self.myDocType == LM_MYDOC_PDF_TYPE) {
        type = @"2";
    }else if (self.myDocType == LM_MYDOC_PPT_TYPE) {
        type = @"3";
    }
    [self.dataSource removeAllObjects];
    NSDictionary *params = @{@"uid" : [AppEntity shareInstance].userid,
                             };
    [[HttpRequestTool shareInstance] GET:K_URL(myDoc_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            NSArray *dataArr = responseObject[@"data"];
//            self.dataSource = [MyDocModel mj_objectArrayWithKeyValuesArray:dataArr];
            for (NSDictionary *dic in dataArr) {
                MyDocModel *model = [MyDocModel mj_objectWithKeyValues:dic];
                model.isHideImg = YES;
                [self.dataSource addObject:model];
            }
            
        }else {
            
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

- (IBAction)deleteDoc:(id)sender {
    if(![self isSelectedDocWithTip:@"未选中待删除文档"]) return;
    [self sendDeleteDocRequest];
}

- (void)sendDeleteDocRequest {
    
    NSDictionary *params = @{@"fid" : [self getDocIds]
                             };
    __weak typeof(self) weakSelf = self;
    [[HttpRequestTool shareInstance] GET:K_URL(deleteDoc_URL) parameters:params success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if(K_SUCCESS_CODE) {
            K_Show_Success_Tip
            weakSelf.isBatchPrinter = NO;
            [weakSelf sendMyDocRequest];
        }else {
            K_Show_Error_Tip
        }
        
    } failure:^(NSError *error) {
        
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
