//
//  UIView+Layout.m
//  GDXL2012
//
//  Created by GDXL2012 on 2019/11/12.
//  Copyright © 2019 GDXL2012. All rights reserved.
//  ⚠️图片选择类，由第三方库 "TZImagePickerController"修改而来⚠️
//  ⚠️相册图片获取及处理逻辑主要来至第三方库：TZImagePickerController⚠️
//  ⚠️Git地址：https://github.com/banchichen/TZImagePickerController⚠️
// 

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (CGFloat)tz_left {
    return self.frame.origin.x;
}

- (void)setTz_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)tz_top {
    return self.frame.origin.y;
}

- (void)setTz_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)tz_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTz_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)tz_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTz_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)tz_width {
    return self.frame.size.width;
}

- (void)setTz_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)tz_height {
    return self.frame.size.height;
}

- (void)setTz_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)tz_centerX {
    return self.center.x;
}

- (void)setTz_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)tz_centerY {
    return self.center.y;
}

- (void)setTz_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)tz_origin {
    return self.frame.origin;
}

- (void)setTz_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)tz_size {
    return self.frame.size;
}

- (void)setTz_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(XLOscillatoryAnimationType)type{
    NSNumber *animationScale1 = type == XLOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = type == XLOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

@end
