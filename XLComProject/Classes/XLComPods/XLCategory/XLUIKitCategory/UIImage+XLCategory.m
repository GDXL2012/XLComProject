//
//  UIImage+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIImage+XLCategory.h"
#import <AVFoundation/AVFoundation.h>
#import "XLMacroLayout.h"
#import "XLDeviceMacro.h"

@implementation UIImage (XLCategory)

+ (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                          minSize:(CGSize)imageMinSize
                          maxSize:(CGSize)imageMaxSiz{
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width,  imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight *imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}

/**
 重新绘制图片
 
 @param image 目标图片
 @param color 填充色
 @return UIImage
 */
+ (UIImage *)reDrawImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 获取视频缩略图
 
 @param videoURL 视频地址
 @param time 时间
 @return 缩略图
 */
+(UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    if (!asset) {
        return nil;
    }
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef){
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

/**
 图片压缩: 默认宽度最大：1024.0f 大小：2.0M
 
 @param image 原图
 @return 压缩后图片
 */
+(UIImage *)comparessImage:(UIImage *)image{
    return [UIImage comparessImage:image maxLength:1024.0f maxSize:2.0f];
}

/**
 图片压缩
 
 @param image 目标图片
 @param maxLength 图片尺寸限制
 @param maxSize 图片大小限制
 @return 压缩后图片
 */
+(UIImage *)comparessImage:(UIImage *)image maxLength:(CGFloat)maxLength maxSize:(CGFloat)maxSize{
    CGSize size = image.size;
    CGFloat imgLength = MAX(size.width, size.height);
    // 1.尺寸压缩
    if (imgLength > maxLength) {
        // 宽度超出限制，计算压缩比例，并进行压缩
        CGFloat scale = maxLength / imgLength;
        image = [UIImage comparessImage:image scale:scale];
    }
    NSData *data = UIImageJPEGRepresentation(image, 1);
    long long bitSize = maxSize * 1024 * 1024;
    if (data.length < bitSize){
        return image;
    }
    
    // 2.质量压缩
    CGFloat compression = 1;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < bitSize * 0.9) {
            min = compression;
        } else if (data.length > bitSize) {
            max = compression;
        } else {
            break;
        }
    }
    return [UIImage imageWithData:data];
}

/**
 等比压缩图片:尺寸压缩，图片失真会比较严重
 
 @param image 原图
 @param scale 压缩比例
 @return 压缩后图片
 */
+(UIImage *)comparessImage:(UIImage *)image scale:(CGFloat)scale{
    CGSize orginalSize = image.size;
    CGSize newSize = CGSizeMake(orginalSize.width * scale, orginalSize.height * scale);
//    UIGraphicsBeginImageContext(newSize); 失真严重，弃用
    /// 第一个参数表示区域大小。第二个参数表示是否是非透明的。
    /// 如果需要显示半透明效果,需要传NO,否则传YES。第三个参数图片密度
    UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 获取灰度图片
 
 @param image 原图
 @return 灰度图
 */
+(UIImage*)grayImage:(UIImage*)image{
    int width = image.size.width;
    int height = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), image.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}

/**
 采用drawinrect截取图片的一部分
 
 @param image 原图
 @param viewsize 截图位置
 @return 截图
 */
+(UIImage *)image:(UIImage *)image fillSize:(CGSize)viewsize{
    CGFloat scale = viewsize.width / viewsize.height;
    return [UIImage image:image aspectRatio:scale];
}

/**
 截取图片的一部分:比使用drawinrect速度更快
 
 @param image 原图
 @param CGSize 截图大小
 @return 截图
 */
+(UIImage *)image:(UIImage *)image toSize:(CGSize)toSize{
    CGFloat scale = toSize.width / toSize.height;
    return [UIImage image:image toRatio:scale];
}

/**
 截取图片的一部分:比使用drawinrect速度更快
 
 @param image 原图
 @param toRatio 截图比例
 @return 截图
 */
