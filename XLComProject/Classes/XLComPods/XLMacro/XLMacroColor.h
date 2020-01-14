//
//  XLMacroColor.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLMacroColor_h
#define XLMacroColor_h
#import "XLComPods.h"

// RGB Color
#define XLRGBAColor(r, g, b, a)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define XLRGBColor(r, g, b)           [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]

// 16进制值转换
#define XLHexColor(hex)       [UIColor colorWithHexString:hex]
#define XLHexAColor(hex, a)   [UIColor colorWithHexString:hex alpha:(a)]

/// 主题色：默认@"#FFFFFF"
#define  XLThemeColor       [XLComPods manager].colorConfig.xlThemeColor

/// 导航栏颜色：默认"#030303"
#define  XLBarTitleColor    [XLComPods manager].colorConfig.xlBarTitleColor
/// 导航栏颜色：xlBarTitleColor
#define  XLBarItemColor     [XLComPods manager].colorConfig.xlBarItemColor

/// 背景颜色：默认"#F6F6F6"
#define  XLComBGColor       [XLComPods manager].colorConfig.xlComBGColor
/// 内容背景颜色：默认"#FFFFFF"
#define  XLContBGColor      [XLComPods manager].colorConfig.xlContBGColor
/// 内容分割背景颜色：默认"#F6F6F6"
#define  XLContSepColor     [XLComPods manager].colorConfig.xlContSepColor

/// 分割线颜色：默认"#E6E6E6"
#define  XLComSepColor      [XLComPods manager].colorConfig.xlComSepColor

/// 标题颜色：默认"#333333"
#define  XLTitleColor       [XLComPods manager].colorConfig.xlTitleColor
/// 副标题颜色：默认"#999999"
#define  XLSubTitleColor    [XLComPods manager].colorConfig.xlSubTitleColor
/// 详情颜色：默认"#333333"
#define  XLDetailColor      [XLComPods manager].colorConfig.xlDetailColor
/// 提示语颜色：默认"#999999"
#define  XLTipsColor        [XLComPods manager].colorConfig.xlTipsColor
/// 提醒、警示语颜色"#FA5151"
#define  XLWarningColor     [XLComPods manager].colorConfig.xlWarningColor
/// 占位符颜色：默认"#999999"
#define  XLHolderColor      [XLComPods manager].colorConfig.xlHolderColor
/// 其他信息颜色：时间等 默认"#999999"
#define  XLOtherColor       [XLComPods manager].colorConfig.xlOtherColor

#endif /* XLMacroColor_h */
