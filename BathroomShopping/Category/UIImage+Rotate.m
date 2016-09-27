//
//  UIImage+Rotate.m
//  BathroomShopping
//
//  Created by zzy on 11/26/15.
//  Copyright © 2015 zzy. All rights reserved.
//

#import "UIImage+Rotate.h"

@implementation UIImage (Rotate)

+(UIImage *)rotateImage:(UIImage *)aImage orientation:(int)aOrientation
{
   CGImageRef imgRef = aImage.CGImage;
   
   CGFloat width = CGImageGetWidth(imgRef);
   
   CGFloat height = CGImageGetHeight(imgRef);
   
   
   
   CGAffineTransform transform = CGAffineTransformIdentity;
   
   CGRect bounds = CGRectMake(0, 0, width, height);
   
   
   
   CGFloat scaleRatio = 1;
   
   
   
   CGFloat boundHeight;
   
//   UIImageOrientation orient = aImage.imageOrientation;
   
   switch(aOrientation)
   
   {
         
      case UIImageOrientationUp: //EXIF = 1
         
         transform = CGAffineTransformIdentity;
         
         break;
         
         
         
      case UIImageOrientationUpMirrored: //EXIF = 2
         
         transform = CGAffineTransformMakeTranslation(width, 0.0);
         
         transform = CGAffineTransformScale(transform, -1.0, 1.0);
         
         break;
         
         
         
      case UIImageOrientationDown: //EXIF = 3
         
         transform = CGAffineTransformMakeTranslation(width, height);
         
         transform = CGAffineTransformRotate(transform, M_PI);
         
         break;
         
         
         
      case UIImageOrientationDownMirrored: //EXIF = 4
         
         transform = CGAffineTransformMakeTranslation(0.0, height);
         
         transform = CGAffineTransformScale(transform, 1.0, -1.0);
         
         break;
         
         
         
      case UIImageOrientationLeftMirrored: //EXIF = 5
         
         boundHeight = bounds.size.height;
         
         bounds.size.height = bounds.size.width;
         
         bounds.size.width = boundHeight;
         
         transform = CGAffineTransformMakeTranslation(height, width);
         
         transform = CGAffineTransformScale(transform, -1.0, 1.0);
         
         transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
         
         break;
         
         
         
      case UIImageOrientationLeft: //EXIF = 6
         
         boundHeight = bounds.size.height;
         
         bounds.size.height = bounds.size.width;
         
         bounds.size.width = boundHeight;
         
         transform = CGAffineTransformMakeTranslation(0.0, width);
         
         transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
         
         break;
         
         
         
      case UIImageOrientationRightMirrored: //EXIF = 7
         
         boundHeight = bounds.size.height;
         
         bounds.size.height = bounds.size.width;
         
         bounds.size.width = boundHeight;
         
         transform = CGAffineTransformMakeScale(-1.0, 1.0);
         
         transform = CGAffineTransformRotate(transform, M_PI / 2.0);
         
         break;
         
         
         
      case UIImageOrientationRight: //EXIF = 8
         
         boundHeight = bounds.size.height;
         
         bounds.size.height = bounds.size.width;
         
         bounds.size.width = boundHeight;
         
         transform = CGAffineTransformMakeTranslation(height, 0.0);
         
         transform = CGAffineTransformRotate(transform, M_PI / 2.0);
         
         break;
         
         
         
      default:
         
         [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
         
   }
   
   
   
   UIGraphicsBeginImageContext(bounds.size);
   
   
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   
   
   
   if (aOrientation == UIImageOrientationRight || aOrientation == UIImageOrientationLeft) {
      
      CGContextScaleCTM(context, -scaleRatio, scaleRatio);
      
      CGContextTranslateCTM(context, -height, 0);
      
   }
   
   else {
      
      CGContextScaleCTM(context, scaleRatio, -scaleRatio);
      
      CGContextTranslateCTM(context, 0, -height);
      
   }
   
   
   
   CGContextConcatCTM(context, transform);
   
   
   
   CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
   
   UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
   
   UIGraphicsEndImageContext();
   
   
   
   return imageCopy;
   
}


- (UIImage *)fixOrientation {
   
   // No-op if the orientation is already correct
   if (self.imageOrientation == UIImageOrientationUp) return self;
   
   // We need to calculate the proper transformation to make the image upright.
   // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
   CGAffineTransform transform = CGAffineTransformIdentity;
   
   switch (self.imageOrientation) {
      case UIImageOrientationDown:
      case UIImageOrientationDownMirrored:
         transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
         transform = CGAffineTransformRotate(transform, M_PI);
         break;
         
      case UIImageOrientationLeft:
      case UIImageOrientationLeftMirrored:
         transform = CGAffineTransformTranslate(transform, self.size.width, 0);
         transform = CGAffineTransformRotate(transform, M_PI_2);
         break;
         
      case UIImageOrientationRight:
      case UIImageOrientationRightMirrored:
         transform = CGAffineTransformTranslate(transform, 0, self.size.height);
         transform = CGAffineTransformRotate(transform, -M_PI_2);
         break;
           
       default:
           break;
   }
   
   switch (self.imageOrientation) {
      case UIImageOrientationUpMirrored:
      case UIImageOrientationDownMirrored:
         transform = CGAffineTransformTranslate(transform, self.size.width, 0);
         transform = CGAffineTransformScale(transform, -1, 1);
         break;
         
      case UIImageOrientationLeftMirrored:
      case UIImageOrientationRightMirrored:
         transform = CGAffineTransformTranslate(transform, self.size.height, 0);
         transform = CGAffineTransformScale(transform, -1, 1);
         break;
           
       default:
           break;
   }
   
   // Now we draw the underlying CGImage into a new context, applying the transform
   // calculated above.
   CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                            CGImageGetBitsPerComponent(self.CGImage), 0,
                                            CGImageGetColorSpace(self.CGImage),
                                            CGImageGetBitmapInfo(self.CGImage));
   CGContextConcatCTM(ctx, transform);
   switch (self.imageOrientation) {
      case UIImageOrientationLeft:
      case UIImageOrientationLeftMirrored:
      case UIImageOrientationRight:
      case UIImageOrientationRightMirrored:
         // Grr...
         CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
         break;
         
      default:
         CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
         break;
   }
   
   // And now we just create a new UIImage from the drawing context
   CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
   UIImage *img = [UIImage imageWithCGImage:cgimg];
   CGContextRelease(ctx);
   CGImageRelease(cgimg);
   return img;
}

@end
