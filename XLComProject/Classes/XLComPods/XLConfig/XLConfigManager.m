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

@end