+(UIImage *)image:(UIImage *)image toRatio:(CGFloat)toRatio{
    CGSize size = image.size;
    float imgAspectRatio = size.width / size.height;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (imgAspectRatio > toRatio) {
        // 宽需要剪切
        width = height * toRatio;
    } else {
        // 高度需要剪切
        height = width * toRatio;
    }
    
    float datX = ((size.width - width) / 2.0f);
    float datY = ((size.height - height) / 2.0f);
    CGRect rect = CGRectMake(datX * image.scale, datY * image.scale, width * image.scale, height * image.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

/**
 截取图片的一部分
 
 @param image 原图
 @param rect 截图区域
 @return 截图
 */
+(UIImage *)image:(UIImage *)image toRect:(CGRect)rect{
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    // determine the orientation of the image and apply a transformation to the crop rectangle to shift it to the correct position
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };

    rect = CGRectMake(rect.origin.x * image.scale, rect.origin.y * image.scale, rect.size.width * image.scale, rect.size.height * image.scale);
    
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);

    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rect, rectTransform);
    // use the rect to crop the image
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, transformedCropSquare);
    // create a new UIImage and set the scale and orientation appropriately
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    // memory cleanup
    CGImageRelease(imageRef);
    return cropped;
}

/**
 根据宽高比，采用drawinrect截取图片的一部分
 
 @param image 原图
 @param aspectRatio 比例
 @return 截图
 */
+(UIImage *)image:(UIImage *)image aspectRatio:(float)aspectRatio{
    CGSize size = image.size;
    float imgAspectRatio = size.width / size.height;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (imgAspectRatio > aspectRatio) {
        // 宽需要剪切
        width = height * aspectRatio;
    } else {
        // 高度需要剪切
        height = width / aspectRatio;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, image.scale);
//    UIGraphicsBeginImageContext(CGSizeMake(width, height));
//    CGFloat scale = [UIScreen mainScreen].scale;
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, scale);
    float dwidth = ((width - size.width) / 2.0f);
    float dheight = ((height - size.height) / 2.0f);
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

/**
 生成纯色image
 
 @param color 颜色值
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color{
    return [UIImage imageWithColor:color alpha:1.0];
}
/**
 生成纯色image
 
 @param color 颜色值
 @param alpha 透明度
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha{
    CGSize size = CGSizeMake(1.0f, 1.0f);
    return [UIImage imageWithColor:color size:size alpha:alpha];
}

/**
 生成纯色分割线image
 
 @param color 颜色值
 @param alpha 透明度
 @return 纯色图片
 */
+ (UIImage *)sepImageWithColor:(UIColor *)color alpha:(CGFloat)alpha{
    return [UIImage imageWithColor:color size:CGSizeMake(XLScreenWidth(), XLCellSepHeight) alpha:alpha];
}

/**
 生成纯色image
 
 @param color 颜色值
 @param size 大小
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    return [UIImage imageWithColor:color size:size alpha:1.0f];
}

/**
 生成纯色image
 
 @param color 颜色值
 @param size 大小
 @param alpha 透明度
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 生成纯色的圆角图片
 
 @param color          图片颜色
 @param size           图片大小
 @param cornerRadius   圆角弧度
 @param rectCornerType 圆角位置
 @return 纯色圆角图片
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    if (nil == UIGraphicsGetCurrentContext()) {
        return nil;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)moBlurryImage:(UIImage *)image withMaskImage:(UIImage *)maskImage blurLevel:(CGFloat)blur {
    // 创建属性
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    //滤镜效果高斯模糊
    // CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //    [filter setValue:cimage forKey:kCIInputImageKey];
    //    // 指定模糊值 默认为10, 范围为0-100
    //    [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    /**
     *  滤镜效果VariableBlur
     * 此滤镜模糊图像具有可变模糊半径。你提供和目标图像相同大小的灰度图像为它指定模糊半径
     * 白色的区域模糊度最高，黑色区域则没有模糊。
     * */
    CIFilter *filter = [CIFilter filterWithName:@"CIMaskedVariableBlur"];
    // 指定过滤照片
    [filter setValue:ciImage forKey:kCIInputImageKey];
    CIImage *mask = [CIImage imageWithCGImage:maskImage.CGImage] ;
    // 指定 mask image
    [filter setValue:mask forKey:@"inputMask"];
    // 指定模糊值  默认为10, 范围为0-100
    [filter setValue:[NSNumber numberWithFloat:blur] forKey: @"inputRadius"];
    // 生成图片
    CIContext *context = [CIContext contextWithOptions:nil];
    // 创建输出
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    // 下面这一行的代码耗费时间内存最多,可以开辟线程处理然后回调主线程给imageView赋值
    //result.extent 指原来的大小size
    //    NSLog(@"%@",NSStringFromCGRect(result.extent));
    //    CGImageRef outImage = [context createCGImage: result fromRect: result.extent];
    CGImageRef outImage = [context createCGImage:result fromRect:frame];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

