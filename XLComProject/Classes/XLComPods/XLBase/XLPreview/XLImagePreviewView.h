//
//  XLImagePreviewView.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/12/1.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPreviewItemInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// 图片预览
@interface XLImagePreviewView : UIView
@property (nonatomic, strong) XLPreviewItemInfo *itemInfo;

@property (nonatomic, readonly) UIView          *previewView;
@property (nonatomic, readonly) UIImageView     *previewImageView;  /// 预览图片
/// 清理背景
- (void)clearBackgroundColor;
- (void)recoverPreviewView;

@end

NS_ASSUME_NONNULL_END
