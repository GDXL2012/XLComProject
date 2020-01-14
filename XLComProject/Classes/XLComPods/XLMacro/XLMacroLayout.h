//
//  XLMacroLayout.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLMacroLayout_h
#define XLMacroLayout_h
#import "XLComPods.h"

#pragma mark - Margin

/// 按钮水平边距：默认35.0f
#define XLBtnHMargin        [XLComPods manager].layoutConfig.xlBtnHMargin
/// 外部左右边距：默认16.0f
#define XLHMargin           [XLComPods manager].layoutConfig.xlHMargin
/// 外部上下边距：默认12.0f
#define XLVMargin           [XLComPods manager].layoutConfig.xlVMargin
/// 内部左右间距：默认10.0f
#define XLHSpace            [XLComPods manager].layoutConfig.xlHSpace
/// 内部上下间距：默认8.0f
#define XLVSpace            [XLComPods manager].layoutConfig.xlVSpace
/// 内部左右最小间距：默认5.0f
#define XLHMinSpace         [XLComPods manager].layoutConfig.xlHMinSpace

#pragma mark - Frame
/// 分割线宽：默认0.5f
#define XLCellSepHeight     [XLComPods manager].layoutConfig.xlCellSepHeight
/// 线宽：默认0.5f
#define XLBorderSepWidth    [XLComPods manager].layoutConfig.xlBorderSepWidth
/// 按钮圆角：默认5.0f
#define XLButtonRadius      [XLComPods manager].layoutConfig.xlButtonRadius
/// 输入框圆角：默认3.0f
#define XLInputViewRadius   [XLComPods manager].layoutConfig.xlInputViewRadius
/// 内容背景圆角：3.0f
#define XLContentViewRadius [XLComPods manager].layoutConfig.xlContentViewRadius

#pragma mark - Cell
/// 图标大小：默认24.0
#define XLCellIcoWidth      [XLComPods manager].layoutConfig.xlCellIcoWidth

#endif /* XLMacroLayout_h */
