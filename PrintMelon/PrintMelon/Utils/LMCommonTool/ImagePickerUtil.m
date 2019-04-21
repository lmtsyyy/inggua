//
//  ImagePickerUtil.m
//  IFaceRecSDK1.0
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import "ImagePickerUtil.h"

@interface ImagePickerUtil()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL _istTakePhotos;//是否是直接拍照
}
@end

static ImagePickerUtil *_shareInstance = nil;

@implementation ImagePickerUtil

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[ImagePickerUtil alloc] init];
    });
    return _shareInstance;
}

- (void)openAlbumWithVC:(UIViewController *)vc getImageBlock:(GetAlbumImageBlock)getImageBlock {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; //设置代理
    imagePickerController.allowsEditing = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        _istTakePhotos = YES;
        //相机
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [vc presentViewController:imagePickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        _istTakePhotos = NO;
        //相册
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [vc presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    // 判断系统是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [alertController addAction:cameraAction];
        [alertController addAction:photoAction];
        [alertController addAction:cancelAction];
        [vc presentViewController:alertController animated:YES completion:nil];
    }else {
        [alertController addAction:photoAction];
        [alertController addAction:cancelAction];
        [vc presentViewController:alertController animated:YES completion:nil];
    }
    
    self.getAlbumImageBlock = getImageBlock;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *imageUrlStr = @"";
    if (@available(iOS 11.0, *)) {
        imageUrlStr = [info objectForKey:UIImagePickerControllerImageURL];
    } else {
        // Fallback on earlier versions
    }
    if(self.getAlbumImageBlock) {
        self.getAlbumImageBlock(image,imageUrlStr);
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
//    _istTakePhotos = NO;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//     if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypeCamera) {
//                [[UIApplication sharedApplication] setStatusBarHidden:NO];
//                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
//    }
//    
//}



@end
