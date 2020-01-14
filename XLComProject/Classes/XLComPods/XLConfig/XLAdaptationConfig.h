//
//  XLAdaptationConfig.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseConfig.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLAdaptationConfig : XLBaseConfig
/// 默认：UIModalPresentationFullScreen
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

/// 默认：
/// iOS 13 之前 UIStatusBarStyleDefault
/// iOS 13 UIStatusBarStyleDarkContent
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;

@property (nonatomic, copy)   NSString *backImageName;  /// 返回按钮图标
@property (nonatomic, assign) BOOL     showBackTitle;   /// default NO
@end

NS_ASSUME_NONNULL_END
