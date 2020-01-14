//
//  XLDevice.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLDevice : NSObject
+(instancetype)xlDevice;

/// 屏幕尺寸
-(CGRect)xlScreenBounds;
-(CGSize)xlScreenSize;
-(CGFloat)xlScreenWidth;
-(CGFloat)xlScreenHeight;

/// 屏幕物理尺寸
-(CGRect)xlScreenNativeBounds;
-(CGSize)xlScreenNativeSize;
-(CGFloat)xlScreenNativeWidth;
-(CGFloat)xlScreenNativeHeight;

/// 设备大类
-(BOOL)xlIsiPad;
-(BOOL)xlIsiPhone;
-(BOOL)xlIsRetina;

-(BOOL)xlMiniScreen;   /// 小屏
/// 非刘海屏
-(BOOL)xliPhone4;
-(BOOL)xliPhone5;
-(BOOL)xliPhone5s;
-(BOOL)xliPhone6;
-(BOOL)xliPhone6p;

-(BOOL)xlBangsScreen;   /// 刘海屏
-(BOOL)xliPhoneX;       /// iPhone Pro, iPHone X, iPhone Xs
-(BOOL)xliPhoneXR;      /// 包含缩水屏（750, 1624）
-(BOOL)xliPhoneXsMax;   /// XLiPhoneXSMax、iPhone Pro Max 尺寸一致

-(CGFloat)xlStatusBarHeight;    /// 状态栏高度
-(CGFloat)xlNaviBarHeight;      /// 导航栏高度

-(CGFloat)xlNaviTopTotalHeight;     /// 顶部高度
-(CGFloat)xlNaviBottomTotalHeight;  /// 底部高度
@end

NS_ASSUME_NONNULL_END
