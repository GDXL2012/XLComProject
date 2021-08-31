//
//  UIView+Layout.h
//  GDXL2012
//
//  Created by GDXL2012 on 2019/11/12.
//  Copyright © 2019 GDXL2012. All rights reserved.
//  ⚠️图片选择类，由第三方库 "TZImagePickerController"修改而来⚠️
//  ⚠️相册图片获取及处理逻辑主要来至第三方库：TZImagePickerController⚠️
//  ⚠️Git地址：https://github.com/banchichen/TZImagePickerController⚠️
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XLOscillatoryAnimationType) {
    XLOscillatoryAnimationToBigger,
    XLOscillatoryAnimationToSmaller,
};

@interface UIView (Layout)

@property (nonatomic) CGFloat tz_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat tz_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat tz_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat tz_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat tz_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat tz_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat tz_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat tz_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint tz_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  tz_size;        ///< Shortcut for frame.size.

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(XLOscillatoryAnimationType)type;

@end
