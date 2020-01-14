//
//  XLLayoutConfig.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/22.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseConfig.h"
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLLayoutConfig : XLBaseConfig
#pragma mark - Margin

/// 按钮水平边距：默认35.0f
@property (nonatomic, assign) CGFloat xlBtnHMargin;
/// 外部左右边距：默认16.0f
@property (nonatomic, assign) CGFloat xlHMargin;
/// 外部上下边距：默认12.0f
@property (nonatomic, assign) CGFloat xlVMargin;
/// 内部左右间距：默认10.0f
@property (nonatomic, assign) CGFloat xlHSpace;
/// 内部上下间距：默认8.0f
@property (nonatomic, assign) CGFloat xlVSpace;
/// 内部左右最小间距：默认5.0f
@property (nonatomic, assign) CGFloat xlHMinSpace;

#pragma mark - Frame
/// 分割线宽：默认0.5f
@property (nonatomic, assign) CGFloat xlCellSepHeight;
/// 线宽：默认0.5f
@property (nonatomic, assign) CGFloat xlBorderSepWidth;
/// 按钮圆角：默认5.0f
@property (nonatomic, assign) CGFloat xlButtonRadius;
/// 输入框圆角：默认3.0f
@property (nonatomic, assign) CGFloat xlInputViewRadius;
/// 内容背景圆角：3.0f
@property (nonatomic, assign) CGFloat xlContentViewRadius;

#pragma mark - Cell
/// 图标大小：默认24.0
@property (nonatomic, assign) CGFloat xlCellIcoWidth;
@end

NS_ASSUME_NONNULL_END
