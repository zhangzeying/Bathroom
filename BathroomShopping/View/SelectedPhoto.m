//
//  SelectedPhoto.m
//  ChangShuo
//
//  Created by shenxiaofei on 3/23/15.
//  Copyright (c) 2015 ctkj. All rights reserved.
//

#import "SelectedPhoto.h"
#import "VPImageCropperViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "UIImage+Rotate.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface SelectedPhoto ()
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
VPImageCropperDelegate
>
@property(nonatomic, copy) SelectedFinished finished;
@property(nonatomic, copy) void(^cropCompletion)(VPImageCropperViewController *,UIImage *);
@property(nonatomic, weak) UIViewController *parentVC;
@property(nonatomic, assign) BOOL isOpenCamera;
@end
@implementation SelectedPhoto

#pragma mark - factory method
- (void)selectedOnePhoto:(UIViewController *)parentViewController completion:(SelectedFinished)completion

{
    self.finished = completion;
    self.parentVC = parentViewController;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地照片",nil];
    [sheet showInView:parentViewController.view];
}

- (void)cropperImage:(UIImage* )image parentViewController:(UIViewController *)parentViewController completion:(void(^)(VPImageCropperViewController*,UIImage*))completion;
{
    self.cropCompletion = completion;
    self.isOpenCamera = NO;
    //裁剪
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, parentViewController.view.frame.size.width, parentViewController.view.frame.size.width) limitScaleRatio:2.0];
    imgEditorVC.delegate = self;
    [parentViewController presentViewController:imgEditorVC animated:YES completion:nil];
}

- (void)takePhotoWithParentViewController:(UIViewController *)parentViewController completion:(SelectedFinished)completion
{
    self.parentVC = parentViewController;
    self.finished = completion;
    self.isOpenCamera = YES;
    [self takePhoto];
}

#pragma mark - 打开照相机
- (void)takePhoto
{
    __weak typeof(self) weakSelf = self;
    
    __block BOOL bCameraAccess = NO;
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted)
        {
        }
        // The user has explicitly denied permission for media capture.
        else if(authStatus == AVAuthorizationStatusDenied)
        {
        }
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        else if(authStatus == AVAuthorizationStatusAuthorized)
        {
            bCameraAccess = YES;
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
        }
        else
        {
        }
    } /* end if () */
    else
    {
        bCameraAccess = YES;
    } /* end else */
    
    if (NO == bCameraAccess)
    {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
            bCameraAccess = granted;
            [weakSelf openCamera:bCameraAccess];
        }];
    } /* end if () */
    else
    {
        [self openCamera:bCameraAccess];
    } /* end else */
}

- (void)openCamera:(BOOL)accessEnable
{
    if (accessEnable == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请进入 设置 > 隐私 > 相机 以允许“108社区”访问你的相机"
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *stPicker = [[UIImagePickerController alloc] init];
        stPicker.delegate = self;
        // 设置拍照后的图片可被编辑
        //fix 图片上传方向
        //stPicker.allowsEditing = YES;
        stPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.parentVC presentViewController:stPicker animated:YES completion:nil];
        //[self presentModalViewController:stPicker animated:YES];
    }else{
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"错误"
                                                         message:@"模拟其中无法打开照相机,请在真机中使用"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [msgbox show];
    }
}

#pragma mark - sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"拍照"]) {
        self.isOpenCamera = YES;
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self.parentVC presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 
                             }];
        }
    } else if ([btnTitle isEqualToString:@"本地照片"]) {
        self.isOpenCamera = NO;
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        
            controller.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:17.0f]};
            
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self.parentVC presentViewController:controller
                                                    animated:YES
                                                  completion:^(void){
                                                    
                                                  }];
        }
    }
}

//#pragma mark - navigation delegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//}

#pragma mark - image pick delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.isOpenCamera) {
            portraitImg = [portraitImg fixOrientation];
        } else {
            portraitImg = [self imageByScalingToMaxSize:portraitImg];
        }
        self.finished(portraitImg,NO);
        self.finished = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.finished(nil,YES);
    self.finished = nil;
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.cropCompletion(cropperViewController,editedImage);
    self.cropCompletion = nil;
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - camera utility
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL)canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL)canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if (widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
