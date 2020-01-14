//
//  XLPreviewItemInfo.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/12/1.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, XLPreviewItemType) {
    XLPreviewItemImage,
    XLPreviewItemImageView,
    XLPreviewItemSDImageView,
    XLPreviewItemImageUrl
};

/// 预览信息
@interface XLPreviewItemInfo : NSObject

/// 预览内容：Image/ImageView/Url
@property (nonatomic, strong) id                originalPreviewInfo;
/// 预览类型
@property (nonatomic, assign) XLPreviewItemType previewItemType;
/// 原图位置：用于预览取消
@property (nonatomic, assign) CGRect            originalFrame;      /// 原位置
@property (nonatomic, assign) CGRect            previewFrame;       /// 预览位置
@property (nonatomic, assign) NSInteger         showIndex;          /// 显示位置：默认0

@property (nonatomic, assign) BOOL  previewHasShow;    // 当前预览图是否显示

-(void)setPreviewImage:(UIImage *)previewImage
               atIndex:(NSInteger)index;
-(void)setPreviewImageUrl:(NSString *)imageUrl
                  atIndex:(NSInteger)index;
-(void)setPreviewImageView:(UIImageView *)previewImageView
                   atIndex:(NSInteger)index;
-(void)setPreviewSDImageView:(UIImageView *)previewImageView
                     atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
