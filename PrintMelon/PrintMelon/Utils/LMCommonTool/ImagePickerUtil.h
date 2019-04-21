//
//  ImagePickerUtil.h
//  IFaceRecSDK1.0
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018年 intellifusion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GetAlbumImageBlock)(UIImage *image,NSString *imageUrlStr);

@interface ImagePickerUtil : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy) GetAlbumImageBlock getAlbumImageBlock;

- (void)openAlbumWithVC:(UIViewController *)vc getImageBlock:(GetAlbumImageBlock)getImageBlock;

@end

NS_ASSUME_NONNULL_END