/**
 截屏
 
 @param view 需要截屏内容的view
 @return 截屏图片
 */
+(UIImage *)screenCaptureFromView:(UIView*)view fillRadius:(BOOL)fillRadius{
    CGRect rect = view.layer.bounds;
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(view.layer.cornerRadius > 0 && fillRadius){ // 有圆角，填充下背景颜色
        CGContextSetFillColorWithColor(context, view.backgroundColor.CGColor);
        CGContextAddRect(context, view.bounds);
        CGContextFillPath(context);
    } else if(view.layer.cornerRadius > 0 && !fillRadius){
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:view.layer.cornerRadius];
        [clipPath addClip];
    }
    
    // 2.将控制器view的layer渲染到上下文
    [view.layer renderInContext:context];
    // 3.取出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束上下文
    UIGraphicsEndImageContext();
    return img;
}

/**
 截屏
 
 @param view 需要截屏内容的view
 @return 截屏图片
 */
+(UIImage *)screenCaptureFromView:(UIView*)view{
    return [UIImage screenCaptureFromView:view fillRadius:NO];
}

/**
 图片二值化：将图片黑白处理
 */
- (UIImage *)covertToGrayScale{
    CGSize size =[self size];
    int width =size.width;
    int height =size.height;
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *)malloc(width *height *sizeof(uint32_t));
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width*height*sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // create a context with RGBA pixels
    CGContextRef context =CGBitmapContextCreate(pixels, width, height, 8, width*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    int tt =1;
    CGFloat intensity;
    int bw;
    
    for (int y = 0; y <height; y++) {
        for (int x = 0; x <width; x ++) {
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y*width+x];
            intensity = (rgbaPixel[tt] + rgbaPixel[tt + 1] + rgbaPixel[tt + 2]) / 3. / 255.;
            bw = intensity > 0.45?255:0;
            rgbaPixel[tt] = bw;
            rgbaPixel[tt + 1] = bw;
            rgbaPixel[tt + 2] = bw;
        }
    }
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

/// 修正图片转向
+ (UIImage *)fixOrientationForImage:(UIImage *)aImage{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp){
        return aImage;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 在指定区域绘制水印
-(UIImage *)xlWaterMarkString:(NSString *)mark
                       inRect:(CGRect)rect
                     withAttr:(NSDictionary *)attr{
    
//    UIGraphicsBeginImageContext(self.size);
    UIGraphicsBeginImageContextWithOptions(self.size, YES, [UIScreen mainScreen].scale);
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    [self drawInRect:CGRectMake(0.0f, 0.0f, width, height)];
  
    NSDictionary *tmpAttr = attr;;
    if(tmpAttr == nil){
        tmpAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                    NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    }
    [mark drawInRect:rect withAttributes:attr];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    return aimg;
}

// degrees 需是90的倍数
-(UIImage *)xlRotateImageWithDegrees:(NSInteger)degrees{
    degrees = degrees / 90;
    degrees = degrees % 4;
    UIImageOrientation orientation = UIImageOrientationUp;
    if(degrees == 0){
        orientation = UIImageOrientationUp;
    } else if(degrees == -1 || degrees == 3){
        orientation = UIImageOrientationLeft;
    } else if(degrees == -2 || degrees == 2){
        orientation = UIImageOrientationDown;
    } else if (degrees == 1 || degrees == -3){
        orientation = UIImageOrientationRight;
    }
    
    UIImage *image = [UIImage imageWithCGImage:self.CGImage scale:1.0f orientation:UIImageOrientationRight];
    image = [UIImage fixOrientationForImage:image];
    return image;
}

-(UIImage *)xlRotateImageRight{
    UIImage *image = [UIImage imageWithCGImage:self.CGImage scale:1.0f orientation:UIImageOrientationRight];
    image = [UIImage fixOrientationForImage:image];
    return image;
}

- (UIImage *)xlRotateImageLeft{
    UIImage *image = [UIImage imageWithCGImage:self.CGImage scale:1.0f orientation:UIImageOrientationLeft];
    image = [UIImage fixOrientationForImage:image];
    return image;
}
@end
