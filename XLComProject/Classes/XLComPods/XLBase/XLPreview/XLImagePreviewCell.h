//
//  XLImagePreviewCell.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/12/1.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLImagePreviewView.h"

NS_ASSUME_NONNULL_BEGIN

@class XLPreviewItemInfo;
@interface XLImagePreviewCell : UICollectionViewCell
@property (nonatomic, strong)   XLPreviewItemInfo *itemInfo;
@property (nonatomic, readonly) XLImagePreviewView *previewView;

/// 清理背景
- (void)clearBackgroundColor;
- (void)recoverPreviewView;
@end

NS_ASSUME_NONNULL_END
