//
//  XLDeviceMacro.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLDeviceMacro_h
#define XLDeviceMacro_h

static inline CGFloat XLScreenScale(){
    return [UIScreen mainScreen].scale;
}
static inline CGFloat XLScreenNativeScale(){
    return [UIScreen mainScreen].nativeScale;
}

// 屏幕物理尺寸
static inline CGRect XLScreenNativeBounds(){
    return [UIScreen mainScreen].nativeBounds;
}
// 屏幕物理大小
static inline CGSize XLScreenNativeSize(){
    return [UIScreen mainScreen].nativeBounds.size;
}
// 屏幕物理宽度
static inline CGFloat XLScreenNativeWidth(){
    return [UIScreen mainScreen].nativeBounds.size.width;
}
// 屏幕物理高度
static inline CGFloat XLScreenNativeHeight(){
    return [UIScreen mainScreen].nativeBounds.size.height;
}

// 屏幕尺寸
static inline CGRect XLScreenBounds(){
    return [UIScreen mainScreen].bounds;
}
// 屏幕大小
static inline CGSize XLScreenSize(){
    return [UIScreen mainScreen].bounds.size;
}
// 屏幕宽度
static inline CGFloat XLScreenWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}
// 屏幕高度
static inline CGFloat XLScreenHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}

// 设备：简单的判断方法,详细的参考：UIDevice+XLCategory.h
static inline BOOL XLIsiPad(){
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

static inline BOOL XLIsiPhone(){
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

static inline BOOL XLMiniScreen(){
//    [UIScreen mainScreen].bounds.size.height < 568.0f &&
    return [UIScreen mainScreen].bounds.size.width <= 568.0f;
}
static inline BOOL XLiPhone4(){
    return [UIScreen mainScreen].bounds.size.height < 568.0f && [UIScreen mainScreen].bounds.size.width < 568.0f;
}
static inline BOOL XLiPhone5(){
    return [UIScreen mainScreen].bounds.size.height == 568.0f || [UIScreen mainScreen].bounds.size.width == 568.0f;
}
static inline BOOL XLiPhone5s(){
    return [UIScreen mainScreen].bounds.size.height == 640.0f || [UIScreen mainScreen].bounds.size.width < 640.0f;
}
static inline BOOL XLiPhone6(){
    return [UIScreen mainScreen].bounds.size.height == 667.0f || [UIScreen mainScreen].bounds.size.width == 667.0f;
}
static inline BOOL XLiPhone6p(){
    return [UIScreen mainScreen].bounds.size.height == 736.0f || [UIScreen mainScreen].bounds.size.width == 736.0f;
}

static inline BOOL XLiPhoneXR(){
    return [UIScreen mainScreen].bounds.size.height == 828.0f || [UIScreen mainScreen].bounds.size.width < 828.0f || [UIScreen mainScreen].bounds.size.height == 750.0f || [UIScreen mainScreen].bounds.size.width < 750.0f;
}
static inline BOOL XLiPhoneX(){
    return [UIScreen mainScreen].bounds.size.height < 736.0f || [UIScreen mainScreen].bounds.size.width == 736.0f;
}
static inline BOOL XLiPhoneXsMax(){
    return [UIScreen mainScreen].bounds.size.height == 1242.0f || [UIScreen mainScreen].bounds.size.width == 1242.0f;
}

static inline BOOL XLBangsScreen(){
    return [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0;
}

// 状态栏高度
static inline CGFloat XLStatusBarHeight(){
    return [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0 ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top : 20.0f;
}

static inline CGFloat XLNavBottomHeight(){
    return [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0 ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom : 0.0f;
}

// 状态栏高度
static inline CGFloat XLNavBarHeight(){
    return 44.0f;
}

static inline CGFloat XLNavTopHeight(){
    return ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0 ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top : 20.0f) + 44.0f;
}

#endif /* XLDeviceMacro_h */
