//
//  UIImage+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XLCategory)
/**
 重新绘制图片
 
 @param image 目标图片
 @param color 填充色
 @return UIImage 重绘后图片
 */
+ (UIImage *)reDrawImage:(UIImage *)image withColor:(UIColor *)color;

/**
 获取视频缩略图

 @param videoURL 视频地址
 @param time 时间
 @return 缩略图
 */
+(UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 图片压缩：默认宽度最大：1024.0f 大小：2.0M

 @param image 原图
 @return 压缩后图片
 */
+(UIImage *)comparessImage:(UIImage *)image;

/**
 图片压缩

 @param image 目标图片
 @param maxLength 图片尺寸限制
 @param maxSize 图片大小限制
 @return 压缩后图片
 */
+(UIImage *)comparessImage:(UIImage *)image maxLength:(CGFloat)maxLength maxSize:(CGFloat)maxSize;

/**
 等比压缩图片

 @param image 原图
 @param scale 压缩比例
 @return 压缩后图片
 */
+(UIImage *)comparessImage:(UIImage *)image scale:(CGFloat)scale;

/**
 获取灰度图片

 @param image 原图
 @return 灰度图
 */
+(UIImage*)grayImage:(UIImage*)image;

/**
 采用drawinrect截取图片的一部分

 @param image 原图
 @param viewsize 截图位置
 @return 截图
 */
+(UIImage *)image:(UIImage *)image fillSize:(CGSize)viewsize;

/**
 截取图片的一部分
 
 @param image 原图
 @param rect 截图区域
 @return 截图
 */
+(UIImage *)image:(UIImage *)image toRect:(CGRect)rect;

/**
 根据宽高比，采用drawinrect截取图片的一部分

 @param image 原图
 @param aspectRatio 比例
 @return 截图
 */
+(UIImage *)image:(UIImage *)image aspectRatio:(float)aspectRatio;

/**
 生成纯色image

 @param color 颜色值
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 生成纯色image
 
 @param color 颜色值
 @param alpha 透明度
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha;
/**
 生成纯色image
 
 @param color 颜色值
 @param size 大小
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 生成纯色的圆角图片
 
 @param color          图片颜色
 @param size           图片大小
 @param cornerRadius   圆角弧度
 @param rectCornerType 圆角位置
 @return 纯色圆角图片
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

/// 图片毛玻璃效果
/// @param image <#image description#>
/// @param maskImage <#maskImage description#>
/// @param blur <#blur description#>
+(UIImage *)moBlurryImage:(UIImage *)image withMaskImage:(UIImage *)maskImage blurLevel:(CGFloat)blur;
/**
 截屏
 
 @param view 需要截屏内容的view
 @return 截屏图片
 */
+(UIImage *)screenCaptureFromView:(UIView*)view;

/**
 图片二值化：将图片黑白处理
 */
-(UIImage *)covertToGrayScale;
@end

NS_ASSUME_NONNULL_END
