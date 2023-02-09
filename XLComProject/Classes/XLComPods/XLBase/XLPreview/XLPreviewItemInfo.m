//
//  XLPreviewItemInfo.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/12/1.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLPreviewItemInfo.h"
#import "XLDeviceMacro.h"
#import <CoreGraphics/CoreGraphics.h>

@interface XLPreviewItemInfo ()
@end

@implementation XLPreviewItemInfo

-(void)setPreviewImage:(UIImage *)previewImage atIndex:(NSInteger)index{
    _showIndex = index;
    _originalImage = previewImage;
    _previewItemType = XLPreviewItemImage;
    [self initPreviewFrameForImage];
}

-(void)setInvisablePreviewImage:(UIImage *)previewImage atVisiableView:(UIView *)visiableview atIndex:(NSInteger)index{
    _showIndex = index;
    _originalImage = previewImage;
    _previewItemType = XLPreviewItemImage;
    [self initInvisablePreviewFrameForImage:visiableview];
}

-(void)setPreviewImageUrl:(NSString *)imageUrl atIndex:(NSInteger)index{
    _showIndex = index;
    _originalImagePath = imageUrl;
    _previewItemType = XLPreviewItemImageUrl;
    [self initPreviewFrameForImage];
}
-(void)setInvisablePreviewImageUrl:(NSString *)imageUrl atVisiableView:(UIView *)visiableview atIndex:(NSInteger)index{
    _showIndex = index;
    _originalImagePath = imageUrl;
    _previewItemType = XLPreviewItemImageUrl;
    [self initInvisablePreviewFrameForImage:visiableview];
}

-(void)setPreviewImageView:(UIImageView *)previewImageView
                      path:(NSString *)path
                   atIndex:(NSInteger)index{
    _showIndex = index;
    _previewItemType = XLPreviewItemImageView;
    self.originalImagePath = path;
    [self initPreviewInfoForImageView:previewImageView];
}

-(void)setPreviewSDImageView:(UIImageView *)previewImageView
                        path:(NSString *)path
                     atIndex:(NSInteger)index{
    _showIndex = index;
    _previewItemType = XLPreviewItemSDImageView;
    self.originalImagePath = path;
    [self initPreviewInfoForImageView:previewImageView];
}

-(void)initInvisablePreviewFrameForImage:(UIView *)visableView{
    /// 设置原位置
    CGFloat datX = CGRectGetMaxX(visableView.frame) + 50.0f;
    CGFloat datY = CGRectGetMaxY(visableView.frame) + 50.0f;
    _originalFrame = CGRectMake(datX, datY, 0.0f, 0.0f);
    /// 预览图片的位置
    _previewFrame = self.originalFrame;
    self.imageSize = self.originalFrame.size;
    _previewFrame.origin.x = self.showIndex * XLScreenWidth() + _previewFrame.origin.x;
}

-(void)initPreviewFrameForImage{
    /// 设置原位置
    _originalFrame = CGRectMake(XLScreenWidth() / 2.0f, XLScreenHeight() / 2.0f, 0.0f, 0.0f);
    /// 预览图片的位置
    _previewFrame = self.originalFrame;
    self.imageSize = self.originalFrame.size;
    _previewFrame.origin.x = self.showIndex * XLScreenWidth() + _previewFrame.origin.x;
}

//// ImageView 预览初始化
-(void)initPreviewInfoForImageView:(UIImageView *)imageView{
    /// 计算原图位置
    self.originalImage = imageView.image;
    self.contentMode = imageView.contentMode;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *superView = imageView.superview;
    CGRect newRect = [window convertRect:imageView.frame fromView:superView];
    self.originalFrame = newRect;
    if (imageView.image) {
        self.imageSize = imageView.image.size;
    } else {
        self.imageSize = newRect.size;
    }
    
    /// 预览图片的位置
    _previewFrame = self.originalFrame;
    _previewFrame.origin.x = self.showIndex * XLScreenWidth() + _previewFrame.origin.x;
}
@end
