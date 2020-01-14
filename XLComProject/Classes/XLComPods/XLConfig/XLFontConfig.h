//
//  XLFontConfig.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/22.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseConfig.h"
#import <CoreGraphics/CoreGraphics.h>

@interface XLFontConfig : XLBaseConfig

#pragma mark - Keep Value 保持值：以下值设置会被保持
/// 当前字体缩放等级：默认1.0，已设置过则取上次设置值
@property (nonatomic, assign) NSInteger fontGrade;
/// 字体等级：正常字体缩放倍数 默认 0.9、1.0、1.1、1.2、1.3、1.4
@property (nonatomic, strong) NSArray   *fontGrades;

/// 用户字体缩放倍数：默认1.0f
/// 设置过fontGrade、fontGrades则取fontGrade对应缩放值
-(CGFloat)userFontScal;
@end
