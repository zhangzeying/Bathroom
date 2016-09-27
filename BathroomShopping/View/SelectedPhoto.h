//
//  SelectedPhoto.h
//  ChangShuo
//
//  Created by shenxiaofei on 3/23/15.
//  Copyright (c) 2015 ctkj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SelectedFinished)(UIImage *image, BOOL isCancel);

@class VPImageCropperViewController;

@interface SelectedPhoto : NSObject

//选择一张图片
- (void)selectedOnePhoto:(UIViewController *)parentViewController completion:(SelectedFinished)completion;

//裁剪图片
- (void)cropperImage:(UIImage* )image parentViewController:(UIViewController *)parentViewController completion:(void(^)(VPImageCropperViewController*,UIImage*))completion;

//使用相机拍照获取 UIImage
- (void)takePhotoWithParentViewController:(UIViewController *)parentViewController completion:(SelectedFinished)completion;

@end
