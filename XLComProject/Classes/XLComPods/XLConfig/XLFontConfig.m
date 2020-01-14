//
//  XLFontConfig.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/22.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLFontConfig.h"

static NSString *const XLFontGrade = @"XLFontConfigGrade";
static NSString *const XLFontGradeArray = @"XLFontConfigGradeArray";

@interface XLFontConfig ()
@property (nonatomic, assign) CGFloat userFontScal;
@end

@implementation XLFontConfig

-(instancetype)init{
    self = [super init];
    if (self) {
        _userFontScal = 1.0f;
    }
    return self;
}

/// 用户字体缩放倍数
-(CGFloat)userFontScal{
    return _userFontScal;
}
@end
