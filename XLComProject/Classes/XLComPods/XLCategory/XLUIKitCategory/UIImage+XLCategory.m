//
//  UIImage+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIImage+XLCategory.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (XLCategory)
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
    CGSize size = image.size;
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    UIGraphicsBeginImageContext(viewsize);
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

/**
 截取图片的一部分
 
 @param image 原图
 @param rect 截图区域
 @return 截图
 */
+(UIImage *)image:(UIImage *)image toRect:(CGRect)rect{
    rect.origin.y = rect.origin.y + 64;
    if (image.imageOrientation != UIImageOrientationUp){
        // 矫正图片方向
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawInRect:(CGRect){0, 0, image.size}];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
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
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
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
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 生成纯色image
 
 @param color 颜色值
 @param size 大小
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
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
+(UIImage *)screenCaptureFromView:(UIView*)view{
    CGRect rect = view.frame;
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 2.将控制器view的layer渲染到上下文
    [view.layer renderInContext:context];
    // 3.取出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束上下文
    UIGraphicsEndImageContext();
    return img;
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

@end
