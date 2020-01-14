//
//  XLLayoutConfig.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/22.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLLayoutConfig.h"

@implementation XLLayoutConfig

/// 默认配置
+(instancetype)defaultConfig{
    XLLayoutConfig *config = [[XLLayoutConfig alloc] init];
    [config defaultConfig];
    return config;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

-(void)defaultConfig{
    self.xlBtnHMargin           = 35.0f; /// 按钮水平边距：默认35.0f
    
    self.xlHMargin              = 16.0f; /// 外部左右边距：默认16.0f
    self.xlVMargin              = 12.0f; /// 外部上下边距：默认12.0f
    
    self.xlHSpace               = 10.0f; /// 内部左右间距：默认10.0f
    self.xlVSpace               = 8.0f;  /// 内部上下间距：默认8.0f
    self.xlHMinSpace            = 5.0f;  /// 内部左右最小间距：默认5.0f
    
    self.xlCellSepHeight        = 0.5f; /// 分割线宽：默认0.5f
    self.xlBorderSepWidth       = 0.5f; /// 线宽：默认0.5f
    
    self.xlButtonRadius         = 5.0f; /// 按钮圆角：默认5.0f
    self.xlInputViewRadius      = 3.0f; /// 输入框圆角：默认3.0f
    self.xlContentViewRadius    = 3.0f; /// 内容背景圆角：3.0f
    
    self.xlCellIcoWidth         = 24.0; /// 图标大小：默认24.0
}
@end
