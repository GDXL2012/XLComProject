//
//  XLMacroLayout.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLMacroLayout_h
#define XLMacroLayout_h
#import "XLConfigManager.h"

#pragma mark - Margin

/// 按钮水平边距：默认35.0f
#define XLBtnHMargin        [XLConfigManager xlConfigManager].layoutConfig.xlBtnHMargin
/// 外部左右边距：默认15.0f
#define XLHMargin           [XLConfigManager xlConfigManager].layoutConfig.xlHMargin
/// 外部上下边距：默认12.0f
#define XLVMargin           [XLConfigManager xlConfigManager].layoutConfig.xlVMargin
/// 内部左右间距：默认10.0f
#define XLHSpace            [XLConfigManager xlConfigManager].layoutConfig.xlHSpace
/// 内部上下间距：默认8.0f
#define XLVSpace            [XLConfigManager xlConfigManager].layoutConfig.xlVSpace
/// 内部左右最小间距：默认5.0f
#define XLHMinSpace         [XLConfigManager xlConfigManager].layoutConfig.xlHMinSpace

#pragma mark - Frame
/// 分割线宽：默认0.5f
#define XLCellSepHeight     [XLConfigManager xlConfigManager].layoutConfig.xlCellSepHeight
/// 线宽：默认0.5f
#define XLBorderSepWidth    [XLConfigManager xlConfigManager].layoutConfig.xlBorderSepWidth
/// 按钮圆角：默认5.0f
#define XLButtonRadius      [XLConfigManager xlConfigManager].layoutConfig.xlButtonRadius
/// 输入框圆角：默认3.0f
#define XLInputViewRadius   [XLConfigManager xlConfigManager].layoutConfig.xlInputViewRadius
/// 内容背景圆角：3.0f
#define XLContentViewRadius [XLConfigManager xlConfigManager].layoutConfig.xlContentViewRadius

#pragma mark - Cell
/// 图标大小：默认24.0
#define XLCellIcoWidth      [XLConfigManager xlConfigManager].layoutConfig.xlCellIcoWidth

#endif /* XLMacroLayout_h */
