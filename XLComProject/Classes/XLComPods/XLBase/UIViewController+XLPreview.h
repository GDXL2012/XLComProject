//
//  UIViewController+XLPreview.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, XLImagePreviewOpItems) {
    XLImagePreviewOpNone        = 0,        /// 不显示更多操作
    XLImagePreviewOpDowload     = 1 << 0,   /// 显示下载原图
    XLImagePreviewOpEdit        = 1 << 1,   /// 显示编辑
    XLImagePreviewOpDelete      = 1 << 2,   /// 显示删除
    XLImagePreviewOpMore        = 1 << 3    /// 显示更多
};

@protocol XLImagePreviewDataSource <NSObject>

@required
/// 预览图片数
-(NSInteger)countOfPreviewImage;

/// 可见图片
-(UIImageView *)visablePreviewImageAtIndex:(NSInteger)atIndex;
/// 可见图片加载路劲：本地图片可以为空，用于加载远端图片
-(NSString *)visablePreviewImagePathAtIndex:(NSInteger)atIndex;
/// 页面不可见图片预览信息：图片或者地址
-(NSObject *)invisablePreviewImageAtIndex:(NSInteger)atIndex;

@end

@protocol XLImagePreviewProtocol <NSObject>
@optional
/// 图片预览操作按钮显示
-(XLImagePreviewOpItems)operationItemsForPreviewImageAtIndex:(NSInteger)index;
/// 是否有长按手势：defaul YES
-(BOOL)showLongPressOperationAtIndex:(NSInteger)index;
/// 编辑图片：返回nil则不会弹出编辑页面
-(void)imageForEditAtIndex:(NSInteger)index
                  complete:(void(^)(UIImage *_Nullable image, NSError *_Nullable error))complete;
/// 原图大小
-(CGFloat)orignialSizeOfRemoteImageAtIndexPath:(NSInteger)index;

/// 预览图片更多回调
-(void)moreOperationClickAtIndex:(NSInteger)index;
/// 预览图片长按回调
-(void)longPressOperationClickAtIndex:(NSInteger)index;
/// 预览图片下载回调
-(void)dowloadOperationClickAtIndex:(NSInteger)index;
/// 预览图片编辑完成回调
-(void)editCompleteForPreviewAtIndex:(NSInteger)index image:(UIImage *)image;
/// 预览图片删除回调
-(void)deleteOperationClickAtIndex:(NSInteger)index;
/// 预览图片删除提示语
-(NSString *)deleteTipsInfo:(NSInteger)index;
/// 预览取消
-(void)imagePreviewCanceled;

@end

@interface UIViewController (XLPreview)

/// 添加预览事件回调
/// @param delegate <#delegate description#>
-(void)addPreivewDelegate:(id<XLImagePreviewProtocol>)delegate;

/// 删除预览图片
-(void)deletePreviewImageAtIndex:(NSInteger)index;
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

/// 图片预览
/// @param atIndex <#atIndex description#>
/// @param dataSource <#dataSource description#>
-(void)previewImageViewAtIndex:(NSInteger)atIndex
                      delegate:(id<XLImagePreviewDataSource>)dataSource;
@end

NS_ASSUME_NONNULL_END
