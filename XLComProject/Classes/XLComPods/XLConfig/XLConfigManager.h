//
//  XLConfigManager.h
//  FLAnimatedImage
//
//  Created by GDXL2012 on 2020/6/28.
//

#import <Foundation/Foundation.h>

#import "XLColorConfig.h"
#import "XLFontConfig.h"
#import "XLLayoutConfig.h"
#import "XLAdaptationConfig.h"
#import "XLComConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLConfigManager : NSObject

+(instancetype)xlConfigManager;

@property (nonatomic, strong) XLColorConfig      *colorConfig;
@property (nonatomic, strong) XLFontConfig       *fontConfig;
@property (nonatomic, strong) XLLayoutConfig     *layoutConfig;
@property (nonatomic, strong) XLAdaptationConfig *adaptationConfig;
@property (nonatomic, strong) XLComConfig        *comConfig;
@end

NS_ASSUME_NONNULL_END
