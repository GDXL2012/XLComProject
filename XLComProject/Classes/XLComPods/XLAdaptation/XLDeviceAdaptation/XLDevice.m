//
//  XLDevice.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLDevice.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface XLDevice ()
/// 屏幕物理尺寸
@property (nonatomic, assign) CGRect    xlScreenNativeBounds;
@property (nonatomic, assign) CGSize    xlScreenNativeSize;
@property (nonatomic, assign) CGFloat   xlScreenNativeWidth;
@property (nonatomic, assign) CGFloat   xlScreenNativeHeight;

/// 屏幕逻辑尺寸
@property (nonatomic, assign) CGRect    xlScreenBounds;
@property (nonatomic, assign) CGSize    xlScreenSize;
@property (nonatomic, assign) CGFloat   xlScreenWidth;
@property (nonatomic, assign) CGFloat   xlScreenHeight;

/// 设备大类
@property (nonatomic, assign) BOOL xlIsiPad;
@property (nonatomic, assign) BOOL xlIsiPhone;
@property (nonatomic, assign) BOOL xlIsRetina;

@property (nonatomic, assign) BOOL xlMiniScreen;   /// 小屏
/// 非刘海屏
@property (nonatomic, assign) BOOL xliPhone4;
@property (nonatomic, assign) BOOL xliPhone5;
@property (nonatomic, assign) BOOL xliPhone5s;
@property (nonatomic, assign) BOOL xliPhone6;
@property (nonatomic, assign) BOOL xliPhone6p;

@property (nonatomic, assign) BOOL xlBangsScreen;   /// 刘海屏
@property (nonatomic, assign) BOOL xliPhoneX;       /// iPhone Pro, iPHone X, iPhone Xs
@property (nonatomic, assign) BOOL xliPhoneXR;      /// 包含缩水屏（750, 1624）
@property (nonatomic, assign) BOOL xliPhoneXsMax;   /// XLiPhoneXSMax、iPhone Pro Max 尺寸一致

@property (nonatomic, assign) CGFloat xlStatusBarHeight;    /// 状态栏高度
@property (nonatomic, assign) CGFloat xlNaviBarHeight;      /// 导航栏高度

@property (nonatomic, assign) CGFloat xlNaviTopTotalHeight;     /// 顶部高度
@property (nonatomic, assign) CGFloat xlNaviBottomTotalHeight;  /// 底部高度
@end

static XLDevice  *shareInstance;
@implementation XLDevice

+(instancetype)xlDevice{
    if (!shareInstance) {
        shareInstance = [[XLDevice alloc] init];
    }
    return shareInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _xlScreenNativeBounds   = [UIScreen mainScreen].nativeBounds;
        _xlScreenNativeSize     = _xlScreenNativeBounds.size;
        _xlScreenNativeWidth    = _xlScreenNativeSize.width;
        _xlScreenNativeHeight   = _xlScreenNativeSize.height;
        
        CGFloat nativeScale     = [UIScreen mainScreen].nativeScale;
        _xlScreenWidth          = _xlScreenNativeWidth / nativeScale;
        _xlScreenHeight         = _xlScreenNativeHeight / nativeScale;
        
        _xlScreenBounds      = CGRectMake(0, 0, _xlScreenWidth, _xlScreenHeight);
        _xlScreenSize        = _xlScreenBounds.size;
        
        UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
        
        _xlIsiPad       = (idiom == UIUserInterfaceIdiomPad);
        _xlIsiPhone     = (idiom == UIUserInterfaceIdiomPhone);
        _xlIsRetina     = (nativeScale >= 2.0);

        if (_xlIsiPhone) {
            /// 小屏幕
            _xlMiniScreen    = _xlScreenNativeHeight <= 568.0;
            /// 手机型号
            _xliPhone4       = _xlScreenHeight < 568.0;
            _xliPhone5       = [self xlCGSizeEqualToSize:CGSizeMake(640, 1136)];
            _xliPhone5s      = _xlScreenHeight == 568.0;
            // iPhone 6/7/8系列屏幕一致
            _xliPhone6       = (_xlScreenHeight == 667.0);
            // iPhone 6p/7p/8p系列屏幕一致
            _xliPhone6p      = (_xlScreenHeight == 736.0);

            // iPhone XR
            BOOL xliPhoneXR1    = [self xlCGSizeEqualToSize:CGSizeMake(828, 1792)];
            // 解决使用xib、iPhone XR缩水屏等
            BOOL xliPhoneXR2    = [self xlCGSizeEqualToSize:CGSizeMake(750, 1624)];
            /// iPhone XR
            _xliPhoneXR         = xliPhoneXR1 || xliPhoneXR2;
            
            /// iPhone Pro, iPHone X, iPhone Xs
            _xliPhoneX          = [self xlCGSizeEqualToSize:CGSizeMake(1125, 2436)];
            
            /// XLiPhoneXSMax、iPhone Pro Max 尺寸一致
            _xliPhoneXsMax      = [self xlCGSizeEqualToSize:CGSizeMake(1242, 2688)];
            
            /// 刘海屏
            _xlBangsScreen      = (_xliPhoneXR || _xliPhoneX || _xliPhoneXsMax);
        } else {
            /// 小屏幕
            _xlMiniScreen = _xliPhone4 = _xliPhone5 = _xliPhone5s = _xliPhone6 = _xliPhone6p = _xliPhoneXR = _xliPhoneX = _xliPhoneXsMax = _xlBangsScreen = NO;
        }
        // 状态栏高度
        _xlStatusBarHeight        = (_xlBangsScreen ? 44.f : 20.f);
        _xlNaviBarHeight          = 44.0f;
        // 顶部高度
        _xlNaviTopTotalHeight     = (_xlNaviBarHeight + _xlStatusBarHeight);
        // 底部高度
        _xlNaviBottomTotalHeight  = (_xlBangsScreen ? 34.f : 0.f);
    }
    return self;
}

-(BOOL)xlCGSizeEqualToSize:(CGSize)size{
    return CGSizeEqualToSize(size, _xlScreenNativeSize);
}

@end
