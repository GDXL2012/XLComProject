//
//  UIView+XLAdditions.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MASViewAttribute;
@interface UIView (XLAdditions)
/**
 目的是为了让方法名短一些
 */
#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) MASViewAttribute *mas_safeGuide NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) MASViewAttribute *mas_safeLeft NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) MASViewAttribute *mas_safeRight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) MASViewAttribute *mas_safeTop NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) MASViewAttribute *mas_safeBottom NS_AVAILABLE_IOS(11.0);
#endif
@end

NS_ASSUME_NONNULL_END
