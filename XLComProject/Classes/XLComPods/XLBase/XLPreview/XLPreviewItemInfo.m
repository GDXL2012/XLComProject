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
    _originalPreviewInfo = previewImage;
    _previewItemType = XLPreviewItemImage;
    [self initPreviewFrameForImage];
}

-(void)setInvisablePreviewImage:(UIImage *)previewImage atVisiableView:(UIView *)visiableview atIndex:(NSInteger)index{
    _showIndex = index;
    _originalPreviewInfo = previewImage;
    _previewItemType = XLPreviewItemImage;
    [self initInvisablePreviewFrameForImage:visiableview];
}

-(void)setPreviewImageUrl:(NSString *)imageUrl atIndex:(NSInteger)index{
    _showIndex = index;
    _originalPreviewInfo = imageUrl;
    _previewItemType = XLPreviewItemImageUrl;
    [self initPreviewFrameForImage];
}
-(void)setInvisablePreviewImageUrl:(NSString *)imageUrl atVisiableView:(UIView *)visiableview atIndex:(NSInteger)index{
    _showIndex = index;
    _originalPreviewInfo = imageUrl;
    _previewItemType = XLPreviewItemImageUrl;
    [self initInvisablePreviewFrameForImage:visiableview];
}

-(void)setPreviewImageView:(UIImageView *)previewImageView atIndex:(NSInteger)index{
    _showIndex = index;
    _originalPreviewInfo = previewImageView;
    _previewItemType = XLPreviewItemImageView;
    [self initPreviewInfoForImageView];
}

-(void)setPreviewSDImageView:(UIImageView *)previewImageView atIndex:(NSInteger)index{
    _showIndex = index;
    _originalPreviewInfo = previewImageView;
    _previewItemType = XLPreviewItemSDImageView;
    [self initPreviewInfoForImageView];
}

-(void)initInvisablePreviewFrameForImage:(UIView *)visableView{
    /// 设置原位置
    CGFloat datX = CGRectGetMaxX(visableView.frame) + 50.0f;
    CGFloat datY = CGRectGetMaxY(visableView.frame) + 50.0f;
    _originalFrame = CGRectMake(datX, datY, 0.0f, 0.0f);
    /// 预览图片的位置
    _previewFrame = self.originalFrame;
    self.imageSize = self.originalFrame.size;
    _previewFrame.origin.x = self.showIndex * XLScreenWidth + _previewFrame.origin.x;
}

-(void)initPreviewFrameForImage{
    /// 设置原位置
    _originalFrame = CGRectMake(XLScreenWidth / 2.0f, XLScreenHeight / 2.0f, 0.0f, 0.0f);
    /// 预览图片的位置
    _previewFrame = self.originalFrame;
    self.imageSize = self.originalFrame.size;
    _previewFrame.origin.x = self.showIndex * XLScreenWidth + _previewFrame.origin.x;
}

//// ImageView 预览初始化
-(void)initPreviewInfoForImageView{
    /// 计算原图位置
    UIImageView *originalImageView = (UIImageView *)self.originalPreviewInfo;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *superView = originalImageView.superview;
    CGRect newRect = [window convertRect:originalImageView.frame fromView:superView];
    self.originalFrame = newRect;
    if (originalImageView.image) {
        self.imageSize = originalImageView.image.size;
    } else {
        self.imageSize = newRect.size;
    }
    
    /// 预览图片的位置
    _previewFrame = self.originalFrame;
    _previewFrame.origin.x = self.showIndex * XLScreenWidth + _previewFrame.origin.x;
}
@end
