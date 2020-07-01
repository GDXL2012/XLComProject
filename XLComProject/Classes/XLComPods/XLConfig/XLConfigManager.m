//
//  XLConfigManager.m
//  FLAnimatedImage
//
//  Created by GDXL2012 on 2020/6/28.
//

#import "XLConfigManager.h"

static XLConfigManager *xlConfigManager;

@implementation XLConfigManager

+(instancetype)xlConfigManager{
    if (!xlConfigManager) {
        xlConfigManager = [[XLConfigManager alloc] init];
    }
    return xlConfigManager;
}

-(XLColorConfig *)colorConfig{
    if (!_colorConfig) {
        _colorConfig = [[XLColorConfig alloc] init];
    }
    return _colorConfig;
}

-(XLFontConfig *)fontConfig{
    if (!_fontConfig) {
        _fontConfig = [[XLFontConfig alloc] init];
    }
    return _fontConfig;;
}

-(XLComConfig *)comConfig{
    if (!_comConfig) {
        _comConfig = [[XLComConfig alloc] init];
    }
    return _comConfig;
}

-(XLLayoutConfig *)layoutConfig{
    if (!_layoutConfig) {
        _layoutConfig = [[XLLayoutConfig alloc] init];
    }
    return _layoutConfig;
}

-(XLAdaptationConfig *)adaptationConfig{
    if (!_adaptationConfig) {
        _adaptationConfig = [[XLAdaptationConfig alloc] init];
    }
    return _adaptationConfig;
}

@end
