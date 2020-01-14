//
//  XLDeviceMacro.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLDeviceMacro_h
#define XLDeviceMacro_h
#import "XLDevice.h"

// 屏幕尺寸
#define XLScreenBounds      [[XLDevice xlDevice] xlScreenBounds]
// 屏幕大小
#define XLScreenSize        [[XLDevice xlDevice] xlScreenHeight]
// 屏幕宽度
#define XLScreenWidth       [[XLDevice xlDevice] xlScreenWidth]
// 屏幕高度
#define XLScreenHeight      [[XLDevice xlDevice] xlScreenHeight]

// 设备：简单的判断方法,详细的参考：UIDevice+XLCategory.h
#define XLIsiPad     [[XLDevice xlDevice] xlIsiPad]     // iPad
#define XLIsiPhone   [[XLDevice xlDevice] xlIsiPhone]   // iPhone
#define XLIsRetina   [[XLDevice xlDevice] xlIsRetina]   // 是否为retina屏幕

/// 小屏幕
#define XLMiniScreen    [[XLDevice xlDevice] xlMiniScreen]
/// 手机型号
#define XLiPhone4       [[XLDevice xlDevice] xliPhone4]
#define XLiPhone5       [[XLDevice xlDevice] xliPhone5]
#define XLiPhone5S      [[XLDevice xlDevice] xliPhone5s]
// iPhone 6/7/8系列屏幕一致
#define XLiPhone6       [[XLDevice xlDevice] xliPhone6]
// iPhone 6p/7p/8p系列屏幕一致
#define XLiPhone6P      [[XLDevice xlDevice] xliPhone6p]

/// 刘海屏
#define XLBangsScreen   [[XLDevice xlDevice] xlBangsScreen]

/// iPhone Pro, iPHone X, iPhone Xs
#define XLiPhoneX       [[XLDevice xlDevice] xliPhoneX]
/// iPhone XR：包含缩水屏（750, 1624）
#define XLiPhoneXR      [[XLDevice xlDevice] xliPhoneXR]
/// XLiPhoneXSMax、iPhone Pro Max 尺寸一致
#define XLiPhoneXsMax   [[XLDevice xlDevice] xliPhoneXsMax]

// 状态栏高度
#define XLStatusBarHeight   [[XLDevice xlDevice] xlStatusBarHeight]
#define XLNavBarHeight      [[XLDevice xlDevice] xlNaviBarHeight]
// 顶部高度
#define XLNavTopHeight      [[XLDevice xlDevice] xlNaviTopTotalHeight]
// 底部高度
#define XLNavBottomHeight   [[XLDevice xlDevice] xlNaviBottomTotalHeight]

#endif /* XLDeviceMacro_h */
