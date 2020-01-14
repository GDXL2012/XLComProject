//
//  UIViewController+XLPreview.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLImagePreviewProtocol <NSObject>

/// 预览图片长按事件回调
/// @param index <#index description#>
-(void)previewLongPressAtIndex:(NSInteger)index;

@end

@interface UIViewController (XLPreview)

/// 添加预览事件回调
/// @param delegate <#delegate description#>
-(void)addPreivewDelegate:(id<XLImagePreviewProtocol>)delegate;

/// 取消图片预览
-(void)cancelImagePreview;

/// 单张图片预览：默认从中间放大显示
/// @param image <#image description#>
-(void)preViewImage:(UIImage *)image;

/// 单张网络图片预览：默认从中间放大显示
/// @param imageUrl <#imageUrl description#>
-(void)preViewImageUrl:(NSString *)imageUrl;

/// 单张图片预览：根据图片位置弹出
/// @param imageView <#imageView description#>
-(void)preViewImageView:(UIImageView *)imageView;

/// 单张图片预览：弹出结合SDImageView库使用，显示网络图片
/// @param imageView <#imageView description#>
-(void)preViewSDImageView:(UIImageView *)imageView;

/// 图片预览：默认从中间放大显示
/// @param imageArray ImageArray 图片列表
/// @param selectIndex <#selectIndex description#>
-(void)previewImageArray:(NSArray *)imageArray
           atSelectIndex:(NSInteger)selectIndex;

/// 网络图片预览：默认从中间放大显示
/// @param imageUrlArray <#imageUrlArray description#>
/// @param selectIndex <#selectIndex description#>
-(void)previewImageUrlArray:(NSArray *)imageUrlArray
               atSelectIndex:(NSInteger)selectIndex;

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray ImageViewArray 图片View列表
/// @param selectIndex <#selectIndex description#>
-(void)previewImageViewArray:(NSArray *)imageViewArray
               atSelectIndex:(NSInteger)selectIndex;

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray 图片View列表：结合SDImageView库使用，显示网络图片
/// @param selectIndex 选中图片位置
-(void)previewSDImageViewArray:(NSArray *)imageViewArray
               atSelectIndex:(NSInteger)selectIndex;

/// 图片预览：默认从中间放大显示
/// @param imageArray ImageArray 图片列表
/// @param selectIndex <#selectIndex description#>
/// @param visibleView 可见区域View
-(void)previewImageArray:(NSArray *)imageArray
           atSelectIndex:(NSInteger)selectIndex
             visibleView:(UIView *)visibleView;

/// 网络图片预览：默认从中间放大显示
/// @param imageUrlArray <#imageUrlArray description#>
/// @param selectIndex <#selectIndex description#>
/// @param visibleView 可见区域View
-(void)previewImageUrlArray:(NSArray *)imageUrlArray
              atSelectIndex:(NSInteger)selectIndex
                visibleView:(UIView *)visibleView;

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray ImageViewArray 图片View列表
/// @param selectIndex <#selectIndex description#>
/// @param visibleView 可见区域View
-(void)previewImageViewArray:(NSArray *)imageViewArray
               atSelectIndex:(NSInteger)selectIndex
                 visibleView:(UIView *)visibleView;

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray 图片View列表：结合SDImageView库使用，显示网络图片
/// @param selectIndex 选中图片位置
/// @param visibleView 可见区域View
-(void)previewSDImageViewArray:(NSArray *)imageViewArray
                 atSelectIndex:(NSInteger)selectIndex
                   visibleView:(UIView *)visibleView;
@end

NS_ASSUME_NONNULL_END
